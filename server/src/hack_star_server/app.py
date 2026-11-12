from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field

from hack_star_server.fighters import FIGHTERS, Fighter
from hack_star_server.hacks import HACKS, Hack, find_hack

app = FastAPI(title="Hack star")


class RedeemRequest(BaseModel):
    code: str = Field(max_length=100)


@app.get("/api/health")
def health() -> dict[str, str]:
    return {"status": "ok", "game": "Hack star"}


@app.get("/api/fighters")
def fighters() -> list[Fighter]:
    return FIGHTERS


@app.get("/api/hacks")
def hacks() -> list[Hack]:
    return HACKS


@app.post("/api/hacks/redeem")
def redeem(request: RedeemRequest) -> Hack:
    hack = find_hack(request.code)
    if hack is None:
        raise HTTPException(status_code=404, detail="Unknown code")
    return hack
