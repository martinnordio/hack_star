from pydantic import BaseModel


class Hack(BaseModel):
    id: str
    code: str
    name: str
    description: str
    duration_seconds: int | None


HACKS: list[Hack] = [
    Hack(
        id="infinite_credits",
        code="INFINITY",
        name="Unlimited credits",
        description="Credits never run out.",
        duration_seconds=72 * 60 * 60,
    ),
    Hack(
        id="unlock_all",
        code="OPENSESAME",
        name="Unlock everything",
        description="Every fighter and every skin is unlocked.",
        duration_seconds=72 * 60 * 60,
    ),
    Hack(
        id="power22",
        code="POWER22",
        name="Power 22",
        description="Fighters can reach power level 22 instead of 11.",
        duration_seconds=None,
    ),
    Hack(
        id="hypercharge",
        code="HYPERCHARGE",
        name="Hypercharge",
        description="Your Super charges 3 times faster and every Super is a Hypercharge.",
        duration_seconds=72 * 60 * 60,
    ),
    Hack(
        id="creator",
        code="CREATOR",
        name="Creator",
        description="Unlocks the fighter you created.",
        duration_seconds=72 * 60 * 60,
    ),
]


def find_hack(code: str) -> Hack | None:
    wanted = code.strip().upper()
    return next((hack for hack in HACKS if hack.code == wanted), None)
