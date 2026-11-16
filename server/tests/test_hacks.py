import pytest
from fastapi.testclient import TestClient

from hack_star_server.app import app
from hack_star_server.world_codes import WORLD_CODE_REUSE_DAYS, WORLD_CODES, WorldCode

client = TestClient(app)


def normal_hacks() -> list[dict[str, object]]:
    return [h for h in client.get("/api/hacks").json() if h["world_coins"] is None]


def test_five_hacks() -> None:
    codes = {h["code"]: h["id"] for h in normal_hacks()}
    assert codes == {
        "INFINITY": "infinite_credits",
        "OPENSESAME": "unlock_all",
        "POWER22": "power22",
        "HYPERCHARGE": "hypercharge",
        "CREATOR": "creator",
    }


def test_hack_durations() -> None:
    durations = {h["id"]: h["duration_seconds"] for h in normal_hacks()}
    assert durations == {
        "infinite_credits": 72 * 60 * 60,
        "unlock_all": 72 * 60 * 60,
        "power22": None,
        "hypercharge": 72 * 60 * 60,
        "creator": 72 * 60 * 60,
    }


def test_redeem_creator() -> None:
    response = client.post("/api/hacks/redeem", json={"code": "creator"})
    assert response.status_code == 200
    assert response.json()["id"] == "creator"


def test_redeem_hypercharge() -> None:
    response = client.post("/api/hacks/redeem", json={"code": "hypercharge"})
    assert response.status_code == 200
    assert response.json()["id"] == "hypercharge"


@pytest.mark.parametrize("code", ["POWER22", "power22", "  Power22 ", "\tpower22\n"])
def test_redeem_ignores_case_and_spaces(code: str) -> None:
    response = client.post("/api/hacks/redeem", json={"code": code})
    assert response.status_code == 200
    assert response.json()["id"] == "power22"


@pytest.mark.parametrize("code", ["hello", "", "POWER 22", "x" * 100])
def test_unknown_code(code: str) -> None:
    response = client.post("/api/hacks/redeem", json={"code": code})
    assert response.status_code == 404
    assert response.json()["detail"] == "Unknown code"


def test_too_long_code_is_refused() -> None:
    assert client.post("/api/hacks/redeem", json={"code": "x" * 101}).status_code == 422


def test_five_world_codes_of_500_and_five_of_1000_are_listed() -> None:
    listed = [h for h in client.get("/api/hacks").json() if h["world_coins"] is not None]
    assert sorted(h["world_coins"] for h in listed) == [500] * 5 + [1000] * 5
    assert {h["reuse_days"] for h in listed} == {30}
    assert {h["id"] for h in listed} == {c.id for c in WORLD_CODES}


def test_every_code_is_unique_and_not_a_word() -> None:
    codes = [h["code"] for h in client.get("/api/hacks").json()]
    assert len(codes) == len(set(codes)) == 15
    assert all(any(ch.isdigit() for ch in c.code) and "-" in c.code for c in WORLD_CODES)


@pytest.mark.parametrize("world_code", WORLD_CODES, ids=lambda c: c.id)
def test_redeem_world_code(world_code: WorldCode) -> None:
    response = client.post("/api/hacks/redeem", json={"code": f" {world_code.code.lower()} "})
    assert response.status_code == 200
    assert response.json() == {
        "id": world_code.id,
        "code": world_code.code,
        "name": f"{world_code.amount} world coins",
        "description": response.json()["description"],
        "duration_seconds": None,
        "world_coins": world_code.amount,
        "reuse_days": WORLD_CODE_REUSE_DAYS,
    }


def test_reuse_days_is_30() -> None:
    assert WORLD_CODE_REUSE_DAYS == 30
