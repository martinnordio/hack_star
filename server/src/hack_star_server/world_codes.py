from typing import NamedTuple

# A world-coin code works again after this many days for the same account.
WORLD_CODE_REUSE_DAYS = 30


class WorldCode(NamedTuple):
    id: str
    code: str
    amount: int


# Codes avoid look-alike characters (no 0, O, 1, I) so they are easy to read from a printout.
WORLD_CODES: list[WorldCode] = [
    WorldCode("wc500-1", "WC-7K2QX", 500),
    WorldCode("wc500-2", "WC-M4P8D", 500),
    WorldCode("wc500-3", "WC-R9TYV", 500),
    WorldCode("wc500-4", "WC-3HXNB", 500),
    WorldCode("wc500-5", "WC-Q6LZE", 500),
    WorldCode("wc1000-1", "WC-D8GWJ", 1000),
    WorldCode("wc1000-2", "WC-N2VKF", 1000),
    WorldCode("wc1000-3", "WC-X5MRA", 1000),
    WorldCode("wc1000-4", "WC-9BTCH", 1000),
    WorldCode("wc1000-5", "WC-F7YSU", 1000),
]
