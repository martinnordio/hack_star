from typing import Literal

from pydantic import BaseModel

Rarity = Literal["Default", "Rare", "Super Rare", "Epic", "Mythic", "Legendary"]


class Skin(BaseModel):
    id: str
    name: str
    rarity: Rarity


class Fighter(BaseModel):
    id: str
    name: str
    rarity: Rarity
    idea: str
    skins: list[Skin]
    unlocked_at_start: bool


def _default() -> Skin:
    return Skin(id="default", name="Default", rarity="Default")


FIGHTERS: list[Fighter] = [
    Fighter(
        id="blaze",
        name="Blaze",
        rarity="Rare",
        idea="Girl with fire powers",
        skins=[
            _default(),
            Skin(id="lava", name="Lava", rarity="Epic"),
            Skin(id="phoenix", name="Phoenix", rarity="Legendary"),
        ],
        unlocked_at_start=True,
    ),
    Fighter(
        id="rocko",
        name="Rocko",
        rarity="Rare",
        idea="Friendly rock golem, a tank",
        skins=[_default(), Skin(id="crystal", name="Crystal", rarity="Epic")],
        unlocked_at_start=True,
    ),
    Fighter(
        id="turbo",
        name="Turbo",
        rarity="Super Rare",
        idea="Fast racing kid with a helmet",
        skins=[_default(), Skin(id="neon", name="Neon", rarity="Mythic")],
        unlocked_at_start=True,
    ),
    Fighter(
        id="frosty",
        name="Frosty",
        rarity="Epic",
        idea="Small ice yeti",
        skins=[_default(), Skin(id="snow_king", name="Snow King", rarity="Legendary")],
        unlocked_at_start=False,
    ),
    Fighter(
        id="luna",
        name="Luna",
        rarity="Mythic",
        idea="Space cat with a ray gun",
        skins=[
            _default(),
            Skin(id="galaxy", name="Galaxy", rarity="Mythic"),
            Skin(id="supernova", name="Supernova", rarity="Legendary"),
        ],
        unlocked_at_start=False,
    ),
    Fighter(
        id="pixel",
        name="Pixel",
        rarity="Legendary",
        idea="Hacker robot, the face of Hack star",
        skins=[_default(), Skin(id="glitch", name="Glitch", rarity="Legendary")],
        unlocked_at_start=False,
    ),
]
