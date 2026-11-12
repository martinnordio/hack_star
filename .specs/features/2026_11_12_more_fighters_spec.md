# More Fighters Spec

> **Author:** Martin Nordio
> **Status:** 🟦 Requirements agreed (defaults where Mattia's answer is open)
> **Created:** 2026-11-12
> **Last updated:** 2026-11-12
> **Branch:** `feature/more-fighters`

---

# Part 1 · Requirements

## Context

Mattia asked to "add more figures". Today there are 6 fighters that all fight the same way, so
the only difference is their look. This spec adds **4 new fighters** and gives every fighter its
own way of attacking, so choosing, unlocking and upgrading a fighter really matters. It is F9 in
the [MVP and architecture spec](done/2026_11_12_mvp_and_architecture_spec.md).

**Already in the repository** (reuse, don't rebuild):
- Fighter catalogue on the server (`server/src/hack_star_server/fighters.py`, `GET /api/fighters`):
  Blaze, Rocko, Turbo, Frosty, Luna, Pixel with rarity and skins.
- 3D fighters built in code (`ui/src/lib/models/fighters3d.ts`), portraits (`portraits.ts`),
  gallery page (`/?gallery`).
- Match rules: `game/world.ts` (one kind of shot for everyone), `game/bots.ts`,
  `game/economy.ts` (unlock prices by rarity, `stats(level)`), the Shop (skins by rarity).

**New:**
- 4 fighters with their own 3D look and at least one extra skin each.
- Fighter types: health, speed, range and attack differ per fighter.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../overall_req.md) | Overall game idea and Mattia's answers |
| [architecture.md](../../docs/architecture.md) | How the code is organised |
| [README](../../README.md) | How to install, run and play |

## 1 · Specs

- **S1 — 10 fighters:** The game has 10 fighters: the 6 of today and 4 new ones with original
  names and looks (no Supercell names or art), covering the rarities Rare to Legendary.
- **S2 — New skins:** Each new fighter has its Default skin and at least one Epic, Mythic or
  Legendary skin, sold in the Shop like the others.
- **S3 — Fighter types:** Each fighter has a type shown on its card and screen, with its own
  numbers: **Tank** (more health, short range), **Sharpshooter** (long range, less health),
  **Speedy** (fast), **Thrower** (shots fly over walls), **Spreader** (several shots in a fan).
- **S4 — Different attacks:** Fighters attack the way their type says, in matches and in
  Training, also when bots play them. Each type also gets its own Super (today every fighter
  has the same Super blast from the
  [super and hypercharge spec](done/2026_11_12_super_and_hypercharge_spec.md)).
- **S5 — Fair:** No fighter wins clearly more often than the others: in a test of many bot-only
  matches at the same power level, every fighter wins between 5% and 20% of them.
- **S6 — Bots use them:** Bots pick from all 10 fighters.
- **S7 — Unlock:** New fighters start locked and are unlocked with credits at their rarity price;
  `OPENSESAME` unlocks them too. Saved progress keeps working.
- **S8 — Screens:** Fighter list, fighter screen, home, Shop and gallery show the new fighters
  on desktop, iPad and phone.
- **S9 — Documentation:** README (fighter list and types), `docs/architecture.md` and the Info
  vocabulary ("Tank", "Sharpshooter", "Thrower") are updated.

### Open questions

- **Q1 (Mattia):** Names or ideas for the new fighters? Until he answers, the game invents them.

<!-- spec-nx:plan -->
