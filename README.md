# Hack star

A browser game for kids inspired by Brawl Stars, with **hack codes** that give unlimited
credits, unlock every fighter and allow power levels up to 22. It runs on a desktop, iPad and
phone browser.

- Vision: [.specs/overall_req.md](.specs/overall_req.md)
- Feature list and MVP scope: [MVP and architecture spec](.specs/features/done/2026_11_12_mvp_and_architecture_spec.md)
- All specs: [.specs/features/](.specs/features/)

## Layout

| Folder | What |
|--------|------|
| `server/` | Python game server (FastAPI) |
| `ui/` | Svelte UI with 3D graphics (Threlte / Three.js) |
| `.specs/` | Specs, written with the spec kit in `.specs/kit/` |
| `.spec-nx/` | spec-nx (git submodule) |

## Prerequisites

- [uv](https://docs.astral.sh/uv/) — installs Python 3.13 for the server by itself
- [Node.js](https://nodejs.org/) 22 or newer

Clone with the submodule:

```powershell
git clone --recurse-submodules <repository url>
```

## Install

```powershell
cd server; uv sync; cd ..
cd ui; npm install; cd ..
```

## Run

In two terminals:

```powershell
cd server; uv run hack-star-server   # http://localhost:8180
cd ui; npm run dev                   # http://localhost:5180
```

Open <http://localhost:5180>. The top bar shows "Server online" when both parts run.

### Play on an iPad or phone

1. Connect the iPad or phone to the same Wi-Fi as the computer.
2. `npm run dev` prints a `Network:` address for the Wi-Fi, for example
   `http://192.168.1.20:5180/`. Open it in Safari or Chrome on the device.
3. On Windows, allow Node.js through the firewall for private networks when asked.

## Test

```powershell
cd server; uv run pytest
cd ui; npm test; npm run check
```

## Art

Only original art or art with a free licence (CC0) is used — no Supercell art, names or
logos. See [ui/public/assets/LICENSES.md](ui/public/assets/LICENSES.md).
