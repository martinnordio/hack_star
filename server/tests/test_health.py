from fastapi.testclient import TestClient

from hack_star_server.app import app

client = TestClient(app)


def test_health() -> None:
    response = client.get("/api/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok", "game": "Hack star"}
