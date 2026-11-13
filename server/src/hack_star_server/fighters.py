from typing import Literal

from pydantic import BaseModel

Rarity = Literal["Default", "Rare", "Super Rare", "Epic", "Mythic", "Legendary"]
FighterType = Literal["tank", "sharpshooter", "speedy", "thrower", "spreader"]


class Skin(BaseModel):
    id: str
    name: str
    rarity: Rarity


class Fighter(BaseModel):
    id: str
    name: str
    rarity: Rarity
    type: FighterType
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
        type="spreader",
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
        type="tank",
        idea="Friendly rock golem, a tank",
        skins=[_default(), Skin(id="crystal", name="Crystal", rarity="Epic")],
        unlocked_at_start=True,
    ),
    Fighter(
        id="turbo",
        name="Turbo",
        rarity="Super Rare",
        type="speedy",
        idea="Fast racing kid with a helmet",
        skins=[_default(), Skin(id="neon", name="Neon", rarity="Mythic")],
        unlocked_at_start=True,
    ),
    Fighter(
        id="frosty",
        name="Frosty",
        rarity="Epic",
        type="thrower",
        idea="Small ice yeti",
        skins=[_default(), Skin(id="snow_king", name="Snow King", rarity="Legendary")],
        unlocked_at_start=False,
    ),
    Fighter(
        id="luna",
        name="Luna",
        rarity="Mythic",
        type="sharpshooter",
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
        type="spreader",
        idea="Hacker robot, the face of Hack star",
        skins=[_default(), Skin(id="glitch", name="Glitch", rarity="Legendary")],
        unlocked_at_start=False,
    ),
    Fighter(
        id="coco",
        name="Coco",
        rarity="Rare",
        type="thrower",
        idea="Cheeky monkey who throws coconuts",
        skins=[_default(), Skin(id="pirate", name="Pirate", rarity="Epic")],
        unlocked_at_start=False,
    ),
    Fighter(
        id="sparky",
        name="Sparky",
        rarity="Super Rare",
        type="speedy",
        idea="Robot dog full of electricity",
        skins=[_default(), Skin(id="gold", name="Gold", rarity="Mythic")],
        unlocked_at_start=False,
    ),
    Fighter(
        id="clank",
        name="Sir Clank",
        rarity="Epic",
        type="tank",
        idea="Little knight in big armour",
        skins=[_default(), Skin(id="dragon", name="Dragon Knight", rarity="Legendary")],
        unlocked_at_start=False,
    ),
    Fighter(
        id="kira",
        name="Kira",
        rarity="Legendary",
        type="sharpshooter",
        idea="Ninja archer who never misses",
        skins=[_default(), Skin(id="sakura", name="Sakura", rarity="Legendary")],
        unlocked_at_start=False,
    ),
    Fighter(
        id="marina",
        name="Marina",
        rarity="Rare",
        type="speedy",
        idea="Surfer girl who rides her own wave and splashes water",
        skins=[_default()],
        unlocked_at_start=True,
    ),
    Fighter(
        id="drako",
        name="Drako",
        rarity="Epic",
        type="spreader",
        idea="Baby dragon with shiny scales who breathes fire waves",
        skins=[_default()],
        unlocked_at_start=False,
    ),
    Fighter(
        id="spectra",
        name="Spectra",
        rarity="Epic",
        type="thrower",
        idea="Ghost magician who throws glowing cards",
        skins=[_default()],
        unlocked_at_start=False,
    ),
    Fighter(
        id="mecha",
        name="Mecha Max",
        rarity="Mythic",
        type="tank",
        idea="Kid piloting a giant robot suit",
        skins=[_default()],
        unlocked_at_start=False,
    ),
    Fighter(
        id="zeus",
        name="Zeus Jr.",
        rarity="Legendary",
        type="sharpshooter",
        idea="Little thunder god who shoots lightning bolts",
        skins=[_default()],
        unlocked_at_start=False,
    ),
]

# Three more skins for every fighter (accounts, fighters and languages spec, S14).
MORE_SKINS: dict[str, list[tuple[str, str, Rarity]]] = {
    "blaze": [("frost", "Frost", "Epic"), ("shadow", "Shadow", "Super Rare"), ("candy", "Candy", "Rare")],
    "rocko": [("emerald", "Emerald", "Mythic"), ("magma", "Magma", "Epic"), ("snowman", "Snowman", "Rare")],
    "turbo": [("golden", "Golden", "Legendary"), ("jungle", "Jungle", "Rare"), ("midnight", "Midnight", "Epic")],
    "frosty": [("lava_yeti", "Lava Yeti", "Epic"), ("candy_floss", "Candy Floss", "Rare"), ("abominable", "Abominable", "Mythic")],
    "luna": [("solar", "Solar", "Epic"), ("neon_cat", "Neon Cat", "Super Rare"), ("shadow_cat", "Shadow Cat", "Mythic")],
    "pixel": [("retro", "Retro", "Rare"), ("gold_bot", "Gold Bot", "Legendary"), ("virus", "Virus", "Epic")],
    "coco": [("astro", "Astro", "Epic"), ("king", "King", "Legendary"), ("banana", "Banana", "Rare")],
    "sparky": [("ice_dog", "Ice Dog", "Epic"), ("hot_dog", "Hot Dog", "Rare"), ("cyber", "Cyber", "Mythic")],
    "clank": [("paladin", "Paladin", "Epic"), ("dark_knight", "Dark Knight", "Mythic"), ("royal", "Royal", "Legendary")],
    "kira": [("storm", "Storm", "Epic"), ("samurai", "Samurai", "Mythic"), ("ghost", "Ghost", "Rare")],
    "marina": [("lava_surf", "Lava Surf", "Epic"), ("tropical", "Tropical", "Rare"), ("mermaid", "Mermaid", "Legendary")],
    "drako": [("ice_dragon", "Ice Dragon", "Epic"), ("gold_dragon", "Gold Dragon", "Legendary"), ("shadow_dragon", "Shadow Dragon", "Mythic")],
    "spectra": [("pumpkin", "Pumpkin", "Epic"), ("snow_ghost", "Snow Ghost", "Rare"), ("rainbow", "Rainbow", "Legendary")],
    "mecha": [("red_mech", "Red Mech", "Rare"), ("camo", "Camo", "Epic"), ("golden_mech", "Golden Mech", "Legendary")],
    "zeus": [("poseidon", "Poseidon", "Epic"), ("hades", "Hades", "Mythic"), ("sun_god", "Sun God", "Legendary")],
}

for _fighter in FIGHTERS:
    _fighter.skins += [Skin(id=i, name=n, rarity=r) for i, n, r in MORE_SKINS[_fighter.id]]
