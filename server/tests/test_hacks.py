import pytest
from fastapi.testclient import TestClient

from hack_star_server.app import app

client = TestClient(app)


def test_three_hacks() -> None:
    codes = {h["code"]: h["id"] for h in client.get("/api/hacks").json()}
    assert codes == {
        "INFINITY": "infinite_credits",
        "OPENSESAME": "unlock_all",
        "POWER22": "power22",
    }


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
