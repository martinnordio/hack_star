import pytest
from fastapi.testclient import TestClient

from hack_star_server.app import app
from hack_star_server.world_codes import WORLD_CODE_REUSE_DAYS, WORLD_CODES

client = TestClient(app)


def world_hacks() -> list[dict]:
    return [h for h in client.get("/api/hacks").json() if h["world_coins"] is not None]


def test_every_code_is_unique() -> None:
    codes = [entry.code for entry in WORLD_CODES]
    ids = [entry.id for entry in WORLD_CODES]
    assert len(set(codes)) == len(codes)
    assert len(set(ids)) == len(ids)


def test_five_codes_of_500_and_five_of_1000() -> None:
    amounts = sorted(entry.amount for entry in WORLD_CODES)
    assert amounts == [500] * 5 + [1000] * 5


def test_reuse_is_thirty_days() -> None:
    assert WORLD_CODE_REUSE_DAYS == 30
    assert all(h["reuse_days"] == 30 for h in world_hacks())


def test_list_includes_world_codes_with_amounts() -> None:
    listed = {h["code"]: h["world_coins"] for h in world_hacks()}
    assert listed == {entry.code: entry.amount for entry in WORLD_CODES}


@pytest.mark.parametrize("entry", WORLD_CODES, ids=lambda entry: entry.id)
def test_redeem_answers_each_world_code(entry) -> None:
    response = client.post("/api/hacks/redeem", json={"code": entry.code})
    assert response.status_code == 200
    body = response.json()
    assert body["id"] == entry.id
    assert body["world_coins"] == entry.amount
    assert body["reuse_days"] == WORLD_CODE_REUSE_DAYS
    assert body["duration_seconds"] is None


@pytest.mark.parametrize("code", ["wc-7k2qx", "  WC-7K2QX ", "\twc-7k2qx\n"])
def test_redeem_ignores_case_and_spaces(code: str) -> None:
    response = client.post("/api/hacks/redeem", json={"code": code})
    assert response.status_code == 200
    assert response.json()["id"] == "wc500-1"


def test_normal_hacks_have_no_world_coins() -> None:
    normal = client.post("/api/hacks/redeem", json={"code": "POWER22"}).json()
    assert normal["world_coins"] is None
    assert normal["reuse_days"] is None
