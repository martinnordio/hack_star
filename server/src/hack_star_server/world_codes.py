"""World-coin hack codes: amounts, waiting time and the list of codes live here only.

An account can use each code once; the game remembers when, and accepts the same code again
after `WORLD_CODE_REUSE_DAYS` days (worlds and world coins spec, S14-S17).
"""

from pydantic import BaseModel

WORLD_CODE_REUSE_DAYS = 30


class WorldCode(BaseModel):
    id: str
    code: str
    amount: int


# Five codes of each amount: unique, and not words, so they cannot be guessed.
WORLD_CODES: list[WorldCode] = [
    WorldCode(id="wc500-1", code="WC5-7K2QX", amount=500),
    WorldCode(id="wc500-2", code="WC5-M3R9D", amount=500),
    WorldCode(id="wc500-3", code="WC5-4HV8T", amount=500),
    WorldCode(id="wc500-4", code="WC5-X6N2B", amount=500),
    WorldCode(id="wc500-5", code="WC5-9PZ5J", amount=500),
    WorldCode(id="wc1000-1", code="WC1-Q8D4W", amount=1000),
    WorldCode(id="wc1000-2", code="WC1-3JY7K", amount=1000),
    WorldCode(id="wc1000-3", code="WC1-T5M6C", amount=1000),
    WorldCode(id="wc1000-4", code="WC1-B9X2R", amount=1000),
    WorldCode(id="wc1000-5", code="WC1-6GL3F", amount=1000),
]
