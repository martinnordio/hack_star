from fastapi import FastAPI

app = FastAPI(title="Hack star")


@app.get("/api/health")
def health() -> dict[str, str]:
    return {"status": "ok", "game": "Hack star"}
