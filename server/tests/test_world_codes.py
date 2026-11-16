import re

import pytest
from fastapi.testclient import TestClient

from hack_star_server.app import app
from hack_star_server.hacks import HACKS
from hack_star_server.world_codes import WORLD_CODE_REUSE_DAYS, WORLD_CODES, WorldCode

client = TestClient(app)


def test_five_codes_of_500_and_five_of_1000_waiting_30_days() -> None:
    amounts = sorted(w.amount for w in WORLD_CODES)
    assert amounts == [500] * 5 + [1000] * 5
    assert WORLD_CODE_REUSE_DAYS == 30


def test_every_code_and_id_is_unique_and_not_a_word() -> None:
    codes = [w.code for w in WORLD_CODES]
    every_code = [h.code for h in HACKS]
    assert len(set(codes)) == len(codes)
    assert len(set(every_code)) == len(every_code)
    assert len({w.id for w in WORLD_CODES}) == len(WORLD_CODES)
    for code in codes:
        assert re.fullmatch(r"WC[15]-[0-9A-Z]{5}", code)
        assert re.search(r"\d", code[4:])


def test_the_list_has_the_world_codes_with_amounts() -> None:
    listed = {h["id"]: h for h in client.get("/api/hacks").json() if h["world_coins"] is not None}
    assert {i: (h["code"], h["world_coins"], h["reuse_days"]) for i, h in listed.items()} == {
        w.id: (w.code, w.amount, 30) for w in WORLD_CODES
    }


@pytest.mark.parametrize("world_code", WORLD_CODES, ids=lambda w: w.id)
def test_redeem_answers_with_id_coins_and_waiting_days(world_code: WorldCode) -> None:
    response = client.post("/api/hacks/redeem", json={"code": f" {world_code.code.lower()} "})
    assert response.status_code == 200
    body = response.json()
    assert (body["id"], body["world_coins"], body["reuse_days"]) == (world_code.id, world_code.amount, 30)
    assert body["duration_seconds"] is None


def test_normal_hacks_have_no_world_coins() -> None:
    body = client.post("/api/hacks/redeem", json={"code": "POWER22"}).json()
    assert body["world_coins"] is None and body["reuse_days"] is None
