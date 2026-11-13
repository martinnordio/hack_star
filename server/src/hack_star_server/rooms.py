"""Rooms for playing with friends: the server only keeps rooms and passes messages.

The host's browser runs the match; friends send their input to the host, and the host sends
snapshots of the match to the friends (play with friends spec, D1-D2).
"""

import json
import re
import secrets
from dataclasses import dataclass, field
from typing import Any

from fastapi import WebSocket, WebSocketDisconnect
from pydantic import BaseModel, Field, ValidationError, field_validator, model_validator

from hack_star_server.fighters import FIGHTERS

# No I or O: easy to read and type.
LETTERS = "ABCDEFGHJKLMNPQRSTUVWXYZ"
CODE_LENGTH = 4
MAX_MEMBERS = 3
MAX_MESSAGE = 64 * 1024
MAX_ROOMS = 100
CREATED = "custom"
FIGHTER_IDS = {f.id for f in FIGHTERS} | {CREATED}
# The look of a created fighter: "L", type 0-4, head 0-2, body 0-2, two colours.
CREATED_LOOK = re.compile(r"^L[0-4][0-2][0-2][0-9a-fA-F]{12}$")


class Member(BaseModel):
    """What a device tells the others about its player."""

    fighter: str = Field(max_length=20)
    skin: str = Field(max_length=20)
    power: int = Field(ge=1, le=22)
    hyper: bool = False
    name: str | None = Field(default=None, min_length=1, max_length=12)

    @field_validator("fighter")
    @classmethod
    def known_fighter(cls, value: str) -> str:
        if value not in FIGHTER_IDS:
            raise ValueError("unknown fighter")
        return value

    @model_validator(mode="after")
    def created_fighter_has_a_look(self) -> "Member":
        if self.fighter == CREATED and not (CREATED_LOOK.match(self.skin) and self.name and self.name.strip()):
            raise ValueError("a created fighter needs its look and name")
        if self.fighter != CREATED and self.name is not None:
            raise ValueError("only a created fighter has a name")
        return self


@dataclass
class Seat:
    slot: int
    socket: WebSocket
    member: Member


@dataclass
class Room:
    code: str
    seats: list[Seat] = field(default_factory=list)
    started: bool = False

    @property
    def host(self) -> Seat:
        return self.seats[0]

    def info(self, you: int) -> dict[str, Any]:
        return {
            "type": "room",
            "code": self.code,
            "you": you,
            "started": self.started,
            "members": [{"slot": s.slot, **s.member.model_dump(exclude_none=True)} for s in self.seats],
        }


class RoomManager:
    def __init__(self) -> None:
        self.rooms: dict[str, Room] = {}

    def new_code(self) -> str:
        while True:
            code = "".join(secrets.choice(LETTERS) for _ in range(CODE_LENGTH))
            if code not in self.rooms:
                return code

    async def handle(self, socket: WebSocket) -> None:
        await socket.accept()
        room: Room | None = None
        seat: Seat | None = None
        try:
            while True:
                text = await socket.receive_text()
                if len(text) > MAX_MESSAGE:
                    await self.error(socket, "too-big")
                    continue
                try:
                    message = json.loads(text)
                except json.JSONDecodeError:
                    await self.error(socket, "bad-message")
                    continue
                if not isinstance(message, dict):
                    await self.error(socket, "bad-message")
                    continue
                kind = message.get("type")
                if room is None or seat is None:
                    room, seat = await self.enter(socket, kind, message)
                elif seat is room.host:
                    await self.from_host(room, kind, message, text)
                else:
                    await self.from_friend(room, seat, kind, message)
        except WebSocketDisconnect:
            pass
        finally:
            if room is not None and seat is not None:
                await self.leave(room, seat)

    async def enter(self, socket: WebSocket, kind: Any, message: dict[str, Any]) -> tuple[Room | None, Seat | None]:
        try:
            member = Member.model_validate(message.get("member"))
        except ValidationError:
            await self.error(socket, "bad-member")
            return None, None
        if kind == "create":
            if len(self.rooms) >= MAX_ROOMS:
                await self.error(socket, "too-many-rooms")
                return None, None
            room = Room(code=self.new_code())
            self.rooms[room.code] = room
            seat = Seat(slot=0, socket=socket, member=member)
        elif kind == "join":
            code = str(message.get("code", "")).strip().upper()
            room = self.rooms.get(code)
            if room is None:
                await self.error(socket, "no-room")
                return None, None
            if len(room.seats) >= MAX_MEMBERS:
                await self.error(socket, "full")
                return None, None
            if room.started:
                await self.error(socket, "started")
                return None, None
            taken = {s.slot for s in room.seats}
            seat = Seat(slot=min(set(range(MAX_MEMBERS)) - taken), socket=socket, member=member)
        else:
            await self.error(socket, "not-in-room")
            return None, None
        room.seats.append(seat)
        room.seats.sort(key=lambda s: s.slot)
        await self.announce(room)
        return room, seat

    async def from_host(self, room: Room, kind: Any, message: dict[str, Any], text: str) -> None:
        if kind == "start":
            room.started = True
            await self.to_friends(room, text)
        elif kind == "state":
            await self.to_friends(room, text)
        elif kind == "lobby":
            # Back to the room after a match.
            room.started = False
            await self.to_friends(room, text)
            await self.announce(room)

    async def from_friend(self, room: Room, seat: Seat, kind: Any, message: dict[str, Any]) -> None:
        if kind == "input" and room.started:
            await self.send(room.host.socket, json.dumps({**message, "slot": seat.slot}))

    async def leave(self, room: Room, seat: Seat) -> None:
        if seat not in room.seats:
            # The room was already closed by its host.
            return
        room.seats.remove(seat)
        if seat.slot == 0:
            self.rooms.pop(room.code, None)
            for other in room.seats:
                await self.send(other.socket, json.dumps({"type": "closed"}))
            room.seats.clear()
            return
        await self.send(room.host.socket, json.dumps({"type": "left", "slot": seat.slot}))
        await self.announce(room)

    async def announce(self, room: Room) -> None:
        for s in room.seats:
            await self.send(s.socket, json.dumps(room.info(s.slot)))

    async def to_friends(self, room: Room, text: str) -> None:
        for s in room.seats[1:]:
            await self.send(s.socket, text)

    async def send(self, socket: WebSocket, text: str) -> None:
        try:
            await socket.send_text(text)
        except (RuntimeError, WebSocketDisconnect):
            # Already gone: its own handler cleans up.
            pass

    async def error(self, socket: WebSocket, reason: str) -> None:
        await self.send(socket, json.dumps({"type": "error", "reason": reason}))
