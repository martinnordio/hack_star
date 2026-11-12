import uvicorn


def main() -> None:
    # 0.0.0.0 so iPads and phones on the same Wi-Fi can reach it.
    uvicorn.run("hack_star_server.app:app", host="0.0.0.0", port=8000, reload=True)
