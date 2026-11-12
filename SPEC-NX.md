# How Hack star was built with spec-nx

Hack star is an example project for **[spec-nx](https://github.com/martinnordio/spec-nx)**, a
small kit for building software together with an AI coding assistant in a controlled way:
nothing is coded without a spec, every spec is split into small steps, and every step ends with
a check and a commit. The specs and the documentation are kept up to date while the code
grows, so the repository explains itself.

The whole game (server, 3D browser UI, ten fighters, hack codes, shop, Supers, overtime and
playing with friends) was built in one day this way, by Martin Nordio and Mattia Nordio with
an AI coding assistant (Claude Opus 5.5 in VS Code).

## What was used

| Part | Where | What it is |
|------|-------|-----------|
| spec-nx | [`.spec-nx/`](.spec-nx/) (git submodule of [spec-nx](https://github.com/martinnordio/spec-nx)) | The methodology and the generator of the kit |
| Generated kit | [`.specs/kit/`](.specs/kit/) | What spec-nx generated for this repository (see below) |
| Kit settings | [`.specs/spec-nx.json`](.specs/spec-nx.json) | Stages `requirements` → `plan` → `pr`, git host GitHub with linked issues, PowerShell |
| Vision | [`.specs/overall_req.md`](.specs/overall_req.md) | The idea of the game in our own words, and the questions for Mattia with his answers |
| Specs | [`.specs/features/done/`](.specs/features/done/) | One file per feature, all finished |

### The generated kit (`.specs/kit/`)

| File | Used for |
|------|----------|
| [requirements/prompt.md](.specs/kit/requirements/prompt.md) | Stage 1: write Part 1 of a spec — context, what already exists, testable requirements (S1…Sn), open questions; `UPDATE ISSUE` puts its summary into the GitHub issue |
| [plan/prompt.md](.specs/kit/plan/prompt.md) | Stage 2: write Part 2 — decisions, then Steps with a goal, tasks and a check each |
| [pr/prompt.md](.specs/kit/pr/prompt.md) | Stage 3: push the branch, open or update the pull request and the issue with the spec summary |
| [spec_template.md](.specs/kit/spec_template.md) | The shape of every spec file |
| [skills/requirements_engineer.md](.specs/kit/skills/requirements_engineer.md), [skills/architect.md](.specs/kit/skills/architect.md) | The roles the assistant takes for requirements and for the plan |
| [tools/](.specs/kit/tools/) | `github/update_issue.ps1`, `github/update_pr.ps1`: keep the issue and the pull request in sync with the spec; `spec_summary.ps1`: shared helper |

## How it was used

1. **Vision first.** We wrote what we wanted in [overall_req.md](.specs/overall_req.md), in plain
   words, with a list of questions for Mattia (the game designer). The game used a default for
   each question until he answered; each answer became a requirement or a new spec.
2. **One spec per feature.** The requirements stage wrote Part 1 (what, not how). Open
   questions were answered before planning.
3. **Plan in steps.** The plan stage added Part 2: decisions with their reasons, and 3–5 Steps.
   The first task of every Step records its start time.
4. **Build step by step**, each on a feature branch:
   - implement the Step,
   - check it: automated tests (`pytest`, `vitest`), type check, and a check in a real browser
     at phone, iPad and desktop sizes,
   - tick the tasks, add a **Done** line (date, time taken, what was verified) and notes about
     anything that went differently, then **commit** (one commit per Step).
5. **Keep docs alive.** The last Step of every spec updates the [README](README.md),
   [docs/architecture.md](docs/architecture.md) and the in-game word list.
6. **Close the spec**: tick the Definition of Done, move it to `.specs/features/done/`, merge the
   branch into `main`. The git history shows this rhythm: a plan commit, one commit per Step, a
   merge per feature.
7. **On GitHub.** F0–F11 were built before the repository was on GitHub, so they were merged
   locally; each has a closed issue that links to its spec. The open-source preparation that
   followed went through a real pull request, and from now on every spec gets an issue, a
   branch and a pull request through the `PR:` stage.

## The features and their specs

| # | Feature | Spec | Issue |
|---|---------|------|-------|
| F0 | Architecture and foundation: Python server, Svelte UI, runs on desktop, iPad and phone; feature list and MVP | [MVP and architecture](.specs/features/done/2026_11_12_mvp_and_architecture_spec.md) | [#1](https://github.com/martinnordio/hack_star/issues/1) |
| F1 | Home screen with the 3D fighter, fighter list, skins, Prestige badge, info page | [Basic UI](.specs/features/done/2026_11_12_basic_ui_spec.md) | [#2](https://github.com/martinnordio/hack_star/issues/2) |
| F2 | Hack codes, typed or scanned as QR codes | [Hack codes](.specs/features/done/2026_11_12_hack_codes_spec.md) | [#3](https://github.com/martinnordio/hack_star/issues/3) |
| F3 | Graphics demo: animated 3D arena, run and shoot | [Graphics demo](.specs/features/done/2026_11_12_graphics_demo_spec.md) | [#4](https://github.com/martinnordio/hack_star/issues/4) |
| F4 | First real match: last fighter standing against bots | [First match](.specs/features/done/2026_11_12_first_match_spec.md) | [#5](https://github.com/martinnordio/hack_star/issues/5) |
| F5 | Trophies and Prestige, saved between visits | [Trophies](.specs/features/done/2026_11_12_trophies_spec.md) | [#6](https://github.com/martinnordio/hack_star/issues/6) |
| F6 | Credits, unlocking fighters, power levels | [Unlock and upgrade](.specs/features/done/2026_11_12_unlock_and_upgrade_spec.md) | [#7](https://github.com/martinnordio/hack_star/issues/7) |
| F7 | Skins shop with a skin of the day | [Skins shop](.specs/features/done/2026_11_12_skins_shop_spec.md) | [#8](https://github.com/martinnordio/hack_star/issues/8) |
| F8 | Overtime without walls; Settings screen for bot level and number of bots | [Overtime and match options](.specs/features/done/2026_11_12_overtime_and_match_options_spec.md) | [#9](https://github.com/martinnordio/hack_star/issues/9) |
| F9 | Ten fighters with five types, each with its own attack and Super | [More fighters](.specs/features/done/2026_11_12_more_fighters_spec.md) | [#10](https://github.com/martinnordio/hack_star/issues/10) |
| F10 | Super, Hypercharge and the HYPERCHARGE hack code | [Super and Hypercharge](.specs/features/done/2026_11_12_super_and_hypercharge_spec.md) | [#11](https://github.com/martinnordio/hack_star/issues/11) |
| F11 | Playing with up to 2 friends on their own devices | [Play with friends](.specs/features/done/2026_11_12_play_with_friends_spec.md) | [#12](https://github.com/martinnordio/hack_star/issues/12) |

Each spec file shows the requirements, the decisions, every Step with its tasks, the time it
took, what was checked, and what went differently from the plan (for example a bug found in the
browser and how it was fixed).

## Try it on your own project

See the [spec-nx repository](https://github.com/martinnordio/spec-nx) for how to add it to a
repository and generate the kit; then start with a vision file and ask the assistant to load
`.specs/kit/requirements/prompt.md` for the first spec.
