from pydantic import BaseModel

WORLD_CODE_REUSE_DAYS = 30


class WorldCode(BaseModel):
    id: str
    code: str
    amount: int


# To change the codes or the amounts, edit this list; the game needs no other change.
WORLD_CODES: list[WorldCode] = [
    WorldCode(id="world_500_1", code="WC5-7K2QX", amount=500),
    WorldCode(id="world_500_2", code="WC5-M4TZ9", amount=500),
    WorldCode(id="world_500_3", code="WC5-X8H3D", amount=500),
    WorldCode(id="world_500_4", code="WC5-B6RN2", amount=500),
    WorldCode(id="world_500_5", code="WC5-Q9V5C", amount=500),
    WorldCode(id="world_1000_1", code="WC1-K3W7P", amount=1000),
    WorldCode(id="world_1000_2", code="WC1-T5ZG8", amount=1000),
    WorldCode(id="world_1000_3", code="WC1-D2N9X", amount=1000),
    WorldCode(id="world_1000_4", code="WC1-H7B4M", amount=1000),
    WorldCode(id="world_1000_5", code="WC1-R6C3Y", amount=1000),
]
