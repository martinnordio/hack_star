# Hack star

> **An example of [spec-nx](https://github.com/martinnordio/spec-nx) in use.** spec-nx is a
> small spec kit for building software with an AI coding assistant: every feature starts as a
> spec (requirements, then a plan in steps), each step is implemented, checked and committed,
> and the spec and the documentation are kept up to date along the way. All the specs of this
> game are in [.specs/features/done/](.specs/features/done/).

A top-down arena browser game for kids, with **hack codes** that give unlimited
credits, unlock every fighter and allow power levels up to 22. It runs on a desktop, iPad and
phone browser. Made by Martin Nordio and Mattia Nordio.

- Vision: [.specs/overall_req.md](.specs/overall_req.md)
- Feature list and MVP scope: [MVP and architecture spec](.specs/features/done/2026_11_12_mvp_and_architecture_spec.md)
- All specs: [.specs/features/](.specs/features/)
- How the code is organised: [docs/architecture.md](docs/architecture.md)

## Layout

| Folder | What |
|--------|------|
| `server/` | Python game server (FastAPI) |
| `ui/` | Svelte UI with 3D graphics (Threlte / Three.js) |
| `docs/` | Documentation of how the game is built |
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

Open <http://localhost:5180>. If the server is not running, the game shows "Cannot reach the
Hack star server" with a **Try again** button.

### What is there

- **Home:** the selected fighter in 3D with an entrance animation (tap to skip), trophies,
  credits, Prestige badge, **Play** and **Training**.
- **Play:** a match in the canyon, last fighter standing, against 3 bots (other fighters; level
  and number of bots on the **Settings** screen):
  - "3, 2, 1, FIGHT!" countdown (showing for example "Easy · 3 bots"), then a 2-minute timer
    (red in the last 10 seconds) and the number of fighters still in.
  - Every fighter has a health bar (yours green, bots red); how much a hit takes depends on
    the fighter's power level and type (power 1 Basic: 480). After 3 seconds without being hit
    or shooting, health slowly comes back.
  - Bots fight you and each other. In the cacti you are see-through and bots far away cannot
    see you; bots hiding in cacti are invisible unless you are close.
  - **Super:** every 5 hits' worth of damage (on fighters or dummies) fills your Super (the ring around the
    **SUPER** button and the yellow bar over your fighter). Each fighter type has its own
    Super (see the table below). After 2 Supers the button turns
    purple (**HYPER**): the next Super is a **Hypercharge** — 5 seconds of purple glow, +25%
    speed and damage, and a bigger Super. Bots use Supers too (no Hypercharge on Easy).
  - **Overtime:** if the 2 minutes end and you and at least one bot are still in, "OVERTIME!"
    gives one more minute and every wall and cactus breaks apart, so nobody can hide.
  - The match ends with **Victory** (last one standing), **Defeat** (with your place) or
    **Time's up** (a draw, when overtime ends with others still in); then **Play again** or **Home**.
  - **Trophies:** a victory gives the fighter you played **+10 trophies** (a defeat or time's up
    gives none for now). The result screen counts them up and shows the bar to the next
    **Prestige** (1000, 2000, 3000…); reaching one shows "PRESTIGE n!" and the fighter gets the
    diamond badge with that number. A fighter never drops below a Prestige it reached.
    Training never changes trophies.
- **Training:** the same arena with three target dummies (5 hits break one; it comes back
  after 5 seconds) to practise.

  Controls in matches and training:

  | | Move | Aim and shoot | Super |
  |---|------|---------------|-------|
  | Computer | WASD or arrow keys | Mouse to aim, click (hold to keep firing); Space shoots the nearest target | **E** or right click (towards the mouse), or click the Super button |
  | iPad / phone | Left thumb: joystick | Right thumb: drag to aim, let go to shoot; quick tap shoots the nearest target | Tap the Super button (aims at the nearest enemy) |
- **Fighters:** the 10 fighters with locks, trophies, power levels and type; open one to see
  it in 3D, read what its type does, try on its skins and choose or buy one. Every type has two
  fighters:

  | Type | Fighters | How it fights | Super |
  |------|----------|---------------|-------|
  | 🛡️ Tank | Rocko, Sir Clank | Lots of health, short range | **Shockwave**: a ring of shots all around |
  | 🎯 Sharpshooter | Luna, Kira | Very long range, less health, slower shots | **Piercing beam**: one huge shot through walls and every fighter on its way |
  | ⚡ Speedy | Turbo, Sparky | Runs 25% faster, shoots quickly | **Dash**: rushes forward and hits everyone on the way |
  | 💣 Thrower | Frosty, Coco | Throws over walls; shots explode where they land (a ring shows where) | **Big bomb**: a huge explosion |
  | 🔥 Spreader | Blaze, Pixel | Three shots in a fan, best up close | **Super blast**: 5 big shots through walls |

  The new four (Coco, Sparky, Sir Clank, Kira) start locked. The types were tuned with bot-only
  test matches so that each one wins about as often as the others.
- **Credits, unlocking and upgrading:** every match gives credits (**+100** for a victory, +20
  otherwise; you start with 500). On a fighter's screen:
  - **Unlock** a locked fighter for its price: Rare 160, Super Rare 430, Epic 925, Mythic 1900,
    Legendary 3800 credits.
  - **Upgrade** its power level for 20 × the current level (7 → 8 costs 140). Each level adds
    10% health and damage (power 1: ❤️ 3200 💥 480; power 11: 6400 / 960), and that is what the
    fighter has in matches and training. Bots play at power 5.
- **Shop:** buy skins with credits: Epic 300, Mythic 600, Legendary 1500. The **skin of the
  day** (a new one each day) is first and costs 30% less. Skins of locked fighters say
  "Unlock … first". After buying, **Wear it** puts it on and makes that fighter the chosen one.
  Skins can also be bought on the fighter screen (try on, then **Buy**). Default skins are free.
- **Info:** the words used in the game.
- **Settings:** bot level (**Easy**, **Medium**, **Hard**) and number of bots (1–5) for every
  match; saved on the device. Default Easy and 3 bots.
- **Friends:** play together, each on your own iPad, phone or computer on the same Wi-Fi — you
  and up to 2 friends **on one team against the bots**:
  1. One player taps **Friends → Create a room** and gets a 4-letter code and a QR code.
  2. Friends tap **Friends**, type the code and **Join**, or scan the QR code (with the game's
     **Scan QR** or the camera app, which opens the game straight into the room).
  3. The room shows Player 1 👑 (the host) and the friends with their fighters. The host taps
     **START**: friends take the place of bots (the host's Settings decide how many fighters in
     total, at least one bot) and everyone starts along the bottom of the arena.
  4. Shots never hurt teammates; teammates' health bars are blue. The team wins if one of you
     is the last one standing. Each player gets trophies and credits on their own device, and
     hacks work only on the device that entered them.
  5. After the match, **Back to the room** to play again. If a friend leaves, a bot takes over
     their fighter; if the host leaves, the room closes and the friends get a draw.
- **Hack:** type a hack code or scan its QR code:

  | Code | Hack |
  |------|------|
  | `INFINITY` | Unlimited credits: unlocking, upgrading and skins are free |
  | `OPENSESAME` | Every fighter and skin unlocked (no need to buy skins) |
  | `POWER22` | Power levels up to 22 instead of 11 (power 22: ❤️ 9920 💥 1488 in matches) |
  | `HYPERCHARGE` | Your Super charges 3 times faster and every Super is a Hypercharge |

  **Reset all hacks** on the same screen goes back to the normal rules: the real credits and
  the 11 limit come back; fighters, levels and skins you got while hacking stay (skins you
  only wore thanks to OPENSESAME go back to Default).

Progress (chosen fighter, bought and chosen skins, trophies) is saved in the browser of each device. Open
<http://localhost:5180/?gallery> to see every fighter and skin side by side.

### Match settings

Match length, overtime length (and whether it removes walls), default number of bots and bot
level (easy, medium, hard), what "time's up" means, the
trophies and credits for each result, prices (fighters and skins, skin-of-the-day discount), upgrade costs, power bonus, Super and Hypercharge numbers and the bots' power
level are in [ui/src/lib/game/settings.ts](ui/src/lib/game/settings.ts)
(`SETTINGS`). To try other values
without changing code, add them to the address, for example
<http://localhost:5180/?seconds=60&bots=5&level=medium&overtime=10> (1–8 bots, 5–600 seconds,
`overtime=0` turns overtime off). The address wins over the Settings screen.

### Play on an iPad or phone

1. Connect the iPad or phone to the same Wi-Fi as the computer.
2. `npm run dev` prints a `Network:` address for the Wi-Fi, for example
   `http://192.168.1.20:5180/`. Open it in Safari or Chrome on the device.
3. On Windows, allow Node.js through the firewall for private networks when asked.
4. To play with friends, every device opens the same **Network** address; the computer running
   the server and the UI is the meeting point (nothing goes outside the Wi-Fi).

### QR codes

Open `/?qr` with the **Network** address (for example `http://192.168.1.20:5180/?qr`) and
print the page. The QR codes contain a link to the game with the code, so:

- the **camera app** of an iPad or phone opens the game and applies the hack directly;
- the game's **Scan QR** button needs the camera, which browsers allow only on `https://` (or
  `localhost`). For that, start the UI with `npm run dev:https` instead of `npm run dev` and open
  `https://<network address>:5180`; accept the certificate warning once (the certificate is
  self-signed). Print the QR page from that `https://` address too.

## Test

```powershell
cd server; uv run pytest
cd ui; npm test; npm run check
```

While the server is running on Windows, use `uv run --no-sync pytest` (the running server
locks its launcher, so `uv` cannot re-install it).

## Art

Only original art or art with a free licence (CC0) is used: every fighter, skin and arena is
built in code from simple shapes. See [ui/public/assets/LICENSES.md](ui/public/assets/LICENSES.md).

## Licence and disclaimer

Hack star is open source under the [MIT licence](LICENSE), © 2026 Martin Nordio and Mattia
Nordio.

Hack star is an independent fan project. It is not affiliated with, endorsed, sponsored or
approved by Supercell, and it contains no Supercell code, art, sound or other content. All
trademarks belong to their owners.
