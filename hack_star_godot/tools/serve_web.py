"""Serves build/web/ and forwards every /api request to the hack server (spec 05, D3).

Python standard library only. Plain HTTP requests are relayed with http.client (answer 502 when
the server cannot be reached); WebSocket upgrades (/api/rooms) become a two-way byte tunnel.
With --cert and --key the page is served over https:// (the browser camera needs it on an iPad).
"""

import argparse
import http.client
import http.server
import json
import socket
import ssl
import threading
import urllib.parse
from functools import partial

HOP_BY_HOP = {
    "connection",
    "keep-alive",
    "proxy-authenticate",
    "proxy-authorization",
    "te",
    "trailers",
    "transfer-encoding",
    "upgrade",
}
API_METHODS = ("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS", "HEAD")
HANDSHAKE_SECONDS = 10
RELAY_BYTES = 65536


def is_api_path(path: str) -> bool:
    route = urllib.parse.urlsplit(path).path
    return route == "/api" or route.startswith("/api/")


class Handler(http.server.SimpleHTTPRequestHandler):
    api_host: str
    api_port: int
    api_tls: bool

    def setup(self) -> None:
        if isinstance(self.request, ssl.SSLSocket):
            self.request.settimeout(HANDSHAKE_SECONDS)
            self.request.do_handshake()
            self.request.settimeout(None)
        super().setup()

    def end_headers(self) -> None:
        if not is_api_path(self.path):
            self.send_header("Cache-Control", "no-store")
        super().end_headers()

    def _api_request(self) -> bool:
        if not is_api_path(self.path):
            return False
        if self.headers.get("Upgrade", "").lower() == "websocket":
            self._tunnel()
        else:
            self._forward()
        return True

    def do_GET(self) -> None:
        if not self._api_request():
            super().do_GET()

    def do_HEAD(self) -> None:
        if not self._api_request():
            super().do_HEAD()

    def _forward(self) -> None:
        length = int(self.headers.get("Content-Length") or 0)
        body = self.rfile.read(length) if length else None
        headers = {
            name: value
            for name, value in self.headers.items()
            if name.lower() not in HOP_BY_HOP and name.lower() != "host"
        }
        connection_class = http.client.HTTPSConnection if self.api_tls else http.client.HTTPConnection
        connection = connection_class(self.api_host, self.api_port, timeout=30)
        try:
            connection.request(self.command, self.path, body=body, headers=headers)
            response = connection.getresponse()
            payload = response.read()
        except (OSError, http.client.HTTPException):
            self._bad_gateway()
            return
        finally:
            connection.close()
        self.send_response(response.status, response.reason)
        for name, value in response.getheaders():
            if name.lower() not in HOP_BY_HOP and name.lower() != "content-length":
                self.send_header(name, value)
        self.send_header("Content-Length", str(len(payload)))
        self.send_header("Connection", "close")
        self.end_headers()
        if self.command != "HEAD":
            self.wfile.write(payload)

    def _bad_gateway(self) -> None:
        payload = json.dumps({"detail": "The hack server is not reachable"}).encode()
        self.send_response(502, "Bad Gateway")
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(payload)))
        self.send_header("Connection", "close")
        self.end_headers()
        if self.command != "HEAD":
            self.wfile.write(payload)

    def _tunnel(self) -> None:
        try:
            upstream = socket.create_connection((self.api_host, self.api_port), timeout=10)
        except OSError:
            self._bad_gateway()
            return
        upstream.settimeout(None)
        request = [f"{self.command} {self.path} HTTP/1.1", f"Host: {self.api_host}:{self.api_port}"]
        request += [f"{name}: {value}" for name, value in self.headers.items() if name.lower() != "host"]
        upstream.sendall(("\r\n".join(request) + "\r\n\r\n").encode("latin-1"))
        done = threading.Event()

        def pump(source: socket.socket, target: socket.socket) -> None:
            try:
                while True:
                    data = source.recv(RELAY_BYTES)
                    if not data:
                        break
                    target.sendall(data)
            except OSError:
                pass
            finally:
                done.set()
                for end in (source, target):
                    try:
                        end.shutdown(socket.SHUT_RDWR)
                    except OSError:
                        pass

        threading.Thread(target=pump, args=(upstream, self.connection), daemon=True).start()
        pump(self.connection, upstream)
        done.wait()
        upstream.close()
        self.close_connection = True

    def do_POST(self) -> None:
        self._method_not_static()

    do_PUT = do_PATCH = do_DELETE = do_OPTIONS = do_POST

    def _method_not_static(self) -> None:
        if not self._api_request():
            self.send_error(405, "Method Not Allowed")

    def log_message(self, format: str, *args: object) -> None:
        print("%s %s" % (self.address_string(), format % args), flush=True)


class Server(http.server.ThreadingHTTPServer):
    daemon_threads = True

    def handle_error(self, request: object, client_address: object) -> None:
        # A browser that refuses the self-signed certificate is not worth a traceback.
        print(f"Connection from {client_address} failed", flush=True)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--port", type=int, default=8060)
    parser.add_argument("--bind", default="0.0.0.0")
    parser.add_argument("--directory", default="build/web")
    parser.add_argument("--api-url", default="http://127.0.0.1:8180")
    parser.add_argument("--cert")
    parser.add_argument("--key")
    args = parser.parse_args()

    api = urllib.parse.urlsplit(args.api_url)
    Handler.api_tls = api.scheme == "https"
    Handler.api_host = api.hostname or "127.0.0.1"
    Handler.api_port = api.port or (443 if Handler.api_tls else 80)

    server = Server((args.bind, args.port), partial(Handler, directory=args.directory))
    scheme = "http"
    if args.cert and args.key:
        context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
        context.load_cert_chain(args.cert, args.key)
        server.socket = context.wrap_socket(
            server.socket, server_side=True, do_handshake_on_connect=False
        )
        scheme = "https"
    print(f"Serving {args.directory} on {scheme}://{args.bind}:{args.port}, /api -> {args.api_url}", flush=True)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()


if __name__ == "__main__":
    main()
