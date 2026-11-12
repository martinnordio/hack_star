from fastapi.testclient import TestClient

from hack_star_server.app import app

client = TestClient(app)


def test_six_fighters() -> None:
    fighters = client.get("/api/fighters").json()
    assert [f["name"] for f in fighters] == ["Blaze", "Rocko", "Turbo", "Frosty", "Luna", "Pixel"]


def test_every_fighter_has_two_or_three_skins_starting_with_default() -> None:
    for fighter in client.get("/api/fighters").json():
        assert 2 <= len(fighter["skins"]) <= 3, fighter["id"]
        assert fighter["skins"][0]["id"] == "default", fighter["id"]


def test_some_skins_are_legendary() -> None:
    rarities = {s["rarity"] for f in client.get("/api/fighters").json() for s in f["skins"]}
    assert "Legendary" in rarities


def test_start_unlocks() -> None:
    unlocked = [f["id"] for f in client.get("/api/fighters").json() if f["unlocked_at_start"]]
    assert unlocked == ["blaze", "rocko", "turbo"]
