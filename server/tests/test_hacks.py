import re

import pytest
from fastapi.testclient import TestClient

from hack_star_server.app import app
from hack_star_server.world_codes import WORLD_CODE_REUSE_DAYS

client = TestClient(app)


def test_five_hacks() -> None:
    codes = {h["code"]: h["id"] for h in client.get("/api/hacks").json() if h["world_coins"] is None}
    assert codes == {
        "INFINITY": "infinite_credits",
        "OPENSESAME": "unlock_all",
        "POWER22": "power22",
        "HYPERCHARGE": "hypercharge",
        "CREATOR": "creator",
    }


def test_hack_durations() -> None:
    durations = {h["id"]: h["duration_seconds"] for h in client.get("/api/hacks").json() if h["world_coins"] is None}
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


def world_code_hacks() -> list[dict]:
    return [h for h in client.get("/api/hacks").json() if h["world_coins"] is not None]


def test_ten_world_coin_codes_five_of_each_amount() -> None:
    hacks = world_code_hacks()
    assert sorted(h["world_coins"] for h in hacks) == [500] * 5 + [1000] * 5
    assert {h["reuse_days"] for h in hacks} == {30}
    assert WORLD_CODE_REUSE_DAYS == 30


def test_world_coin_codes_are_unique_and_not_words() -> None:
    hacks = world_code_hacks()
    assert len({h["id"] for h in hacks}) == 10
    assert len({h["code"] for h in hacks}) == 10
    all_codes = [h["code"] for h in client.get("/api/hacks").json()]
    assert len(set(all_codes)) == len(all_codes)
    for hack in hacks:
        assert re.fullmatch(r"WC[51]-[A-Z0-9]{5}", hack["code"])
        assert not re.search(r"[AEIOU01]", hack["code"][4:])


def test_redeem_world_coin_code() -> None:
    hack = world_code_hacks()[0]
    response = client.post("/api/hacks/redeem", json={"code": f" {hack['code'].lower()} "})
    assert response.status_code == 200
    assert response.json() == hack
    assert response.json()["world_coins"] == 500
    assert response.json()["reuse_days"] == 30


def test_normal_hacks_have_no_world_coins() -> None:
    body = client.post("/api/hacks/redeem", json={"code": "power22"}).json()
    assert body["world_coins"] is None
    assert body["reuse_days"] is None
