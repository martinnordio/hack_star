import json
from collections.abc import Iterator
from typing import Any

import pytest
from fastapi.testclient import TestClient

from hack_star_server.app import app, rooms

client = TestClient(app)


@pytest.fixture(scope="module", autouse=True)
def one_event_loop() -> Iterator[None]:
    # All sockets share one event loop, as on the real server; separate loops can deadlock.
    with client:
        yield

BLAZE = {"fighter": "blaze", "skin": "default", "power": 7}
ROCKO = {"fighter": "rocko", "skin": "crystal", "power": 4, "hyper": True}


def receive(socket: Any) -> dict[str, Any]:
    return json.loads(socket.receive_text())


def send(socket: Any, message: dict[str, Any]) -> None:
    socket.send_text(json.dumps(message))


def create(socket: Any) -> str:
    send(socket, {"type": "create", "member": BLAZE})
    room = receive(socket)
    assert room["type"] == "room" and room["you"] == 0
    return room["code"]


def test_create_gives_a_four_letter_code() -> None:
    with client.websocket_connect("/api/rooms") as host:
        code = create(host)
        assert len(code) == 4 and code.isalpha() and "I" not in code and "O" not in code
        assert code in rooms.rooms
    assert code not in rooms.rooms


def test_join_shows_both_members_to_both() -> None:
    with client.websocket_connect("/api/rooms") as host:
        code = create(host)
        with client.websocket_connect("/api/rooms") as friend:
            send(friend, {"type": "join", "code": code.lower(), "member": ROCKO})
            mine = receive(friend)
            theirs = receive(host)
            assert mine["you"] == 1 and theirs["you"] == 0
            assert [m["fighter"] for m in mine["members"]] == ["blaze", "rocko"]
            assert theirs["members"][1] == {"slot": 1, **ROCKO}


def test_fourth_device_and_unknown_code_are_refused() -> None:
    with client.websocket_connect("/api/rooms") as host:
        code = create(host)
        friends = [client.websocket_connect("/api/rooms") for _ in range(3)]
        try:
            sockets = [f.__enter__() for f in friends]
            for s in sockets[:2]:
                send(s, {"type": "join", "code": code, "member": ROCKO})
                assert receive(s)["type"] == "room"
            send(sockets[2], {"type": "join", "code": code, "member": ROCKO})
            assert receive(sockets[2]) == {"type": "error", "reason": "full"}
            send(sockets[2], {"type": "join", "code": "ZZZZ", "member": ROCKO})
            assert receive(sockets[2]) == {"type": "error", "reason": "no-room"}
        finally:
            for f in reversed(friends):
                f.__exit__(None, None, None)


def test_bad_member_is_refused() -> None:
    with client.websocket_connect("/api/rooms") as socket:
        send(socket, {"type": "create", "member": {"fighter": "nobody", "skin": "x", "power": 1}})
        assert receive(socket) == {"type": "error", "reason": "bad-member"}
        send(socket, {"type": "create", "member": {**BLAZE, "power": 99}})
        assert receive(socket) == {"type": "error", "reason": "bad-member"}


def test_messages_go_to_the_right_devices() -> None:
    with client.websocket_connect("/api/rooms") as host:
        code = create(host)
        with client.websocket_connect("/api/rooms") as friend:
            send(friend, {"type": "join", "code": code, "member": ROCKO})
            receive(friend), receive(host)
            # Input before the start is ignored; after it, it reaches the host with the slot.
            send(host, {"type": "start", "seed": 1})
            assert receive(friend) == {"type": "start", "seed": 1}
            send(friend, {"type": "input", "x": 1.5})
            assert receive(host) == {"type": "input", "x": 1.5, "slot": 1}
            send(host, {"type": "state", "t": 2})
            assert receive(friend) == {"type": "state", "t": 2}
            # A friend cannot pretend to be the host.
            send(friend, {"type": "state", "t": 3})
            send(host, {"type": "state", "t": 4})
            assert receive(friend) == {"type": "state", "t": 4}


def test_started_room_cannot_be_joined_until_back_in_the_lobby() -> None:
    with client.websocket_connect("/api/rooms") as host:
        code = create(host)
        send(host, {"type": "start"})
        with client.websocket_connect("/api/rooms") as late:
            send(late, {"type": "join", "code": code, "member": ROCKO})
            assert receive(late) == {"type": "error", "reason": "started"}
            send(host, {"type": "lobby"})
            assert receive(host)["started"] is False
            send(late, {"type": "join", "code": code, "member": ROCKO})
            assert receive(late)["you"] == 1


def test_friend_leaving_tells_the_host() -> None:
    with client.websocket_connect("/api/rooms") as host:
        code = create(host)
        with client.websocket_connect("/api/rooms") as friend:
            send(friend, {"type": "join", "code": code, "member": ROCKO})
            receive(friend), receive(host)
            friend.close()
            assert receive(host) == {"type": "left", "slot": 1}
            assert [m["slot"] for m in receive(host)["members"]] == [0]


def test_host_leaving_closes_the_room() -> None:
    with client.websocket_connect("/api/rooms") as friend:
        with client.websocket_connect("/api/rooms") as host:
            code = create(host)
            send(friend, {"type": "join", "code": code, "member": ROCKO})
            receive(friend), receive(host)
            host.close()
            assert receive(friend) == {"type": "closed"}
        assert code not in rooms.rooms


def test_too_big_or_broken_messages_are_refused() -> None:
    with client.websocket_connect("/api/rooms") as socket:
        socket.send_text("x" * (64 * 1024 + 1))
        assert receive(socket) == {"type": "error", "reason": "too-big"}
        socket.send_text("not json")
        assert receive(socket) == {"type": "error", "reason": "bad-message"}
