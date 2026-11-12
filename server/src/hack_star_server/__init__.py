from pathlib import Path

import uvicorn


def main() -> None:
    # 0.0.0.0 so iPads and phones on the same Wi-Fi can reach it.
    uvicorn.run(
        "hack_star_server.app:app",
        host="0.0.0.0",
        port=8180,
        reload=True,
        reload_dirs=[str(Path(__file__).parent)],
    )
