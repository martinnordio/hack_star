"""Makes the self-signed certificate for `serve_web.ps1 -Https` (spec 05, D3).

Needs `cryptography` (pinned in tools/versions.json, installed by uv for this run only).
Writes cert.pem and key.pem into the given folder, and does nothing when the existing
certificate is still valid and already covers every given address.
"""

import argparse
import datetime
import ipaddress
from pathlib import Path

from cryptography import x509
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.x509.oid import NameOID

VALID_DAYS = 365


def names_for(addresses: list[str]) -> list[x509.GeneralName]:
    names: list[x509.GeneralName] = [
        x509.DNSName("localhost"),
        x509.IPAddress(ipaddress.ip_address("127.0.0.1")),
    ]
    for address in addresses:
        entry = x509.IPAddress(ipaddress.ip_address(address))
        if entry not in names:
            names.append(entry)
    return names


def still_good(certificate_path: Path, names: list[x509.GeneralName]) -> bool:
    if not certificate_path.exists():
        return False
    certificate = x509.load_pem_x509_certificate(certificate_path.read_bytes())
    soon = datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(days=7)
    if certificate.not_valid_after_utc < soon:
        return False
    alternative = certificate.extensions.get_extension_for_class(x509.SubjectAlternativeName).value
    return all(name in list(alternative) for name in names)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--out", required=True, help="folder for cert.pem and key.pem")
    parser.add_argument("addresses", nargs="*", help="IPv4 addresses of this computer on the Wi-Fi")
    args = parser.parse_args()

    folder = Path(args.out)
    folder.mkdir(parents=True, exist_ok=True)
    names = names_for(args.addresses)
    certificate_path = folder / "cert.pem"
    key_path = folder / "key.pem"
    if still_good(certificate_path, names) and key_path.exists():
        print(f"Certificate kept: {certificate_path}")
        return

    key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
    subject = x509.Name([x509.NameAttribute(NameOID.COMMON_NAME, "Hack star (local)")])
    now = datetime.datetime.now(datetime.timezone.utc)
    certificate = (
        x509.CertificateBuilder()
        .subject_name(subject)
        .issuer_name(subject)
        .public_key(key.public_key())
        .serial_number(x509.random_serial_number())
        .not_valid_before(now - datetime.timedelta(days=1))
        .not_valid_after(now + datetime.timedelta(days=VALID_DAYS))
        .add_extension(x509.SubjectAlternativeName(names), critical=False)
        .sign(key, hashes.SHA256())
    )
    key_path.write_bytes(
        key.private_bytes(
            serialization.Encoding.PEM,
            serialization.PrivateFormat.TraditionalOpenSSL,
            serialization.NoEncryption(),
        )
    )
    certificate_path.write_bytes(certificate.public_bytes(serialization.Encoding.PEM))
    print(f"Certificate written: {certificate_path}")


if __name__ == "__main__":
    main()
