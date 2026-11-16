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


CREATED = {"fighter": "custom", "skin": "L321e8322b39d353", "power": 3, "hyper": False, "name": "Zappy"}
CREATED_EXTRA = {"fighter": "custom-2", "skin": "L010ff8a1affd23f", "power": 5, "hyper": False, "name": "Comet"}
# Head 4, body 3, hands 2, legs 1 (18 characters).
CREATED_FULL = {"fighter": "custom-3", "skin": "L34321e8322b39d353", "power": 2, "hyper": False, "name": "Nova"}


def test_created_fighter_with_hands_and_legs_is_shown_with_its_look() -> None:
    with client.websocket_connect("/api/rooms") as host:
        send(host, {"type": "create", "member": CREATED_FULL})
        assert receive(host)["members"] == [{"slot": 0, **CREATED_FULL}]


def test_created_fighter_is_shown_with_its_look_and_name() -> None:
    with client.websocket_connect("/api/rooms") as host:
        code = create(host)
        with client.websocket_connect("/api/rooms") as friend:
            send(friend, {"type": "join", "code": code, "member": CREATED})
            assert receive(friend)["members"][1] == {"slot": 1, **CREATED}
            assert "name" not in receive(host)["members"][0]


def test_two_created_fighters_keep_distinct_ids_looks_and_names_in_one_room() -> None:
    with client.websocket_connect("/api/rooms") as host:
        send(host, {"type": "create", "member": CREATED})
        code = receive(host)["code"]
        with client.websocket_connect("/api/rooms") as friend:
            send(friend, {"type": "join", "code": code, "member": CREATED_EXTRA})
            joined = receive(friend)
            assert joined["type"] == "room"
            receive(host)
            assert [member["fighter"] for member in joined["members"]] == ["custom", "custom-2"]
            assert joined["members"] == [
                {"slot": 0, **CREATED},
                {"slot": 1, **CREATED_EXTRA},
            ]


@pytest.mark.parametrize(
    "member",
    [
        {**CREATED, "skin": "default"},
        {**CREATED, "skin": "L921e8322b39d353"},
        {**CREATED, "skin": "L321red000green0"},
        {**CREATED, "skin": "L35321e8322b39d353"},
        {**CREATED, "skin": "L34331e8322b39d353"},
        {**CREATED, "skin": "L3432e8322b39d353"},
        {**CREATED, "name": "x" * 13},
        {**CREATED, "name": "  "},
        {**CREATED_EXTRA, "fighter": "custom-16"},
        {key: value for key, value in CREATED.items() if key != "name"},
        {**BLAZE, "name": "Blaze"},
    ],
)
def test_bad_created_fighter_is_refused(member: dict[str, Any]) -> None:
    with client.websocket_connect("/api/rooms") as socket:
        send(socket, {"type": "create", "member": member})
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


NEW_ROCKO = {**ROCKO, "version": 2}
MOON_LARGE = {"type": "start", "settings": {"world": {"id": "moon-base", "size": "large"}}}


def test_members_join_with_and_without_a_version() -> None:
    with client.websocket_connect("/api/rooms") as host:
        send(host, {"type": "create", "member": {**BLAZE, "version": 2}})
        code = receive(host)["code"]
        with client.websocket_connect("/api/rooms") as friend:
            send(friend, {"type": "join", "code": code, "member": ROCKO})
            members = receive(friend)["members"]
            receive(host)
            assert members[0]["version"] == 2
            assert "version" not in members[1]
    with client.websocket_connect("/api/rooms") as socket:
        send(socket, {"type": "create", "member": {**BLAZE, "version": 0}})
        assert receive(socket) == {"type": "error", "reason": "bad-member"}


def test_start_outside_canyon_small_removes_friends_of_the_previous_version() -> None:
    with client.websocket_connect("/api/rooms") as host:
        code = create(host)
        with client.websocket_connect("/api/rooms") as old, client.websocket_connect("/api/rooms") as new:
            send(old, {"type": "join", "code": code, "member": ROCKO})
            receive(old), receive(host)
            send(new, {"type": "join", "code": code, "member": NEW_ROCKO})
            receive(new), receive(old), receive(host)
            send(host, MOON_LARGE)
            assert receive(old) == {"type": "error", "reason": "update-the-game"}
            assert receive(host) == {"type": "removed", "slots": [1], "reason": "update-the-game"}
            assert receive(host) == {"type": "left", "slot": 1}
            assert receive(new) == MOON_LARGE
            # The removed friend's input no longer reaches the host.
            send(old, {"type": "input", "x": 1})
            send(new, {"type": "input", "x": 2})
            assert receive(host) == {"type": "input", "x": 2, "slot": 2}
            assert [s.slot for s in rooms.rooms[code].seats] == [0, 2]


@pytest.mark.parametrize(
    "start",
    [
        {"type": "start", "settings": {"world": {"id": "canyon", "size": "small"}}},
        {"type": "start", "settings": {"matchSeconds": 120}},
        {"type": "start"},
    ],
)
def test_start_in_canyon_small_keeps_every_friend(start: dict[str, Any]) -> None:
    with client.websocket_connect("/api/rooms") as host:
        code = create(host)
        with client.websocket_connect("/api/rooms") as old:
            send(old, {"type": "join", "code": code, "member": ROCKO})
            receive(old), receive(host)
            send(host, start)
            assert receive(old) == start
            assert len(rooms.rooms[code].seats) == 2
