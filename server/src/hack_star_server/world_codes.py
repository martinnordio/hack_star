"""World-coin hack codes: amounts, codes and the waiting time live here only (worlds spec S17).

Each account on a device can use a code once; the same code works again for that account
`WORLD_CODE_REUSE_DAYS` days later. The device keeps the dates (worlds spec D10).
"""

from dataclasses import dataclass

WORLD_CODE_REUSE_DAYS = 30


@dataclass(frozen=True)
class WorldCode:
    id: str
    code: str
    amount: int


WORLD_CODES: list[WorldCode] = [
    WorldCode(id="world-coins-1", code="WC5-7K2QX", amount=500),
    WorldCode(id="world-coins-2", code="WC5-M4T8R", amount=500),
    WorldCode(id="world-coins-3", code="WC5-P9H3D", amount=500),
    WorldCode(id="world-coins-4", code="WC5-B6N2W", amount=500),
    WorldCode(id="world-coins-5", code="WC5-X3F7J", amount=500),
    WorldCode(id="world-coins-6", code="WC1-Q8L4Z", amount=1000),
    WorldCode(id="world-coins-7", code="WC1-R2V9K", amount=1000),
    WorldCode(id="world-coins-8", code="WC1-D7Y5H", amount=1000),
    WorldCode(id="world-coins-9", code="WC1-T5C8M", amount=1000),
    WorldCode(id="world-coins-10", code="WC1-G3W6P", amount=1000),
]
