from fastapi import FastAPI

from hack_star_server.fighters import FIGHTERS, Fighter

app = FastAPI(title="Hack star")


@app.get("/api/health")
def health() -> dict[str, str]:
    return {"status": "ok", "game": "Hack star"}


@app.get("/api/fighters")
def fighters() -> list[Fighter]:
    return FIGHTERS
