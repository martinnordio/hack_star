# Python — baseline

> Rules for the server in `server/`. `.specs/guidelines/python.md` wins over this file, and so
> does a linter configuration if the project adds one. Style reference:
> [PEP 8](https://peps.python.org/pep-0008/), [PEP 257](https://peps.python.org/pep-0257/).

## Environment

- Python 3.13 (`server/.python-version`, `requires-python = ">=3.13"`); write syntax for it.
- `uv` manages the environment and the dependencies (`server/pyproject.toml`, `uv.lock`);
  never install into the system Python. A new dependency is a decision in the plan.
- Run the server with `cd server; uv run hack-star-server` (port 8180).

## Layout and naming

- Code in `server/src/hack_star_server/`, one module per area (`fighters.py`, `hacks.py`,
  `rooms.py`), routes in `app.py`.
- 4 spaces, no tabs; double quotes for strings.
- `snake_case` functions, variables and modules; `PascalCase` classes; `UPPER_SNAKE`
  constants; `_leading_underscore` for non-public names.
- Imports: standard library, third party, local — one blank line between groups; no
  `from x import *`.

## Types

- Type hints on every function and method, tests included (`-> None`).
- Modern syntax: `list[str]`, `dict[str, int]`, `X | None`.
- Pydantic `BaseModel` for data the API sends or receives — not bare dicts passed around.
- Avoid `Any` in public signatures.

## Errors

- Fail fast with a clear message naming the bad value; in routes, raise `HTTPException` with
  the status and a short `detail`.
- Catch specific exceptions; never a bare `except:`; never swallow an error silently.
- Validate everything a client sends (room messages included) before using it.

## Files and output

- Open text files with `encoding="utf-8"`; build paths with `pathlib.Path`.

## Docs and comments

- A docstring where the name and the types do not say enough; comments say *why*, never repeat
  *what* the code does.

## Tests

- `pytest` in `server/tests/`; files `test_<module>.py`, functions `test_<behaviour>`; the
  FastAPI `TestClient` for endpoints and WebSockets.
- Room tests open the client and each socket in `with` blocks (`with client:`), so sockets
  close and the tests do not hang.
- Every Step that changes behaviour adds or updates a test that would fail without it.
- Tests do not depend on network, real credentials or the order they run in.

## Checks before a Step is done

- `cd server; uv run pytest` passes (`uv run --no-sync pytest` while the server is running on
  Windows).
