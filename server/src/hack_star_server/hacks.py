from pydantic import BaseModel


class Hack(BaseModel):
    id: str
    code: str
    name: str
    description: str


HACKS: list[Hack] = [
    Hack(
        id="infinite_credits",
        code="INFINITY",
        name="Unlimited credits",
        description="Credits never run out.",
    ),
    Hack(
        id="unlock_all",
        code="OPENSESAME",
        name="Unlock everything",
        description="Every fighter and every skin is unlocked.",
    ),
    Hack(
        id="power22",
        code="POWER22",
        name="Power 22",
        description="Fighters can reach power level 22 instead of 11.",
    ),
]


def find_hack(code: str) -> Hack | None:
    wanted = code.strip().upper()
    return next((hack for hack in HACKS if hack.code == wanted), None)
