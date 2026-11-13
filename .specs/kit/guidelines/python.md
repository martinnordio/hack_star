# Python — baseline

> Rules for the Hack star server (`server/`). Any linter configuration added to
> `server/pyproject.toml` and `.specs/guidelines/python.md` win over this file. Style
> reference: [PEP 8](https://peps.python.org/pep-0008/), [PEP 257](https://peps.python.org/pep-0257/).

## Environment

- Python 3.13 (`requires-python = ">=3.13"`), managed with **uv**: `cd server; uv sync`, run
  with `uv run hack-star-server` (port 8180). Never install into the system Python.
- Dependencies are declared in `server/pyproject.toml` (`uv add <pkg>`, dev tools with
  `uv add --dev`); a new dependency is a decision in the plan.

## Layout and naming

- Code in `server/src/hack_star_server/`, one module per concern (`app.py`, `fighters.py`,
  `hacks.py`, `rooms.py`).
- 4 spaces, no tabs; no linter is configured yet, so follow PEP 8 line lengths by hand.
- `snake_case` functions, variables and modules; `PascalCase` classes; `UPPER_SNAKE`
  constants; `_leading_underscore` for non-public names.
- Imports: standard library, third party, local — one blank line between groups; no
  `from x import *`.

## Types

- Type hints on every public function and method; modern syntax (`list[str]`, `X | None`).
- `dataclass` or Pydantic models (FastAPI) for structured data — not bare dicts passed around.
- Avoid `Any` in public signatures.

## Errors

- Fail fast with a clear message naming the bad value:
  `raise ValueError(f"Unknown fighter {fighter_id!r}")`; HTTP errors as `HTTPException`
  with a message the UI can show.
- Catch specific exceptions; never a bare `except:`; never swallow an error silently.
- Compare with `None` using `is` / `is not`.

## Files and output

- Open text files with `encoding="utf-8"`; build paths with `pathlib.Path`.

## Docs and comments

- A one-line docstring for each public module, class and function.
- Comments say *why*, never repeat *what* the code does.

## Tests

- `pytest` in `server/tests/`; files `test_<module>.py`, functions `test_<behaviour>`; run
  with `cd server; uv run pytest`.
- WebSocket room tests share one `TestClient` (`with client:`) and close their sockets
  explicitly, so they do not hang.
- Every Step that changes behaviour adds or updates a test that would fail without it.
- Tests do not depend on network, real credentials or the order they run in.

## Checks before a Step is done

- `uv run pytest` passes.
