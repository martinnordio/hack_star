from pydantic import BaseModel

from hack_star_server.world_codes import WORLD_CODE_REUSE_DAYS, WORLD_CODES


class Hack(BaseModel):
    id: str
    code: str
    name: str
    description: str
    duration_seconds: int | None
    world_coins: int | None = None
    reuse_days: int | None = None


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


WORLD_COIN_HACKS: list[Hack] = [
    Hack(
        id=world_code.id,
        code=world_code.code,
        name=f"{world_code.amount} world coins",
        description=f"Gives {world_code.amount} world coins, once every {WORLD_CODE_REUSE_DAYS} days.",
        duration_seconds=None,
        world_coins=world_code.amount,
        reuse_days=WORLD_CODE_REUSE_DAYS,
    )
    for world_code in WORLD_CODES
]

ALL_HACKS: list[Hack] = [*HACKS, *WORLD_COIN_HACKS]


def find_hack(code: str) -> Hack | None:
    wanted = code.strip().upper()
    return next((hack for hack in ALL_HACKS if hack.code == wanted), None)
