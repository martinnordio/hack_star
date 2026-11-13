from fastapi.testclient import TestClient

from hack_star_server.app import app

client = TestClient(app)


def test_fifteen_fighters() -> None:
    fighters = client.get("/api/fighters").json()
    assert [f["name"] for f in fighters] == [
        "Blaze", "Rocko", "Turbo", "Frosty", "Luna", "Pixel", "Coco", "Sparky", "Sir Clank", "Kira",
        "Marina", "Drako", "Spectra", "Mecha Max", "Zeus Jr.",
    ]


def test_three_fighters_of_each_type() -> None:
    types = [f["type"] for f in client.get("/api/fighters").json()]
    assert sorted(types) == sorted(["tank", "sharpshooter", "speedy", "thrower", "spreader"] * 3)


def test_new_fighters_start_locked_and_cover_rare_to_legendary() -> None:
    new = client.get("/api/fighters").json()[6:10]
    assert not any(f["unlocked_at_start"] for f in new)
    assert {f["rarity"] for f in new} == {"Rare", "Super Rare", "Epic", "Legendary"}


def test_every_fighter_has_skins_starting_with_default() -> None:
    for fighter in client.get("/api/fighters").json():
        assert len(fighter["skins"]) >= 1, fighter["id"]
        assert fighter["skins"][0]["id"] == "default", fighter["id"]


def test_some_skins_are_legendary() -> None:
    rarities = {s["rarity"] for f in client.get("/api/fighters").json() for s in f["skins"]}
    assert "Legendary" in rarities


def test_start_unlocks() -> None:
    # Must match START_FIGHTERS in ui/src/lib/progress.ts (new accounts).
    unlocked = [f["id"] for f in client.get("/api/fighters").json() if f["unlocked_at_start"]]
    assert unlocked == ["blaze", "rocko", "turbo", "marina"]


def test_five_newest_fighters_one_of_each_type() -> None:
    newest = client.get("/api/fighters").json()[10:]
    assert sorted(f["type"] for f in newest) == sorted(["tank", "sharpshooter", "speedy", "thrower", "spreader"])
