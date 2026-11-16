import pytest
from fastapi.testclient import TestClient

from hack_star_server.app import app

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
