# Better Graphics Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** 🔄 Reopened 2026-11-22 — animated characters
> **Created:** 2026-11-22
> **Last updated:** 2026-11-23
> **Branch:** `feature/better-graphics`
> **Issue:** #35

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-22 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | 3.90 M (143 k in · 3.73 M cached · 27 k out) | CHF 1.67 (200 credits) | Part 1 written (screenshots of both games compared; web research for part B) |
| 2026-11-22 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | included in the plan row | included in the plan row | Part 1 revised: Q1–Q7 answered (Q4–Q7 the suggestions) and moved into the statements (A2, A3, B6, G1, G3, G5, new G17, G18); group W added (W1–W7, a new world built with ProtonScatter, repository checked); A0 added |
| 2026-11-22 | requirements | `CREATE ISSUE:` | Claude Opus 5.5 | included in the plan row | included in the plan row | issue #35 created (no parent) |
| 2026-11-22 | plan | `PLAN:` | Claude Opus 5.5 | 2.87 M (138 k in · 2.69 M cached · 50 k out) | CHF 1.86 (222 credits) | Part 2 written: 20 Steps, all reasoning (Claude Opus 5.5) per S1; Step 14 is the gate for the author's drawing (A0) (agent `s09g-lead`; requirements revision and issue included) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 2.82 M (117 k in · 2.69 M cached · 13 k out) | CHF 1.15 (138 credits) | Step 1 done (`usage.ps1 -AgentName s09g-steps1-3` from 12:35:00 to 12:42:16) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 8.99 M (88 k in · 8.86 M cached · 39 k out) | CHF 2.50 (298 credits) | Step 2 done (`usage.ps1 -AgentName s09g-steps1-3` from 12:42:16 to 12:55:30) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 10.98 M (93 k in · 10.84 M cached · 41 k out) | CHF 2.89 (345 credits) | Step 3 done (`usage.ps1 -AgentName s09g-steps1-3` from 12:55:30 to 13:11:15) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 7.56 M (72 k in · 7.45 M cached · 38 k out) | CHF 2.19 (261 credits) | Step 4 done (`usage.ps1 -AgentName s09g-steps4-6` from 13:12:53 to 13:22:37) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 7.15 M (48 k in · 7.08 M cached · 22 k out) | CHF 1.75 (208 credits) | Step 5 done (`usage.ps1 -AgentName s09g-steps4-6` from 13:22:37 to 13:30:18) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 11.32 M (74 k in · 11.20 M cached · 39 k out) | CHF 2.84 (339 credits) | Step 6 done (`usage.ps1 -AgentName s09g-steps4-6` from 13:30:18 to 13:42:24) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 5.48 M (121 k in · 5.33 M cached · 25 k out) | CHF 1.82 (217 credits) | Step 7 done (`usage.ps1 -AgentName s09g-steps7-9` from 13:43:19 to 13:50:52) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 6.19 M (251 k in · 5.92 M cached · 25 k out) | CHF 2.47 (295 credits) | Step 8 done (`usage.ps1 -AgentName s09g-steps7-9` from 13:51:50 to 14:13:07) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 6.44 M (49 k in · 6.37 M cached · 19 k out) | CHF 1.60 (190 credits) | Step 9 done (`usage.ps1 -AgentName s09g-steps7-9` from 14:13:42 to 14:21:06) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 4.78 M (125 k in · 4.63 M cached · 23 k out) | CHF 1.68 (201 credits) | Step 10 done (`usage.ps1 -AgentName s09g-steps10-13` from 14:22:23 to 14:30:28) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 10.98 M (91 k in · 10.84 M cached · 44 k out) | CHF 2.93 (349 credits) | Step 11 done (`usage.ps1 -AgentName s09g-steps10-13` from 14:31:56 to 14:44:53) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 12.65 M (86 k in · 12.52 M cached · 43 k out) | CHF 3.18 (379 credits) | Step 12 done (`usage.ps1 -AgentName s09g-steps10-13` from 14:45:43 to 14:56:09) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 13.27 M (54 k in · 13.18 M cached · 37 k out) | CHF 3.05 (364 credits) | Step 13 done (`usage.ps1 -AgentName s09g-steps10-13` from 14:56:50 to 15:09:25) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 650 k (30 k in · 614 k cached · 6 k out) | CHF 0.32 (39 credits) | Step 14 done (`usage.ps1 -AgentName s09g-step14` from 15:12:33 to 15:13:43) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 2.32 M (95 k in · 2.22 M cached · 12 k out) | CHF 0.97 (116 credits) | Step 15 done (`usage.ps1 -AgentName s09g-steps15-17` from 15:14:29 to 15:19:30) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 18.96 M (132 k in · 18.75 M cached · 74 k out) | CHF 4.94 (589 credits) | Step 16 done (`usage.ps1 -AgentName s09g-steps15-17` from 15:19:28 to 15:44:13) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 5.84 M (31 k in · 5.78 M cached · 24 k out) | CHF 1.50 (179 credits) | Step 17 done (`usage.ps1 -AgentName s09g-steps15-17` from 15:44:41 to 15:57:30) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 2.49 M (114 k in · 2.36 M cached · 15 k out) | CHF 1.13 (135 credits) | Step 18 done (`usage.ps1 -AgentName s09g-steps18-20` from 15:58:18 to 16:03:41) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 434 k (4 k in · 427 k cached · 3 k out) | CHF 0.14 (17 credits) | Step 19 prepared, trial deferred (`usage.ps1 -AgentName s09g-steps18-20` from 16:04:13 to 16:06:57) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 5.86 M (61 k in · 5.78 M cached · 20 k out) | CHF 1.57 (187 credits) | Step 20 done; the G1 verdict, A3, the iPad play-test and the B6 trial wait for the author (`usage.ps1 -AgentName s09g-steps18-20` from 16:07:28 to 16:17:13) |
| 2026-11-22 | review | `REVIEW:` | Claude Opus 5.5 | 16.93 M (258 k in · 16.61 M cached · 67 k out) | CHF 4.99 (595 credits) | semantic diff written: change record `changes/better-graphics/` (16 blocks), review page [2026-11-22_better-graphics.html](../../review/2026-11-22_better-graphics.html) and index row, PR text `semantic_diff.md`; checks 6 pass · 2 n/a · 1 fail (agent `s09g-review`; `CODE REVIEW:` included) |
| 2026-11-22 | review | `CODE REVIEW:` | Claude Opus 5.5 | included in the review row | included in the review row | Approve — 0 Blocking · 2 Should-fix · 8 Nit (7 fix now, 2 deferred, 1 plan decision); check_tools, lint, test (468 passed), export_web exit 0 |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 6.41 M (130 k in · 6.25 M cached · 27 k out) | CHF 2.05 (245 credits) | review fixes #1–#7, deferred rows #8, #9 and the decision D19 (#10); `tools/test.ps1` 469 passed, `lint.ps1`, `check_tools.ps1` exit 0; commit `Fix review findings (#35)` (`usage.ps1 -AgentName s09g-close` 2026-11-22 16:35:25–16:42:47) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 1.26 M (388 k in · 853 k cached · 22 k out) | CHF 2.14 (255 credits) | spec runner (coordination); two runner agents, s09g-runner and s09g-runner2 — both counted (`usage.ps1 -AgentName s09g-runner,s09g-runner2` from 2026-11-22 12:34:45) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 5.19 M (1.73 M in · 3.45 M cached · 10 k out) | CHF 8.00 (955 credits) | orchestrator (main chat) (`usage.ps1 -Agent main` from 2026-11-22 12:12:57) |
| 2026-11-22 | implementation | `CLOSE:` | Claude Opus 5.5 | 4.42 M (45 k in · 4.36 M cached · 18 k out) | CHF 1.21 (145 credits) | spec closed (`usage.ps1 -AgentName s09g-close` from 2026-11-22 16:42:47) |
| 2026-11-22 | pr | `PR:` | Claude Opus 5.5 | 1.43 M (66 k in · 1.36 M cached · 9 k out) | CHF 0.66 (78 credits) | pull request opened (#36, base `main`, not draft; issue #35 updated and commented; `usage.ps1 -AgentName s09g-pr` from 2026-11-22 16:48:31) |
| 2026-11-22 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | included in the plan row | included in the plan row | Part 1 revised: spec reopened in place for the author's request (issue #35 kept, comment added); groups C (C1–C11, two new characters Flarekid and Echo), V (V1–V7, views) and L (L1–L8, brighter worlds and lighting presets) added; Q8–Q13 answered with the suggestions; no open questions |
| 2026-11-22 | plan | `PLAN:` | Claude Opus 5.5 | 3.64 M (128 k in · 3.47 M cached · 40 k out) | CHF 1.79 (214 credits) | re-planned: two characters, views, lighting — Steps 1–20 kept; Steps 21–29 added, all reasoning (Claude Opus 5.5); D20–D30 (agent `s09g-lead3`; requirements revision included; `usage.ps1 -AgentName s09g-lead3` from 2026-11-22 16:55:00) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 3.98 M (119 k in · 3.84 M cached · 19 k out) | CHF 1.47 (175 credits) | Step 21 done (`usage.ps1 -AgentName s09g-steps21-22` from 17:03:28 to 17:11:25) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 18.47 M (167 k in · 18.23 M cached · 73 k out) | CHF 4.98 (594 credits) | Step 22 done (`usage.ps1 -AgentName s09g-steps21-22` from 17:11:25 to 17:37:12) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 9.62 M (171 k in · 9.40 M cached · 50 k out) | CHF 3.14 (374 credits) | Step 23 done; runner decision D31 recorded (`usage.ps1 -AgentName s09g-steps23-24` from 17:41:35 to 17:58:59) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 13.91 M (92 k in · 13.76 M cached · 56 k out) | CHF 3.63 (433 credits) | Step 24 done (`usage.ps1 -AgentName s09g-steps23-24` from 17:58:59 to 18:17:35) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 7.87 M (160 k in · 7.65 M cached · 56 k out) | CHF 2.89 (345 credits) | Step 25 done; runner decision D31 extended (export filter `characters/*_new/*`, `characters/magmax*/*`) (`usage.ps1 -AgentName s09g-steps25-26` from 18:19:26 to 18:39:21) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 8.86 M (94 k in · 8.72 M cached · 48 k out) | CHF 2.67 (318 credits) | Step 26 done (`usage.ps1 -AgentName s09g-steps25-26` from 18:39:21 to 18:52:12) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 11.93 M (177 k in · 11.71 M cached · 46 k out) | CHF 3.47 (414 credits) | Step 27 done; default preset Bright day (`usage.ps1 -AgentName s09g-steps27-29` from 18:52:55 to 19:09:38) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 3.17 M (275 k in · 2.89 M cached · 8 k out) | CHF 1.76 (210 credits) | Step 28 done; every row within L8, nothing trimmed (`usage.ps1 -AgentName s09g-steps27-29` from 19:11:06 to 19:32:58) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 6.04 M (36 k in · 5.99 M cached · 18 k out) | CHF 1.46 (174 credits) | Step 29 done; web export 41,244,423 bytes (`usage.ps1 -AgentName s09g-steps27-29` from 19:33:53 to 19:41:23) |
| 2026-11-22 | review | `REVIEW:` | Claude Opus 5.5 | 16.10 M (313 k in · 15.72 M cached · 67 k out) | CHF 5.08 (605 credits) | semantic diff of the reopening written: change record `changes/done/better-graphics-2/` (13 blocks), review page [2026-11-22_better-graphics-2.html](../../review/2026-11-22_better-graphics-2.html) and index row, PR text `semantic_diff.md`; checks 6 pass · 3 n/a · 0 fail (agent `s09g-review3`, `usage.ps1 -AgentName s09g-review3` from 2026-11-22 16:55:00; `CODE REVIEW:` included) |
| 2026-11-22 | review | `CODE REVIEW:` | Claude Opus 5.5 | included in the review row | included in the review row | Approve — 0 Blocking · 1 Should-fix · 4 Nit (3 fix now, 2 plan decision); check_tools, lint, test (516 passed), export_web exit 0 |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 6.47 M (139 k in · 6.30 M cached · 32 k out) | CHF 2.18 (259 credits) | review fixes of the reopening #1 (bar and numbers over the picture in every view) and #2 (crystal pulse on own materials), decisions D32 (#4) and D33 (#5), a Deferred Items row (shader pre-warm); #3 at `CLOSE:`; `tools/test.ps1` 517 passed, `lint.ps1` exit 0; commit `Fix review findings (#35)` (`usage.ps1 -AgentName s09g-close3` 2026-11-22 19:59:31–20:11:59) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 467 k (271 k in · 184 k cached · 12 k out) | CHF 1.36 (163 credits) | spec runner (coordination) of the reopening (`usage.ps1 -AgentName s09g-runner3` from 2026-11-22 16:55:00) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 2.37 M (593 k in · 1.77 M cached · 6 k out) | CHF 2.88 (344 credits) | orchestrator (main chat) of the reopening (`usage.ps1 -Agent main` from 2026-11-22 15:11:46; all 4 requests after 16:46, so none counted in the first close's row) |
| 2026-11-22 | implementation | `CLOSE:` | Claude Opus 5.5 | 3.99 M (32 k in · 3.94 M cached · 12 k out) | CHF 1.00 (120 credits) | spec closed again after the reopening; web export 41,244,583 bytes (`usage.ps1 -AgentName s09g-close3` from 2026-11-22 20:11:59) |
| 2026-11-22 | pr | `PR:` | Claude Opus 5.5 | 1.37 M (72 k in · 1.29 M cached · 10 k out) | CHF 0.68 (81 credits) | pull request updated (#36: summary with the reopening and the new Cost summary, both semantic diffs; branch pushed; issue #35 updated; `usage.ps1 -AgentName s09g-pr3` from 2026-11-22 16:55:00) |
| 2026-11-22 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | 4.06 M (159 k in · 3.86 M cached · 35 k out) | CHF 1.90 (226 credits) | Part 1 revised: spec reopened in place a second time for the author's request (issue #35 kept); group M added (M1–M16, animated characters: MagMax a new fighter, Echo and Flarekid with the new delivery, facing, walk, shoot pose and own projectiles in play, showcase on the pedestal, the fighter screen and the list); C2, C5, C8, C9, C11 superseded; Q14–Q18 answered with the suggestions; the image tool and the name MagMax open with the author (agent `s09g-lead4`; `usage.ps1 -AgentName s09g-lead4` from 2026-11-22 20:22:00 to 20:28:42) |
| 2026-11-22 | plan | `PLAN:` | Claude Opus 5.5 | 2.36 M (28 k in · 2.31 M cached · 24 k out) | CHF 0.90 (107 credits) | re-planned: animated characters — Steps 1–29 kept; Steps 30–37 added, all reasoning (Claude Opus 5.5); D34–D43 (D31 superseded by D43) (agent `s09g-lead4`; `usage.ps1 -AgentName s09g-lead4` from 2026-11-22 20:28:42) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 6.43 M (139 k in · 6.27 M cached · 28 k out) | CHF 2.11 (251 credits) | Step 30 done; frames imported at 448 px (M14) (`usage.ps1 -AgentName s09g-steps30-32` from 20:33:14 to 20:44:30) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 9.88 M (74 k in · 9.77 M cached · 34 k out) | CHF 2.52 (300 credits) | Step 31 done; MagMax's main colour `ff4500` (`usage.ps1 -AgentName s09g-steps30-32` from 20:44:57 to 20:59:38) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 15.11 M (85 k in · 14.97 M cached · 53 k out) | CHF 3.76 (448 credits) | Step 32 done (`usage.ps1 -AgentName s09g-steps30-32` from 21:00:08 to 21:19:53) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 4.57 M (115 k in · 4.43 M cached · 26 k out) | CHF 1.67 (199 credits) | Step 33 done (`usage.ps1 -AgentName s09g-steps33-35` from 21:21:08 to 21:37:44) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 9.21 M (300 k in · 8.86 M cached · 46 k out) | CHF 3.52 (420 credits) | Step 34 done; hero pictures unused and out of the export (`usage.ps1 -AgentName s09g-steps33-35` from 21:37:44 to 22:01:54) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 7.81 M (59 k in · 7.72 M cached · 31 k out) | CHF 2.06 (246 credits) | Step 35 done (`usage.ps1 -AgentName s09g-steps33-35` from 22:01:54 to 22:16:19) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 3.82 M (122 k in · 3.68 M cached · 18 k out) | CHF 1.43 (171 credits) | Step 36 done; every warm row within L8, nothing trimmed (`usage.ps1 -AgentName s09g-steps36-37` from 22:17:54 to 22:30:21) |
| 2026-11-23 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 7.99 M (289 k in · 7.68 M cached · 27 k out) | CHF 2.95 (352 credits) | Step 37 done; web export 43,544,883 bytes (`usage.ps1 -AgentName s09g-steps36-37` from 2026-11-22 22:32:37 to 2026-11-23 07:19:37) |

---

## Cost summary

This feature used 305.83 M tokens, CHF 103.64 (12364 credits) — measured, see [COSTS.md](../../../../.specs/kit/COSTS.md). It covers the first run (Steps 1–20, its review, close and pull request) and the reopening (Steps 21–29, its review, its close and the pull request update).

| Stage | Models | Tokens | Cost (CHF) | Share of Copilot Business |
|-------|--------|--------|------------|---------------------------|
| requirements | Claude Opus 5.5 | 3.90 M | CHF 1.67 (200 credits) | 10.5 % |
| plan | Claude Opus 5.5 | 6.51 M | CHF 3.65 (436 credits) | 22.9 % |
| implementation | Claude Opus 5.5 | 259.59 M | CHF 86.91 (10369 credits) | 545.7 % |
| review | Claude Opus 5.5 | 33.03 M | CHF 10.07 (1200 credits) | 63.2 % |
| pr | Claude Opus 5.5 | 2.80 M | CHF 1.34 (159 credits) | 8.4 % |
| **Total** | | **305.83 M** | **CHF 103.64 (12364 credits)** | **650.7 %** |

**Implementation by Step**

| Step | Model | Tokens | Cost (CHF) | Share of Copilot Business |
|------|-------|--------|------------|---------------------------|
| Step 1 | Claude Opus 5.5 | 2.82 M | CHF 1.15 (138 credits) | 7.3 % |
| Step 2 | Claude Opus 5.5 | 8.99 M | CHF 2.50 (298 credits) | 15.7 % |
| Step 3 | Claude Opus 5.5 | 10.98 M | CHF 2.89 (345 credits) | 18.2 % |
| Step 4 | Claude Opus 5.5 | 7.56 M | CHF 2.19 (261 credits) | 13.7 % |
| Step 5 | Claude Opus 5.5 | 7.15 M | CHF 1.75 (208 credits) | 10.9 % |
| Step 6 | Claude Opus 5.5 | 11.32 M | CHF 2.84 (339 credits) | 17.8 % |
| Step 7 | Claude Opus 5.5 | 5.48 M | CHF 1.82 (217 credits) | 11.4 % |
| Step 8 | Claude Opus 5.5 | 6.19 M | CHF 2.47 (295 credits) | 15.5 % |
| Step 9 | Claude Opus 5.5 | 6.44 M | CHF 1.60 (190 credits) | 10.0 % |
| Step 10 | Claude Opus 5.5 | 4.78 M | CHF 1.68 (201 credits) | 10.6 % |
| Step 11 | Claude Opus 5.5 | 10.98 M | CHF 2.93 (349 credits) | 18.4 % |
| Step 12 | Claude Opus 5.5 | 12.65 M | CHF 3.18 (379 credits) | 19.9 % |
| Step 13 | Claude Opus 5.5 | 13.27 M | CHF 3.05 (364 credits) | 19.2 % |
| Step 14 | Claude Opus 5.5 | 650 k | CHF 0.32 (39 credits) | 2.1 % |
| Step 15 | Claude Opus 5.5 | 2.32 M | CHF 0.97 (116 credits) | 6.1 % |
| Step 16 | Claude Opus 5.5 | 18.96 M | CHF 4.94 (589 credits) | 31.0 % |
| Step 17 | Claude Opus 5.5 | 5.84 M | CHF 1.50 (179 credits) | 9.4 % |
| Step 18 | Claude Opus 5.5 | 2.49 M | CHF 1.13 (135 credits) | 7.1 % |
| Step 19 | Claude Opus 5.5 | 434 k | CHF 0.14 (17 credits) | 0.9 % |
| Step 20 | Claude Opus 5.5 | 5.86 M | CHF 1.57 (187 credits) | 9.8 % |
| Step 21 | Claude Opus 5.5 | 3.98 M | CHF 1.47 (175 credits) | 9.2 % |
| Step 22 | Claude Opus 5.5 | 18.47 M | CHF 4.98 (594 credits) | 31.3 % |
| Step 23 | Claude Opus 5.5 | 9.62 M | CHF 3.14 (374 credits) | 19.7 % |
| Step 24 | Claude Opus 5.5 | 13.91 M | CHF 3.63 (433 credits) | 22.8 % |
| Step 25 | Claude Opus 5.5 | 7.87 M | CHF 2.89 (345 credits) | 18.2 % |
| Step 26 | Claude Opus 5.5 | 8.86 M | CHF 2.67 (318 credits) | 16.7 % |
| Step 27 | Claude Opus 5.5 | 11.93 M | CHF 3.47 (414 credits) | 21.8 % |
| Step 28 | Claude Opus 5.5 | 3.17 M | CHF 1.76 (210 credits) | 11.1 % |
| Step 29 | Claude Opus 5.5 | 6.04 M | CHF 1.46 (174 credits) | 9.2 % |
| Review fixes | Claude Opus 5.5 | 6.41 M | CHF 2.05 (245 credits) | 12.9 % |
| Spec runner (coordination) | Claude Opus 5.5 | 1.26 M | CHF 2.14 (255 credits) | 13.4 % |
| Orchestrator (main chat) | Claude Opus 5.5 | 5.19 M | CHF 8.00 (955 credits) | 50.3 % |
| CLOSE (first close) | Claude Opus 5.5 | 4.42 M | CHF 1.21 (145 credits) | 7.6 % |
| Review fixes (reopening) | Claude Opus 5.5 | 6.47 M | CHF 2.18 (259 credits) | 13.6 % |
| Spec runner (coordination, reopening) | Claude Opus 5.5 | 467 k | CHF 1.36 (163 credits) | 8.6 % |
| Orchestrator (main chat, reopening) | Claude Opus 5.5 | 2.37 M | CHF 2.88 (344 credits) | 18.1 % |
| CLOSE (reopening) | Claude Opus 5.5 | 3.99 M | CHF 1.00 (120 credits) | 6.3 % |
| **Total implementation** | | **259.59 M** | **CHF 86.91 (10369 credits)** | **545.7 %** |

# Part 1 · Requirements

## Context

The author and Mattia find that the Godot game's screens and characters look much worse than
the Python + Svelte game, and Mattia is unhappy with the new game. This spec makes the UI and
the characters clearly better (judged side by side with the Svelte game on the same screens),
adds a second, fantasy world built with the ProtonScatter addon (part W), lets a child's
drawing become a character of the game with what Claude (via Copilot) can do on its own
(part A), and recommends a better drawing-to-character workflow with one or a few tools,
Google Flow among them (part B). Every stage and Step of this spec runs on Claude Opus 5.5.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- [Basic UI](2026_11_21_04_basic_ui_spec.md) (spec 04) — the screens (home, fighter list,
  fighter screen, info), the shared theme `scenes/ui/hack_star_theme.tres`, `FighterStage`,
  `FighterCard`, `SkinButton`, `PrestigeBadge`, the minimum sizes (44 px buttons, 14 px text,
  D13) and the five screen sizes of `tests/test_screen_sizes.gd`.
- [Graphics Demo](2026_11_21_06_graphics_demo_spec.md) (spec 06) — the canyon arena, the
  effects, the see-through in a bush and S10 (30 frames per second or more on a recent iPad and
  phone, checked by the author with the FPS label).
- `scenes/fighter_model.gd` (`FighterModel`) — the 6 fighters and 14 skins built in code from
  primitive meshes, with a toon material (`DIFFUSE_TOON`) and an outline pass
  (`OUTLINE_GROW` 0.022), idle, run and attack animations; `scenes/canyon.gd` builds the arena
  the same way. No imported model, texture, icon or font: the text uses Godot's default font
  (`LICENSES.md`, `docs/architecture.md` *3D models* and *Art and licences*).
- The Svelte game's look, the reference: `ui/src/lib/models/parts.ts` (3-step toon shading and
  a dark "inverted hull" outline, 7 % larger, on every part), `heroes3d.ts`, `fighters3d.ts`,
  `skins3d.ts`, `arena3d.ts`, and the screens `Home.svelte`, `FighterList.svelte`,
  `FighterDetail.svelte`, `Arena.svelte` (weight 900 text with a dark outline and shadow, round
  icon buttons, coloured chips).
- Asset rules: `hack_star_godot/LICENSES.md` and `ui/public/assets/LICENSES.md` — original art
  or free licence (Quaternius and Kenney, CC0), a line per asset, no Supercell art, names or
  logos; root README **Art** and **Licence and disclaimer**.
- Root specs still open (Python + Svelte game, requirements only) whose findings this spec
  reuses: [Graphics review](../../../../.specs/features/2026_11_14_2_graphics_review_spec.md)
  (#20: candidate packs, licence first — CC0, or CC BY with credit — and a phone-size check per
  model), [Art tools research](../../../../.specs/features/2026_11_14_3_art_tools_research_spec.md)
  (#21: the questions to ask each tool — cost, ownership, training on uploads, age, formats,
  weight; free use only; Martin owns the accounts; only drawings uploaded),
  [Originality review](../../../../.specs/features/2026_11_14_4_originality_review_spec.md) (#22:
  our own identity, no copied look). Part B answers #21's question for the Godot game in a
  narrower form; it does not replace #21.
- The canyon is the only world: `game/arena_layout.gd` (`ArenaLayout`, constants for the walls,
  cactus patches, decoration and start points, read by `Canyon`, `Arena`, `MatchArena`,
  `BotBrain` and `ControlsHelp`) and `scenes/canyon.gd`. More worlds, world coins, prices and
  three sizes are [Worlds and World Coins](../2026_11_22_18_worlds_and_world_coins_spec.md)
  (spec 18, requirements only); part W adds one world and a minimal choice, nothing of spec 18.
- **ProtonScatter** (checked 2026-11-22: [Godot Asset Store](https://store.godotengine.org/asset/hungryproton/protonscatter/),
  version 4.2.0 of 2026-07-28; [source](https://codeberg.org/hungryproton/proton_scatter),
  `addons/proton_scatter/`, MIT, "Copyright (c) 2019 HungryProton") is a **placement tool**,
  not a world: a `ProtonScatter` node with a modifier stack (points on a grid, at random, along
  an edge; then moved, rotated, scaled, projected), `ScatterItem` nodes naming the scene to
  place, and `ScatterShape` nodes (box, sphere, path; can be negative) for the area. It places
  instanced meshes (MultiMesh) or copies of scenes. In a running game it rebuilds on load
  (`force_rebuild_on_load`, default on) **on a `Thread`** unless `dbg_disable_thread` is set —
  a risk for the single-threaded web export. Its repository has demo assets
  (`addons/proton_scatter/demos/assets/`: rocks, grass, bush, pine tree, mushroom, fence,
  brick, dead branch, the Godot mascot Gobot, a `source.blend` with textures) under the addon's
  MIT licence; they are textured and realistic, not Hack star's outlined cartoon look, so the
  objects to scatter are made for Hack star (W3).

**Compared on screenshots (2026-11-22, 1280 × 720, same screens, both games run locally; the
Svelte game rendered in a headless browser with software 3D, so its colours are paler than on a
device; screenshots not committed).** What is worse in the Godot game:
- **Background and depth:** every screen is a flat dark navy colour; the Svelte game has a
  purple gradient with light rays, the fighter stands on a round pedestal, and the fighter
  screen frames the stage.
- **Fonts:** Godot's default font in normal weight, plain white, no outline or shadow; the title
  "Hack star" is plain text. Svelte uses very bold text with a dark outline and drop shadow, and a
  two-colour, slanted logo.
- **Buttons and layout:** five identical purple text buttons in a centred block; Svelte has round
  coloured buttons with icons (a different colour per action), a large yellow **PLAY** in the
  corner, and chips with icons for trophies, credits and the account. Godot shows
  "Trophies: 1745" / "Credits: 500" as plain labels.
- **Fighter list and screen:** Godot cards are dark boxes with five lines of text; Svelte cards
  have a coloured backdrop by unlock state, a lock icon and price on locked fighters, icons for
  trophies and power, and the fighter's type. Godot skin buttons are text only ("Lava Epic");
  Svelte shows a picture of every skin in a rarity frame, and health, damage and a power bar.
- **Characters:** the Godot outline is thin and disappears at card size; shading is soft and
  "plastic" (faces nearly white, little form), where Svelte's 3-step cel shading and thick dark
  outline read clearly at every size. The Godot shapes themselves (Blaze, Rocko, Turbo) are close
  to the Svelte ones.
- **Arena:** the Godot floor is a saturated yellow checkerboard, the wall nearest to the camera
  covers about a quarter of the screen at the start, the controls hint is low-contrast text on
  orange, and "FPS: 60" is shown to the player; Svelte has softer sand tiles, outlined rocks and
  props, and the timer and fighters-left in dark chips with icons.
- **Animation:** both have idle animations and a home entrance; Svelte's buttons react visibly to
  a press, Godot's barely do.

**Research for part B (sources read 2026-11-22):**

| Tool | What it can do for a drawn character | What it cannot do | Cost (free use) | Terms for an MIT open-source game | Source |
|------|------|------|------|------|------|
| **Google Flow** (Google Labs, AI film studio) | Images with Nano Banana (generate and edit, also from an uploaded picture, lasso edits), videos with Veo and Gemini Omni; keeps a character consistent across images and scenes; agent for batch variations; mobile app (Android beta) | **No 3D model, no rig, no game asset formats** — images and video clips only; 18+ with age verification; Chromium browser; supported regions only | No subscription: basic features and 50 credits a day; images "for free" (Feb 2026); full features with Google AI Plus, Pro or Ultra | Google's terms: "Google won't claim ownership" of generated content; no explicit commercial grant; invisible SynthID watermark on every output; Generative AI Prohibited Use Policy; protections for uploaded photos of people and minors | [Flow help: Get started](https://support.google.com/flow/answer/16353333) (read 2026-11-22); [Flow updates, Feb 2026](https://blog.google/innovation-and-ai/models-and-research/google-labs/flow-updates-february-2026/) (2026-02-25); [Flow updates, May 2026](https://blog.google/innovation-and-ai/models-and-research/google-labs/flow-updates/) (2026-05-19) |
| **Meshy** (image or multi-view to 3D) | Textured 3D model from an image; auto-rig of humanoids with walk and run loops, 600+ motion presets; GLB, FBX, USDZ | Fine details of a child's drawing; four-legged characters only get a walk | Free: 100 credits a month (a few models; the newest model's downloads may need Pro); Pro about $20 a month, 1,000 credits | Free plan: outputs under **CC BY 4.0** (credit to Meshy needed); paid plans: the user owns the assets, commercial use allowed | [Meshy pricing](https://www.meshy.ai/pricing) and [docs](https://docs.meshy.ai/en/webapp/pricing) (read 2026-11-22); [Meshy Animate](https://docs.meshy.ai/en/webapp/guides/animate) (read 2026-11-22); [comparison, Oct 2026](https://news.littlewolflabs.com/posts/2026-10-18-image-to-3d-compared) |
| Tripo, Hunyuan3D, TRELLIS (other image-to-3D) | Similar models | — | Tripo free: 200 credits a month | Tripo free outputs are **non-commercial**; Hunyuan3D's licence **excludes the EU, UK and South Korea**; TRELLIS is MIT but needs a 24 GB GPU — not recommended | [comparison, Oct 2026](https://news.littlewolflabs.com/posts/2026-10-18-image-to-3d-compared); [free image-to-3D, Jul 2026](https://triposr.org/blog/free-image-to-3d) |
| **Claude via Copilot** | Reads a photo; writes the code that builds a fighter from shapes and colours (as for today's fighters), or turns the photo into a flat cut-out figure; imports a GLB into Godot and fits it into the game | **Does not generate images or 3D models** itself | Included in the author's Copilot plan | Code written for the project (MIT) | — |
| **Godot 4.7** | Imports glTF 2.0 (`.glb`, recommended), also `.blend`, FBX, OBJ | — | Free | MIT | [Godot docs: Available 3D formats](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/available_formats.html) (read 2026-11-22) |

Result: Google Flow alone cannot make a game character — it can clean and complete the
drawing (front, side and back views in the game's style), which is the input a 3D tool needs.
The smallest set for a real 3D character is **Google Flow → Meshy → Claude in Godot** (three
tools, all free to start); the smallest set without a 3D tool is **Claude alone** (part A), or
**Google Flow → Claude** for a cleaned-up flat figure. Outputs of AI tools may not be protected by
copyright at all; the drawing itself is Mattia's own work. Not legal advice.

**New:**
- A clearly better look of the Godot game's screens and characters, checked side by side with
  the Svelte game.
- A second world, a fantasy place unlocked from the start, its objects placed with
  ProtonScatter, and a minimal choice between the two worlds.
- A drawing → character workflow that Claude runs on its own (part A), with a first drawing of
  Mattia's in the game.
- A written recommendation for a better workflow with Google Flow and few other tools (part B).
- _(added 2026-11-22, reopened)_ Two new fighters from the author's generated pictures (part C),
  camera views switchable with the keyboard (part V), and brighter worlds with lighting presets
  switchable with the keyboard (part L).
- _(added 2026-11-22, author's request)_ Animated characters (part M): a third picture fighter,
  **MagMax**, and Echo and Flarekid with the author's new delivery — front, back and side views
  that follow the movement, a walk loop, a shoot pose and their own projectiles in play, and a
  showcase on the pedestal, the fighter screen and the fighter list.

**Reopened 2026-11-22 (author's request) — found in the repository:**
- `characters/blaze2/` and `characters/echo/` (untracked, made by the author with an AI image
  tool from Mattia's drawing): `<name>_hero.png` (full body, transparent, 1058 × 1415 and
  1088 × 1431, 1.9 and 2.2 MB), `<name>_card.png` (512 × 512, 0.34 and 0.42 MB), a `Sprite3D`
  billboard scene `<name>_hero.tscn`, a `TextureRect` scene `<name>_hero_ui.tscn`, a helper
  `character_preview.gd` (pop-in and bob on a podium) and a README each. Both READMEs say: a 2D
  picture in 3D, it does not turn or animate. `blaze2`'s two scenes point to
  `res://characters/blaze/` (wrong folder). The PNGs are imported as VRAM-compressed S3TC, which
  the web export does not ship for mobile (`vram_texture_compression/for_mobile=false`; an iPad
  has no S3TC). The Blaze picture is a "hero upgrade" of Blaze (flame hood, scarf, fire ball);
  Echo has teal headphones that send sound waves, a "sound blaster" staff and neon soles — like
  Beatbolt, who was built from shapes from Mattia's drawing (A2, A3), and who stays.
- `scenes/blaze_godot.zip` (2.3 MB) and `scenes/blaze_godot/` (a duplicate with
  `echo_godot (1).zip`, 2.6 MB): untracked copies of the same delivery. Step 20 measured that
  Godot packs untracked files of the project folder into the web export (+4.7 MB in the working
  tree); `.gitignore` and the export's `exclude_filter` do not name them yet.
- `FighterModel` (rig, body, head; idle, run lean and bounce, attack recoil; see-through by
  material swap), `DrawnFighters` (a registry asked first by `FighterModel.setup`),
  `Fighters.LIST` (`"drawn": true`, `"plays_like"`), `FighterPictures` (cards rendered
  off-screen), `FighterStage` (pedestal on home and the fighter screen), `Fighter` (turns to the
  input; knock-out spin and shrink in 0.5 s).
- `Arena` (Training) and `MatchArena` (extends `Arena`): one `Camera3D` at a 55° pitch looking
  north, distance fitted to the screen, the G11 near-wall rule; `WorldEnvironment` (ambient
  only) and `Sun` in `arena.tscn`; `GlimmerIsles` sets its own sky and sun. Input actions:
  `move_*` (WASD and arrows) and `shoot` (Space) — no key is bound to `1`–`4`, `V`, `L` or `K`,
  and the arena has no text field.

**Reopened again 2026-11-22 (author's request: animated characters) — found in the repository:**
- `characters/echo_new/`, `characters/flarekid_new/` and `characters/magmax_new/` (untracked, made
  by the author with an AI image tool): a hero picture and a 512 × 512 card picture — **byte for
  byte the same files** as the committed `characters/echo/` and `characters/blaze2/` pictures and
  the older untracked `characters/magmax/` (checked with SHA-256) — the same helper scenes and
  `character_preview.gd`, a README, and what is new, a `gameplay/` set: **12 frames** per
  character (`down` = front, `up` = back, `side` = looking right, mirrored for left; each `idle`,
  `walk1`, `walk2`, `shoot`; 582 × 509 (MagMax), 592 × 503 (Echo), 626 × 507 (Flarekid) px,
  transparent, feet at the bottom centre; 2.6, 3.1 and 2.6 MB of PNG per character),
  `*_frames.tres` (a `SpriteFrames`: `idle_`, `walk_` and `shoot_` × `up`, `down`, `side`; the walk
  loop walk1 → idle → walk2 → idle at 8 frames a second; the shoot frame 0.25 s), `*_gameplay.tscn`
  (an unshaded `AnimatedSprite3D` billboard about 1.3 m tall, no outline), `*_animator.gd` (the view
  and animation from the parent body's velocity — `up` when it moves to −z, the side view mirrored
  for left, the closest view for a diagonal, the last view when standing, the shoot pose 0.25 s on
  the `shoot` action), a projectile picture (256 px wide: MagMax a lava-fist shockwave, Echo a
  sound wave, Flarekid a fireball) with a flat `Sprite3D` scene and a mover script, and an
  `*_animation_preview.png` (all 12 frames). The imports are as delivered (not VRAM-compressed,
  lossless, full size). The internal paths point to `res://characters/echo/` (Echo),
  `res://characters/magmax/` (MagMax) and `res://characters/blaze/` (Flarekid, whose files are
  still named `blaze_*`) — none of them is the folder the files are in.
- `characters/magmax/` (untracked): the author's older MagMax (hero, card, helper scenes, no
  frames), superseded by `magmax_new`. `characters/echo/` and `characters/blaze2/` (committed in
  Step 21): today's Echo and Flarekid, one picture each, used by `CutoutFighters`.
- `export_presets.cfg` already keeps `characters/*_new/*`, `characters/magmax*/*`,
  `characters/*.zip` and the delivered helper files (`character_preview.gd`, `*_hero.tscn`,
  `*_hero_ui.tscn`, `README.md`) out of the web export (D22, D31); `.gitignore` has
  `/characters/*.zip`, not `characters/magmax/`.
- Picture fighters today: `CutoutFighters` puts one picture on one outlined, camera-facing quad
  (`cutout.gdshader`, uniforms `picture`, `flash`, `fade`, `flip`, `tilt`, `tip`; all hero and
  card pictures preloaded), `CutoutMotion` (hop, lean, left/right flip, muzzle star, knock-out
  tip), `FighterModel` (996 lines — gdlint's limit is 1000), `Fighter.face()`, `FighterStage`
  (pop-in, halo and sparks, C3), `FighterCard` (the card picture, still).
- Camera and controls: in all four views the camera looks north (−z) and never turns
  (`CameraViews`, D25: Classic and Close at 55°, Behind at 28°, Overview at 78°), and `Movement`
  maps up on the screen (W, the joystick up) to −z. So in every view, moving up the screen means
  away from the camera, the delivery's back (`up`) view — the delivery's assumption holds.
- Shots: every fighter fires the same `Shot` (`Combat`: 16 m/s, 9 m, 480 damage, a ray each frame;
  a glowing ball with a tail in the fighter's main colour). `Fighters.LIST` rarities: Rare (Blaze,
  Rocko), Super Rare (Turbo), Epic (Frosty), Mythic (Luna, Beatbolt, Echo), Legendary (Pixel,
  Flarekid); Rocko is the "friendly rock golem, a tank". No fighter, skin or brand in the
  repository is called MagMax.
- Web export at the last close: 41,244,583 bytes, 4.1 MB under G15's budget (45,361,090); the two
  picture fighters' imported pictures 0.67 MB.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../../../.specs/overall_req.md) | Overall game idea ("very good graphics", "woww effect for kids") |
| [architecture.md](../../../docs/architecture.md) | How the Godot game is organised (UI foundation, 3D models, art and licences) |
| [README](../../../README.md) | How to open, run, test and export the Godot game |
| [LICENSES.md](../../../LICENSES.md) | Every asset of the Godot game and its licence |

## 1 · Specs

### G — Better graphics of the UI and the characters

- **G1 — Side by side:** Before and after this spec, the home screen, the fighter list, the
  fighter screen and a match of both games are captured at the same size (desktop landscape and
  iPad portrait); the author and Mattia judge each Godot screen "as good as or better than" the
  Svelte one, and their verdict per screen is written in this spec. Mattia decides per screen and
  the author breaks a tie, in one session at the end of the spec, with a mid-way look after the
  first screens (home and match).
- **G2 — Background:** No Godot screen has a plain flat background: menus have a coloured
  gradient or pattern with depth, and the fighter on home, the fighter screen and the result
  screen stands on a visible pedestal or stage.
- **G3 — Fonts:** The title, headings, buttons and numbers use a bold display font with a dark
  outline or shadow; body text stays readable; the font is one free display font under the SIL
  Open Font License, in `assets/`, named in `LICENSES.md`.
- **G4 — Logo:** "Hack star" on home is a logo (more than one colour, outline, not plain text)
  and plays in the entrance as today.
- **G5 — Buttons and icons:** Every home action is a button with an icon and its own colour,
  **Play** is the largest and most visible button, and trophies, credits, power, lock and price
  are shown with   icons instead of words like "Trophies:"; the icons are Kenney's (CC0) or original, in
  `assets/`.
- **G6 — Press feedback:** Every button visibly reacts to a press (mouse and touch) within one
  frame, and to hovering with a mouse.
- **G7 — Fighter cards:** A card shows the fighter's picture on a coloured backdrop (unlocked)
  or grey with a lock icon (locked), its name, rarity in its colour, trophies and power with
  icons; the Prestige badge as today.
- **G8 — Skin pictures:** On the fighter screen every skin button shows a picture of the fighter
  in that skin, framed in its rarity colour (Legendary gold as today), with its name.
- **G9 — Characters:** Every fighter and skin has a dark outline that is visible on the cards and
  in the arena, and cel shading with at least two clear tones per colour; faces (eyes) are
  readable on a card. The 6 fighters keep their shapes, names and colours.
- **G10 — Arena look:** The arena floor, walls, cacti and props have the same outlined cartoon
  look as the fighters; the floor is less saturated than the fighters, so fighters stand out.
- **G11 — Arena framing:** At the start of a match and of Training, the wall nearest to the
  camera covers at most 10 % of the screen height at the five screen sizes.
- **G12 — Match HUD:** The timer, "fighters left" and the controls hint are shown on dark rounded
  backings with icons, readable on every part of the arena; the FPS label is hidden for players
  and can be switched on for the author's play-test.
- **G13 — All screens:** The info, hack, QR codes and result screens use the same new look
  (theme, fonts, buttons, icons) as the four compared screens.
- **G14 — Smooth:** A match with 4 fighters runs at 30 frames per second or more on a recent
  iPad and phone in the web export (as spec 06 S10), checked by the author.
- **G15 — Download size:** The web export grows by at most 5 MB, and the game is playable within
  5 s after **Play** on the iPad, as before.
- **G16 — Sizes and input:** Every screen still fits the five screen sizes, buttons stay at least
  44 px and text at least 14 px on screen, and every button works with mouse and touch.
- **G17 — Order:** Home and the match get the new look first (what Mattia sees most), then the
  fighter list and the fighter screen, then the result, info, hack and QR screens; all of them
  in this spec.
- **G18 — Style:** The new look matches the Svelte game's layout and style (gradient, coloured
  icon buttons, a large yellow **Play**); an own identity (root spec #22) comes later.

### W — A new world, built with ProtonScatter

- **W1 — Glimmer Isles:** A second world, **Glimmer Isles** (floating islands with glowing
  crystals and giant mushrooms — not a real place; original art), is unlocked for every account
  from the start, old saves included.
- **W2 — Choose the world:** Before a match and before Training the player chooses between the
  canyon and Glimmer Isles with a minimal choice (both names shown, the current one marked; the
  canyon is the default); the choice is used by **Play** and **Training** and kept while the
  game is open. World coins, prices, sizes, more worlds and saving the choice stay with
  [Worlds and World Coins](../2026_11_22_18_worlds_and_world_coins_spec.md) (spec 18).
- **W3 — Own look:** Glimmer Isles has its own ground, cover (the hiding patches), walls and
  decoration, placed with ProtonScatter, in the outlined cartoon look of G9 and G10; every
  object placed is made for Hack star (the addon's demo assets are not used).
- **W4 — Same rules:** The match rules stay as in the canyon: the arena is as big, bots find
  the player, the cover hides as the cactus patches do, start points are free of walls and
  cover and at least 4 m apart, and overtime and closing walls work as in the canyon (once spec
  11 adds them).
- **W5 — Smooth and on the web:** A match with 4 fighters in Glimmer Isles runs at 30 frames per
  second or more on a recent iPad (as G14) and works in the single-threaded web export; nothing
  of the world is computed on a thread while the game runs (if ProtonScatter cannot run there,
  its result is baked in the editor — the plan decides).
- **W6 — Credit:** ProtonScatter (HungryProton, MIT, version 4.2.0, its source) is credited in
  `LICENSES.md` with its licence file, and its version is pinned.
- **W7 — Canyon unchanged:** The canyon looks (apart from G10, G11) and plays as before.

### A — Drawing → character, done by Claude in this spec

- **A0 — Author's drawing first:** Part A starts only after the author has sent the photo of
  the drawing. Before part A the implementation stops, tells the author exactly what to do
  (photograph the whole drawing flat, in daylight, on plain paper with nothing else in the
  picture; no people, faces, full names or places; remove the photo's metadata such as GPS —
  as A1 and A7 say) and where to put it, and reminds him while it waits; nothing of part A is
  built from an invented drawing.
- **A1 — Workflow:** A short document in the repository says how to take the photo (whole
  drawing, flat, daylight, plain paper, nothing else in the picture), where to put it, and the
  exact request to give Claude via Copilot; following it, Claude turns one drawing into a
  character of the game without other tools.
- **A2 — In the game:** The drawn character is a new **fighter**, unlocked from the start with
  one default skin (more skins come with spec 10), with the name the child chooses: shown in the
  fighter list and the fighter screen, selectable, shown on home, and playable in Training and a
  match like every other fighter.
- **A3 — Recognisable:** The character is a 3D figure built from shapes, with the drawing's main
  shapes and colours (head, body, limbs, special parts such as a hat or a weapon) in the game's
  outlined cartoon style; a flat "paper cut-out" of the photo is the fallback only for a drawing
  too detailed for shapes. Mattia confirms "this is my drawing".
- **A4 — Moves like the others:** The drawn character has the idle, run and attack animations,
  its picture on the card, and the see-through in a bush, as the other fighters.
- **A5 — First drawing done:** At least one of Mattia's drawings is in the game at the end of this
  spec; the author provides the photo.
- **A6 — Limits written down:** The workflow document states what the result can and cannot be
  (one drawing per run; front view only — sides and back are guessed; no fine lines, textures or
  writing from the drawing; a name of 1–12 letters; a fighter, not a new attack) and how long a
  run takes.
- **A7 — Privacy:** Only drawings are photographed — no people, faces, full names or places; the
  photo's metadata (for example GPS) is removed before it is used; the original photo is not
  committed unless the author says so.
- **A8 — Licence:** The drawn character is credited in `LICENSES.md` as the child's own work
  under the repository's licence (with the first name or a nickname the author chooses); no
  drawing copied from a game, film or brand is accepted.
- **A9 — Repeatable:** A second drawing can be added the same way without changing the other
  fighters, and a drawn fighter can be removed again; saves that chose a removed fighter fall
  back to the default fighter.

### B — A better workflow: recommendation

- **B1 — Recommendation document:** A short document in the repository recommends one main
  workflow from a photo of a drawing to a 3D character in the Godot game with at most three
  tools (Google Flow and/or others, plus Claude via Copilot), step by step, and one fallback
  with fewer tools.
- **B2 — Facts per tool:** For each tool of B1 the document states what it does in the
  workflow, what it cannot do, the cost (free use and paid), account and minimum age, the
  output format and how Godot loads it, whether uploads are used for training, and the terms
  for using the result in this MIT-licensed open-source game, each with its source and date.
- **B3 — Google Flow:** The document states what Google Flow can and cannot do for a game
  character (images and videos, character consistency; no 3D model or rig), and where it fits in
  the workflow.
- **B4 — Licence first:** A tool whose terms do not allow publishing its results in an MIT
  open-source game, or are unclear, is not recommended (as root spec #21, S4); any required
  credit (for example CC BY 4.0) is listed for `LICENSES.md`.
- **B5 — Fit for the game:** The document states the limits a generated character must meet to
  join the game (size in MB and triangles for an iPad at 30 frames per second, the outlined
  cartoon look, the animations of A4).
- **B6 — Trial:** One drawing goes through the B1 workflow in this spec, done by the author with
  his own accounts (Google Flow; Meshy free plan — CC BY 4.0, credit Meshy), on free use only;
  its result, time and cost are recorded in the document, and it joins the game only if its
  licence allows it and Mattia prefers it to the part A version.

### Everywhere

- **S1 — Model:** Every stage and every Step of this spec (requirements, plan, implementation,
  review, close) runs on Claude Opus 5.5; the plan's Model column says so for every Step.
- **S2 — Gameplay unchanged:** Rules, numbers, controls, bots, matches, trophies, hack codes and
  saved progress behave as before; old saves load as before.
- **S3 — Checks pass:** `tools/test.ps1`, `tools/lint.ps1` and `tools/export_web.ps1` pass;
  tests that check texts or layouts are updated only where the look changes, not the behaviour.
- **S4 — Assets and licences:** Every new font, icon, texture, model or drawing is in
  `assets/` (or built in code) with a line in `LICENSES.md`; no Supercell art, names or logos;
  the README and `docs/architecture.md` describe the new look and the workflows.
- **S5 — Python + Svelte game unchanged:** Nothing outside `hack_star_godot/` changes, except
  links from root documents if needed.
- **S6 — Language:** New visible text is in English, as in the rest of the Godot game until
  spec 15.

### C — Two new characters (added 2026-11-22, author's request)

- **C1 — Two new fighters:** **Flarekid** (the "hero upgrade" of Blaze, a fighter of its own,
  not a Blaze skin) and **Echo** (the sound-powered hero from Mattia's drawing) join the
  fighters, unlocked for every account from the start (old saves included), with one Default
  skin each and playing like an existing fighter (as A2): Flarekid like Blaze, Echo like Luna.
  Both are shown in the fighter list, the fighter screen and on home, can be chosen, and are
  playable in Training and a match. Blaze and Beatbolt stay as they are.
- ~~**C2 — The author's pictures:** Each new fighter is shown with the author's pictures from
  `characters/blaze2/` and `characters/echo/`: the full-body picture in 3D, and the 512 × 512
  card picture on its fighter card and its skin button. The delivered scene files point to their
  own folder (`blaze2`'s path is fixed).~~ (superseded 2026-11-22 by M1, M2, M8: in play and on
  the pedestal the gameplay frames replace the single full-body picture; the card picture stays)
- **C3 — Reveal on the pedestal:** Whenever a fighter appears on home's pedestal or on the
  fighter screen (opening the screen, choosing another fighter or skin), it pops in — grows from
  small to its size with a short overshoot within 0.5 s — with a burst of glowing particles and a
  halo or frame in its rarity colour behind it. This holds for every fighter, not only the new
  ones.
- **C4 — Alive when standing:** On home and the fighter screen the two new fighters are never
  still: they breathe (a slight stretch and squash), bob and sway gently in a loop.
- ~~**C5 — Alive in play:** In Training and a match the two new fighters move like paper
  cut-outs: running hops with a lean and a squash on landing; they face left or right by
  flipping with the movement direction (and keep the last facing when moving straight up or
  down); a shot gives a recoil and a muzzle flash; a hit gives a short white flash; a knock-out
  makes them fall flat and fade before they are hidden, as the other fighters are.~~ (superseded
  2026-11-22 by M3–M5 and M7: front, back and side views, a walk loop and a shoot pose replace
  the left/right flip and the hop of one picture; the muzzle flash, the hit flash and the
  knock-out stay)
- **C6 — Toon fit:** The new fighters have a dark outline around their silhouette, as wide on
  screen as the other fighters' outline (G9), and a soft shadow on the ground; on a card and in
  the arena they read as clearly as the other fighters at the five screen sizes.
- **C7 — Cover:** In a bush (cover) the new fighters are see-through like the others.
- ~~**C8 — What is missing, written down:** A document says what a flat picture cannot do (no
  side or back view, no real turning, no drawn run or shot frames), what the author can make with
  the same tool to improve it (side and back views, a run cycle of 4–8 frames, a shot pose and a
  hit pose — same size, transparent background — or a 3D model through the B1 workflow), where to
  put the files, and what the game then does with them.~~ (superseded 2026-11-22 by M16: the
  author delivered the side and back views, walk and shoot frames; the document now says how the
  animated fighters work and how to add one)
- ~~**C9 — Licence:** `LICENSES.md` has a row per new picture: "generated by the author with an AI
  image tool from Mattia's drawing — tool to be confirmed by the author".~~ (superseded
  2026-11-22 by M13: MagMax, the frames and the projectiles are added)
- **C10 — Kept out:** `scenes/blaze_godot.zip` and `scenes/blaze_godot/` (with its zip) are never
  committed (`.gitignore`) and never in the web export; files of the delivery that the game does
  not use are not in the web export either; the author's files are not deleted.
- ~~**C11 — Size:** The two new fighters add at most 1.0 MB to the web export, and the whole
  export stays within G15's budget (Step 1 + 5 MB), measured in the working tree with the
  author's untracked files present.~~ (superseded 2026-11-22 by M14: three animated fighters
  with 12 frames each)

### V — Views while playing (added 2026-11-22, author's request)

- **V1 — Four views:** In Training and a match the player can switch between four camera views:
  **Classic** (today's angled view from above, the default), **Close** (the same angle, nearer to
  the fighter), **Behind** (low, just behind the fighter, looking ahead up the arena) and
  **Overview** (high above, the whole arena in sight).
- **V2 — Keys:** `V` switches to the next view (Classic → Close → Behind → Overview → Classic),
  `1`–`4` (also on the number pad) choose a view directly; they work during the countdown and the
  fight, and clash with no other key of the game.
- **V3 — Name shown:** After a switch the view's name is shown at the top of the screen on a dark
  backing for about 1.5 s.
- **V4 — Same controls:** In every view the movement keys move the fighter the same way on the
  screen as in Classic (W and up move away from the camera), and shooting is unchanged.
- **V5 — Framing:** In every view the player's fighter stays within the screen at the five screen
  sizes; Classic keeps G11; Overview shows all four border walls.
- **V6 — Kept and touch:** The chosen view is kept for the next match and Training while the game
  is open (not saved). Touch players get the default view; no touch button in this spec.
- **V7 — Documented:** The README's controls, the Info page's *How to play* and the start hint
  name the view keys.

### L — Brighter worlds and lighting presets (added 2026-11-22, author's request)

- **L1 — Brighter colours:** The canyon and Glimmer Isles look clearly more saturated and
  brighter than before the reopening (before and after screenshots of both worlds compared); the
  floor stays less saturated than the fighters, so the fighters stand out (G10).
- **L2 — More detail:** Each world gets at least three new kinds of decoration, at least one of
  them moving (for example flags, birds or water in the canyon; fireflies, waterfalls or
  pulsing crystals in Glimmer Isles); walls, cover, start points and collisions stay as they are
  (W4, W7, S2).
- **L3 — Lighting presets:** `L` switches to the next of at least four lighting presets —
  **Bright day**, **Golden sunset**, **Neon night**, **Candy pop** — in both worlds; each changes
  the sun, the sky, the ambient light and the colour balance (brightness, contrast, saturation);
  glow is used only where the web export shows it and the frame rate allows (L8).
- **L4 — Saturation boost:** `K` switches an extra saturation boost on and off, on top of any
  preset.
- **L5 — Name shown:** After `L` or `K` the preset's name, or "Saturation boost on/off", is shown
  as in V3.
- **L6 — Best default:** The preset a game starts with is the best-looking one, chosen from
  screenshots of every preset in both worlds; the reason is written down. The chosen preset and
  the boost are kept while the game is open (not saved).
- **L7 — Readable:** In every preset, with and without the boost, the fighters, shots, health
  bars, cover and see-through, and the HUD stay readable (screenshots).
- **L8 — Smooth:** With 4 fighters in both worlds, every preset and the boost, the desktop frame
  time and draw calls are measured and compared with a measurement before the reopening: draw
  calls at most 30 % more, frame time at most 30 % more and under 33 ms; the iPad check
  (≥ 30 frames per second, G14) stays with the author.

### M — Animated characters (added 2026-11-22, author's request)

- **M1 — Three animated fighters:** **MagMax** — a masked hero with flame hair and glowing
  lava-rock fists, the author's new character — joins the fighters: unlocked for every account
  from the start (old saves included), one Default skin, rarity **Epic**, playing like **Rocko**
  (the numbers of the fighter it plays like, no new attack, as C1 and A6). **Echo** and
  **Flarekid** keep their id, name, rarity, how they play, unlock and saved progress, and get the
  author's new delivery (12 gameplay frames and a projectile each; their hero and card pictures
  are the same files as before). All three are shown in the fighter list, the fighter screen and
  on home, can be chosen and are playable in Training and a match. Blaze, Beatbolt and the other
  fighters stay as they are. _(added 2026-11-22, author's request)_
- **M2 — Final folders:** The delivery lives in the game's character folders: Echo's in
  `characters/echo/`, Flarekid's in `characters/blaze2/` (the delivered `blaze_*` file names
  kept), MagMax's in `characters/magmax2/` (`characters/magmax/` is the author's older, untracked
  MagMax). Every delivered scene and resource points to the folder it is in — no path to
  `characters/blaze/`, `characters/magmax/` or a `*_new` folder — and the three `*_new` folders
  are moved, not copied (they no longer exist afterwards). _(added 2026-11-22, author's request)_
- **M3 — Facing from movement:** In Training and a match (the player and the bots) an animated
  fighter shows its **back** view while it moves up the screen (away from the camera), its
  **front** view while it moves down the screen, and its **side** view while it moves mostly left
  or right (mirrored for left); a diagonal shows the closer of these, and standing still keeps the
  last view. Up on the screen is the same direction in all four camera views (the camera never
  turns, V4), so the facing is the same in Classic, Close, Behind and Overview. At the start of a
  match and of Training the fighter shows its front view. _(added 2026-11-22, author's request)_
- **M4 — Walk and idle:** While it moves, an animated fighter plays the walk loop of its current
  view (walk 1, idle, walk 2, idle) at a pace that fits its speed, with a small hop; when it stops
  it shows that view's idle frame at once and stays alive (breathing, as C4). It never slides
  across the ground as a still picture. _(added 2026-11-22, author's request)_
- **M5 — Shoot pose:** On every shot (Space, the release of the touch aim, a tap that fires at the
  nearest target, a bot's shot) an animated fighter turns to the view of the shot's direction,
  shows that view's shoot frame for about 0.25 s and then walks or idles again; the muzzle flash
  appears at the fist, blaster or fireball of that frame. _(added 2026-11-22, author's request)_
- **M6 — Own projectiles:** The shots of MagMax, Echo and Flarekid look like their delivered
  projectile pictures (a lava-fist shockwave, a sound wave, a fireball), turned along the
  direction they fly; they fly as fast and as far, hit, stop at walls and do the damage of every
  other shot, and the hit burst stays (S2); they are readable in all four views and every
  lighting preset (L7). The other fighters keep their shots. _(added 2026-11-22, author's
  request)_
- **M7 — Effects kept:** In every view and frame the animated fighters keep the dark outline as
  wide on screen as the other fighters' (C6), the soft shadow, the white hit flash, the knock-out
  (tip over and fade, then hidden), the see-through in cover (C7), and the health bar and damage
  numbers over the figure in every camera view; their feet stay on the ground, they do not jump
  in size between frames, and they read about as tall on screen as the other fighters.
  _(added 2026-11-22, author's request)_
- **M8 — Showcase on the pedestal:** On home, the fighter screen and the result screen an
  animated fighter pops in with sparks and its rarity halo (C3), then plays a showcase loop of at
  most 8 s that never stands still: idle facing the viewer, a turn through its views (front,
  side, back, the other side, front), a few walk steps on the spot, and a shoot pose with its
  projectile flying out and a burst of sparks; then it starts again. _(added 2026-11-22, author's
  request)_
- **M9 — Turn and shoot on the fighter screen:** On the fighter screen the player can turn an
  animated fighter through its views by dragging left or right over it, and make it shoot (the
  shoot pose with its projectile) with a tap or click on it — with the mouse and with touch; the
  showcase goes on a few seconds after the last drag or tap. _(added 2026-11-22, author's
  request)_
- **M10 — Living cards:** On the fighter list the card of each animated fighter moves: its figure
  plays its idle and walk frames on the card with its card picture, and a light sweep in its
  rarity colour crosses the card every few seconds; a locked card stays grey (G7); the list fits,
  scrolls and reacts as before at the five screen sizes. _(added 2026-11-22, author's request)_
- **M11 — Clearly better, on screenshots:** Before and after screenshots of home, the fighter
  list, the fighter screen and a match with each of the three fighters (1280 × 720 and
  820 × 1180, and short frame sequences of the animation) show the animated fighters clearly
  livelier than the single pictures before; what changed is written in this spec; the author's
  own verdict (as G1) stays with the author. _(added 2026-11-22, author's request)_
- **M12 — Kept out:** The author's older `characters/magmax/` and every zip are never committed,
  changed or in the web export; of the delivery only what the game uses is in the web export (no
  preview picture, and no delivered example script or scene the game does not use).
  _(added 2026-11-22, author's request)_
- **M13 — Licence:** `LICENSES.md` has rows for every picture of the three fighters (hero, card,
  frames, projectile): "generated by the author with an AI image tool from Mattia's drawing or the
  author's own idea — the tool, and the drawing or idea per character, to be confirmed by the
  author"; the existing Echo and Flarekid rows are updated. _(added 2026-11-22, author's request)_
- **M14 — Size:** The three animated fighters' files in the web export (pictures, frames,
  projectiles) are together at most 3.5 MB, and the whole export stays within G15's budget
  (at most 45,361,090 bytes: Step 1 + 5 MB), measured in the working tree with the author's
  untracked files present; the sizes are reported. _(added 2026-11-22, author's request)_
- **M15 — Smooth:** With four animated fighters in a match in both worlds the desktop frame time
  and draw calls stay within L8 of the reopening's baseline (Step 21); the game is playable within
  5 s after **Play** as before (G15); the iPad check (≥ 30 frames per second, G14) stays with the
  author. _(added 2026-11-22, author's request)_
- **M16 — Documented:** The README, `docs/architecture.md` and `docs/drawing_to_fighter.md`
  (*Picture fighters*) say how the animated fighters work (views, walk, shoot pose, projectiles,
  showcase) and how the author adds another one from the same kind of delivery (12 frames, a card,
  a hero picture, a projectile). _(added 2026-11-22, author's request)_

### Open questions

None. The author answered Q1–Q7 on 2026-11-22 (Q1 3D built from shapes, cut-out as the
fallback → A3; Q2 a new fighter, unlocked from the start, one default skin → A2; Q3 home and the
match first, then the fighter list and screen, then the result, info and hack screens, all in
this spec → G17; Q4–Q7 the suggestions → B6, G1, G18, G3 and G5) and added part W and A0.

Reopened 2026-11-22: the questions of parts C, V and L were answered with the suggestions
(the author's rule for this run): Q8 the Blaze upgrade's name → **Flarekid** (C1; original,
not "Blaze"); Q9 rarity and how they play → Flarekid like Blaze, Echo like Luna, one Default skin
(C1); Q10 the keys → `V` and `1`–`4` for views, `L` and `K` for lighting, checked against the
existing keys (V2, L3, L4); Q11 a touch button for views → not in this spec, touch keeps the
default (V6); Q12 the Behind view and the controls → the camera never turns, so the keys keep
their direction (V1, V4); Q13 the reveal → for every fighter (C3).

Reopened again 2026-11-22 (animated characters): the questions of part M were answered with the
suggestions (the author's rule for this run): Q14 MagMax's data → rarity **Epic** (the rarity
with only one fighter, Frosty), plays like **Rocko** (lava-rock fists, a brawler like the rock
golem), unlocked from the start, one Default skin, the name written **MagMax** as in the author's
request (the files say "Magmax") (M1); Q15 the folders → `characters/echo/` and
`characters/blaze2/` kept (their imports, links and the export filter stay; Flarekid's `blaze_*`
names kept), `characters/magmax2/` for MagMax because `characters/magmax/` is the author's older
untracked folder (M2); Q16 the view at the start → the front view, so the player sees the face
(the delivery starts in the back view) (M3); Q17 the projectiles → their pictures change only the
look of the shot, never its rules (M6); Q18 where the showcase plays → every pedestal (home, the
fighter screen, the result), as the reveal (M8, C3). **Open with the author (not blocking;
Deferred Items):** the AI image tool's name and, per character, Mattia's drawing or the author's
idea (M13); and whether the name **MagMax** is fine — a 1985 arcade game by Nichibutsu is called
"MagMax" (no fighter, skin or brand of the repository uses it).

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## Closing summary

_First close (2026-11-22, Steps 1–20). The spec was reopened in place the same day for the
author's request — two new characters, views and lighting (C1–C11, V1–V7, L1–L8, Steps 21–29) —
and closed again the same day after Step 29, its review and the review fixes (see **Reopened
2026-11-22** below)._

**Built:** The Godot game has the new cartoon look: every menu screen stands on a purple gradient with soft light rays (`MenuBackground`), titles, headings, buttons and numbers use the outlined display font Lilita One, the buttons are coloured with icons (Kenney *Game Icons*, CC0, plus a few drawn in code) and show hover and press from the theme alone, and trophies, credits, power, the timer and the fighters left are icon chips. Home has a two-colour logo, the chosen fighter on a pedestal and a large yellow **Play**; the fighter cards have rarity-coloured backdrops (grey with a lock for locked fighters); the fighter screen a framed stage and skin pictures in rarity frames; the result, info, hack and QR screens follow. Fighters, the canyon and the new world share cel-shaded toon materials with an outline of fixed pixel width (`ToonMaterials`), the camera keeps the near wall under 10 % of the screen in every world, and the FPS label is hidden unless **Show FPS (play-test)** is switched on in Info. A second world, **Glimmer Isles** (crystal ridges, glow-fern cover, giant mushrooms and floating islands, original art), is placed with ProtonScatter 4.2.0 in the editor and baked into plain MultiMeshes (`tools/bake_world.ps1`), so no addon code ships; the world button on home chooses it for **Play** and **Training** (`Worlds`, per-world `ArenaLayout`). Mattia's drawing became **Beatbolt**, a seventh fighter built from shapes (`scenes/drawn/`), unlocked from the start and playable; `docs/drawing_to_fighter.md` says how to add or remove a drawn fighter and `docs/drawing_tools.md` recommends a Google Flow → Meshy → Claude workflow with sources, terms and fit limits. The web export grew by 0.16 MB (budget 5 MB). Nothing in `server/` or `ui/` changed.

**Differs from the plan:** Step 19 (the B6 trial with Google Flow and Meshy) is 🔜 Deferred: it needs the author's own accounts; its instructions are in `docs/drawing_tools.md`. What only the author and Mattia can do is not invented and stays in **Deferred Items**: the G1 side-by-side verdict, Mattia's A3 "this is my drawing", the iPad play-test (G14, W5, G15's 5 s) and the trial — the spec is closed with these open, as D17 foresaw. Step 7 shows a "Locked" chip instead of a price on locked cards, because the game has no prices yet (D19). Step 16 keeps Beatbolt standing instead of the drawing's crouch (the animations need it) and scales him to 0.85. The code review (Approve, 0 Blocking · 2 Should-fix · 8 Nit) was handled: findings 1–7 fixed (the architecture names the five look tests; the near-wall test runs in every world; a Markdown heading in Step 16; the ordered list's status and the double 09 explained; two float/int warnings; `Hacks.power_text`, the theme's `BackgroundPanel` and `IconButton` and the icons `gear`, `star`, `singleplayer` removed; `GameState.reset()` also sets `ArenaLayout` back to the canyon, with a test), findings 8 and 9 deferred (tool scripts without tests and lint; the kit's schema accepts only S-numbered statements), finding 10 decided as D19 (prices come with Unlock and Upgrade S2 and the Skins Shop).

**Files:** `hack_star_godot/assets/` (`fonts/` Lilita One, `icons/` Kenney), `hack_star_godot/scenes/` (`toon/`, `ui/` — theme, `icons`, `icon_chip`, `menu_background`, `world_choice`, `fighter_card`, `fighter_stage`, `fighter_pictures` —, `drawn/`, `worlds/glimmer_isles/`, `home`, `arena`, `match_arena`, `canyon`, `fighter_model`, `fighter_screen`, `result_screen`, `info`, `hack_screen`, `qr_page`, `autoload/game_state`), `hack_star_godot/game/` (`worlds`, `glimmer_isles_layout`, `arena_layout`, `fighters`, `sample_progress`, `hacks`, `bot_brain`, `controls_help`), `hack_star_godot/addons/proton_scatter/` (editor only, excluded from the export), `hack_star_godot/tools/` (`bake_world.ps1`, `bake_world.gd`, `check_tools.ps1`, `versions.json`), `hack_star_godot/tests/` (the look, world, framing and drawn-fighter tests), `hack_star_godot/docs/` (`architecture.md`, `drawing_to_fighter.md`, `drawing_tools.md`), `hack_star_godot/README.md`, `hack_star_godot/LICENSES.md`, `project.godot`, `export_presets.cfg`; this spec, now in `done/`, its change record in `changes/done/` and the review page in `review/`.

**Reopened 2026-11-22:** *What was added (Steps 21–29).* Two new fighters from the author's pictures, **Flarekid** (`characters/blaze2/`) and **Echo** (`characters/echo/`), unlocked from the start and playable: each is an outlined, camera-facing paper cut-out (`CutoutFighters`, `scenes/toon/cutout.gdshader`) with a soft shadow, its card picture on the cards and skin buttons, see-through in cover; in play it hops with a squash and a lean, looks left or right with the movement and the shot, shows a muzzle star, flashes white on a hit and tips over and fades at a knock-out (`CutoutMotion`); the four pictures are imported web-safe (0.67 MB for both, C11) and credited in `LICENSES.md`. Every fighter on a pedestal pops in with sparks and a halo in its rarity colour (the reveal of `FighterStage`), and the picture fighters breathe, bob and sway. **Views:** `V` and `1`–`4` switch Training and a match between Classic, Close, Behind and Overview (`CameraViews`) with a short blend and the view's name in a toast (`HudToast`); the camera never turns, so the controls stay the same. **Brighter worlds:** both worlds more vivid, with four new kinds of moving decoration each and no collider (`CanyonDecor`: blossoms, flags, birds, a stream; `GlimmerDecor`: fireflies, pulsing crystals, waterfalls, turning islands). **Lighting presets:** `L` switches between Bright day (the default), Golden sunset, Neon night, Candy pop and Classic, `K` a saturation boost (`LightPresets`, `WorldLighting`). Measured on the desktop every preset × world × view stays within L8 (draw calls below the baseline); the web export is 41,244,423 bytes (+0.88 MB vs Step 1, 4.1 MB under the budget). *Differences from the plan:* nothing was trimmed in Step 28 (every row within L8); the author dropped newer art into `characters/` during the run — kept untracked and out of the web export (D31, extended in Step 25); the health bar and the damage numbers of a picture fighter now sit over the picture along the camera's up instead of straight up (review fix, below); L8 is judged on the warm run of each pair (D32) and V5 after the 5 s start hint (D33). *Review* ([2026-11-22_better-graphics-2.html](../../review/2026-11-22_better-graphics-2.html), range `bccd2ed..f10d71c`): Approve, 0 Blocking · 1 Should-fix · 4 Nit, all handled — #1 (Should-fix: in Overview a picture fighter's bar and numbers showed under him in the lower half of the screen) fixed with a stronger test (both worlds, every view, the fighter at the centre, edges and corners; checked on real 820×1180 screenshots), #2 (the crystal pulse changed the shared `ToonMaterials` entry) fixed with an own copy per crystal part and a test, #3 (the ordered list) set to *closed*, #4 decided as D32 (with a Deferred row for shader pre-warm), #5 decided as D33 (no change). Open with the author (Deferred Items): the iPad check of the reopened parts, the AI image tool's name for `LICENSES.md`, a touch button for views and lighting, more pictures for Flarekid and Echo, the author's newer art for a follow-up, and the shader pre-warm. *Files:* `hack_star_godot/characters/` (`blaze2/`, `echo/`), `scenes/cutout/`, `scenes/toon/` (`cutout`, `flag`, `flowing_water` shaders), `scenes/ui/` (`hud_toast`, `fighter_pictures`, the reveal of `fighter_stage`), `scenes/` (`arena`, `home`, `canyon`, `fighter`, `fighter_model`, `damage_number`, `world_lighting`, `canyon_decor`, `worlds/glimmer_isles/` — `glimmer_decor`, `glimmer_isles`, the props and the re-baked `baked.tscn` —, `autoload/game_state`), `game/` (`camera_views`, `light_presets`, `fighters`, `sample_progress`, `controls_help`), `project.godot` (the view and light keys), `export_presets.cfg` (the filter for the author's art), the reopening's tests (`test_cutout_fighters`, `test_fighter_reveal`, `test_camera_views`, `test_light_presets`, `test_world_decor`), `README.md`, `docs/architecture.md`, `docs/drawing_to_fighter.md`, `LICENSES.md`; the change record `changes/done/better-graphics-2/` and the review page.

## 2 · Spec Overview

| Step | Description | Model (suggested) | Status | Detail |
|------|-------------|-------------------|--------|--------|
| **1** | Before screenshots and size baseline | reasoning (Claude Opus 5.5) — S1; capturing both games the same way, the reference for G1 and G15 | ✅ Done | [→ Step 1](#step-1--before-screenshots-and-size-baseline) |
| **2** | Font, icons and theme | reasoning (Claude Opus 5.5) — S1; new pinned assets with licences and a theme that every screen inherits (D3, D4, D7) | ✅ Done | [→ Step 2](#step-2--font-icons-and-theme) |
| **3** | Toon look of the fighters | reasoning (Claude Opus 5.5) — S1; shaders for cel shading and a screen-space outline, graphics-heavy (D5) | ✅ Done | [→ Step 3](#step-3--toon-look-of-the-fighters) |
| **4** | Home screen | reasoning (Claude Opus 5.5) — S1; the screen Mattia sees most, layout at five sizes (D6, D7) | ✅ Done | [→ Step 4](#step-4--home-screen) |
| **5** | Arena look | reasoning (Claude Opus 5.5) — S1; the canyon in the outlined look without losing frames (D5) | ✅ Done | [→ Step 5](#step-5--arena-look) |
| **6** | Arena framing and match HUD | reasoning (Claude Opus 5.5) — S1; camera rule with a test, HUD chips, the FPS switch (D8); mid-way look | ✅ Done | [→ Step 6](#step-6--arena-framing-and-match-hud) |
| **7** | Fighter cards | reasoning (Claude Opus 5.5) — S1; the list's cards with pictures, icons and the lock | ✅ Done | [→ Step 7](#step-7--fighter-cards) |
| **8** | Fighter screen and skin pictures | reasoning (Claude Opus 5.5) — S1; stage, skin pictures in rarity frames | ✅ Done | [→ Step 8](#step-8--fighter-screen-and-skin-pictures) |
| **9** | Result, info, hack and QR screens | reasoning (Claude Opus 5.5) — S1; the remaining screens in the new look | ✅ Done | [→ Step 9](#step-9--result-info-hack-and-qr-screens) |
| **10** | ProtonScatter addon | reasoning (Claude Opus 5.5) — S1; a new pinned dependency kept out of the export (D11) | ✅ Done | [→ Step 10](#step-10--protonscatter-addon) |
| **11** | Worlds and the world choice | reasoning (Claude Opus 5.5) — S1; the arena layout per world, the Glimmer Isles layout and the choice on home (D9, D10) | ✅ Done | [→ Step 11](#step-11--worlds-and-the-world-choice) |
| **12** | Glimmer Isles objects and scatter scene | reasoning (Claude Opus 5.5) — S1; original fantasy props and the ProtonScatter setup (D13) | ✅ Done | [→ Step 12](#step-12--glimmer-isles-objects-and-scatter-scene) |
| **13** | Glimmer Isles baked and playable | reasoning (Claude Opus 5.5) — S1; the bake tool, the world in a match, web export and frame rate (D12) | ✅ Done | [→ Step 13](#step-13--glimmer-isles-baked-and-playable) |
| **14** | Gate: author's drawing photo | reasoning (Claude Opus 5.5) — S1; no code: stops the run and tells the author what to do (A0, D14) | ✅ Done | [→ Step 14](#step-14--gate-authors-drawing-photo) |
| **15** | Drawing workflow document | reasoning (Claude Opus 5.5) — S1; the repeatable workflow, limits and privacy rules (D15) | ✅ Done | [→ Step 15](#step-15--drawing-workflow-document) |
| **16** | Drawn fighter in the game | reasoning (Claude Opus 5.5) — S1; reading the drawing and building a recognisable fighter from shapes (D14) | ✅ Done | [→ Step 16](#step-16--drawn-fighter-in-the-game) |
| **17** | Adding and removing drawn fighters | reasoning (Claude Opus 5.5) — S1; the add/remove path and the save fallback, with tests (D14) | ✅ Done | [→ Step 17](#step-17--adding-and-removing-drawn-fighters) |
| **18** | Tool recommendation document | reasoning (Claude Opus 5.5) — S1; research with sources and dates, licence first (D15) | ✅ Done | [→ Step 18](#step-18--tool-recommendation-document) |
| **19** | Trial of the recommended workflow | reasoning (Claude Opus 5.5) — S1; the author's trial with his accounts, recorded and judged (D17) | 🔜 Deferred | [→ Step 19](#step-19--trial-of-the-recommended-workflow) |
| **20** | Final check, README and architecture | reasoning (Claude Opus 5.5) — S1; every Godot check, the size budget, the side-by-side verdict and the documents | ✅ Done | [→ Step 20](#step-20--final-check-readme-and-architecture) |
| **21** | Baseline, art import and licences | reasoning (Claude Opus 5.5) — S1; the before set and the measurements of the reopening, web-safe imports within the size budget (D22, D28) | ✅ Done | [→ Step 21](#step-21--baseline-art-import-and-licences) |
| **22** | Flarekid and Echo in the game | reasoning (Claude Opus 5.5) — S1; a new kind of fighter look (cut-out shader with outline, shadow, see-through) behind the existing model API (D20, D21) | ✅ Done | [→ Step 22](#step-22--flarekid-and-echo-in-the-game) |
| **23** | Pedestal reveal and idle | reasoning (Claude Opus 5.5) — S1; animation and particles on home and the fighter screen, graphics-heavy (D23) | ✅ Done | [→ Step 23](#step-23--pedestal-reveal-and-idle) |
| **24** | Paper cut-out animation in play | reasoning (Claude Opus 5.5) — S1; run, facing, recoil, flashes and knock-out of a flat figure; the missing-art document (D24, D29) | ✅ Done | [→ Step 24](#step-24--paper-cut-out-animation-in-play) |
| **25** | Camera views | reasoning (Claude Opus 5.5) — S1; four camera rigs with framing rules at five sizes, new keys and the HUD toast (D25) | ✅ Done | [→ Step 25](#step-25--camera-views) |
| **26** | Brighter worlds and more detail | reasoning (Claude Opus 5.5) — S1; palettes and new animated decoration in both worlds without touching the rules (D26) | ✅ Done | [→ Step 26](#step-26--brighter-worlds-and-more-detail) |
| **27** | Lighting presets and saturation boost | reasoning (Claude Opus 5.5) — S1; environment and light presets in the Compatibility renderer, the default chosen from screenshots (D27) | ✅ Done | [→ Step 27](#step-27--lighting-presets-and-saturation-boost) |
| **28** | Performance comparison | reasoning (Claude Opus 5.5) — S1; measuring every preset, world and view against the baseline and trimming what is over (D28) | ✅ Done | [→ Step 28](#step-28--performance-comparison) |
| **29** | Final check of the reopening, README and architecture | reasoning (Claude Opus 5.5) — S1; every Godot check, the size report, the after set and the documents | ✅ Done | [→ Step 29](#step-29--final-check-of-the-reopening-readme-and-architecture) |
| **30** | Delivery into the final folders, imports and export filter | reasoning (Claude Opus 5.5) — S1; the before set, moving the author's files with fixed paths, web-safe imports within the size budget (D35, D42) | ✅ Done | [→ Step 30](#step-30--delivery-into-the-final-folders-imports-and-export-filter) |
| **31** | MagMax joins and the frame table | reasoning (Claude Opus 5.5) — S1; a new fighter and the frames behind the existing cut-out look, loaded on demand (D34, D36) | ✅ Done | [→ Step 31](#step-31--magmax-joins-and-the-frame-table) |
| **32** | Facing, walk and shoot pose in play | reasoning (Claude Opus 5.5) — S1; the animator with the camera's orientation in every view, keeping every effect (D37) | ✅ Done | [→ Step 32](#step-32--facing-walk-and-shoot-pose-in-play) |
| **33** | Own projectiles | reasoning (Claude Opus 5.5) — S1; a picture look for the shot without touching the combat rules (D38) | ✅ Done | [→ Step 33](#step-33--own-projectiles) |
| **34** | Showcase on the pedestal, turn and shoot on the fighter screen | reasoning (Claude Opus 5.5) — S1; a timeline on every pedestal and mouse/touch input, graphics-heavy (D39) | ✅ Done | [→ Step 34](#step-34--showcase-on-the-pedestal-turn-and-shoot-on-the-fighter-screen) |
| **35** | Living cards on the fighter list | reasoning (Claude Opus 5.5) — S1; animated cards at five sizes without a cost off screen (D40) | ✅ Done | [→ Step 35](#step-35--living-cards-on-the-fighter-list) |
| **36** | Performance and the after set | reasoning (Claude Opus 5.5) — S1; measuring four animated fighters against the baseline, the after set compared (D42) | ✅ Done | [→ Step 36](#step-36--performance-and-the-after-set) |
| **37** | Final check of the animated characters, README, architecture and licences | reasoning (Claude Opus 5.5) — S1; every Godot check, the size report and the documents | ✅ Done | [→ Step 37](#step-37--final-check-of-the-animated-characters-readme-architecture-and-licences) |

**Reopened 2026-11-22:** Steps 1–20 were done in the first run and are kept unchanged with their
Notes. Steps 21–29 cover the added parts C, V and L; every one runs on Claude Opus 5.5 (S1, D1)
and is done by the agent; the iPad check of the new parts stays with the author (Deferred Items).

**Reopened again 2026-11-22 (animated characters):** Steps 1–29 are kept unchanged with their
Notes. Steps 30–37 cover part M (M1–M16, D34–D43); every one runs on Claude Opus 5.5 (S1, D1),
is done by the agent and checks the look on real screenshots (D2; PNGs under `%TEMP%\hs09c\`);
the iPad check, the image tool's name and the name MagMax stay with the author (Deferred Items).
Step 30 moves the author's untracked `*_new` folders and commits them; `characters/magmax/` and
the zips are never touched.

**Who does what:** Steps 1–13, 15–18 and 20 are done by the agent. **Step 14 is a gate:** it
stops the run until the author has sent the photo (A0); Steps 15–20 start only after it.
**Step 19 needs the author** (his Google Flow and Meshy accounts, B6); Step 20 needs the author
and Mattia for the side-by-side verdict (G1) and the iPad play-test (G14, W5) — the agent
prepares everything and records their answers (D17).

> **Step completion protocol (required):** every time a Step is finished, in the same edit:
> 1. Tick its tasks `[x]` **and** set its row in this table to ✅ Done.
> 2. Append a **`**Done (YYYY-MM-DD · ~<duration> · <model>)**`** line to that Step's
>    **Notes**: date, time it took, the AI model that did the work, a one-line summary and
>    the verifying test/command result. With per-Step models, end it with
>    `suggested: <tier> (<model>) · ran: <model>`; with cost tracking on, with
>    `· ~<tokens> · ~<currency> <amount>` from the `usage` script.
>
> The table and the Step sections must **always agree**.

> **Time tracking (required for every Step):** each Step's **first task** is
> `Record the start time in Notes` (e.g. `Started: YYYY-MM-DD HH:MM`); the Done line records
> the finish and the duration.

> **Godot spec:** this spec lives in `hack_star_godot/.specs/`. Every stage writes its files
> there (`changes/`, `review/`, `costs.md`, `features/done/`), never in the root `.specs/`;
> the checks are `hack_star_godot/tools/check_tools.ps1`, `test.ps1`, `lint.ps1`,
> `export_web.ps1` (all exit 0) and the guideline is
> `hack_star_godot/.specs/guidelines/gdscript.md` ([AGENTS.md](../../../../AGENTS.md)). Each
> Step ends with `tools/test.ps1` and `tools/lint.ps1` exit 0. Nothing in `server/` or `ui/`
> changes (S5). `gdlint` allows at most 20 public tests per file: new tests go into new files
> where a file is full. **Looks are checked on real screenshots** (D2): a windowed Godot run
> (not headless) with a temporary capture script (PNGs under `%TEMP%`, viewed, then the script
> removed, never committed), at 1280×720 and 820×1180 (iPad portrait) unless the Step says
> otherwise; the Step's Notes say what was looked at and what was changed after looking.
> **Every Step runs on Claude Opus 5.5** (S1, D1).

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | **One model:** every Step's Model column is `reasoning (Claude Opus 5.5)`; the implementation, review and close run on Claude Opus 5.5 too, and the Done lines say `suggested: reasoning (Claude Opus 5.5) · ran: <model>`. | S1, the author's choice for this spec. |
| D2 | **Screenshots:** looks are judged on real screenshots of a windowed Godot run (the GPU renders as on a device; headless has no image). A temporary script (an autoload added for the run, or `--script`) waits for the screen, saves `get_viewport().get_texture().get_image()` as PNG and quits; it is removed before the commit. The **before** and **after** sets for G1 (home, fighter list, fighter screen, a match; both games; 1280×720 and 820×1180) are kept outside the repository in `%LOCALAPPDATA%\hack_star\screens\09\before\` and `…\after\` with the same file names (`godot_home_1280x720.png`, `svelte_home_1280x720.png`, …) — not committed (size, and the Svelte side is software-rendered); the Svelte game is run with `npm run dev` in `ui/` and captured in a headless browser, as the requirements stage did, without changing `ui/`. | G1, G17; the same method for both sets makes the comparison fair; the repository stays small. |
| D3 | **Font:** **Lilita One** (Google Fonts, Juan Montoreano, SIL Open Font License 1.1, one heavy weight, about 30–60 KB) in `assets/fonts/LilitaOne-Regular.ttf` with `assets/fonts/OFL.txt`; pinned in `tools/versions.json` (`"font_lilita_one"`: the version in the font's name table) with its source (the `ofl/lilitaone/` folder of `github.com/google/fonts` at a named commit) and SHA-256 in `LICENSES.md`. It is used for the title, headings, buttons and numbers, with `outline_size` and a dark `font_outline_color` plus a shadow in the theme; body text keeps Godot's default font (readable, no download). | G3, G15, S4: one bold, rounded display font close to the Svelte look's weight 900 text; OFL allows shipping it in an MIT game with its licence file. |
| D4 | **Icons:** **Kenney "Game Icons"** (kenney.nl, CC0 1.0): only the icons used (play, trophy, credits/coin, power, lock, price tag, fighters, info, hack/key, back, home, clock, fighters left, eye, world, settings — about 15–20 white PNGs, tinted in Godot with `modulate` or `icon_*_color`) are copied into `assets/icons/` with Kenney's `License.txt`; the pack version (from its `License.txt`/download page) is pinned in `tools/versions.json` (`"kenney_game_icons"`), the download URL and date in `LICENSES.md`. An icon missing from the pack is drawn in code (own work, MIT). | G5, G15, S4: CC0 needs no credit but we credit anyway, as `ui/public/assets/LICENSES.md`; copying only the used icons keeps the export small. |
| D5 | **Toon look (outline technique):** two shaders in `scenes/toon/`: `toon.gdshader` (3 clear bands — light, mid, shadow — in `light()`, a thin rim; colour, emission and see-through alpha as uniforms; works in the Compatibility renderer) and `outline.gdshader`, an **inverted hull** as the material's `next_pass` (`cull_front`, `unshaded`, dark colour) that grows each vertex **along its normal in clip space by a fixed number of pixels** (about 3 px at 720 px height, scaled with the viewport height), so the outline keeps its width on a 150 px card and in the arena — unlike today's `OUTLINE_GROW` 0.022 in metres. `ToonMaterials` (`scenes/toon/toon_materials.gd`) caches one material pair per colour, shared by fighters, arena and world props (also on `MultiMeshInstance3D` via `material_override`). It replaces `DIFFUSE_TOON` and the grown copy in `FighterModel` and the toon materials of `Canyon`. | G9, G10, W3, G14: the Svelte look (`parts.ts`: 3-step shading, dark hull 7 % larger) in a form that stays visible at every size; one pair per colour keeps draw state small for the iPad. |
| D6 | **Menu background and stage:** a `MenuBackground` scene (`scenes/ui/menu_background.tscn`, a `ColorRect` with `menu_background.gdshader`: a purple gradient with slow soft light rays) behind every menu screen; `FighterStage` gets a round pedestal (a toon-shaded cylinder with outline and a soft shadow disc) and a frame on the fighter screen. | G2: one shared background instead of a flat colour per screen; drawn by the GPU, no texture to download. |
| D7 | **Buttons in the theme:** `hack_star_theme.tres` gets type variations per colour (`PlayButton` large yellow, `GreenButton`, `BlueButton`, `PinkButton`, `IconButton` round) with `StyleBoxFlat`s for normal, hover (lighter), pressed (darker, content moved 3 px down, no bottom edge) and focus; icons are set as `Button.icon`. A press and a hover are shown by the theme in the same frame, with no script; the entrance animation stays in `home.gd`. Chips (trophies, credits, power, timer, fighters left) are one small scene `scenes/ui/icon_chip.tscn` (dark rounded backing, icon, number in the display font). | G5, G6, G12, G18: a theme change reaches every screen; no per-button script to forget. |
| D8 | **FPS label:** hidden for players; the info screen gets a **Show FPS (play-test)** switch that sets `GameState.show_fps` (kept while the game is open, not saved — no save change). | G12, S2: the author can switch it on on the iPad without a keyboard; saves stay as they are. |
| D9 | **Worlds and layouts:** `game/worlds.gd` (`Worlds`, static): the list `[{id: "canyon", name: "Canyon"}, {id: "glimmer_isles", name: "Glimmer Isles"}]`, `ids()`, `get_world(id)`, all unlocked from the start (no save field). `ArenaLayout` becomes per world: today's constants become the canyon's layout data, a second layout holds Glimmer Isles (same `SIZE` 20 × 26 m, own walls, cover patches, decoration spots, dummies and start points); `ArenaLayout.use(world_id)` sets the active layout (default canyon) and the existing functions (`bounds`, `in_bush`, `is_free`, …) and accessors (`walls()`, `bushes()`, `starts()`, …) read it, so `BotBrain`, `ControlsHelp`, `Arena` and `MatchArena` keep their logic. `GameState.world` (memory only, default `"canyon"`) holds the choice; `Arena` and `MatchArena` call `ArenaLayout.use(GameState.world)` and build `Canyon` or `GlimmerIsles`. Collisions and hiding come from the layout rectangles, never from scattered meshes. | W1, W2, W4, W7, S2: one source of truth for the rules per world; the canyon's numbers do not change; saving the choice is spec 18 (S19), so the save version stays. |
| D10 | **World choice (minimal):** on home, a `WorldButton` (world icon + the current world's name) next to **Play** opens a small popup with the two worlds (the current one marked); the choice applies to **Play** and **Training**. Spec 18 replaces it with its world screen. | W2: the smallest UI that lets the player choose before a match and before Training. |
| D11 | **ProtonScatter in the project:** version **4.2.0** from the Godot Asset Store download (its `plugin.cfg` says 4.2.0) is copied into `addons/proton_scatter/` **without** `demos/` and `tests/` (not used — the demo assets are textured and realistic, Gobot is Godot's mascot — and they are most of the repository's 15 MiB); its `LICENSE` stays in the folder. The plugin is enabled in `project.godot` (`editor_plugins`, next to GUT). `tools/versions.json` gets `"protonscatter": "4.2.0"`, and `check_tools.ps1` checks `addons/proton_scatter/plugin.cfg` like GUT. `LICENSES.md` gets a row (MIT, "Copyright (c) 2019 HungryProton", source URL, download date and SHA-256 of the zip). `lint.ps1` already skips `addons/`; `export_presets.cfg` excludes `addons/proton_scatter/*` (the game uses only the baked result, D12). | W3, W6, G15: a new dependency, pinned and credited like GUT; nothing of it ships. |
| D12 | **Always baked:** ProtonScatter rebuilds on load on a `Thread` (`force_rebuild_on_load`, `dbg_disable_thread`) — a risk in the single-threaded web export and extra start-up time — so the scatter result is **baked**: `tools/bake_world.ps1` runs `tools/bake_world.gd` with Godot (headless; a windowed run if headless cannot rebuild), which loads `scenes/worlds/glimmer_isles/scatter_source.tscn`, sets every `ProtonScatter` to `dbg_disable_thread = true` and `enable_updates_in_game = true` with a fixed `global_seed`, waits for the rebuild, and saves the outputs as plain `MultiMeshInstance3D` nodes (toon materials of D5) in `scenes/worlds/glimmer_isles/baked.tscn`, which references no addon script. The game loads only `baked.tscn`; the source scene is re-baked by hand when it changes (README *How to…*). | W5, G15: no thread and no addon code while the game runs; the same result every time; the decision Part 1 leaves to the plan. |
| D13 | **Glimmer Isles look:** own props in `scenes/worlds/glimmer_isles/props/`, built from Godot's primitive meshes with the D5 materials: crystal clusters (walls: tall prisms with glowing tips), glow-fern and small-mushroom patches (cover), giant mushrooms and floating island chunks with hanging roots (decoration, outside the border), a soft teal-lavender tiled ground with a glowing path and a starry sky gradient. ProtonScatter places them: one scatter per kind, its `ScatterShape` boxes taken from the layout rectangles (crystals inside each wall, cover plants inside each cover patch, a negative box around the start points, islands outside the border). `GlimmerIsles` (`scenes/worlds/glimmer_isles/glimmer_isles.gd`) adds the floor, the colliders from the layout and the baked scene. Original art, MIT. | W1, W3, W4, S4: not a real place; readable like the canyon (walls block, cover hides); scatter only decides where the looks go. |
| D14 | **Drawn fighters:** the author sends the photo in the chat or puts it in `%USERPROFILE%\hack_star_drawings\` (outside the repository; never committed unless he says so, A7); the agent re-encodes it with Godot's `Image` (load → resize to at most 1024 px → `save_png`), which drops EXIF/GPS metadata, and checks it shows only the drawing. The fighter is a new entry in `Fighters.LIST` (`drawn: true`, the child's name, one `default` skin, stats and attack copied from an existing fighter the child picks — no new attack, A6), unlocked through `Fighters.start_unlocked()` (old saves join it, spec 08 D4); its look is code in `scenes/drawn/<id>_model.gd` (shapes and colours from the drawing, D5 materials, the same idle, run and attack animation hooks and see-through as `FighterModel`), registered in one table `scenes/drawn/drawn_fighters.gd`. Removing it = deleting its file, its table row and its list entry; a save that chose it falls back to the default fighter through the existing checks (`SaveData` drops unknown ids, spec 08 D3/D11). If the drawing is too detailed for shapes, the fallback (A3) is a flat cut-out: the re-encoded picture on a double-sided quad with an outline, bobbing and turning. | A2–A5, A7–A9: no change to the rules or the save format; one place per drawn fighter, so adding or removing one touches nothing else. |
| D15 | **Documents:** `hack_star_godot/docs/drawing_to_fighter.md` (A1, A6, A7, A9: photo rules, where to put it, the exact request to Claude, limits, time, add/remove) and `hack_star_godot/docs/drawing_tools.md` (B1–B6: the recommended workflow Google Flow → Meshy → Claude in Godot, the fallback Claude alone, the facts per tool with sources and dates, the fit limits, the trial result). Both linked from the README. | A1, B1: the author follows them without this spec open. |
| D16 | **Web size budget (G15):** Step 1 measures the web export (`build/web` total and the `.pck`); the budget for the whole spec is **+5 MB**, planned as font ≤ 0.1 MB, icons ≤ 0.3 MB, shaders and scenes ≤ 0.5 MB, Glimmer Isles baked scene ≤ 1.5 MB, drawn fighter (code) ≈ 0 — ProtonScatter is excluded (D11). Steps 2, 10, 13 and 16 note the size after their change; Step 20 fails if the total grows by more than 5 MB. | G15: checked as it grows, not only at the end. |
| D17 | **What needs the author:** Step 14 stops the run (A0) and Steps 15–20 wait for the photo. The B6 trial (Step 19) is done by the author with his accounts; the agent prepares the instructions, records the result and imports it only if D14's licence rules and Mattia allow it. The G1 verdict and the G14/W5 iPad play-test (Step 20) are done by the author and Mattia; a mid-way look (G1) is sent after Step 6 without stopping. A Step that waits says *waiting for the author* in its Notes and is not ✅ Done until the answer is recorded. | A0, B6, G1, G14, W5: what only the author can do is visible in the table and never invented. |
| D18 | **Tests:** looks are checked on screenshots; what a script can check is tested: the theme's fonts and button styles exist and every home button has an icon (`test_home.gd` / new `test_home_look.gd`); the toon and outline materials on every fighter part (`test_fighter_model.gd`); the nearest wall's share of the screen height ≤ 10 % at the five sizes (new `test_arena_framing.gd`); the FPS label hidden by default (`test_match_hud.gd`); `Worlds`, `ArenaLayout.use` and the Glimmer Isles layout (starts free and ≥ 4 m apart, every cover reachable, walls inside the bounds — new `test_world_layouts.gd`); the world choice used by Play and Training (new `test_world_choice.gd`); the baked scene has no addon reference and has props in every wall and cover rectangle (new `test_glimmer_isles.gd`); the drawn fighter in the list, selectable, playable, and the fallback after removal (new `test_drawn_fighter.gd`); the existing screen-size tests at the five sizes with the new layouts. Tests that count fighters (`test_fighters.gd`, `test_fighter_list.gd`, `test_sample_progress.gd`) are updated in Step 16. | S2, S3, G16: behaviour stays tested; tests change only where the look changes. |
| D19 | **Review finding 10 (runner decision): no price on locked fighters yet.** A locked fighter's card shows the lock icon on a grey backdrop, a grey picture and a lock chip "Locked" instead of a price, and the fighter screen a disabled **Locked** button, because the game has no prices yet (a fighter is unlocked only by the start list or the unlock-all hack). G5's price tag on locked fighters comes with the prices: [Unlock and Upgrade](../2026_11_22_09_unlock_and_upgrade_spec.md) S2 (the unlock price by rarity, also on locked cards); skin prices with [Skins Shop](../2026_11_22_10_skins_shop_spec.md) (spec 10). | S2 (nothing invented: no number without a rule behind it); Part 1, the plan (Step 7) and the result now agree. |
| D20 | **Name and data of the new fighters (reopened, Q8–Q9):** the Blaze upgrade is **Flarekid** (id `flarekid`) — a kid whose hood is a flame, an original name that is not "Blaze" and is not used by any fighter, skin or brand checked in the repository; rarity **Legendary** (an upgrade hero), `"plays_like": "blaze"`. **Echo** (id `echo`), rarity **Mythic**, `"plays_like": "luna"` (a ranged "sound blaster", like Luna's ray gun). Both are rows in `Fighters.LIST` with `"unlocked": true`, `"cutout": true`, one `default` skin, and the `plays_like` numbers (as drawn fighters, D14; `SampleProgress` gets their numbers); old saves get them through `Fighters.start_unlocked()` (spec 08 D4). Their folders stay `characters/blaze2/` and `characters/echo/` as the author delivered them. | C1: the author asked for an own name; a known rule (`plays_like`) gives the numbers without inventing an attack (A6). |
| D21 | **Cut-out fighter look:** a registry `CutoutFighters` (`scenes/cutout/cutout_fighters.gd`, like `DrawnFighters`): id → hero texture, card texture, height in metres (about 1.6 m, as the other fighters), the feet point of the picture. `FighterModel.setup` asks it after `DrawnFighters` and builds into its body a `MeshInstance3D` with a `QuadMesh` and a `ShaderMaterial` of a new `scenes/toon/cutout.gdshader`: the quad turns to the camera around the vertical axis in the vertex shader (Y billboard, so the model's own yaw does not matter); alpha scissor; a dark outline found from the picture's alpha in a ring of a fixed **screen-pixel** width (D5's width); uniforms `flash` (mix to white), `fade` (see-through and knock-out alpha), `flip` (mirror), `saturation`. Plus a soft round blob shadow on the ground (unshaded, transparent disc, as the pedestal's shadow). See-through (C7) sets `fade` instead of the material swap. The card picture is the author's `_card.png` itself (`FighterPictures` returns it instead of rendering). The delivered `Sprite3D` scenes are not used (they cannot outline, flash or flip). | C2, C5, C6, C7: one material does all the per-fighter effects; the rig/body/head API of `FighterModel` keeps the existing idle, run and recoil code working for the new fighters. |
| D22 | **Art files, web size and git:** the author's two folders are committed (pictures, READMEs, scenes with `blaze2`'s path fixed to `res://characters/blaze2/`). The hero pictures are imported **not** VRAM-compressed (the web export has no mobile VRAM formats) with `process/size_limit` 768 (hero) and 256 (card) and `compress/mode` lossless, or lossy WebP if lossless is over the C11 budget of 1.0 MB for both — Step 21 measures and decides. Not shipped (export `exclude_filter`): `characters/*/character_preview.gd`, `characters/*/*_hero.tscn`, `characters/*/*_hero_ui.tscn`, `characters/*/README.md`, `scenes/blaze_godot/*`, `scenes/blaze_godot.zip`. `.gitignore` gets `/scenes/blaze_godot.zip` and `/scenes/blaze_godot/`; the zips and the duplicate folder are never touched. | C2, C9, C10, C11: the original pictures stay as delivered (re-import is lossless for the source); the game ships only what it uses, sized for a phone. |
| D23 | **Reveal and idle:** `FighterStage.show_fighter` plays a reveal whenever it shows a fighter with `pedestal = true` (home, fighter screen; not the off-screen pictures): scale 0.3 → 1.08 → 1.0 in 0.45 s (`Tween`, `TRANS_BACK`), a one-shot `CPUParticles3D` burst (about 24 sparks in the rarity colour, `Rarity` colours) and a rarity-coloured halo quad behind the fighter (the radial gradient of home's halo) that flares and settles. The cut-out idle is in `FighterModel.animate` for cut-out fighters: body scale y `1 + 0.03·sin`, x `1 − 0.02·sin` (breathing), bob 0.04 m, sway ±4° around the view axis. CPU particles, not GPU (Compatibility and web safe). | C3, C4: one place for both screens; reused by every fighter. |
| D24 | **In-play cut-out animation:** in `FighterModel.animate` (cut-out branch) — running: a hop `|sin|·0.18 m` with a squash at the bottom (scale y 0.9, x 1.08) and a lean of 8° towards the movement; facing: `Fighter` sets `model.facing_left` from the sign of the input's x (unchanged when x ≈ 0), the shader's `flip`; shot: the existing recoil plus `FighterModel.muzzle_flash()` — a small unshaded star quad at the muzzle for 0.08 s; hit: `Fighter.hit` calls `model.flash()` (white for 0.12 s); knock-out: cut-out fighters tip backwards (rotation about the screen's horizontal axis to 80°) and fade out in `KNOCK_OUT_SECONDS` instead of the spin and shrink. Shape fighters keep their animations. | C5: the "paper" moves the author asked for with the one picture that exists. |
| D25 | **Camera views:** `game/camera_views.gd` (`CameraViews`, static data): `classic` (pitch 55°, distance fitted as today, G11), `close` (55°, 0.6 × the fitted distance, at least 6 m), `behind` (pitch 28°, 6 m, look-ahead 4 m north), `overview` (pitch 78°, distance fitted to the whole `ArenaLayout.bounds()` at the screen's aspect). The camera's yaw never changes — it always looks north — so the keys keep their screen direction (V4) and the billboards face it. `Arena` keeps one `Camera3D` and moves it between rigs with a short blend (0.3 s); the follow, look-ahead and near-wall rule stay for `classic`. Input actions in `project.godot`: `view_next` (V), `view_1`–`view_4` (keys 1–4 and keypad 1–4), `light_next` (L), `saturation_boost` (K) — none is bound elsewhere (only `move_*` and `shoot` exist; the arena has no text field). `GameState.camera_view` (memory only, default `classic`). A shared `HudToast` (`scenes/ui/hud_toast.gd`: a `ChipPanel` backing with a `HudLabel`, top centre, shown 1.5 s then faded) says the view's name and is reused by D27. No touch button (V6, Deferred Items). | V1–V6: a fixed yaw is the simplest way to keep world-relative controls right in every view. |
| D26 | **Brighter worlds and detail:** palette constants of `Canyon` and `GlimmerIsles` (and their props) are raised in saturation and value — canyon: warmer orange-red rock, apricot sand floor, greener cacti; Glimmer Isles: vivid teal and violet ground, magenta and cyan crystals — the floor stays the least saturated surface (L1, G10). New decoration only in decoration spots or outside the border, with no collider: canyon — flowering cactus tops, flags on the border that wave, circling birds, a turquoise stream outside the border with moving highlights; Glimmer Isles — fireflies (`CPUParticles3D`, at most 64), pulsing crystal glow (one shared material, its emission animated), waterfalls from the floating islands (a scrolling quad), slowly turning islands. Static props are instanced (MultiMesh), moving ones in code; `baked.tscn` is re-baked with `tools/bake_world.ps1` only if the scatter source changes. | L1, L2, W4, W7: more life without touching the rules, the layouts or the bake's no-thread rule (D12). |
| D27 | **Lighting presets:** `game/light_presets.gd` (`LightPresets`, data per preset: name, sun colour, energy and angle, ambient colour and energy, sky top/horizon/ground colours, `adjustment_brightness/contrast/saturation`, optional fog and glow) and `scenes/world_lighting.gd` (`WorldLighting`, applies a preset to the arena's `WorldEnvironment`, `Sun` and the world's sky; each world may tint a preset through its own base values). Presets in `L` order: **Bright day**, **Golden sunset**, **Neon night**, **Candy pop**, plus **Classic** (the look before the reopening, to compare). `K`: saturation × 1.3 on top. `GameState.light_preset` and `GameState.saturation_boost` (memory only); `HudToast` (D25) shows the name. Glow is enabled in a preset only if a windowed Compatibility run and the web export both show it and Step 28's numbers stay within L8; otherwise the preset uses emission and the adjustments only. The default (L6) is chosen in Step 27 from screenshots of every preset × world at 1280×720 and 820×1180 and recorded in this table (D27's last sentence and the Step's Notes). **Default (Step 27): Bright day** — on the screenshots of every preset in both worlds at both sizes it is the one that is clearly brighter and more saturated than Classic in both worlds (L1) while the floor stays the calmest surface, so the fighters, shots and bars stand out most (G10, L7), with short shadows that keep the field clear; Golden sunset's long wall and crystal shadows cover much of the floor, Neon night darkens the fighters against the floor, Candy pop washes the floors pastel. Glow is on only in Neon night (seen in a windowed run and in the web export in Edge). | L3–L7: data in one place, applied in one place, the same for Training and a match. |
| D28 | **Measurements and budgets:** Step 21 takes the reopening's **before** set (D2 method: both worlds in a match 4 s in, home, fighter screen; 1280×720 and 820×1180; `%LOCALAPPDATA%\hack_star\screens\09b\before\`), the **performance baseline** (a windowed run, vsync off, a 4-fighter match in each world, Classic view, 10 s: average and worst frame time, `Performance` `RENDER_TOTAL_DRAW_CALLS_IN_FRAME` and `RENDER_TOTAL_PRIMITIVES_IN_FRAME`, by a temporary script, never committed) and the **web size** (`tools/export_web.ps1` in the working tree). Budgets: the two characters ≤ 1.0 MB (C11); the reopening ≤ 1.5 MB in total; the whole export ≤ 45,361,090 bytes (G15: Step 1 + 5 MB); L8 as stated. Step 28 repeats the performance run for every preset × world, with and without the boost, in Classic and Overview, and trims (particle counts, glow off) what is over. | L8, C11, G15: measured the same way before and after, in the same folder state the author has. |
| D29 | **Missing-art document:** `docs/drawing_to_fighter.md` gets a section *Picture fighters (Flarekid, Echo)*: how a picture fighter is added or removed (folder, imports, `CutoutFighters` row, `Fighters.LIST` row, `SampleProgress`, `LICENSES.md`), what a single picture cannot do, and exactly what the author can generate with the same tool to improve it — a side and a back view, a run cycle of 4–8 frames, a shot pose and a hit pose (same height and feet point, transparent PNG, `characters/<folder>/<name>_<pose>.png`), or a GLB through the B1 workflow (`docs/drawing_tools.md`) — and what the game then does (frames swapped by the animation; a GLB replaces the cut-out). | C8: the author knows what to deliver next without this spec open. |
| D30 | **Tests (reopening):** new files (at most 20 tests each, D18): `test_cutout_fighters.gd` (both in the list and unlocked, old save gets them, card picture is the delivered card, model builds the cut-out quad with the outline shader, see-through `fade`, `flip` follows the input, `flash` after a hit, knock-out fades), `test_fighter_reveal.gd` (reveal on home and the fighter screen, not on pictures; particles and halo in the rarity colour), `test_camera_views.gd` (order of `V`, keys `1`–`4`, the toast, fighter within the screen per view at the five sizes, Overview sees the four borders, Classic keeps G11, kept for the next match), `test_light_presets.gd` (order of `L`, `K` toggles, default preset, each preset changes sun, sky and adjustments, kept for the next match), `test_world_decor.gd` (new decoration has no collider, layouts and start points unchanged, at least three new kinds per world). Tests that count fighters are updated in Step 22. | S2, S3: what a script can check is tested; looks are checked on screenshots (D2). |
| D31 | **The author's newer files (runner decision, during Step 23):** during the run the author dropped new untracked files — `characters/magmax/`, `characters/echo_new/` (with `gameplay/frames/`: directional idle, walk and shoot frames) and `characters/echo_godot_gameplay.zip`. They are not part of this reopening's request: never committed, modified or moved; `.gitignore` gets `/characters/*.zip`; the web export's `exclude_filter` gets `characters/magmax/*`, `characters/echo_new/*` and `characters/*.zip`, so the web budget (C11, G15) holds in the author's working tree; a Deferred Items row says a follow-up can use them (Echo's in-play animation, a new fighter). Committed with Step 23. **Extended in Step 25 (runner decision):** the author also dropped `characters/blaze_new/` and `characters/magmax_new/`; the filter is made robust — `characters/*_new/*` and `characters/magmax*/*` replace the two folder entries (`characters/*.zip` and the D22 entries stay), so only the game files of `characters/blaze2/` and `characters/echo/` are exported, measured with `tools/export_web.ps1` in Step 25. | C10, C11, G15: the reopening ships only what it planned; the author's files stay as he left them. |
| D32 | **L8 is judged on the warm run (runner decision, code review 2026-11-22 of the reopening, finding 4):** Step 28 measures every row twice in a fresh process; L8 (frame time at most 30 % over the baseline and every frame under 33 ms) is judged on the **second (warm) run** of each pair. The first run includes Godot's one-time shader compilation: its average (up to 17.62 ms, canyon, Classic, Bright day) and its worst-frame hitches (21–489 ms) are reported in Step 28's Notes but do not count against L8. Pre-warming the shaders (so the first match has no hitch) stays a deferred idea (Deferred Items). | L8 asks about the look's cost while playing, not about the one-time compile on the first load; the rule makes Step 28's "every row within L8" checkable. |
| D33 | **V5 is judged after the start hint (runner decision, code review 2026-11-22 of the reopening, finding 5):** "Overview shows all four border walls" (V5) is judged once the 5 s start hint has faded; the hint is transient in every view, as it was in Classic before the views. No change to Overview's framing. | V5 is about what the player sees while playing; the hint is shown for 5 s at the start of each match and Training only. |
| D34 | **MagMax's data (reopened again, Q14):** a row in `Fighters.LIST` after Echo — id `magmax`, name **MagMax**, rarity **Epic**, idea "The author's hero: a masked brawler with flame hair and lava-rock fists", `"unlocked": true`, `"cutout": true`, `"plays_like": "rocko"`, one `default` skin; `SampleProgress` 0 trophies and power level 1 (as Step 22 did for the picture fighters: no Prestige never earned, the sample totals stay); old saves get him through `Fighters.start_unlocked()` (spec 08 D4). Main colour (shot, damage numbers) lava orange `ff6a1a`. | M1: a known rule (`plays_like`) gives the numbers without inventing an attack (A6); Epic has only Frosty. |
| D35 | **Folders, paths, imports, git and export (M2, M12, M14):** Step 30 **moves** (`Move-Item`, never copies) the delivery: `characters/echo_new/*` → `characters/echo/` and `characters/flarekid_new/*` → `characters/blaze2/` (the hero and card pictures are the same bytes as the committed ones: the committed files and their `.import` stay, so their uids stay; the delivered README, helper scenes and `character_preview.gd` replace the committed ones), `characters/magmax_new/` → `characters/magmax2/`. Every `res://characters/blaze/` becomes `res://characters/blaze2/` and every `res://characters/magmax/` becomes `res://characters/magmax2/` in the moved `.tscn`, `.tres`, `.gd` and README files; the delivered `.import` files of moved pictures are deleted (they name the `_new` source) and Godot writes new ones. Imports, all **not** VRAM-compressed (`detect_3d/compress_to` off): the **frames** lossy WebP at quality 0.85 with `process/size_limit` 512 and mipmaps (small in the arena) — Step 30 checks the pedestal at 820×1180 and the size and may change the limit (384–640); MagMax's **hero** and **card** as D22 (hero lossy WebP 0.9, 768; card lossless, 256); the **projectiles** lossless. `.gitignore` gets `/characters/magmax/`; the export's `exclude_filter` replaces `characters/magmax*/*` by `characters/magmax/*` (otherwise `magmax2` would be cut) and adds `characters/*/gameplay/*_animation_preview.png`, `*_animator.gd`, `*_gameplay.tscn`, `*_projectile.gd`, `*_projectile.tscn` (under `characters/*/gameplay/`); `characters/*_new/*`, `characters/*.zip` and the D22 entries stay. The game uses only the frame PNGs, the `*_frames.tres` (data, no script), the projectile PNGs, the cards and — if Step 34 keeps it — the heroes. `characters/magmax/` and the zips are never touched (a SHA-256 list before Step 30 and after Step 37 is the same). | M2, M12, M14: one folder per fighter, delivered files kept as the author made them except the paths; the web export ships only what the game uses. |
| D36 | **Frame table and memory (M1, M7, M15):** `CutoutFighters` rows get `frames` (the path of the delivered `*_frames.tres`: `idle_`, `walk_`, `shoot_` × `down`, `up`, `side`), `projectile` (the path of the projectile PNG), `figure_height` in metres (the figure's height in the idle frames, so each reads about as tall as today: MagMax 2.5 m, Echo 2.5 m, Flarekid 2.7 m), the feet point of the frames (bottom centre) and per view the `muzzle` point of the shoot frame (UV; replaces the one-picture `muzzle`). Frames and heroes are **loaded on first use** (`load()`, cached per fighter in a static dictionary), not preloaded, so only the fighters on screen are in memory (12 frames at 512 px are about 12 MB of texture memory each fighter); the cards stay preloaded (small, needed by the list). The quad's size is the frame's aspect (all frames of a fighter are the same size), so nothing jumps between frames. | M7, M15: the delivered `SpriteFrames` is the single source of which frame belongs to which animation; memory grows only with the fighters in use. |
| D37 | **Animator in play (M3, M4, M5, M7):** a new `CutoutAnimator` (`scenes/cutout/cutout_animator.gd`, `RefCounted`, owned by `FighterModel` for animated fighters; `FighterModel` is at 996 of gdlint's 1000 lines, so it only forwards): `view_for(direction: Vector2)` on the screen (x right, y down = +z, as `Movement`) — `side` when |x| > |y| (mirrored when x < 0), otherwise `up` (back view) when y < 0, else `down` (front view) — the delivery's rule; standing keeps the last view; the start view is `down`. `Fighter._physics_process` and `Fighter.face()` hand the input direction and `running` to the model; `Arena.fire_from` calls `model.play_shoot(direction)`: the shoot frame of the shot's view for 0.25 s. The walk loop (walk1 → idle → walk2 → idle) runs at 8 frames a second at 5 m/s (scaled with the speed, 6–10), with a hop of 0.05 m; standing keeps the breathing of C4 (no sway and no lean: the frames lean themselves). The animator swaps the shader's `picture` and sets `flip`; `flash`, `fade`, `tip`, the shadow, the outline and the bar over the figure (`CutoutFighters.top_offset` with `figure_height`) are unchanged. **Camera:** every view of `CameraViews` looks north (−z) with a fixed yaw (D25), so up on the screen is −z in all four views and W shows the back view in each (a test pins it; a view that turns the camera would have to pass its yaw to `view_for`). C5's left/right flip and hop are replaced for the animated fighters (all three picture fighters are animated). | M3–M5, M7: one small class holds the rule and the timing; the shader, effects and existing hooks stay. |
| D38 | **Projectile look (M6):** `Shot.launch` gets an optional `picture: Texture2D` (from `CutoutFighters.projectile(id)`, passed by `Arena.fire_from`); with a picture the shot shows a camera-facing quad of it (a small `scenes/toon/projectile.gdshader`: billboard, rotated on the screen along the direction it flies, unshaded, alpha-blended, about 1.0 m long — between the ball's halo of 0.72 m and its 1.1 m tail —, drawn over the floor) instead of the ball, halo and tail; one material per picture, shared like today's per-colour materials. The ray, speed, range, damage and the hit burst (in the fighter's main colour) do not change; other fighters pass no picture and keep the ball. | M6, S2: only the look changes; the combat rules stay in `Combat` and `Shot`. |
| D39 | **Showcase and the fighter screen (M8, M9):** a new `CutoutShowcase` (`scenes/cutout/cutout_showcase.gd`, static timeline): 0–1.2 s idle front; 1.2–3.2 s a turn front → side → back → other side → front (0.4 s each); 3.2–4.8 s the front walk loop on the spot; 4.8–5.4 s the side shoot pose with the projectile flying out 1.5 m and fading and a burst of the stage's sparks in the fighter's main colour; 5.4–7.0 s idle; then again (7 s, ≤ 8 s). `FighterStage` (pedestal stages: home, the fighter screen, the result) runs it for animated fighters after the reveal (C3, unchanged); fighters of shapes keep their idle. On the fighter screen a drag over the stage turns the figure (every 80 px one view in the ring front, side, back, other side), a press and release within 0.25 s and 10 px is a tap and shoots; the showcase pauses and starts again 3 s after the last drag or tap. The **hero picture** is used only if Step 34's screenshots show a smooth switch from it (a short hero pose before the loop); otherwise it is not used and `characters/*/*_hero.png` is added to the export filter (size). | M8, M9: one timeline for every pedestal; the input is the fighter screen's only. |
| D40 | **Living cards (M10):** `FighterCard` of an animated fighter gets a `Figure` (`TextureRect`, the front frames: idle 1.2 s, then the walk loop 1.6 s, at the card's bottom right, about 60 % of the card picture's height) and a light sweep on its picture (`scenes/ui/card_sweep.gdshader`: a soft diagonal band in the rarity colour, every 4 s, phase shifted by the card's place in the list). It animates only while the card is inside the visible part of the list (its global rect intersects the viewport), so a long list costs nothing; a locked card is grey and still (G7). | M10, G16: livelier cards without a cost for cards out of sight. |
| D41 | **Tests (reopened again):** new files, at most 20 tests each (D18): `test_animated_fighters.gd` (MagMax's data, unlocked, old save; every frame and projectile loads from its final folder and no resource names `characters/blaze/`, `characters/magmax/` or `_new`; 12 frames of one size per fighter; the card on the card), `test_cutout_animator.gd` (the view per direction, diagonals, mirrored left, the last view kept, the front view at the start, the walk loop's order and pace, the shoot frame for 0.25 s in the shot's view, bots too, W → back view in all four camera views, flash, fade, tip and the bar with frames), `test_projectile_look.gd` (the three with their pictures, others the ball, same speed, range and damage, turned along the direction), `test_showcase.gd` (order and ≤ 8 s, never still, drag turns, tap shoots, resumes after 3 s, home, fighter screen and result, shapes unchanged), `test_living_cards.gd` (the figure changes frames, the sweep, locked grey and still, only visible cards animate, the five sizes). Tests that count fighters or expect C5's flip and hop (`test_cutout_fighters.gd`, `test_fighter_reveal.gd`, `test_fighter_list.gd`, …) are updated in the Step that changes the behaviour. | S2, S3: what a script can check is tested; looks on screenshots (D2). |
| D42 | **Measurements (M11, M14, M15):** Step 30 takes the **before** set before it moves anything (D2 method; home, the fighter list scrolled to the picture fighters, the fighter screen with Echo and with Flarekid, a 4-fighter match 4 s in with Echo as the player in the canyon; 1280×720 and 820×1180; `%LOCALAPPDATA%\hack_star\screens\09c\before\`), the SHA-256 list of `characters/magmax/` and the web size. Step 36 takes the **after** set (the same names, plus MagMax and short frame sequences) into `…\09c\after\` and the performance run of D28/D32 (warm run) with four animated fighters (a temporary script picks MagMax, Echo and Flarekid for the bots) in both worlds, Classic and Overview, Bright day and Neon night, against Step 21's baseline (the higher of its two runs): within L8; texture memory (`Performance.RENDER_TEXTURE_MEM_USED`) reported. Size budget (M14): the three fighters' imported files ≤ 3.5 MB, the export ≤ 45,361,090 bytes — measured in Steps 30 and 37. | M11, M14, M15: measured the same way before and after, in the author's working tree. |
| D43 | **D31 superseded (reopened again):** the `*_new` folders are now the author's request and are moved into the game's folders by Step 30 (D35); `characters/magmax/` stays the author's untracked older art, now also ignored by git, and excluded from the export; the zips stay ignored and excluded. | M2, M12. |

---

## Step 1 — Before screenshots and size baseline

### Goal
The **before** screenshots of both games and the web export size are recorded, the reference for
the side-by-side verdict and the size budget (G1, G15, G17).

### Tasks
- [x] Record the start time in Notes below.
- [x] Capture the Godot game (D2): home, fighter list, fighter screen, a match a few seconds in, at 1280×720 and 820×1180, into `%LOCALAPPDATA%\hack_star\screens\09\before\`.
- [x] Capture the Svelte game the same way (`ui/`: `npm run dev`, headless browser), the same screens and sizes, same folder; stop the dev server; `git status` shows nothing in `ui/`.
- [x] Run `tools/export_web.ps1`; write the total size of `build/web` and of the `.pck` in Notes (D16).
- [x] Check: 16 PNGs present and viewed; the size line in Notes; `tools/test.ps1` and `tools/lint.ps1` exit 0 (nothing in the game changed).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 12:35
**Before set** (D2): 16 PNGs in `%LOCALAPPDATA%\hack_star\screens\09\before\` — `godot_` and `svelte_` × `home`, `fighters`, `fighter`, `match` × `1280x720`, `820x1180`, all viewed. Godot: a windowed run (`--resolution`) with a temporary `-s` capture script (kept outside the repository, never committed; at 820×1180 the window is taller than the 960 px desktop and Windows allows it); the game's own save (Rocko chosen, 1755 trophies), the match 4 s in. Svelte: `npm run dev` (the FastAPI server already ran on 8180) and headless Edge through Playwright (`uv run --with playwright`, SwiftShader), a fresh account (Blaze), the match 6 s in (countdown / *FIGHT!* still visible); dev server stopped, nothing changed in `ui/`. What the requirements stage saw holds: flat navy vs purple gradient with rays and a pedestal, plain default font vs bold outlined display text and a two-colour logo, five identical purple buttons vs coloured icon buttons and a big yellow **PLAY**, text-only cards and skin buttons, thin outline, yellow checker floor, the near wall covering the lower ~25 % (1280×720) and ~35 % (820×1180) of the match, FPS shown.
**Size baseline** (D16, `tools/export_web.ps1` exit 0): `build/web` total **40,361,090 bytes** (38.49 MiB), of which `index.wasm` 39,514,754 and `index.pck` **239,960 bytes**; budget for the spec: total ≤ 45,361,090 bytes (+5 MB).
**Done (2026-11-22 · ~7 min · Claude Opus 5.5)** — before screenshots of both games (16 PNGs, outside the repository) and the web size baseline; no game file changed. `tools/test.ps1` 403 tests passed, `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 2.82 M tokens · CHF 1.15 (138 credits)

---

## Step 2 — Font, icons and theme

### Goal
The display font and the icons are in `assets/`, pinned and credited, and the theme gives every
screen bold outlined text and buttons that react to a press and a hover (G3, G5, G6, G16, S4).

### Tasks
- [x] Record the start time in Notes below.
- [x] Add Lilita One and `OFL.txt` to `assets/fonts/` (D3); add the used Kenney icons and `License.txt` to `assets/icons/` (D4); pin both in `tools/versions.json`; rows in `LICENSES.md` (source, version, date, SHA-256, licence).
- [x] Theme (`scenes/ui/hack_star_theme.tres`): the display font with outline and shadow for the title, heading, button and number types; body text unchanged; the button type variations and states of D7; the `IconChip` scene.
- [x] Keep every button ≥ 44 px and text ≥ 14 px (`UiScale`, spec 04 D13).
- [x] Check: screenshots of home and info at 1280×720 and 390×844 show the new text and buttons, hover and pressed states captured; `test.ps1`, `lint.ps1`, `check_tools.ps1` exit 0; export size noted (D16).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 12:42
**Assets** (D3, D4): Lilita One 1.002 (name table) from `google/fonts` `ofl/lilitaone/` at commit `0b03411` (28,092 bytes, with `OFL.txt`); Kenney **Game Icons** — kenney.nl is blocked by the author's network filter (Zscaler, "games" category), so the same pack was taken from Kenney's own upload on OpenGameArt (`Kenney_gameIcons.zip`, 2014-11-03, CC0, no version number → the upload date is pinned); 14 white 100 px icons copied unchanged with `License.txt`. The pack has no coin, bolt, clock, world or eye: `Icons` (`scenes/ui/icons.gd`) draws them once in code (own work) and names every icon (`Icons.get_icon("trophy")`). Both pinned in `tools/versions.json` (`font_lilita_one`, `kenney_game_icons`), rows with source, date, licence and SHA-256 in `LICENSES.md`; `.specs/guidelines/gdscript.md` *Art* line updated (the font and icons are the only files).
**Theme** (D7): Lilita One with a dark outline on `Button` (and every button variation), `HeadingLabel`, `SubheadingLabel`, `HudLabel`, new `NumberLabel`, `BadgeLabel`; a drop shadow on the heading and HUD labels; plain `Label` (body text) keeps Godot's default font and size. Button variations `PlayButton` (large yellow, dark text and icon, 60 px), `GreenButton`, `BlueButton`, `PinkButton`, `IconButton` (round) and the base purple `Button`: dark 3 px border with an 8 px bottom edge; hover lighter; pressed darker, edge 3 px, content 3 px lower (also `hover_pressed`); focus is now a white ring (before it reused the hover look); `icon_max_width` 48 (Play 64). `IconChip` (`scenes/ui/icon_chip.tscn` + `.gd`, `ChipPanel` dark rounded backing, icon tinted, number in `NumberLabel`). Button and text sizes unchanged (≥ 44 px buttons, ≥ 14 px text: `test_screen_sizes*.gd` green). New `tests/test_theme_look.gd` (8 tests: display font and outline, body font unchanged, hover lighter / pressed darker and lower per variation, own colours, focus ring, every icon, drawn icons not empty, chip).
**Screenshots** (`%LOCALAPPDATA%\hack_star\screens\09\step2\`, viewed): home and info at 1280×720 and 390×844 (headings, name and buttons in the outlined display font, body text unchanged and readable); home with the mouse over **Play** (lighter) and pressed (darker, text 3 px lower, short edge) — real input events, so the theme alone reacts in the same frame; a gallery of the six variations × normal/hover/pressed, the chips with all drawn icons and a heading. After looking: the first gallery showed purple for every variation (the capture read the styles before the buttons were in the tree) — fixed in the capture code; nothing to change in the theme. Home still uses the base purple buttons and plain title until Step 4.
**Size** (D16): `build/web` 40,406,582 bytes (+45,492 vs Step 1), `index.pck` 285,452 bytes (+45,492); budget font ≤ 0.1 MB and icons ≤ 0.3 MB met.
**Done (2026-11-22 · ~13 min · Claude Opus 5.5)** — Lilita One and 14 Kenney icons in `assets/` (pinned, credited, checksums), `Icons`, the theme's display font, button colours and states, `IconChip`; `tests/test_theme_look.gd`. `tools/test.ps1` 411 tests passed (one run before had a timing flake in `test_touch_joystick.gd` "held about 0.3 s", unrelated; green on the re-run), `tools/lint.ps1` exit 0, `tools/check_tools.ps1` exit 0, `tools/export_web.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 8.99 M tokens · CHF 2.50 (298 credits)

---

## Step 3 — Toon look of the fighters

### Goal
Every fighter and skin has 3-band cel shading and a dark outline that stays visible on a card and
in the arena, with readable eyes; shapes, names and colours unchanged (G9).

### Tasks
- [x] Record the start time in Notes below.
- [x] Add `scenes/toon/toon.gdshader`, `outline.gdshader` and `toon_materials.gd` (D5).
- [x] `FighterModel`: use the shared materials on every part (replacing `DIFFUSE_TOON` and the grown copy); eyes with a white and a dark part large enough for a card; the see-through in a bush still works.
- [x] Update `test_fighter_model.gd` (every visible part has the toon material with the outline pass; see-through).
- [x] Check: screenshots of all 6 fighters and the 14 skins on cards (150 px) and in Training; outline visible at both sizes, two or more tones per colour; `test.ps1`, `lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 12:55
**Shaders and materials** (D5): `scenes/toon/toon.gdshader` — per light three bands (lit 0.85, mid 0.5, none; a surface in a cast shadow gets none), the ambient light is the shadow tone, so every colour shows two or three clear tones; a thin light rim; colour and glow as uniforms. `scenes/toon/outline.gdshader` — inverted hull (`cull_front`, unshaded, dark navy) as `next_pass`; each vertex moves out from the part's centre (not along the face normal, so box corners stay closed) by `grow` 0.012 m and then by 3 px on screen, scaled up when the shorter side of the view is over 720 px (820×1180 → 3.4 px). `ToonMaterials` (`scenes/toon/toon_materials.gd`) caches one material per colour/glow/outline, shared by every fighter (`test_fighters_share_their_materials`), and the see-through copies. **Differs from D5:** the see-through copy is a transparent toon `StandardMaterial3D` with a faded grown outline, not an alpha uniform in `toon.gdshader` — writing `ALPHA` in the shader would make every fighter part transparent all the time (sorting artefacts between parts, cost on the iPad). `Canyon` keeps its own materials until Step 5.
**FighterModel**: every `_toon` part takes `ToonMaterials.toon` (no `DIFFUSE_TOON` and no per-model outline copy left); `_faded` and the per-model cache replaced by `ToonMaterials.see_through`; eyes darker than 0.35 luminance get an outlined white (`LeftEyeWhite`/`RightEyeWhite`) around a larger-looking pupil (`…Pupil`) with the shine; Rocko's yellow glowing eyes stay without a white. Shapes, names and colours unchanged.
**Tests**: `tests/test_fighter_model.gd` +4 (all 14 looks cel-shaded with the shared outline pass and ≥ 8 outlined parts, materials shared, eye whites and pupils, see-through copy transparent with a faded outline); the see-through swap tests in `test_arena_effects.gd` / `test_match_arena.gd` unchanged and green. `tests/test_touch_joystick.gd`: the "held about 0.3 s" test failed in every run of this Step, also on the plan commit `dd563c8` (checked in a scratch worktree) — GUT's `wait_seconds` counts physics time, which ran ahead of the wall clock the joystick measures (0.18–0.22 s); the test now waits on the wall clock (test only, no game change).
**Screenshots** (`%LOCALAPPDATA%\hack_star\screens\09\step3\`, viewed): all 14 looks rendered at the picture size (256×320) and shown at 150 px like a card (1280×720) and at 80 px (820×1180); home and the fighter screen (close-ups); the fighter list; Training and a match at 1280×720 and 820×1180. Outline visible at every size, faces and bodies show a lit and a shaded tone, eye whites readable on the 150 px pictures; a bot in a cactus patch is see-through. After looking: lit band 1.0 → 0.85 and mid 0.55 → 0.5 (faces were nearly white on home); the screen width first scaled with the view height (4.9 px at 820×1180 looked heavy in the arena) → now with the shorter side.
**Done (2026-11-22 · ~16 min · Claude Opus 5.5)** — toon and outline shaders, `ToonMaterials`, `FighterModel` on the shared materials with eye whites, tests. `tools/test.ps1` 415 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 10.98 M tokens · CHF 2.89 (345 credits)

---

## Step 4 — Home screen

### Goal
Home has the gradient background, the fighter on a pedestal, the "Hack star" logo, coloured icon
buttons with a large yellow **Play**, and icon chips for trophies and credits (G2, G4, G5, G6,
G16, G17, G18).

### Tasks
- [x] Record the start time in Notes below.
- [x] Add `MenuBackground` (D6) and use it on home; the pedestal in `FighterStage`.
- [x] Logo: "Hack" and "star" in two colours, outlined, slightly slanted, in the display font; the entrance animation as today.
- [x] Buttons: **Play** large yellow (corner in wide layout, bottom in tall), Training, Fighters, Info, Hack as coloured buttons with icons (D7); trophies and credits as `IconChip`s.
- [x] Update `test_home.gd` / add `test_home_look.gd` (each button has an icon and its colour variation; chips show the numbers; button names and actions unchanged); `test_screen_sizes.gd` passes at the five sizes.
- [x] Check: screenshots at the five sizes and with a press and a hover; compared with the Svelte before shot; `test.ps1`, `lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 13:12
**Background and pedestal** (D6): `scenes/ui/menu_background.tscn` (a `ColorRect`, mouse ignored) with `menu_background.gdshader` — purple gradient (lighter top, dark bottom), a soft glow above the middle and 14 slow light rays (one turn in ~170 s); used on home instead of the flat `BackgroundPanel` (the other screens follow in Steps 7–9). `FighterStage` builds a `Pedestal` (three outlined toon drums from `ToonMaterials`: blue side, cream rim, lavender top just under the feet) and moves its camera back and up to show it; `@export var pedestal` (default on) — `FighterPictures` turns it off, so the card pictures are unchanged until Step 7. The fighter screen and result screen now also show the pedestal (G2).
**Logo** (G4): `Title` is an `HBoxContainer` with `Hack` (yellow) and `Star` ("star", pink) labels; theme variations `LogoHackLabel` / `LogoStarLabel` use a `FontVariation` of Lilita One slanted by `variation_transform` (0.22), 88 px, 18 px dark outline, dark drop shadow; the entrance pops it as before (scale/alpha on `Title`).
**Buttons and chips** (G5, G6, G18): Training `PinkButton`, Fighters `BlueButton`, Info the base purple `Button`, Hack `GreenButton`, each with its icon (`home.gd` `BUTTON_ICONS` → `Icons`: target, two people, i, wrench); **Play** `PlayButton` (yellow, play arrow, 360×120) now after the other buttons — bottom-right corner when wide, across the bottom when tall (`_arrange`). Trophies and credits are `IconChip`s (`TrophiesChip` trophy, `CreditsChip` drawn coin) with the number only; `Hacks.credits_text` ("Credits: 500") became `Hacks.credits_amount` ("500" / "∞"); `docs/architecture.md` updated for the rename. Node paths of the buttons unchanged.
**Tests**: new `tests/test_home_look.gd` (6: every button has an icon and its own colour; Play the largest and yellow; Play in the corner when wide and under the buttons, across the screen when tall; chips with trophy/coin icons and numbers; the two-colour outlined slanted logo; gradient background and outlined toon pedestal); `test_home.gd`, `test_hacks.gd`, `test_hack_effects.gd`, `test_hack_expiry.gd`, `test_mvp_flow.gd`, `test_screen_sizes.gd` updated for the chips and the logo labels only.
**Screenshots** (`%LOCALAPPDATA%\hack_star\screens\09\step4\`, viewed): home at 1280×720, 1180×820, 820×1180, 390×844, 844×390; Play hovered and pressed at 1280×720 and 390×844 (real mouse events: lighter on hover, darker and 3 px lower when pressed). Compared with `before\svelte_home_1280x720.png`: gradient with rays, a pedestal, a two-colour slanted logo, coloured icon buttons, a big yellow Play in the corner and dark chips — the same layout ideas; the Svelte's square icon tiles and player chip are not copied (wide buttons stay readable at 390 px). After looking: the logo slant checked on an enlarged crop (leans right as intended); nothing else changed. Also captured the fighter screen at 1280×720 (`godot_fighter_1280x720.png`): Blaze on the pedestal, nothing cut off.
**Done (2026-11-22 · ~10 min · Claude Opus 5.5)** — home on the gradient background with the fighter on a pedestal, the two-colour slanted logo, coloured icon buttons with a large yellow Play in the corner / at the bottom, trophy and coin chips; `tests/test_home_look.gd`. `tools/test.ps1` 421 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 7.56 M tokens · CHF 2.19 (261 credits)

---

## Step 5 — Arena look

### Goal
The canyon's floor, walls, cacti and props have the outlined cartoon look, and the floor is less
saturated than the fighters (G10, W7).

### Tasks
- [x] Record the start time in Notes below.
- [x] `Canyon`: softer sand tiles (lower saturation), D5 materials with outline on walls, boulders, cacti, crates, skulls and bones (also on its `MultiMeshInstance3D`s); layout and collisions unchanged.
- [x] Note the draw calls (`Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME`) and the frame time of Training on the desktop before and after in Notes.
- [x] Check: screenshots of Training and a match at 1280×720 and 820×1180; fighters stand out from the floor; `test_arena*.gd` unchanged and green; `test.ps1`, `lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 13:22
**Canyon** (D5, G10, W7): every part takes its material from `ToonMaterials` (the canyon's own `_toon` / `_vertex_color_material` StandardMaterials are gone): walls (body, band, top), the boulders on and outside the walls, cactus trunks, arms and flowers, crates, skulls, bones and rocks are cel-shaded with the dark outline pass; the floor box, the sand tiles, the outside ground and the bush patches are cel-shaded without an outline (flat ground needs none). For the MultiMeshes `toon.gdshader` got `use_instance_color` and `ToonMaterials.instanced(outlined)` (one shared material each), so every boulder, tile and cactus keeps its own colour. Sand `f2b866`/`e4a456` → `b89c74`/`ad9068` (the arena's bright sun made the first try, `ecd3a4`, render almost white — measured on the screenshot, the old floor rendered at 255,255,140, the new one at about 248,208,155: saturation 0.45 → 0.37, the fighters' colours stay at 0.8–1.0); bush ground `b9a24a` → olive `8f9a5a` so the patches still read; outside ground `a5512f` → `b47552`. Layout, wall heights, collisions and names unchanged.
**Draw calls and frame time** (Training at 1280×720, desktop GPU, vsync off, mean of 240 frames, two runs each): before **384** draw calls, 3.2 / 4.8 ms per frame; after **539** draw calls (+155: one outline pass per outlined mesh and MultiMesh), 2.6–5.1 ms per frame (same as before within the run-to-run noise). The iPad check stays with Step 20 (G14).
**Tests**: new `tests/test_canyon_look.gd` (2: walls and props cel-shaded with the outline; the ground cel-shaded without one); `test_arena*.gd` unchanged and green.
**Screenshots** (`%LOCALAPPDATA%\hack_star\screens\09\step5\`, viewed): Training and a match (5 s in) at 1280×720 and 820×1180. Outlines on walls, boulders, cacti, crates, skulls and bones read like the fighters'; the soft sand lets the fighters stand out. After looking: the first sand was too pale (blown out by the sun) → darker, and the bush ground greener. The near wall and the HUD are Step 6.
**Done (2026-11-22 · ~8 min · Claude Opus 5.5)** — the canyon on the shared toon materials with the dark outline on walls and props (MultiMeshes too, per-instance colour), softer sand; `tests/test_canyon_look.gd`. `tools/test.ps1` 423 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 7.15 M tokens · CHF 1.75 (208 credits)

---

## Step 6 — Arena framing and match HUD

### Goal
The nearest wall covers at most 10 % of the screen height at the start, the HUD shows the timer,
fighters left and the controls hint on dark backings with icons, and the FPS label is hidden
unless switched on (G11, G12, G1 mid-way look).

### Tasks
- [x] Record the start time in Notes below.
- [x] Camera framing and/or the camera-side wall height so that the projected nearest wall is ≤ 10 % of the screen height at the start of a match and of Training at the five sizes; new `test_arena_framing.gd` measures it with `Camera3D.unproject_position`.
- [x] HUD: timer and fighters left as `IconChip`s, the controls hint on a dark rounded backing with icons; the FPS label hidden by default; the info screen's **Show FPS (play-test)** switch (D8); `test_match_hud.gd` updated.
- [x] Mid-way look (G1, D17): copy the current home and match screenshots to `%LOCALAPPDATA%\hack_star\screens\09\midway\` and write in Notes that they are ready for the author and Mattia (not blocking).
- [x] Check: screenshots of a match and Training at five sizes; `test.ps1`, `lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 13:30
**Framing** (G11): the wall heights stay (W7); the camera does the work. After `_frame_camera` has found the distance (as before), `Arena._near_wall_offset` finds by bisection how far south of the camera target the near wall's top edge (`Canyon.CAMERA_SIDE_WALL_HEIGHT` + `WALL_CAP_HEIGHT` 0.1, at `Arena.near_wall_z()`, the inner face of the southmost border wall) may lie so that it projects at 92 % of the screen height (`NEAR_WALL_SHARE` 0.08), and the camera target is never south of that (`_camera_max_z`). The camera moves with its target, so the limit is computed once per screen size. A tall screen now shows more arena ahead instead of the wall and the ground behind it. Measured as "from the wall's top edge to the bottom of the screen" (the wall and the outside ground behind it — what hid the arena): before 26 % (1280×720, 844×390), 30 % (1180×820), 40 % (820×1180), 43 % (390×844); now ≤ 8 % at all five sizes, Training and a match (`tests/test_arena_framing.gd`: the share ≤ 10 %, and the player in view above the wall; checked that it fails with the old framing). The existing camera tests (`test_screen_sizes.gd` fighter in view at the start and in the far corner) still pass.
**HUD** (G12, D8): `match.tscn` — `TimerChip` (clock icon, white; `IconChip.text_color` red in the last 10 s) and `FightersLeftChip` (fighters icon in red, the number) replace `TimerLabel` / `FightersLeftLabel` (and the scene's own timer StyleBox); `IconChip` got `text_color`, setters that skip unchanged values (the HUD sets them every physics frame) and children that ignore the mouse. `arena.tscn` — `ControlsHint` is a `PanelContainer` (`ChipPanel`, dark rounded) with `Row/Icon` (info icon) and `Row/Label` (the same text), growing upwards from the bottom; the FPS label moved under the fighters-left chip (top 88 px) and is hidden unless `GameState.show_fps` (new, memory only, reset by `reset()`; no save change). Info screen: a `FpsSwitch` `CheckButton` **Show FPS (play-test)** under the list (80 px tall, 28 px text). Docs: `docs/architecture.md` (arena and match rows, play-test line) and the README's match rules updated for the chips and the switch.
**Tests**: new `tests/test_arena_framing.gd` (2); `test_match_hud.gd` (chips, red timer via `text_color`, icons, FPS hidden by default and shown with the switch on: +2); `test_controls_hint.gd` (hint on the dark backing with an icon, every part ignores input; text read from `Row/Label`); `test_screen_sizes_match.gd` (chip paths); `test_info.gd` (+1: the switch by click on, by touch off).
**Screenshots** (`%LOCALAPPDATA%\hack_star\screens\09\step6\`, viewed): a match (1.5 s in, countdown) and Training at 1280×720, 1180×820, 820×1180, 390×844, 844×390; a match with the FPS switch on; the info screen at 1280×720 and 390×844. The near wall is a thin strip at the bottom; the hint covers the lowest ~15 % for its 5 s, then fades; the chips read on sand and on walls.
**Mid-way look** (G1, D17, not blocking): `%LOCALAPPDATA%\hack_star\screens\09\midway\` has `godot_home_1280x720.png`, `godot_home_820x1180.png`, `godot_match_1280x720.png`, `godot_match_820x1180.png` — ready for the author and Mattia to compare with `…\09\before\svelte_*` (home and match).
**Done (2026-11-22 · ~12 min · Claude Opus 5.5)** — the camera never shows more than 8 % of near wall at the bottom, the timer and fighters left as icon chips, the controls hint on a dark backing with an icon, the FPS label hidden unless Info's **Show FPS (play-test)** is on; mid-way screenshots ready; `tests/test_arena_framing.gd`. `tools/test.ps1` 428 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 11.32 M tokens · CHF 2.84 (339 credits)

---

## Step 7 — Fighter cards

### Goal
Each card shows the fighter's picture on a coloured backdrop (or grey with a lock icon and price
when locked), its name, rarity in its colour, trophies and power with icons, and the Prestige
badge (G5, G7, G16).

### Tasks
- [x] Record the start time in Notes below.
- [x] `FighterCard`: backdrop by unlock state and rarity, picture from `fighter_pictures.gd` with the new look, lock icon and price for locked fighters, icon chips for trophies and power, rarity label in `Rarity` colours, `PrestigeBadge` as today; the fighter list on `MenuBackground`.
- [x] Update `test_fighter_list.gd` (lock icon only on locked cards; numbers shown); screen sizes pass.
- [x] Check: screenshots of the list (unlocked and locked cards, with the unlock-all hack and without) at five sizes; `test.ps1`, `lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 13:43
**Card** (G5, G7): `FighterCard` — `Column/Backdrop` (a rounded, dark-bordered panel in `Rarity.color` of the fighter, `LOCKED_BACKDROP` grey while locked) holding the `Picture` (the cached `FighterPictures` render, unchanged: the toon look of Step 3, no pedestal) and a centred `LockIcon` (Kenney lock, tinted orange); the name; the rarity in its colour, upper case, in the display font with an outline (new theme variation `RarityLabel`); the `PrestigeBadge` as before; `Stats` with a `TrophiesChip` (trophy, "1240") and a `PowerChip` (drawn bolt, "7 / 11" — new `Hacks.power_amount`, `power_text` now uses it) at 26 px; a `LockChip` (lock, "Locked") on locked cards. A locked picture is drawn grey by `scenes/ui/fighter_picture.gdshader` (keeps the premultiplied blend of the old `CanvasItemMaterial`; one material per card, `resource_local_to_scene`) instead of tinting the whole card. `CardPanel` (also used by the result and QR screens) is now the dark violet card with a dark border and a thicker bottom edge. The list's flat `BackgroundPanel` became `MenuBackground`. **Differs from the plan:** no price on locked cards — the game has no fighter prices yet (fighters unlock only by the hack; the shop is a later spec), so the lock chip says "Locked" instead of inventing a number (S2).
**Tests**: `test_fighter_list.gd` (the numbers in the chips with their icons; locked cards — lock icon, lock chip, grey backdrop and grey picture — and unlocked cards — none of them, the backdrop in the rarity colour); `test_hack_effects.gd` (unlock-all removes the lock icon and the grey; Power 22 shows "7 / 22" on the card's chip). `test_screen_sizes*.gd` unchanged and green. `docs/architecture.md` (list row, `power_amount`) updated.
**Screenshots** (`%LOCALAPPDATA%\hack_star\screens\09\step7\`, viewed): `godot_fighters_<size>.png` and `godot_fighters_unlockall_<size>.png` at 1280×720, 1180×820, 820×1180, 390×844, 844×390 (sample progress; with the unlock-all hack every card has its rarity backdrop: green, blue, purple, red, gold). Compared with `before\svelte_fighters_1280x720.png`: the same idea (rarity-coloured backdrop, grey locked fighter with a lock, icons for trophies and power); the text stays readable at 390 px (two columns). Nothing changed after looking.
**Done (2026-11-22 · ~8 min · Claude Opus 5.5)** — fighter cards with a rarity-coloured backdrop, grey picture with a lock for locked fighters, trophy and power chips, outlined rarity; the list on the gradient background. `tools/test.ps1` 428 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 5.48 M tokens · CHF 1.82 (217 credits)

---

## Step 8 — Fighter screen and skin pictures

### Goal
The fighter screen frames the fighter on its stage, and every skin button shows a picture of the
fighter in that skin in its rarity frame with its name (G2, G8, G16).

### Tasks
- [x] Record the start time in Notes below.
- [x] Fighter screen on `MenuBackground`, the stage framed with the pedestal; `SkinButton` shows the skin's picture (rendered once per skin and cached, as `fighter_pictures.gd`), a rarity-coloured frame (Legendary gold as today) and the name; select and back actions unchanged.
- [x] Update `test_fighter_screen.gd` (every skin button has a picture and the frame colour of its rarity).
- [x] Check: screenshots for a fighter with several skins at five sizes; `test.ps1`, `lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 13:51
**Screen** (G2, G8): `fighter_screen.tscn` on `MenuBackground`; the `FighterStage` (with the pedestal of Step 4) now sits in `Body/StageFrame`, a `PanelContainer` with the new theme variation `StageFramePanel` (a translucent lighter purple inside a dark rounded border, like the Svelte stage frame). The rarity is upper case; trophies and power are `IconChip`s next to the Prestige badge in one `Details/Stats` row (G5; saves height on a phone held sideways); **Select** is a `GreenButton` with a tick icon (a lock icon while it reads "Locked"); "Skins" in the outlined display font. Select, preview and Back unchanged.
**Skin pictures** (G8): `FighterPictures` renders any list of fighter/skin pairs (`_render`); `ensure` (the list, as before) and new `ensure_skins(host, fighter_id)` (every skin of one fighter), `cached_skin`; the fighter screen shows the cached pictures at once and the rest after rendering (once per skin per game start, headless renders nothing). `SkinButton` (150×190) shows the picture as its expanded icon above the name and rarity (`clip_text` on, otherwise Godot subtracts the text width from the icon's room), frames it in `Rarity.color` (a duplicate of the theme's frame per state with the border in that colour; Legendary keeps the thicker gold frame; Default the plain frame), `frame_color()`. Theme: skin frames 4 px on a dark violet fill, text 24 px, `icon_max_width` 0 for both skin variations.
**Tests**: `test_fighter_screen.gd` +2 (every skin of Blaze and Luna shows its cached picture and the frame colour of its rarity, Default the plain frame; the gradient background, the `StageFramePanel` frame and the pedestal); values read from the chips; `test_hack_effects.gd` and `test_screen_sizes.gd` paths for the chips and `StageFrame/FighterStage`. `docs/architecture.md` (fighter screen row, `FighterPictures`) updated.
**Screenshots** (`%LOCALAPPDATA%\hack_star\screens\09\step8\`, viewed): `godot_fighter_blaze_<size>.png` (3 skins: Default, Lava Epic, Phoenix Legendary) and `godot_fighter_luna_<size>.png` (locked; Default, Galaxy Mythic, Supernova Legendary) at 1280×720, 1180×820, 820×1180, 390×844, 844×390. After looking: the skin pictures first drew at ~40 px — the theme's `icon_max_width` 48 and Godot subtracting the text width — fixed with `icon_max_width` 0 and `clip_text`; now the fighter fills the frame above its name at every size. One test run hung in Godot's `--import` step (no output for 10 min, the author's editor open on the same project); the process was stopped and the re-run passed — not a code problem.
**Done (2026-11-22 · ~21 min · Claude Opus 5.5)** — the fighter screen on the gradient with the fighter framed on its pedestal, chips for trophies and power, a green Select, and skin buttons with the fighter's picture in each skin in a rarity-coloured frame. `tools/test.ps1` 430 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 6.19 M tokens · CHF 2.47 (295 credits)

---

## Step 9 — Result, info, hack and QR screens

### Goal
The result, info, hack and QR screens use the new background, fonts, buttons and icons; the
fighter on the result screen stands on the pedestal (G2, G13, G16).

### Tasks
- [x] Record the start time in Notes below.
- [x] `MenuBackground`, display font headings, coloured icon buttons and chips on `result_screen`, `info`, `hack_screen`, `qr_page`; the result screen's trophy part (spec 08) in the new look; the QR page keeps printable black-on-white codes.
- [x] Update the tests of these screens only where names or the look changed; `test_screen_sizes*.gd` pass.
- [x] Check: screenshots of the four screens at five sizes (result: victory with a Prestige celebration); `test.ps1`, `lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 14:13
**Screens** (G2, G13): `result_screen`, `info`, `hack_screen` and `qr_page` stand on `MenuBackground` (no screen uses `BackgroundPanel` any more); the scrolling content of info, hack and QR codes sits on a dark rounded panel (new theme variation `ContentScroll`, the `ScrollContainer`'s own `panel` style, so no node path changed). `BackButton` shows the back arrow on every screen. **Result**: heading in gold for Victory and light red for Defeat (Time's up white); **Play again** the yellow `PlayButton` with the play icon (60 px text, 40 px on short screens), **Home** a `BlueButton` with the home icon; the trophy part on the new dark `CardPanel` with a gold trophy icon in its corner (`TrophyPanel/TrophyIcon`), the change green for a gain and red for a loss, the count in `NumberLabel`; the Prestige celebration and the gold bar as before; the fighter on its pedestal (Step 4). **Info**: the words in the display font, gold with a dark outline (`WordLabel`; still "bold" for `test_info.gd`), the FPS switch unchanged. **Hack**: **Use code** green with a tick, **Scan QR code** blue with the eye, **Turn all hacks off** pink with a cross, **QR codes** purple with a new drawn `qr` icon (`Icons`, own work), "Active hacks" as a subheading. **QR codes**: the cards on the dark `CardPanel`, **Save image** blue; the codes stay black on white with their quiet zone (`QrImage` unchanged). Chips are not used here — these screens show no trophies, credits or power except the result's trophy part, which got the icon.
**Tests**: new `tests/test_screens_look.gd` (3: the four screens on the gradient, the back arrow and the dark content panel; the result's yellow Play again, blue Home, trophy icon, gold Victory heading, green gain and pedestal; the hack buttons' colours and icons); no existing test had to change (names and paths kept); `test_screen_sizes*.gd` green. `docs/architecture.md` (theme paragraph: `MenuBackground` on every menu screen, `ContentScroll`, the icons) updated.
**Screenshots** (`%LOCALAPPDATA%\hack_star\screens\09\step9\`, viewed): `godot_result_<size>.png` (a victory from 1990 trophies: +10, 2000 / 3000, PRESTIGE 2! with the badge and the gold burst), `godot_info_<size>.png`, `godot_hack_<size>.png` (with Unlimited credits active), `godot_qr_<size>.png` (three codes from a fake server list) at 1280×720, 1180×820, 820×1180, 390×844, 844×390. On the short screen (844×390) the result hides the fighter as spec 08 decided. Nothing changed after looking.
**Done (2026-11-22 · ~8 min · Claude Opus 5.5)** — the result, info, hack and QR screens on the gradient with the dark content panel, coloured icon buttons, the back arrow, a trophy icon and coloured results; `tests/test_screens_look.gd`. `tools/test.ps1` 433 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 6.44 M tokens · CHF 1.60 (190 credits)

---

## Step 10 — ProtonScatter addon

### Goal
ProtonScatter 4.2.0 is in the project, pinned, credited and kept out of the export (W6, D11).

### Tasks
- [x] Record the start time in Notes below.
- [x] Download 4.2.0 from the Godot Asset Store page; copy `addons/proton_scatter/` without `demos/` and `tests/`; keep `LICENSE`; note the zip's SHA-256.
- [x] Enable the plugin in `project.godot`; `tools/versions.json` `"protonscatter": "4.2.0"`; `check_tools.ps1` checks its `plugin.cfg` version (pending/fail rules as GUT); `export_presets.cfg` excludes `addons/proton_scatter/*`; `LICENSES.md` row.
- [x] Check: `check_tools.ps1` shows ProtonScatter 4.2.0; Godot imports the project headless without errors from the addon; `test.ps1`, `lint.ps1`, `export_web.ps1` exit 0; no addon file in the `.pck` (export file list); export size unchanged (D16).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 14:22
**Addon** (D11, W6): the Godot Asset Store download of version 4.2.0 (`/asset/hungryproton/protonscatter/download/4384/`, 10,151,948 bytes, SHA-256 `ea971151188dfa33ad78c0a53058cfdfdc0a97e4d310641a14dfefe9b5e0e449`; `plugin.cfg` says 4.2.0, `LICENSE` MIT "Copyright (c) 2019 HungryProton") copied unchanged into `addons/proton_scatter/` without `demos/` (11.8 MB) and `tests/` — 334 files, 0.6 MB. The two built-in presets (`presets/grass.tscn`, `scatter_default.tscn`) name demo assets by path; they are loaded only when someone picks them in the editor's preset menu, so they stay unchanged (the import shows no error). Enabled in `project.godot` next to GUT; `tools/versions.json` `"protonscatter": "4.2.0"`; `check_tools.ps1` checks `addons/proton_scatter/plugin.cfg` like GUT (pending without `project.godot`, fails when missing or another version); `export_presets.cfg` excludes `addons/proton_scatter/*`; `LICENSES.md` row (source, version and date, download date, zip SHA-256, licence file) and the "excluded from the export" paragraph; README (folders, setup, `check_tools.ps1`) and `docs/architecture.md` (folders, checks) name the addon.
**Export** (D16): the only trace of the addon in `index.pck` is its `plugin.cfg` path in the project settings (as GUT's) — no addon file. `index.pck` 306,300 bytes vs 306,252 at `6c00b7e` (exported from a scratch worktree, then removed): +48 bytes, the setting; `build/web` 40,427,430 bytes (+66,340 vs the Step 1 baseline of 40,361,090, budget +5 MB).
**Done (2026-11-22 · ~8 min · Claude Opus 5.5)** — ProtonScatter 4.2.0 in `addons/proton_scatter/` (without demos and tests), pinned, checked by `check_tools.ps1`, credited, enabled in the editor and excluded from the export. `tools/check_tools.ps1` exit 0 (ProtonScatter 4.2.0), headless `--import` exit 0 without errors, `tools/test.ps1` 433 tests passed, `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 4.78 M tokens · CHF 1.68 (201 credits)

---

## Step 11 — Worlds and the world choice

### Goal
The arena layout is per world with a tested Glimmer Isles layout, and the player chooses the
world on home for **Play** and **Training** (W1, W2, W4, W7, S2).

### Tasks
- [x] Record the start time in Notes below.
- [x] `game/worlds.gd` and the per-world `ArenaLayout` (D9); callers read the active layout; the canyon's data unchanged.
- [x] The Glimmer Isles layout: walls, cover patches, decoration spots, dummies, start points (same size).
- [x] `GameState.world`; `WorldButton` and popup on home (D10); `Arena` and `MatchArena` use the chosen world; until Step 13, `GlimmerIsles` builds plain toon blocks and patches from the layout so the world is playable.
- [x] Tests: new `test_world_layouts.gd` (both layouts: starts free and ≥ 4 m apart, walls inside the bounds, every cover reachable, `in_bush` per world) and `test_world_choice.gd` (default canyon; the choice used by Play and Training; a bot finds the player in Glimmer Isles; saves unchanged); all existing arena and bot tests green for the canyon.
- [x] Check: screenshot of home with the world button and popup at 1280×720 and 390×844; `test.ps1`, `lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 14:31
**Worlds and layouts** (D9, W1, W4, W7): `game/worlds.gd` (`Worlds`: `LIST` canyon first, `ids()`, `get_world()`, `is_unlocked()` — every known world, no save field). `ArenaLayout`'s constants stay the canyon's layout, unchanged (`Canyon` and the canyon tests read them); `use(world_id)` sets the active layout in static variables (an unknown id gives the canyon), and `in_bush`, `is_free` and the new accessors `world()`, `walls()`, `border_count()`, `bushes()`, `decoration()`, `dummies()`, `starts()`, `start()` read it. `Arena` (start, dummies, near wall), `MatchArena` (starts), `BotBrain` (fallback wander point) and `ControlsHelp` (dummy count) now use the accessors. `game/glimmer_isles_layout.gd` (`GlimmerIslesLayout`): the canyon's size and border, 7 crystal ridges, 5 glow-fern patches, 10 decoration spots (crystal, mushroom, stone), 3 dummies and 9 starts. `GameState.world` (memory only, `reset()` → canyon). **Choosing the scenery:** `Arena` handles `NOTIFICATION_SCENE_INSTANTIATED` (before any child is ready) — `ArenaLayout.use(GameState.world)` and, for Glimmer Isles, `GlimmerIsles` replaces the scene's `Canyon` node on the same `Floor` and `Walls` (`match.tscn` inherits the scene, so the notification comes once per scene level; the second finds no `Canyon`). `scenes/worlds/glimmer_isles/glimmer_isles.gd` (`GlimmerIsles`, for now): violet sky and ambient light, a pale teal ground with its collision, the border in violet, the crystal ridges as glowing cyan toon blocks (collision boxes from the layout, the canyon's wall heights, so the camera framing of G11 holds), the fern patches as green ground; Step 13 adds the baked props.
**World choice** (D10, W2): `scenes/ui/world_choice.tscn` + `.gd` (`WorldChoice`: a dimmed screen with a `CardPanel` "Choose a world" and one 400×84 button per world, the current one `GreenButton` with a tick, the other purple with the world icon; a choice sets `GameState.world` and closes it, a tap on the dimmed part closes it unchanged). Home's `WorldButton` (world icon, the current world's name, new theme variation `TealButton`: compact teal, 28 px text, 76 px tall = 45.6 px on a phone) opens it. **Differs from D10:** the button sits in the top bar between the trophy and credit chips, not next to **Play** — next to Play it did not fit the phone held sideways (844×390: the controls column is full) and would have moved **Play**'s node path; the top bar has room at all five sizes. README (home, *How to play a match*) and `docs/architecture.md` (home, arena, `ArenaLayout`, `Worlds`, `GlimmerIslesLayout`, tests) updated.
**Tests**: new `tests/test_world_layouts.gd` (7: worlds, canyon default and unchanged, Glimmer Isles active and as big with the same border, walls/cover/decoration/dummies fit, starts free and ≥ 4 m apart, every cover and start reachable on foot from the player's start — a 0.25 m grid walk with the 0.4 m fighter radius —, `in_bush` per world) and `tests/test_world_choice.gd` (10: canyon default on home, the button opens the choice with the current world marked, choosing Glimmer Isles keeps it and shows it on home, a tap beside closes without change, Training and a match built in Glimmer Isles with its walls, start, dummies and bot starts, back to the canyon, a bot fires at the player in Glimmer Isles, wander points free in Glimmer Isles, the world is not saved). All existing arena, bot and screen-size tests unchanged and green (the first world button, 60 px tall, was below 44 px on the phone sizes → 76 px).
**Screenshots** (`%LOCALAPPDATA%\hack_star\screens\09\step11\`, viewed): `godot_home_world_<size>.png`, `godot_home_world_choice_<size>.png`, `godot_home_world_glimmer_<size>.png` and `godot_training_glimmer_<size>.png` at 1280×720 and 390×844 — the teal "Canyon" button between the chips, the choice over the dimmed home with Canyon marked, "Glimmer Isles" on the button after choosing, Training in Glimmer Isles (plain glowing blocks, fern patches, the dummies). Nothing changed after looking.
**Done (2026-11-22 · ~13 min · Claude Opus 5.5)** — the arena layout per world (`Worlds`, `ArenaLayout.use`, `GlimmerIslesLayout`), the world choice on home for Play and Training, Glimmer Isles playable with placeholder blocks; `tests/test_world_layouts.gd`, `tests/test_world_choice.gd`. `tools/test.ps1` 450 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 10.98 M tokens · CHF 2.93 (349 credits)

---

## Step 12 — Glimmer Isles objects and scatter scene

### Goal
The fantasy props exist in the outlined look, and a ProtonScatter scene places them from the
layout (W1, W3, D13).

### Tasks
- [x] Record the start time in Notes below.
- [x] Props in `scenes/worlds/glimmer_isles/props/` (crystal cluster, glow fern, small mushroom, giant mushroom, floating island chunk), each a small scene from primitive meshes with D5 materials.
- [x] `scatter_source.tscn`: one `ProtonScatter` per kind with its `ScatterItem`s and `ScatterShape` boxes from the layout (negative boxes around the start points), fixed seeds; `LICENSES.md` own-work row for the props.
- [x] Check: a windowed run of the source scene with the scatter rebuilt shows the props in the right places (screenshot from above and from the game camera); `test.ps1`, `lint.ps1` exit 0 (the source scene is not loaded by the game).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 14:45
**Props** (D13, W3): one `@tool` script `props/glimmer_prop.gd` (`GlimmerProp`, `kind` one of `KINDS`; setting it builds the parts at once, so `instantiate()` — what `ScatterItem` does, also in the editor — gives a finished prop) and five scenes `props/crystal_cluster.tscn` (a dark violet rock with three glowing six-sided spikes, cyan and pink, ~1.5 m), `glow_fern.tscn` (four green fronds with glowing tips, ~1.1 m, half-hides a fighter like a cactus), `small_mushroom.tscn` (cream stem, glowing violet cap), `giant_mushroom.tscn` (~4 m, pink cap with light gills), `island_chunk.tscn` (a grass disc on a rock cone with hanging roots). Every part is a direct `MeshInstance3D` from a primitive mesh with a `ToonMaterials` material (cel-shaded, outlined, glow where it shines), placed without scale — so the bake can give each part its own MultiMesh with a correct outline (ProtonScatter merges a prop's parts into one mesh, whose outline would grow from the prop's origin, not from each part). `ToonMaterials` became `@tool` (the props build in the editor too). The decoration kind "stone" of Step 11's layout had no prop: those three spots are now crystal or mushroom (`GlimmerIslesLayout.DECORATION`, test and `docs/architecture.md` updated).
**Scatter source** (`scenes/worlds/glimmer_isles/scatter_source.tscn`, D13): written once by a temporary generator from `GlimmerIslesLayout` (outside the repository, removed) and from now on edited in the editor like any scene. Seven `ProtonScatter`s with fixed `global_seed`s (11–17), chunks off: **Crystals** (a box inside each of the 7 crystal ridges, inset 0.15 m, grid 0.85 m + small jitter, random turn, scale 1–1.35; 31 clusters), **BorderCrystals** (random on top of the north, west and east border walls, not the low camera-side one; 41), **Ferns** (a box inside each of the 5 fern patches, grid 0.62 m + jitter, 75 % glow ferns and 25 % small mushrooms; 88), **DecorationCrystal** / **DecorationMushroom** (one *Add Single Item* modifier per decoration spot; 5 + 5), **GiantMushrooms** (random on the rim strips west, east and north of the border; 12), **Islands** (random in big boxes around and 4 m below to 1 m above the arena; 16). Crystals and Ferns have a negative 1.5 m box around each of the 9 start points. The grid boxes' tops lie on exactly representable heights (0.0, 0.375): the grid modifier puts its points on the top face of the shapes (it keeps `restrict_height` on after a reload), so a box top that is not exact in binary can drop every point. The scene references only addon scripts and the prop scenes; the game never loads it and `export_presets.cfg` now leaves it out of the export as well (it needs the excluded addon). `LICENSES.md`: own-work row for the props and their placement.
**Tests**: new `tests/test_glimmer_props.gd` (2: every prop scene has outlined toon parts from primitive meshes, direct and without scale, right after `instantiate()`; changing `kind` rebuilds the parts).
**Screenshots** (`%LOCALAPPDATA%\hack_star\screens\09\step12\`, viewed): a windowed run of Training in Glimmer Isles with `scatter_source.tscn` added and every scatter rebuilt on the main thread (`dbg_disable_thread`) — `godot_scatter_game_camera_<size>.png` (the game camera; Step 11's placeholder crystal blocks hidden so the clusters show), `godot_scatter_above_<size>.png` and `godot_scatter_above_arena_<size>.png` (orthographic from above: clusters exactly on the ridge rectangles, ferns and mushrooms filling the patches, one prop per decoration spot, border crystals on three sides, giant mushrooms on the rim, islands around), `godot_props_<size>.png` (close-up) at 1280×720 and 820×1180. After looking: both mushroom caps were tall egg shapes (a hemisphere's `height` is its own height, not the whole sphere's) → flat domes; the crystal ridges now read as crystal walls; the pale ground and the lighting are Step 13.
**Done (2026-11-22 · ~11 min · Claude Opus 5.5)** — five original Glimmer Isles props built from primitive meshes in the outlined look, and the ProtonScatter source scene placing them from the layout with fixed seeds; `tests/test_glimmer_props.gd`. `tools/test.ps1` 452 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 12.65 M tokens · CHF 3.18 (379 credits)

---

## Step 13 — Glimmer Isles baked and playable

### Goal
The scatter result is baked into a plain scene, Glimmer Isles is played with it in Training and a
match, also in the web export, at a good frame rate (W3, W4, W5, D12).

### Tasks
- [x] Record the start time in Notes below.
- [x] `tools/bake_world.ps1` + `tools/bake_world.gd` (D12) write `baked.tscn`; `GlimmerIsles` loads it with the floor and the layout colliders; the sky gradient and glow.
- [x] New `test_glimmer_isles.gd`: `baked.tscn` loads without the addon and references no `addons/proton_scatter` path; props in every wall and cover rectangle; no prop on a start point.
- [x] Desktop: draw calls and frame time of a 4-fighter match in Glimmer Isles vs the canyon in Notes; web: `export_web.ps1`, `serve_web.ps1`, a match in Glimmer Isles in a browser starts and runs (screenshot); export size noted (D16).
- [x] Check: screenshots of Training and a match in Glimmer Isles at 1280×720 and 820×1180; `test.ps1`, `lint.ps1`, `export_web.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 14:56
**Bake** (D12, W5): `tools/bake_world.ps1` imports the project and runs `tools/bake_world.gd` headless: it loads `scatter_source.tscn`, sets every `ProtonScatter` to `dbg_disable_thread`, `enable_updates_in_game` and `force_rebuild_on_load`, waits for every `build_completed` (main thread), and writes `scenes/worlds/glimmer_isles/baked.tscn` — one plain `MultiMeshInstance3D` per prop part (19: crystal cluster 4, glow fern 6, small mushroom 2, giant mushroom 3, island chunk 4), no script, no addon path, 127 KB. **Differs from D12** (found while baking headless): a headless run has no renderer, so a MultiMesh holds no transforms there (the scatter's own output and a baked MultiMesh both came back empty or as identity) and a `ShaderMaterial` saves its unset uniforms as `null`; so the bake reads the places from each scatter's transform list and splits them between its items as ProtonScatter does (`_update_multimeshes`, chunks off), and stores per part the places (`transforms`, prop place × part offset) and colours (`albedo`, `glow`, `glow_strength`, `outlined`) as metadata; `GlimmerIsles.load_baked()` fills each MultiMesh and puts the shared `ToonMaterials` material on it (fighters, canyon and Glimmer Isles share one material per colour). Two bakes give the same places; only Godot's random node `unique_id`s differ. ProtonScatter 4.2.0's grid modifier puts its points at the height *bounds max + bounds min* of its shapes, so the grid boxes of `scatter_source.tscn` were changed to [−0.25, 0.25] m (ferns and mushrooms on the ground) and [−0.25, 0.5] m (crystal clusters at 0.25 m, on the plinths); counts unchanged (crystal clusters 77, glow ferns 66, small mushrooms 27, giant mushrooms 12, island chunks 16).
**World** (W3, D13): `GlimmerIsles` now builds a tiled teal-lavender ground (MultiMesh, per-tile colour) with a path of glowing stones along the two middle lines (skipping walls and patches), the violet border walls with caps (unchanged heights, so G11's framing holds), low dark-violet rock plinths (0.25 m) under the crystal ridges — the baked clusters fill the ridge rectangles; the collision boxes stay 1.4 m —, the fern-patch ground, the island's teal rim (where the giant mushrooms stand) and a rocky underside cone, a starry-violet `ProceduralSkyMaterial` gradient (the camera looks down, so its dark lower half shows around the island), lavender ambient light and a pink-white sun; Step 11's "Outside" plane and glowing blocks are gone. **Glow** is the props' own emission (crystals, fern tips, mushroom caps, path stones), not the environment's glow post-process: a full-screen pass costs too much on the iPad for G14/W5.
**Tests**: new `tests/test_glimmer_isles.gd` (4: `baked.tscn` has no `addons/` or `proton_scatter` text, only plain `MultiMeshInstance3D`s without script, every prop kind placed; crystal clusters in every ridge, ≥ 6 plants in every fern patch, one prop at each decoration spot; no prop within 0.75 m of a start point; in the game every MultiMesh is filled and on a cel-shaded material with the stored outline choice, and no node of the running world has an addon script).
**Frame rate (desktop, 1280×720, vsync off, a 4-fighter match, mean of 240 frames, two runs each):** canyon 748 / 738 draw calls, 9.1 / 3.1 ms per frame; Glimmer Isles 623 / 670 draw calls, 7.8 / 3.7 ms per frame — the same within the run-to-run noise, about 0.8 M primitives each. The iPad check stays with Step 20 (G14, W5).
**Web** (D16): `tools/export_web.ps1` exit 0, `build/web` **40,510,230 bytes** (+149,140 vs the Step 1 baseline; budget +5 MB), `index.pck` 389,100 bytes (+82,800 vs Step 10, the baked scene and the world code; the plan's ≤ 1.5 MB for Glimmer Isles met); `scatter_source.tscn`, the bake tool and the addon are not in the `.pck` (the addon only as its `plugin.cfg` path in the project settings). `tools/serve_web.ps1` (port 8061) and headless Edge (software WebGL, Playwright): skip the entrance, world button → Glimmer Isles → Play: the match starts in Glimmer Isles in the single-threaded web build, countdown "2" and then "FIGHT!" (`web_match_glimmer_1280x720.png`, `web_match_glimmer_later_1280x720.png`; software rendering in a headless browser runs at about 1 frame per second, so it says nothing about the frame rate); server stopped.
**Screenshots** (`%LOCALAPPDATA%\hack_star\screens\09\step13\`, viewed): `godot_training_glimmer_<size>.png` and `godot_match_glimmer_<size>.png` (5 s in) at 1280×720 and 820×1180, and the web shots above. Crystal ridges read as walls, the fern patches are dense, the outlined props match the fighters' look, the near border stays a thin strip. Nothing changed after looking.
**README**: *Commands* gets `bake_world.ps1` and a *How to change Glimmer Isles* section (edit the source scene or props, bake, test, commit both); `docs/architecture.md` (tools, 3D models, tests) updated.
**Done (2026-11-22 · ~13 min · Claude Opus 5.5)** — the bake tool, Glimmer Isles built from its baked props with ground, path, plinths, rim, sky and lights, playable in Training, a match and the web export; `tests/test_glimmer_isles.gd`. `tools/test.ps1` 456 tests passed, `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0, `tools/bake_world.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 13.27 M tokens · CHF 3.05 (364 credits)

---

## Step 14 — Gate: author's drawing photo

### Goal
Part A starts only with the author's real photo: the run stops here and tells the author exactly
what to do (A0, A1, A7, D14, D17). No code.

### Tasks
- [x] Record the start time in Notes below.
- [x] Author has modified this. I saw the instruction and placed the image named: character_drawing_01.png at `%USERPROFILE%\hack_star_drawings\`. No need to stop, we can continue. So, don't Stop the implementation and the requests  *"Please photograph one of Mattia's drawings: the whole drawing, lying flat, in daylight, on plain paper, with nothing else in the picture — no people, faces, full names, addresses or places. Remove the photo's location and other metadata (or send it as a screenshot of the photo). Send it in the chat or put it in `%USERPROFILE%\hack_star_drawings\`, and tell me the fighter's name (1–12 letters), which existing fighter's attack it should use, and the first name or nickname for `LICENSES.md`. If you also want the part B trial (Step 19), it needs your Google Flow and Meshy accounts."* is already done. 
- [x] Create a name for the character by yourself. 
- [x] Check: the photo has arrived and its location is noted (not the photo itself); no need for the author's answers (name, attack, credit name)  in Notes since you decide the name..

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 15:12
**Gate** (A0, D17): the author placed the photo and asked to continue without stopping; the run goes on with Step 15.
**Photo**: `%USERPROFILE%\hack_star_drawings\character_drawing_01.jpg` (JPEG, 1308×1744 px, 710 KB) — the author's task line says `.png`, the real file is `.jpg`. Location noted only; the photo is not copied into the repository (A7). Viewed: it shows only the drawing on plain white paper — no people, faces of real persons, full names, addresses or places; only a tiny pen mark ("B-") at the lower right edge of the paper. **Metadata**: no EXIF and no GPS (System.Drawing finds only the two JPEG quantisation tables, no camera, date or location tags); Step 16 re-encodes it anyway (D14).
**Drawing** (shapes and colours, no personal data): a chibi kid in a crouching action pose, front view, big round head; spiky hair in purple and navy with a pink streak across it; large white-and-teal over-ear headphones (white band, teal cups with an orange detail, a small red block on top of the right cup); big dark-blue eyes, serious look; white jacket with teal trim (round teal shoulder pad with orange edge, teal collar, hem and cuff); navy trousers; black shoes; one hand in a black fingerless glove touching the ground; the other arm is a long white tube (an arm cannon or bat) held forward and down.
**Name**: **Beatbolt** (8 letters, within 1–12) — "beat" for the big headphones, "bolt" for the shots from the white tube arm cannon; original (not from a game, film or brand known to us), not an existing fighter in `game/fighters.gd` (Blaze, Rocko, Turbo, Frosty, Luna, Pixel) and not "Blaze".
**Attack source** (D14, A6): **Luna** — the space cat with a ray gun; the tube arm cannon is a ranged weapon like her ray gun. Today every fighter shares the same shot rules of `game/combat.gd` (speed, range, cool-down, damage), so Step 16 copies Luna's entry (stats and attack) without a new attack.
**Credit name** for `LICENSES.md`: "Mattia (drawing)".
No code changed in this Step, so `tools/test.ps1` and `tools/lint.ps1` were not run.
**Done (2026-11-22 · ~2 min · Claude Opus 5.5)** — photo found at `%USERPROFILE%\hack_star_drawings\character_drawing_01.jpg` (not `.png`), checked (only the drawing, no EXIF/GPS), the fighter named Beatbolt with Luna's attack, credit "Mattia (drawing)"; no code changed; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 650 k tokens · CHF 0.32 (39 credits)

---

## Step 15 — Drawing workflow document

### Goal
`docs/drawing_to_fighter.md` tells the author how to photograph a drawing, where to put it, what
to ask Claude, what the result can and cannot be and how long it takes (A1, A6, A7, D15).

### Tasks
- [x] Record the start time in Notes below.
- [x] Write the document: photo rules and privacy (A7, as Step 14's request), where the photo goes, metadata removal (D14), the exact request to Claude via Copilot, the limits of A6 (one drawing per run, front view only, no fine lines/texture/writing, name 1–12 letters, a fighter not a new attack, 3D from shapes with the cut-out fallback), expected time; link from the README.
- [x] Check: the document's steps match what Step 16 does (re-read after Step 16); links valid; `test.ps1`, `lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 15:14
**Document** (D15): `docs/drawing_to_fighter.md` — 1 photograph (only the drawing, flat, daylight, nothing else; no people, faces, full names, addresses, places; remove metadata; own idea, no copied character), 2 where it goes (`%USERPROFILE%\hack_star_drawings\` outside the repository or the chat; never committed) and the three choices (name 1–12 letters, the fighter whose attack and starting numbers it copies, the credit name), 3 the exact request to Claude and what Claude then does (re-encode with `Image` ≤ 1024 px `save_png` outside the repository, read shapes and colours, build from shapes in `scenes/drawn/<id>_model.gd` with `ToonMaterials`, the three places of D14 + `SampleProgress`, credit, screenshots next to the photo, the child's "this is my drawing"), the A6 limits (one drawing per run, front view only, shapes not lines, no new attack, name 1–12 letters, the cut-out fallback) and the time (≈ 15 min of the author, 30–60 min of Claude). Linked from the README (*Layout* `docs/` row and a new *How to turn a drawing into a fighter* section). Written before Step 16 from D14 and the Step 16 plan; the re-read against what Step 16 really did is in Step 16's Notes (any change goes into Step 16's commit). *Add another drawing* / *Remove a drawn fighter* come in Step 17.
**Done (2026-11-22 · ~5 min · Claude Opus 5.5)** — `docs/drawing_to_fighter.md` (photo and privacy rules, where it goes, the request to Claude, limits, time) and the README links; links checked by hand. `tools/test.ps1` 456 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 2.32 M tokens · CHF 0.97 (116 credits)

---

## Step 16 — Drawn fighter in the game

### Goal
Mattia's drawing is a new fighter built from shapes, unlocked from the start, with its name,
card, animations and see-through, playable in Training and a match (A2, A3, A4, A5, A8).

### Tasks
- [x] Record the start time in Notes below.
- [x] Re-encode the photo without metadata (D14); describe the drawing's main shapes and colours in Notes (no personal data).
- [x] Add the fighter (D14): `Fighters.LIST` entry, `scenes/drawn/<id>_model.gd`, the `drawn_fighters.gd` row; the cut-out fallback only if shapes cannot carry the drawing (say why in Notes).
- [x] `LICENSES.md`: the drawn character as the child's own work under the repository licence, with the chosen name; confirm it is not copied from a game, film or brand.
- [x] Tests: new `test_drawn_fighter.gd` (in the list, selectable, shown on home, plays in Training and a match, has idle/run/attack and see-through); update the fighter counts in existing tests.
- [x] Check: screenshots of the card, the fighter screen, home and a match next to the photo; export size noted (D16); `test.ps1`, `lint.ps1` exit 0.
- [x] Screenshots ready to send to the author for Mattia's "this is my drawing" (A3) — the answer itself is *waiting for the author* (not invented; moved to Deferred Items, target Step 20 / author).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 15:19
**Photo** (D14, A7): re-encoded with Godot's `Image` (load the JPEG → Lanczos resize to 768×1024 → `save_png`) by a temporary headless script outside the repository into `%USERPROFILE%\hack_star_drawings\character_drawing_01_clean.png` (1,237,131 bytes, a PNG without metadata); viewed: only the drawing. Neither the photo nor the PNG is committed (the shapes version needs no picture; only the cut-out fallback would).
**Drawing** (shapes and colours, no personal data; adds to Step 14's description): big round head with yellow-peach skin; spiky hair in purple and navy, the big locks swept to both sides and a fringe over the forehead, a pink streak across the left side; big dark-blue eyes with black upper lids under serious slanted brows, a small frown; large white over-ear headphones with teal cups, an orange mark on each and a red block on top of the right one, the white band crossing over the hair; white jacket with teal collar, hem and a teal stripe down the front, a round teal shoulder pad with an orange edge on the left shoulder (screen right); left hand in a black fingerless glove with the fingertips showing, teal cuff; the right arm a long white tube with a cuff ring and an orange accent; navy trousers, black shoes; a crouching pose.
**Fighter** (D14, A2, A4): `Fighters.LIST` gets `beatbolt` ("Beatbolt", `drawn: true`, unlocked, one Default skin, rarity Mythic and `SampleProgress` 0 trophies / power 1 copied from Luna — every fighter shoots with `Combat`'s shared rules, so the attack is Luna's without a new one); old saves get him through `Fighters.start_unlocked()` (tested). `scenes/drawn/drawn_fighters.gd` (`DrawnFighters`: the `MODELS` table, `has`, `looks`, `build`) and `scenes/drawn/beatbolt_model.gd` (`LOOKS` + static `build`): legs, shoes, jacket with teal hem, collar and stripe; head, eyes (dark-blue pupils on whites), lids, brows, frown; `SpikyHair` (cap, navy back, 11 swept locks, 5-lock fringe, `PinkStreak` of 4 segments on the cap); `Headphones` (cups with teal discs and orange marks, sliders, a 7-segment band over the hair, the red `BeatLight` that flickers); the glove arm with cuff, black glove, fingertips, `ShoulderPad` with an orange ring; `ArmCannon` (the long white tube with cuff and orange ring). The whole rig is scaled 0.85 (his hair and headphones made him taller than the others and hid the health bar at `Fighter.BAR_Y` 2.3). `FighterModel.setup` asks `DrawnFighters` first; its building blocks became public for the look files (`part`, `group`, `eyes`, `flicker`, static `sphere`, `capsule`, `cone`, `cylinder`, `box`, `torus` — renamed from `_…`, no change in what they do) with `get_rig`, `get_body`, `get_head`; the six fighters are unchanged. **No cut-out fallback**: the drawing's parts are all round or straight shapes, so they carry it. **Differs from the drawing**: the crouching pose becomes the standing pose (the idle, run and attack animations need it), written in `docs/drawing_to_fighter.md` (A6).
**Licence** (A8): `LICENSES.md` *Own work* row — Beatbolt, the child's own drawing, credited "Mattia (drawing)", MIT as the repository, the photo not in the repository; not a character of a game, film or brand known to us.
**Tests**: new `tests/test_drawn_fighter.gd` (9: a drawn, unlocked fighter with one Default skin and a 1–12 letter name; rarity and numbers of Luna; every drawn fighter has one look file and every look file a drawn fighter; an old save without him gets him unlocked; selectable and on home; plays in Training (runs) and in a match against the bots; idle, run and attack; see-through and back). Updated for the 7th fighter only: `test_fighters.gd` (7 fighters, a drawn one has 1 skin, 15 skins, start unlocks, ids), `test_fighter_model.gd` (Beatbolt's idea parts, 15 combinations — the cel-shading and outline tests cover him), `test_fighter_list.gd` (7 cards), `test_sample_progress.gd`, `test_game_state.gd`, `test_game_state_save.gd`, `test_hack_effects.gd` (the start unlocks). The first version of the match test left its match in the tree, whose walls stopped a shot in `test_fighter_health.gd`; the test now frees it.
**Screenshots** (`%LOCALAPPDATA%\hack_star\screens\09\step16\`, a windowed run with a temporary `-s` capture script kept outside the repository, viewed next to the photo): `godot_closeup{,_turn,_back}_1280x720.png` (on the stage: front, turned, back), `godot_cards_`, `godot_fighter_`, `godot_home_`, `godot_match_` (5 s in) at 1280×720 and 820×1175 (the desktop caps the window height at 1175, not 1180), `godot_training_1280x720.png`, `godot_closeup_820x1175.png`. After looking: (1) the hair cap covered the eyes and the fringe and brows were inside the head → cap moved up and back, fringe and brows in front of the forehead; (2) a "sunburst" of thin spikes → fewer, wider locks swept to the sides as drawn; (3) the pink streak looked like a hairpin, then like a headband → a diagonal streak of 4 segments on the left; (4) the headphone band was hidden in the hair → a larger band with sliders; (5) in the match his health bar was hidden in his hair → the figure scaled 0.85, the bar shows; (6) a straight mouth → a small frown. **How he reads now**: on home, the fighter screen and the 150 px card the spiky purple-and-navy hair with the pink streak, the big white headphones with teal cups and the red light, the big blue eyes, the white jacket with teal trim and shoulder pad, the black glove, navy trousers, black shoes and the long white arm tube are all recognisable; in the match (seen from above) the purple spikes, the white band and the white tube make him easy to tell from the other fighters.
**Waiting for the author (A3)**: Mattia's "this is my drawing" cannot be asked by the agent; the screenshots above wait for the author and Mattia in that folder (best: `godot_home_820x1175.png`, `godot_fighter_1280x720.png`, `godot_closeup_turn_1280x720.png`, `godot_cards_1280x720.png`, `godot_match_1280x720.png`), next to the photo. No answer is invented; the item is in **Deferred Items** (target Step 20 / author).
**Size** (D16): `tools/export_web.ps1` exit 0. In the working tree the export is 45,232,739 bytes (`index.pck` 5,111,608) because Godot packs the author's untracked `characters/` folder (Blaze PNGs and scenes, created 15:11, not part of this spec, not committed). What this Step adds, measured on a scratch copy of the project without `characters/` and `scenes/blaze_godot.zip` (under `%LOCALAPPDATA%\hack_star\step16\`, not committed): `build/web` **40,520,286 bytes** (+10,056 vs Step 13's 40,510,230; +159,196 vs Step 1's 40,361,090), `index.pck` 399,156 bytes (+10,056) — the plan's "drawn fighter (code) ≈ 0" holds. If the author's `characters/` folder joins the export it adds about 4.7 MB (then +4.87 MB vs Step 1, close to the 5 MB budget of G15).
**Step 15 re-read** (its check): `docs/drawing_to_fighter.md` matches what this Step did; adjusted in this commit: the rarity is copied too, and the figure is scaled to the others' height so the health bar stays visible. `docs/architecture.md` (*Game rules* `Fighters`, *3D models* drawn fighters, *Tests*) updated.
**Done (2026-11-22 · ~25 min · Claude Opus 5.5)** — Beatbolt built from shapes after Mattia's drawing (`scenes/drawn/`, `DrawnFighters`, `Fighters.LIST`, `SampleProgress`), credited, tested and checked on screenshots next to the photo; Mattia's A3 answer waits for the author (Deferred Items). `tools/test.ps1` 465 tests passed, `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 18.96 M tokens · CHF 4.94 (589 credits)

---

## Step 17 — Adding and removing drawn fighters

### Goal
A second drawing can be added the same way without touching other fighters, and a drawn fighter
can be removed with saves falling back to the default fighter (A9).

### Tasks
- [x] Record the start time in Notes below.
- [x] `docs/drawing_to_fighter.md`: *Add another drawing* and *Remove a drawn fighter* sections (the three places of D14).
- [x] Tests in `test_drawn_fighter.gd`: a save that selected an unknown (removed) drawn fighter loads with the default fighter and keeps the rest; adding a drawn fighter changes no other fighter's data.
- [x] Check: a dry run of the removal on a scratch copy (not committed) leaves the tests green; `test.ps1`, `lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 15:44
**Document** (A9): `docs/drawing_to_fighter.md` gets *Add another drawing* (the new look file, its `DrawnFighters.MODELS` row, its `Fighters.LIST` entry with the two `SampleProgress` numbers, its `LICENSES.md` row; no test change) and *Remove a drawn fighter* (delete the same places and the doc mentions; a save that chose it falls back to Blaze and keeps the rest); D14's three places plus the `SampleProgress` lines Step 16 added. `docs/architecture.md` (*3D models*, *Tests*) updated.
**Tests made independent of the drawn fighters** (so adding or removing one changes no test): `test_drawn_fighter.gd` now checks *every* drawn fighter (12 tests): unlocked with one Default skin and a 1–12 letter name; rarity and numbers of the fighter in its new `"plays_like"` field (`"luna"` for Beatbolt); one look file per drawn fighter and back; its `IDEA_PARTS` (new const in the look file, read by `DrawnFighters.idea_parts`; Beatbolt: `SpikyHair`, `PinkStreak`, `Headphones`, `ArmCannon`); old saves; **new** `test_a_save_that_chose_a_removed_drawn_fighter_falls_back_to_the_default` (a version 3 save with `selected_fighter`, trophies, power, unlock and skin of an unknown `removedbolt` → Blaze chosen, the unknown id dropped everywhere, Blaze's 1300 trophies, Rocko's power 6 and 42 credits kept); **new** `test_drawn_fighters_change_no_other_fighter` (the six originals first, in order, with their names, rarities, skins, unlocks, start numbers and own looks; `FighterModel.LOOKS` still six); the home, Training, match, animation and see-through tests on the first drawn fighter (with none: pass with a note). Step 16's count changes were replaced: `test_fighters.gd` checks the six originals (drawn ones filtered), `test_fighter_model.gd` the originals' idea parts and 14 + the drawn skins, `test_fighter_list.gd` 6 + the drawn cards, `test_game_state.gd`, `test_game_state_save.gd`, `test_hack_effects.gd` compare with `Fighters.start_unlocked()`.
**Dry run** (A9): the project copied without the author's `characters/` and `blaze_godot` files to `%LOCALAPPDATA%\hack_star\step17\proj` (never committed); there Beatbolt was removed exactly as the document says (deleted `beatbolt_model.gd` and its `.uid`, `MODELS = {}`, the `Fighters.LIST` entry, the two `SampleProgress` lines); only a comment in `test_drawn_fighter.gd` still named him. `tools/test.ps1` 468 tests passed (the first run had 3 "risky" tests that asserted nothing without a drawn fighter → they now pass with a note; re-run clean), `tools/lint.ps1` exit 0. The copy was deleted; the repository was never changed by the dry run.
**Done (2026-11-22 · ~13 min · Claude Opus 5.5)** — add and remove sections in the workflow document, the drawn-fighter tests made generic with the removed-fighter save fallback and the no-change-to-others check, the removal dry run green on a scratch copy. `tools/test.ps1` 468 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 5.84 M tokens · CHF 1.50 (179 credits)

---

## Step 18 — Tool recommendation document

### Goal
`docs/drawing_tools.md` recommends one main workflow with at most three tools and one fallback,
with the facts, terms and limits of each tool (B1, B2, B3, B4, B5, D15).

### Tasks
- [x] Record the start time in Notes below.
- [x] Re-check the sources of Part 1's research table (Google Flow, Meshy, Tripo/Hunyuan3D/TRELLIS, Godot import) and date every fact.
- [x] Write the document: main workflow (Google Flow → Meshy → Claude in Godot) step by step, fallback (Claude alone, or Google Flow → Claude), facts per tool (what it does, cannot do, cost, account and minimum age, output format and Godot import, training on uploads, terms for an MIT game), Google Flow's place (B3), licence first and credits for `LICENSES.md` (B4), the fit limits (MB and triangles for 30 fps on an iPad, outlined look via D5, the A4 animations) (B5); "not legal advice"; link from the README.
- [x] Check: every fact has a source and date; no tool with unclear terms recommended; `test.ps1`, `lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 15:58
**Sources re-checked** (2026-11-22, web_fetch/web_search): Flow help *Get started* and *Manage your credits*, the Flow Privacy Notice (2026-05-19), the Feb 2026 Flow blog, Google Terms of Service (effective 2026-07-30), Meshy pricing, docs (*Pricing and credits*, *Image to 3D*, *Animation*), Meshy Terms of Service and Privacy Policy (both 2026-09-19), the Oct 2026 image-to-3D comparison, the Hunyuan3D-2.1 licence, Godot's *Available 3D formats*, CC BY 4.0. **New or changed against Part 1's table:** Meshy's free plan downloads only **10 Meshy 6 Lite models a month** (no texture at generation; AI Texturing 10 credits), has **20** of the animation presets, rigging and presets cost 0 credits; Meshy's minimum age is **14** (under 18 with a parent's permission); Meshy may **train on uploads and outputs** of non-Enterprise users (opt-out by e-mail to support@meshy.ai); on the free plan **Meshy owns the output** and licenses it under CC BY 4.0; uploads to the **Meshy Community** become CC BY-NC 4.0 (images) / CC0 (models) — so never publish there; Google Flow uses uploads and outputs to improve products and ML (switch *Help improve Flow* off); Google's terms forbid using AI output to develop ML models; the Pro price is shown as CHF 18 a month to a Swiss visitor (Part 1: about $20).
**Document** (D15, B1–B5): `docs/drawing_tools.md` — recommendation (main Google Flow → Meshy → Claude in Godot; fallback A Claude alone; fallback B Google Flow → Claude), licence first (B4), the main workflow in 5 steps, facts per tool (Google Flow with its place before the 3D tool, B3; Meshy; Claude; Godot 4.7), the tools not recommended (Tripo free = non-commercial, Hunyuan3D excludes the EU/UK/South Korea, TRELLIS.2 needs a 24 GB GPU), the `LICENSES.md` credit line for a Meshy free-plan model (CC BY 4.0, © Meshy LLC, changes noted), the fit limits (B5: ≤ 10,000 triangles per fighter, GLB ≤ 2 MB with textures ≤ 1024 px, rig with idle/run/attack, the D5 toon material and outline, licence, the child's preference), "not legal advice", and a *Sources* table (every fact, page date, read 2026-11-22). The fit limits are this spec's own numbers, reasoned from Step 13's ~0.8 M primitives per match and G15's budget. The *Trial (B6)* section is a placeholder for Step 19. Linked from the README (*Layout* `docs/` row and *How to turn a drawing into a fighter*) and from `docs/drawing_to_fighter.md`.
**Done (2026-11-22 · ~6 min · Claude Opus 5.5)** — `docs/drawing_tools.md` with the recommended workflow, fallbacks, facts and terms per tool with sources and dates, fit limits; README and workflow-document links. `tools/test.ps1` 468 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 2.49 M tokens · CHF 1.13 (135 credits)

---

## Step 19 — Trial of the recommended workflow

### Goal
The author runs the B1 workflow with one drawing on his own accounts; the result, time and cost are
recorded, and it joins the game only if its licence allows it and Mattia prefers it (B6, D17).
**Needs the author.**

### Tasks
- [x] Record the start time in Notes below.
- [x] Send the author the trial steps from `docs/drawing_tools.md` (free use only; Meshy free plan = CC BY 4.0, credit Meshy); wait — *waiting for the author* in Notes.
- [ ] Record in the document: what came out, time, credits used, problems.
- [ ] If Mattia prefers it to the Step 16 version and the licence allows: import the GLB (size and triangle limits of B5, D5 outline, A4 animations), credit in `LICENSES.md`; else keep the files out of the repository and say why.
- [ ] Check: the trial section of the document is filled; if imported, `test.ps1`, `lint.ps1`, `export_web.ps1` exit 0 and the export size noted (D16).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 16:04
**Waiting for the author** (B6, D17): the trial needs the author's own Google Flow and Meshy accounts, which the agent does not have; nothing of the trial is invented. Prepared in `docs/drawing_tools.md` § *Trial (B6)*: before-you-start (folder `%USERPROFILE%\hack_star_drawings\trial\` outside the repository, the cleaned photo `character_drawing_01_clean.png` of Beatbolt, Meshy Free plan without card, the training opt-out e-mail to support@meshy.ai, never publish to the Meshy Community, Flow's *Help improve Flow* off), Step A Google Flow (the prompt to paste: front view, A-pose, whole body, plain white background, toon style with flat colours and thick outlines, Beatbolt's shapes and colours), Step B Meshy Image to 3D (Meshy 6 Lite, Pose A-Pose, licence CC BY 4.0, poly count 8,000 if offered — limit 10,000, AI Texturing at 1024 if grey, at most 3 models ≤ 60 credits), Step C rig (0 credits), idle + run + attack-like clip, download **GLB** with all clips as `beatbolt_meshy.glb`, Step D Mattia's preference next to the Step 16 screenshots, the list of what to send back (GLB and size, screenshots, time per step, Flow and Meshy credits before/after, model and settings, problems, Mattia's words, opt-out sent) and an empty *Trial results* table. The remaining tasks (record the result, import or not, check) wait for the author's files; the item is in **Deferred Items**. No game file changed; `tools/test.ps1` 468 tests passed, `tools/lint.ps1` exit 0.
**Done — agent part only, trial deferred (2026-11-22 · ~3 min · Claude Opus 5.5)** — trial instructions, prompts, settings, what to send back and the empty results table in `docs/drawing_tools.md`; Deferred Items row added. `tools/test.ps1` 468 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 434 k tokens · CHF 0.14 (17 credits)

---

## Step 20 — Final check, README and architecture

### Goal
Everything that worked before still works, the size budget is met, the after-screenshots and the
author's verdict are recorded, and the documents describe the new look, the world and the
workflows (G1, G14, G15, G16, W5, S2, S3, S4, S5, S6).

### Tasks
- [x] Record the start time in Notes below.
- [x] Run `tools/check_tools.ps1`, `tools/test.ps1`, `tools/lint.ps1`, `tools/export_web.ps1` (all exit 0); every `.ps1` changed parses with `[System.Management.Automation.Language.Parser]::ParseFile`; `git status` shows nothing outside `hack_star_godot/` (S5).
- [x] Size: compare `build/web` with Step 1; ≤ +5 MB (G15, D16); write both numbers in Notes.
- [ ] After screenshots (D2) into `%LOCALAPPDATA%\hack_star\screens\09\after\`; the side-by-side session with the author and Mattia (G1, D17): their verdict per screen recorded in this Step's Notes; the iPad play-test (G14, W5: ≥ 30 fps with 4 fighters in the canyon and in Glimmer Isles, FPS switch of D8; playable within 5 s after **Play**) recorded — *waiting for the author* until then. *(Agent part done: the after set is captured and viewed; the verdict and the iPad play-test wait for the author — Notes and Deferred Items.)*
- [x] `README.md`: the new look, the world choice, Glimmer Isles and its re-bake (`tools/bake_world.ps1`), the FPS switch, links to both documents; `docs/architecture.md`: *UI foundation* (font, icons, theme, `MenuBackground`, `IconChip`), *3D models* (toon shaders, `ToonMaterials`, drawn fighters), worlds (`Worlds`, per-world `ArenaLayout`, `GlimmerIsles`, ProtonScatter bake), *Art and licences*; `LICENSES.md` complete (S4).
- [x] Check: every statement G1–G18, W1–W7, A0–A9, B1–B6, S1–S6 has a Step that is ✅ Done or a Note saying what waits for the author.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 16:07
**Checks** (S3): `tools/check_tools.ps1` exit 0 (Godot 4.7.2, web_nothreads templates, gdlint 4.5.0, GUT 9.7.1, ProtonScatter 4.2.0), `tools/test.ps1` 468 tests passed, `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0. The `.ps1` files changed in `91cc8be..HEAD` — `tools/bake_world.ps1`, `tools/check_tools.ps1` — parse with `Parser::ParseFile` with 0 errors. **S5**: `git diff --name-only 91cc8be..HEAD` lists nothing outside `hack_star_godot/`; `git status` shows only ` M .spec-nx` (the submodule, not ours) and the author's untracked `hack_star_godot/characters/`, `scenes/blaze_godot.zip`, `scenes/blaze_godot/` (his unrelated work in progress, not committed, not used).
**Size** (G15, D16; Step 1: `build/web` 40,361,090 bytes, `index.pck` 239,960): measured on a scratch copy of the project without the author's three untracked items (`%LOCALAPPDATA%\hack_star\step20\proj`, deleted afterwards), as Step 16 did: **`build/web` 40,520,478 bytes, +159,388 bytes (+0.16 MB) vs Step 1** — the budget of +5 MB is met by far; `index.pck` 399,348 bytes. In the working tree the export is **45,232,931 bytes (+4,871,841 vs Step 1)**, `index.pck` 5,111,800, because Godot packs every resource in the project folder, including the author's untracked `characters/` and `blaze_godot` files (about 4.7 MB); they are not part of this spec. Even so it stays under +5 MB, but with almost no room: if that work is committed later, its spec must count it against the size.
**After screenshots** (D2, G1), `%LOCALAPPDATA%\hack_star\screens\09\after\` (18 PNGs, all viewed; not committed): the 16 file names of the before set — `godot_` and `svelte_` × `home`, `fighters`, `fighter`, `match` × `1280x720`, `820x1180` — plus `godot_match_glimmer_1280x720.png` and `godot_match_glimmer_820x1180.png`. Godot: a windowed run (`--resolution`) with a temporary `-s` capture script outside the repository (deleted afterwards, never committed), the game's own save (now Blaze chosen, 1765 trophies), the matches 4 s in; the 820×1180 window is capped by the desktop at 820×1175 (as in Step 16), the files keep the D2 names. Svelte: `npm run dev` in `ui/` (port 5180; the FastAPI server already ran on 8180) and headless Edge through Playwright (`uv run --with playwright`, SwiftShader), a fresh account (Blaze), the match about 6 s in (countdown "1"); dev server stopped, nothing changed in `ui/`. Seen: home (gradient with rays, pedestal, two-colour outlined logo, coloured icon buttons, large yellow **Play**, trophy and coin chips, world button), fighter list (coloured backdrops by rarity, grey with a lock for locked fighters, rarity colours, trophy and power chips, Beatbolt as the seventh card), fighter screen (framed stage on a pedestal, chips, skin pictures in rarity frames, Legendary gold), match (outlined toon canyon with a soft sand floor, a thin near wall, timer and fighters-left chips, the hint on a dark backing, no FPS label) and Glimmer Isles. Nothing changed after looking.
**Waiting for the author** (D17): (1) **G1 verdict** — the author and Mattia compare `…\screens\09\before\` and `…\after\` side by side (same file names; open e.g. `godot_home_1280x720.png` of *after* next to `svelte_home_1280x720.png`), per screen (home, fighter list, fighter screen, match; desktop and iPad portrait) "as good as or better than the Svelte one?" — Mattia decides, the author breaks a tie; their words go into these Notes. (2) **A3** — Mattia's "this is my drawing" for Beatbolt (Step 16 screenshots in `…\screens\09\step16\`, and `godot_fighters_*.png` of the after set). (3) **G14 / W5 / G15 iPad play-test** — `tools/export_web.ps1`, `tools/serve_web.ps1 -Https` (README *Play on an iPad or a phone*), on the iPad: **Info → Show FPS (play-test)** on, then **Play** with 4 fighters in the canyon and again with **Glimmer Isles** chosen with the world button; measure the FPS label during a fight (lowest value seen, should stay ≥ 30) and the seconds from pressing **Play** to the arena showing (≤ 5 s). (4) the **B6 trial** of Step 19. All four are rows in **Deferred Items**; none is invented.
**Documents** (S4): README — intro (seven fighters with Beatbolt, two worlds), *Run in the editor* (seven fighters), a new *The look* section (gradient, pedestal, Lilita One, icon buttons, chips, toon outline, Glimmer Isles with ProtonScatter and the bake, the **Show FPS (play-test)** switch), *Play on an iPad* step 5 and *Controls* (the FPS switch), *Resources outside the folder* (art, fonts, drawing photos); the world choice, *How to change Glimmer Isles* (`bake_world.ps1`) and both document links were already there (Steps 11, 13, 15, 18). `docs/architecture.md` — *Layout* (`docs/` and `assets/` rows), *UI foundation* (font, button variations, `Icons`, `IconChip`, the world choice, the FPS switch), *3D models* (toon shaders, `ToonMaterials`; the tools workflow link), *Art and licences*; `MenuBackground`, worlds (`Worlds`, per-world `ArenaLayout`, `GlimmerIsles`, the bake) and drawn fighters were already described by Steps 4–17. `LICENSES.md` — complete: own work (now naming the shaders and the theme), Beatbolt, the Glimmer Isles props, the drawn icons, Lilita One and Kenney Game Icons with source, version, SHA-256, GUT, ProtonScatter, jsQR; every file in `assets/` has its row and licence file.
**Coverage of the statements** (the check task): G2 Steps 4, 8, 9 · G3 2 · G4 4 · G5 2, 4, 7 · G6 2 · G7 7 · G8 8 · G9 3 · G10 5 · G11 6 · G12 6 · G13 9 · G16 every Step (`test_screen_sizes*.gd`) · G17 the order of Steps 4–9 · G18 2, 4 · W1 11–13 · W2 11 · W3 12, 13 · W4 11 (overtime → spec 11, Deferred Items) · W6 10 · W7 5, 11 · A0 14 · A1 15 · A2 16 · A4 16 · A5 16 · A6 15 · A7 14, 16 · A8 16 · A9 17 · B1–B5 18 · S1 every Step on Claude Opus 5.5 · S2 the 468 tests · S3 this Step · S4 Steps 2, 10, 16 and this Step · S5 this Step · S6 all new text English (translations → spec 15) — all ✅ Done. **Waiting for the author** (Notes above and Deferred Items): G1 (before and after sets ready, verdict open), G14 and W5 (desktop frame time in Step 13, web build single-threaded and baked in Step 13; iPad check open), G15 (size met here; the 5 s on the iPad open), A3 (built from shapes; Mattia's confirmation open), B6 (Step 19 🔜 Deferred).
**Done (2026-11-22 · ~10 min · Claude Opus 5.5)** — all Godot checks green, size +0.16 MB vs Step 1 (working tree +4.87 MB with the author's untracked folders), the after set of both games captured and viewed, README, `docs/architecture.md` and `LICENSES.md` brought up to date, every statement covered; the G1 verdict, A3, the iPad play-test and the B6 trial wait for the author. `tools/check_tools.ps1` exit 0, `tools/test.ps1` 468 tests passed, `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 5.86 M tokens · CHF 1.57 (187 credits)

---

## Step 21 — Baseline, art import and licences

### Goal
The reopening's before set and measurements exist, the author's pictures are imported web-safe
and within budget, credited, and the delivery's extra files are kept out of git and the export
(C2, C9, C10, C11, L1, L8; D22, D28).

### Tasks
- [x] Record the start time in Notes below.
- [x] Before set (D28, D2): home, fighter screen, a 4-fighter match 4 s in, in the canyon and in Glimmer Isles, at 1280×720 and 820×1180, into `%LOCALAPPDATA%\hack_star\screens\09b\before\`; all viewed; capture script outside the repository, deleted.
- [x] Performance baseline (D28): a windowed run, vsync off, 4-fighter match per world, Classic view, 10 s — average and worst frame time, draw calls, primitives — written in Notes; temporary script deleted.
- [x] `.gitignore`: `/scenes/blaze_godot.zip`, `/scenes/blaze_godot/`; `export_presets.cfg` `exclude_filter`: the D22 entries; the zips and `scenes/blaze_godot/` untouched (`git status` shows them as ignored, not untracked).
- [x] Imports (D22): the four PNGs not VRAM-compressed, `size_limit` 768 / 256, lossless (lossy WebP if over budget); `blaze_hero.tscn` and `blaze_hero_ui.tscn` point to `res://characters/blaze2/`; the two folders committed (pictures, `.import`, READMEs, scenes, preview scripts with their `.uid`).
- [x] `LICENSES.md`: one row per picture (C9 wording, Mattia's drawing, the author, date 2026-11-22); `tools/export_web.ps1` in the working tree: total and `.pck` size and the size of the two characters' imported files in Notes (C11 ≤ 1.0 MB; total ≤ 45,361,090 bytes).
- [x] Check: 8 PNGs present and viewed; the numbers in Notes; `tools/test.ps1`, `tools/lint.ps1`, `tools/export_web.ps1` exit 0; `git status --short` shows no zip and no `scenes/blaze_godot`.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 17:03
**Before set** (D28, D2), `%LOCALAPPDATA%\hack_star\screens\09b\before\` (8 PNGs, all viewed; not committed): `godot_home_<size>.png`, `godot_fighter_<size>.png`, `godot_match_canyon_<size>.png`, `godot_match_glimmer_<size>.png` at `1280x720` and `820x1180` (the 820×1180 window is capped by the desktop at 820×1175, as in Steps 16 and 20). A windowed run (`--resolution`) with a temporary `-s` capture script under `%TEMP%` (outside the repository, deleted afterwards), the game's own save (Blaze, 1765 trophies), the entrance skipped, the matches 4 s in (timer 2:00, the fight just started). Seen: home and the fighter screen with Blaze on the pedestal; the canyon in its sand-and-orange look and Glimmer Isles in pale lavender and teal with crystal ridges and fern patches — the reference for L1 ("more saturated and brighter").
**Performance baseline** (D28, L8; a windowed Compatibility run at 1280×720, vsync off, `Engine.max_fps` 0, a 4-fighter match per world, Classic view, sampled for 10 s from 1 s after the scene loads, the same temporary script, deleted): run 1 — canyon 764 frames, average **13.09 ms**, worst 131.43 ms, draw calls avg **792** (max 844), primitives avg 926 k (max 959 k); Glimmer Isles 1012 frames, average **9.89 ms**, worst 65.86 ms, draw calls avg **570** (max 674), primitives avg 810 k (max 894 k). Run 2 — canyon 780 frames, 12.84 ms, worst 93.88 ms, draw calls avg **1042** (max 1139), primitives avg 1.40 M (max 1.48 M); Glimmer Isles 1397 frames, 7.16 ms, worst 36.33 ms, draw calls avg 533 (max 577), primitives avg 752 k (max 787 k). The bots' fighters are random per match, so the canyon's draw calls vary by about a third between runs; the worst frame is the first frames' shader compilation. Step 28 compares against the higher of the two runs per world and repeats each run twice.
**Git and export** (C10, D22): `.gitignore` gets `/scenes/blaze_godot.zip` and `/scenes/blaze_godot/`; `git status --short --ignored` shows both as `!!` (ignored), the files untouched. `export_presets.cfg` `exclude_filter` gets `characters/*/character_preview.gd`, `characters/*/*_hero.tscn`, `characters/*/*_hero_ui.tscn`, `characters/*/README.md`, `scenes/blaze_godot/*`, `scenes/blaze_godot.zip`; the exported `index.pck` holds only the four pictures of `characters/` (searched for the file names: no preview script, scene, README or zip).
**Imports** (D22, C11): every picture not VRAM-compressed (`detect_3d/compress_to` off too, so Godot does not switch it to VRAM when a 3D material uses it); heroes `size_limit` 768 with mipmaps (they are small in the arena), cards 256 without. **Lossless was over budget**: heroes 780,800 + 904,548 bytes, cards 91,500 + 109,874 = 1,886,722 bytes (> 1.0 MB). **Decided:** heroes **lossy WebP** at quality 0.9 (210,596 + 258,378 bytes; alpha is kept exact by WebP), cards stay **lossless** (crisp on the card and skin buttons): **670,348 bytes for both characters** (C11 ≤ 1.0 MB met). The author's PNGs are unchanged. `blaze_hero.tscn` and `blaze_hero_ui.tscn` now point to `res://characters/blaze2/`. The two folders are committed: pictures, `.import`, READMEs, the four scenes and `character_preview.gd` with its `.uid` (not used by the game, not exported).
**Licences** (C9): `LICENSES.md` gets *Pictures of Flarekid and Echo*, a row per picture (the C9 wording, Mattia's drawing, the author, 2026-11-22; the tool and its terms to be confirmed by the author — Deferred Items), and the intro names the pictures.
**Web size** (`tools/export_web.ps1` exit 0, in the working tree with the author's untracked zip and folder present): `build/web` **41,188,483 bytes** (≤ 45,361,090; +827,393 vs Step 1, −4,044,448 vs Step 20's working-tree export, which packed the delivery's VRAM pictures), `index.pck` **1,067,352 bytes** (+668,004 vs Step 20's clean 399,348 — the two characters' imported pictures, 670,348 bytes).
**Done (2026-11-22 · ~8 min · Claude Opus 5.5)** — the reopening's before set (8 PNGs) and performance baseline, the delivery's extras ignored by git and kept out of the export, the four pictures imported web-safe (heroes lossy WebP, cards lossless, 0.67 MB for both) and credited, `blaze2`'s scenes fixed, the two folders committed. `tools/test.ps1` 469 tests passed, `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0 (41,188,483 bytes); `git status --short` shows no zip and no `scenes/blaze_godot`; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 3.98 M tokens · CHF 1.47 (175 credits)

---

## Step 22 — Flarekid and Echo in the game

### Goal
Flarekid and Echo are fighters, unlocked from the start, shown with their pictures — an outlined
cut-out with a shadow in 3D, their card picture on cards and skin buttons — and see-through in
cover (C1, C2, C6, C7; D20, D21).

### Tasks
- [x] Record the start time in Notes below.
- [x] `Fighters.LIST` rows and `SampleProgress` numbers (D20); `CutoutFighters` registry and `scenes/toon/cutout.gdshader` (Y billboard, alpha scissor, pixel-width outline, `flash`, `fade`, `flip`, `saturation`) and the blob shadow (D21); `FighterModel.setup` builds a cut-out fighter; `FighterPictures` returns the card picture.
- [x] See-through in cover through `fade` (C7); the tests that count fighters updated; `tests/test_cutout_fighters.gd` (D30, the data, card, model, see-through parts).
- [x] Screenshots (D2) at 1280×720 and 820×1180: home with Flarekid and with Echo on the pedestal, the fighter list (both cards), the fighter screen, both in a match in each world and in a bush; the outline compared with Blaze's next to it; Notes say what was looked at and changed.
- [x] Check: `tools/test.ps1`, `tools/lint.ps1` exit 0; both fighters selectable and playable in Training and a match (a test and the screenshots).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 17:12
**Data** (D20): `Fighters.LIST` gets **Flarekid** (`flarekid`, Legendary, plays like Blaze) and **Echo** (`echo`, Mythic, plays like Luna), both `"unlocked": true`, `"cutout": true`, one Default skin; old saves get them through `Fighters.start_unlocked()`. **Differs from D20:** `SampleProgress` gives both the numbers of a new fighter — 0 trophies, power level 1 — not Blaze's 1240 trophies and level 7 for Flarekid: the sample totals are the Svelte game's values (1745 trophies, checked by `test_game_state`, `test_hack_effects`, `test_match_trophies`, `test_mvp_flow`), and a new fighter with a Prestige badge it never earned would be wrong; Echo's numbers equal Luna's anyway.
**Look** (D21): `CutoutFighters` (`scenes/cutout/cutout_fighters.gd`) — id → hero and card picture, height, feet point, main colour; `build` puts one `QuadMesh` with a new `scenes/toon/cutout.gdshader` into the model's body (so the existing bob, squash and recoil move it) and turns the rig's shadow into a soft radial blob (`PlaneMesh`, `GradientTexture2D`, 0.03 m over the floor — at the floor's height it flickered into a thin streak from the arena camera). The shader: alpha-blended, unshaded, a dark outline found from the picture's alpha in two rings of 12 samples at `ToonMaterials.OUTLINE_PIXELS` screen pixels (scaled with the screen like `outline.gdshader`) plus its `OUTLINE_GROW` metres, the quad 5 % larger on each side for the outline's room, uniforms `flash`, `fade`, `flip` (around the feet), `saturation`. `FighterModel.setup` asks `CutoutFighters` after `DrawnFighters` (`get_cutout()`); see-through (C7) sets `fade` to `SEE_THROUGH_ALPHA` instead of swapping the material; `FighterPictures.cached_skin` returns the delivered card picture (never rendered), so the card and the skin button show it. **Differs from D21, found on the screenshots:** (1) a Y billboard looked half as tall and squashed in the arena (the camera looks down at 55°), so the quad turns fully to the camera and shrinks around its feet by 40 % of the camera's foreshortening (`foreshorten` 0.4): proportions kept, about Blaze's size on screen; (2) heights **2.7 m** (Flarekid) and **2.5 m** (Echo, crouching), not 1.6 m — the fighters of shapes are 2.3–2.6 m with hair, and at 2.3 m Flarekid looked smaller than Blaze on the pedestal; (3) the health bar and damage numbers over a picture fighter follow the camera (`Fighter._bar_y`, `FighterModel.picture_top`, `CutoutFighters.top_height`: over the picture's top + 0.3 m), because at the usual 2.3 m the bar crossed the picture's face.
**Tests** (D30): new `tests/test_cutout_fighters.gd` (9: data and unlocked, old save, card picture on the card and the skin button, the outlined quad on its feet with the soft shadow, own material per fighter, see-through `fade` and back, chosen and on home, Training (runs, moves, shoots) for both, a match with Echo and the bar over the picture). Tests that count or loop over fighters skip the picture fighters, which have their own file: `test_fighters.gd`, `test_fighter_model.gd` (`_shape_fighters()`), `test_drawn_fighter.gd`, `test_fighter_list.gd` (6 + drawn + picture fighters).
**Screenshots** (D2; windowed runs at 1280×720 and 820×1180 — capped at 820×1175 —, a temporary `-s` script under `%TEMP%\hs09b\`, deleted; the PNGs stay there, viewed): home with Flarekid and with Echo, the fighter screen of each, the fighter list scrolled to its end (both cards), and a match in each world with Flarekid as the player, Echo on his right, Blaze on his left and another Echo in the nearest bush — and the same with Echo as the player (`final\godot_<screen>_<size>.png`, 18 files). Seen: on the pedestal both stand on their feet with a dark outline as wide as the pedestal's and Blaze's, a soft shadow under them; the cards show the delivered card pictures in the rarity colours (Echo's card has a white fringe in the delivered picture, kept as delivered); in the arena both read as clearly as Blaze next to them, outlined, the bush copy faded. **Changed after looking:** the billboard, the heights, the bar height and the shadow's lift above.
**Open (not in this Step):** the author added `characters/magmax/` (untracked, 17:24) during this Step; it is not used, not committed, and its pictures would be packed by the web export if they stay in the folder (Step 21's numbers were measured before it).
**Done (2026-11-22 · ~25 min · Claude Opus 5.5)** — Flarekid and Echo are unlocked fighters shown as the author's pictures: an outlined, camera-facing cut-out with a soft shadow on home, the fighter screen and in play, their card pictures on the cards and skin buttons, see-through in cover; both selectable and playable in Training and a match. `tools/test.ps1` 478 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 18.47 M tokens · CHF 4.98 (594 credits)

---

## Step 23 — Pedestal reveal and idle

### Goal
Every fighter pops in with particles and a rarity halo on home and the fighter screen, and the
cut-out fighters breathe, bob and sway when standing (C3, C4; D23).

### Tasks
- [x] Record the start time in Notes below.
- [x] Reveal in `FighterStage` (scale tween, `CPUParticles3D` burst, rarity halo) when the stage has a pedestal; none on the off-screen pictures.
- [x] Cut-out idle in `FighterModel.animate` (breathing, bob, sway).
- [x] `tests/test_fighter_reveal.gd` (D30); existing home and fighter-screen tests still green.
- [x] Screenshots (D2): a sequence of 4 frames (0, 0.15, 0.3, 0.6 s) of the reveal on home and on the fighter screen for Flarekid (Legendary), Echo (Mythic) and Rocko (Rare), and two idle frames of each new fighter 0.5 s apart; viewed; Notes say what was changed after looking.
- [x] Check: `tools/test.ps1`, `tools/lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 17:41
**Reveal** (C3, D23): `FighterStage` builds, when it has a pedestal, a `Reveal` node with a soft radial **halo** (a camera-facing quad behind the fighter, 3.6 × 4 m) and a one-shot `CPUParticles3D` **burst** of 24 sparks; `show_fighter` plays `reveal()` in the fighter's rarity colour (`rarity_color()`, `Rarity`): the rig grows 0.3 → 1.0 in 0.45 s with `TRANS_BACK` (a ~7 % overshoot), the halo flares to 1.2× in 0.15 s and settles to its size at alpha 0.55 in 0.45 s, where it stays behind the fighter. It scales the model's **rig**, not the model, so home's entrance (which tweens the model's scale and position) and the knock-out keep their own transforms. The off-screen pictures (`pedestal = false`) build no halo and no sparks. Home's first entrance hides the reveal while the fighter drops (`hide_reveal()`) and plays it without the pop at the landing (`reveal(false)`, the drop is the pop); skipping ends it settled (`finish_reveal()`). The result screen's stage has a pedestal, so the fighter pops in there too (D23: every pedestal stage). Showing the same fighter and skin again does nothing — home refreshes on every progress change (a hack from another tab) and must not replay it.
**Idle** (C4, D23): for a picture fighter that is not running, `FighterModel.animate` sets the body's scale y `1 + 0.03·sin`, x `1 − 0.02·sin` (breathing, at the shapes' `BREATH_SPEED`), a bob of 0.04 m **upwards only** (so the feet never sink into the pedestal) at its own speed, and a sway of ±4° around the view axis through a new `tilt` uniform of `cutout.gdshader` (the quad turns to the camera in the shader, so a node rotation would not show), each wave at its own speed so the loop never looks mechanical. Fighters of shapes keep their idle.
**Tests** (D30): new `tests/test_fighter_reveal.gd` (8): the pop within 0.5 s with a 3–15 % overshoot; home reveals Flarekid, Echo and Rocko in gold, red and green (halo and sparks) and settles; the fighter screen on opening and on another skin; no reveal on the off-screen pictures; the entrance without a second pop, no halo or sparks while falling, settled after it; no replay for the same fighter, a replay for another; the picture fighters breathe (area kept), bob (never under 0), sway (±4°); shapes keep their idle. The existing home and fighter-screen tests pass unchanged.
**Screenshots** (D2; windowed runs at 1280×720 and 820×1180 — capped at 820×1175 —, a temporary `-s` script under `%TEMP%\hs09b\`, deleted; the PNGs stay in `%TEMP%\hs09b\s23\`, viewed as contact sheets): the reveal at 0, 0.15, 0.3 and 0.6 s on home and the fighter screen for Flarekid, Echo and Rocko (`home_<id>_<ms>_<size>.png`, `screen_…`), two idle frames 0.5 s apart of each new fighter (`idle_<id>_a|b_…`), and the first home's entrance with Echo at 0.5 s, 1.0 s and the end (`entrance_echo_…`). Seen: the fighter small with the halo flaring and sparks rising at 0 s, growing past its size at 0.3 s, standing with a soft halo of its rarity colour (gold, red, green) and the last sparks falling at 0.6 s; the idle frames differ by a small lean and lift. **Changed after looking:** (1) on the first frames of the fighter screen the pop was already over — the screen's first frame (the skin pictures and the shaders) takes long and a tween jumps over it — so the reveal runs on its own clock that moves at most 1/30 s per frame (`MAX_REVEAL_STEP`): a slow first frame slows the pop instead of skipping it; (2) the halo did not grow or shrink — a billboard material drops the node's scale — `billboard_keep_scale` on; (3) during the entrance the halo and the sparks of the first `show_fighter` showed around the falling fighter — `hide_reveal()` hides the sparks too (stopped particles keep their last frame) and the same fighter is not shown twice; (4) sparks 0.09 m instead of 0.07 m (hard to see at 820 px).
**Runner decision D31** (recorded here): the author's newer untracked files (`characters/magmax/`, `characters/echo_new/` with `gameplay/frames/`, `characters/echo_godot_gameplay.zip`) are not part of this reopening: not committed, modified or moved; `.gitignore` gets `/characters/*.zip`; `export_presets.cfg` `exclude_filter` gets `characters/magmax/*`, `characters/echo_new/*`, `characters/*.zip`; a Deferred Items row. `tools/export_web.ps1` exit 0 in the working tree with those files present: `build/web` **41,203,139 bytes** (≤ 45,361,090), `index.pck` **1,082,008 bytes** (+14,656 vs Step 21: this Step's code); the `.pck` holds no `magmax`, `echo_new`, `echo_down` or zip name (searched).
**Done (2026-11-22 · ~18 min · Claude Opus 5.5)** — every fighter on a pedestal (home, the fighter screen, the result) pops in with an overshoot, a burst of sparks and a halo in its rarity colour that settles behind it; home's entrance plays it at the landing; the picture fighters breathe, bob and sway; the author's newer files kept out of git and the export (D31). `tools/test.ps1` 486 tests passed, `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0 (41,203,139 bytes); suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 9.62 M tokens · CHF 3.14 (374 credits)

---

## Step 24 — Paper cut-out animation in play

### Goal
In Training and a match the cut-out fighters hop, lean, flip with the direction, recoil with a
muzzle flash, flash white when hit and fall flat at a knock-out; the missing art is written down
(C5, C8; D24, D29).

### Tasks
- [x] Record the start time in Notes below.
- [x] Run hop, squash and lean; `facing_left` from `Fighter` → shader `flip`; `muzzle_flash()` on a shot; `flash()` on a hit; the knock-out tip-and-fade for cut-out fighters (D24); shape fighters unchanged.
- [x] Tests in `tests/test_cutout_fighters.gd` for flip, flash and knock-out (D30).
- [x] `docs/drawing_to_fighter.md` section *Picture fighters (Flarekid, Echo)* (D29); README link.
- [x] Screenshots (D2) in a match at 1280×720: running left and right (flip), mid-hop, a shot (flash), a hit (white), the knock-out at 0.25 s; both fighters; viewed; Notes say what was changed after looking.
- [x] Check: `tools/test.ps1`, `tools/lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 17:59
**Motion** (C5, D24): a new `CutoutMotion` (`scenes/cutout/cutout_motion.gd`, static) holds the picture fighters' poses and effects — `FighterModel` would have passed gdlint's 1000-line limit, so Step 23's idle moved there too (`CutoutMotion.pose(time, running, facing_left)`: lift, scale, tilt). Running: a hop `|sin|·0.18 m` at the shapes' bounce speed, squashed to x 1.08, y 0.9 on landing (eased out within the first third of each hop) and a lean of 8° towards where the picture looks (the shader's `tilt`; a node rotation would not show on a camera-facing quad). **Facing:** `FighterModel.facing_left` (a setter that sets the shader's `flip`); `Fighter.face(direction)` sets it from the input's x when |x| ≥ 0.1, so going straight up or down keeps the last facing; each picture says which way it was drawn (`CutoutFighters` `faces_left`: Flarekid right, Echo left) and is mirrored only when looking the other way. **Differs from D24:** `Arena.fire_from` also turns the picture to the shot's side (`face(direction)`), as it already turns the fighter's yaw — a picture shooting behind its back looked wrong. **Shot:** the existing recoil plus `FighterModel.muzzle_flash()` — a yellow four-pointed star with a soft glow (a 64 px texture drawn once in code) for 0.08 s, placed every frame where the picture's muzzle shows on screen (`CutoutFighters` `muzzle`: Flarekid's fireball, Echo's blaster tip; mirrored with the picture, shrunk with its foreshortening). **Hit:** `Fighter.hit` calls `model.flash()` — the shader's `flash` at 1 for 0.12 s. **Knock-out:** `Fighter` asks `model.knock_out_pose(progress)`; a picture fighter tips over around its feet (the shader's new `tip`, to 80°) and fades (`fade` to 0) in `KNOCK_OUT_SECONDS`, no spin and no shrink, then is hidden as before. **Differs from D24:** it tips **towards** the camera around the screen's horizontal axis, not away from it — away, the top goes along the view into the floor and the floor cuts it; on screen both look the same (the picture folds down onto its feet). Fighters of shapes keep everything (`flash()` and `muzzle_flash()` do nothing for them; the arena's muzzle flash stays for all).
**Tests** (D30): `tests/test_cutout_fighters.gd` +5 (14): looks where it runs and keeps it going up or almost straight down, mirrored per drawn side, kept after a rebuild; running hops from 0 to 0.18 m, squashes on landing, stretches back in the air and leans to its side; a hit flashes white and back after 0.12 s (shapes unchanged); a shot shows the star on the right of the picture aiming right and on the left aiming left, gone after 0.08 s (shapes: none); a knock-out tips and fades halfway, no spin or shrink, flat, gone and hidden at the end. `test_fighter_reveal.gd` reads the idle numbers from `CutoutMotion`.
**Document** (C8, D29): `docs/drawing_to_fighter.md` § *Picture fighters (Flarekid, Echo)* — what the game does with one picture, what a single picture cannot do (no side or back view, no drawn run, shot or hit, one pose), what the author can make with the same tool (side and back views, a run cycle of 4–8 frames, a shot and a hit pose: same height and feet point, transparent PNG, `characters/<folder>/<name>_<pose>.png`) or a GLB through the B1 workflow, what the game then does, how to add and remove a picture fighter; it names the author's `characters/echo_new/gameplay/frames/` (D31) as such a set for a later spec. The README's *How to turn a drawing into a fighter* links the section.
**Screenshots** (D2; a windowed match at 1280×720 with a temporary `-s` script under `%TEMP%\hs09b\`, deleted; PNGs in `%TEMP%\hs09b\s24\`, viewed full and cropped): for Flarekid and for Echo as the player — running left, mid-hop, running right, running up after right, a shot right and left, a hit, the knock-out at 0.25 s and its end (`<id>_<moment>.png`). Seen: each picture mirrored to the side it runs or shoots, its feet staying in place, keeping its facing going up; the lean and the hop; the star at the fireball and at the blaster's tip; the whole picture white on the hit; at 0.25 s the picture folded halfway down and faded inside the arena's knock-out burst. **Changed after looking:** (1) Echo mirrored lost its blaster's tip — the shader mirrored the picture around its feet (Echo's feet are at 0.56, off the middle), so a strip went outside the quad: it now mirrors around the middle and moves the quad back under the feet (`width_m`); (2) the muzzle star did not show at all — the picture, transparent too, was drawn over it: the star is drawn after it (`render_priority` 1, no depth test) and alpha-blended instead of additive (white added to the light sand did not show); (3) the star larger (1.5 m) with thicker rays and a wider glow.
**Open (not in this Step):** two more untracked folders of the author appeared during this Step, `characters/blaze_new/` and `characters/magmax_new/` (32 PNGs, 10.6 MB); D31 does not name them: they are not committed or touched, but the web export would pack them (not measured here; Step 29's export) — for the runner to decide.
**Done (2026-11-22 · ~19 min · Claude Opus 5.5)** — in Training and a match Flarekid and Echo hop with a squash and a lean, look left or right with the movement and the shot (keeping it going up or down), show a muzzle star on a shot, flash white on a hit and tip over and fade at a knock-out; fighters of shapes unchanged; the picture fighters' limits and what to deliver are documented. `tools/test.ps1` 491 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 13.91 M tokens · CHF 3.63 (433 credits)

---

## Step 25 — Camera views

### Goal
Four camera views switch with `V` and `1`–`4` in Training and a match, the name shows briefly,
the controls and framing stay right, and the choice is kept while the game is open (V1–V7; D25).

### Tasks
- [x] Record the start time in Notes below.
- [x] Input actions `view_next`, `view_1`–`view_4`, `light_next`, `saturation_boost` in `project.godot` (D25; the last two used in Step 27); `CameraViews`; `Arena` places the camera per view with the blend; `GameState.camera_view`.
- [x] `HudToast` (D25) on switching; the start hint (`ControlsHelp.KEYBOARD_HINT`) and *How to play* name the view keys (V7).
- [x] `tests/test_camera_views.gd` (D30); `tests/test_arena_framing.gd` still green.
- [x] Screenshots (D2): each view in each world at 1280×720 and 820×1180 (16 PNGs) with the toast in one of them; viewed; Notes say what was changed after looking.
- [x] Check: `tools/test.ps1`, `tools/lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 18:19
**Views** (V1, V2, V4, V5, D25): `game/camera_views.gd` (`CameraViews`, static data) lists Classic, Close, Behind and Overview in `V`'s order with their numbers; `project.godot` gets `view_next` (V), `view_1`–`view_4` (keys 1–4 and the number pad's 1–4), `light_next` (L) and `saturation_boost` (K; Step 27) — no other action uses these keys (a test). `Arena._unhandled_input` switches (also during the countdown); `Arena.set_view` keeps the view in `GameState.camera_view` (memory only, Classic after `reset()`), names it in the toast and blends the camera to it in 0.3 s (the two transforms interpolated with a smoothstep); `Arena.view_pose(view)`: **Classic** unchanged (fitted distance, look-ahead, near-wall rule, G11); **Close** at 55°, 0.6 × Classic's fitted distance (at least 6 m); **Behind** low behind the fighter looking up the arena; **Overview** at 78°, its distance fitted (on every size change) so that the whole `ArenaLayout.bounds()` at the walls' height fits under the top margin of the Back button and the chips. The yaw never changes, so the keys move the fighter the same way on the screen in every view (V4) and the pictures still face the camera.
**Differs from D25:** (1) **Behind:** "6 m" is the camera's distance behind the fighter, at the height where its line to the look-ahead point (4 m north) is 28° down (5.3 m) — orbiting the look-ahead point at 6 m put the fighter's feet 37° under the view axis, outside the 25° half field of view; (2) **Close** keeps a near-wall limit of its own (the Classic rule for Close's distance): without it, at the south start in portrait the near wall and the ground behind it filled a third of the screen (seen on the first screenshots); (3) **the health bar over a picture fighter:** `CutoutFighters.top_height` now takes the camera's transform and the fighter's feet and solves the perspective (a point straight up also comes nearer to a camera that looks down): Step 22's approximation from the camera's up vector only was right at Classic's distance but put Flarekid's bar far over his head in Close (behind the timer chip) and Behind (seen on the screenshots).
**Toast** (V3, D25): `HudToast` (`scenes/ui/hud_toast.gd`, a `ChipPanel` with a `HudLabel`, top centre 84 px down — under the match's timer chip —, shown 1.5 s, then faded in 0.3 s, ignores the mouse); the arena builds one and `Arena.toast()` hands it to Step 27.
**Texts** (V7): the start hint gets "View: V or 1-4"; *How to play*'s Controls: "V switches the camera view, 1 to 4 choose one (Classic, Close, Behind, Overview)" (the names from `CameraViews`). The README's controls follow in Step 29 (its task).
**Tests** (D30): new `tests/test_camera_views.gd` (11): `V`'s order; keys 1–4 and the number pad, during the countdown; the view keys bound to no other action; the toast (name, backing, top centre, gone after ~1.5 s); Flarekid's feet and bar on the screen in every view, in both worlds, at the five sizes; Overview sees both corners of every border wall at the five sizes; the camera always looks north and down; Close nearer, Behind lower, Overview higher than Classic; Classic back where it was after a round of views (G11); the blend half-way at 0.15 s and arrived after 0.3 s; the view kept for the next match, Classic after a fresh start. `test_controls_help.gd` checks the view keys in both texts; `test_cutout_fighters.gd` uses the camera's transform; `test_arena_framing.gd` green unchanged.
**Screenshots** (D2; windowed runs at 1280×720 and 820×1180 — capped at 820×1175 —, a 4-fighter match with Flarekid as the player, each view 2 s after its switch, in both worlds, a temporary `-s` script under `%TEMP%\hs09b\s25\`, deleted; PNGs there, all viewed): `<view>_<world>_<size>.png` (16) and `toast_close_<world>_<size>.png` (4, 0.5 s after the switch). Seen: Classic as before; Close nearer with the fighter below the middle; Behind low behind the fighter, the arena and the bots ahead up to the far wall; Overview the whole arena with its four walls inside the screen under the chips; the toast "Close" under the timer chip. **Changed after looking:** the bar's height (3) and Close's near-wall limit (2).
**Runner decision (D31 extended):** the export's `exclude_filter` replaces `characters/magmax/*` and `characters/echo_new/*` by `characters/*_new/*` and `characters/magmax*/*` (`characters/*.zip` and the D22 entries kept). `tools/export_web.ps1` exit 0 in the working tree with the author's four untracked folders present (`blaze_new`, `echo_new`, `magmax`, `magmax_new`, 20.0 MB): `build/web` **41,222,079 bytes** (≤ 45,361,090; +18,940 vs Step 23: this Step's code), `index.pck` **1,100,948 bytes**; the `.pck` holds no `magmax`, `_new` or `.zip` name, only paths of `characters/blaze2/` and `characters/echo/` (searched). The author's folders are not committed, modified or moved.
**Done (2026-11-22 · ~20 min · Claude Opus 5.5)** — `V` and `1`–`4` switch Training and a match between Classic, Close, Behind and Overview with a 0.3 s blend and the view's name in a toast; the camera never turns, so the controls stay the same; the fighter and its bar stay on the screen in every view at the five sizes, Overview shows the four walls, Classic keeps G11; the view is kept while the game is open; the hint and *How to play* name the keys; the export filter keeps all of the author's newer folders out (D31). `tools/test.ps1` 502 tests passed, `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0 (41,222,079 bytes); suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 7.87 M tokens · CHF 2.89 (345 credits)

---

## Step 26 — Brighter worlds and more detail

### Goal
The canyon and Glimmer Isles are brighter and more saturated, with at least three new kinds of
decoration each, some moving, and the same rules (L1, L2, L7; D26).

### Tasks
- [x] Record the start time in Notes below.
- [x] Palettes of `Canyon`, `GlimmerIsles` and their props (D26); the floor stays the least saturated surface.
- [x] New decoration per world (D26), no colliders, instanced where static; re-bake Glimmer Isles only if its scatter source changed (`tools/bake_world.ps1`, D12).
- [x] `tests/test_world_decor.gd` (D30); `tests/test_world_layouts.gd`, `test_glimmer_isles.gd`, `test_canyon_look.gd` still green (tests changed only where colours are checked).
- [x] Screenshots (D2): both worlds in a match at 1280×720 and 820×1180 next to Step 21's before set; viewed; Notes say what is brighter, what was added and what was changed after looking.
- [x] Check: `tools/test.ps1`, `tools/lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 18:39
**Palettes** (L1, D26): `Canyon` — warmer orange-red rock (`ROCK` c95a33 → e65a2a, band, top and boulders likewise), apricot sand (`SAND` b89c74 → d6ad7e, `SAND_DARK` cb9f6e), a warmer outside, greener cacti (3fd35c / 1fa848) on a fresher patch ground, brighter crates, bones and pebbles; `GlimmerIsles` — teal and violet ground tiles (`GROUND` 86a3b4 → 74bccb, `GROUND_LAVENDER` 9a95c4 → a294dc), a greener rim, a violet border, plinths and underside; `GlimmerProp` — cyan and magenta crystals (4feaff, ff5cd6) with stronger glow colours, greener ferns, brighter mushroom caps, island grass and rock. The ground stays the least saturated surface of each world (G10: sand about 40 %, the teal tiles about 43 %; rocks, cacti, crystals and caps 60–90 %). **Re-bake:** the scatter source did not change, but the bake stores each part's colours in `baked.tscn` (`tools/bake_world.ps1` says to re-bake after changing the props), so Glimmer Isles was re-baked: only the colours and the node ids changed, every transform is the same (diff checked).
**New decoration** (L2, D26; no collider, nothing in the playing area): **canyon** — (1) **blossoms** on the cactus tops without a flower (a five-petal disc in yellow, orange or pink; one MultiMesh `CactusBlossoms`, from a second seed so every older piece keeps its place), (2) **flags** that wave on the three high border walls (9; a pole and a cloth with the new `scenes/toon/flag.gdshader`, out of step by their place), (3) **birds** circling high over the canyon (5, flapping; `CanyonDecor._process`), (4) a **turquoise stream** outside the east wall among the outside boulders, its light bands flowing (`scenes/toon/flowing_water.gdshader`); all in `scenes/canyon_decor.gd` (`CanyonDecor`, the canyon's child `Decor`) but the blossoms. **Glimmer Isles** — (1) **fireflies** (`CPUParticles3D`, 48, fading in and out over the island), (2) the **crystals' glow pulses** (the baked crystal parts' shared materials, ±60 % of their baked strength), (3) **waterfalls** pouring from every second floating island (8; the flowing-water shader downwards, fading at the foot), (4) the **islands turn** slowly around their own axes and bob (their baked MultiMesh transforms moved each frame; the waterfalls bob with them); all in `scenes/worlds/glimmer_isles/glimmer_decor.gd` (`GlimmerDecor`, the world's child `Decor`). Static props are instanced (the blossoms), the moving ones are shaders (flags, water) or code (birds, islands, pulse). **Differs from D26:** the stream runs outside the **east** wall, not beyond the far one — there it showed only in the Behind view (seen on the first screenshots); beside the east wall it shows in Classic at the right edge and in Overview.
**Tests** (D30): new `tests/test_world_decor.gd` (5): the canyon's four new kinds are there and the world has no collider of its own (only the floor and one body per layout wall, at the layout's places); flags on the high border walls, the stream outside, the birds high; the birds fly on and flap, the flags and the stream use their shaders; Glimmer Isles' four kinds (at most 64 fireflies, D26) and no collider; the waterfalls outside, the crystals pulse, the islands turn and bob around their own axes. `test_world_layouts.gd`, `test_glimmer_isles.gd`, `test_canyon_look.gd` green unchanged (no test checks a colour value).
**Screenshots** (D2; windowed runs at 1280×720 and 820×1180 — capped at 820×1175 —, a 4-fighter match 4 s in with the game's own save (Blaze), as Step 21's before set, plus Behind and Overview at 1280×720 to see the decoration around the arena; a temporary `-s` script under `%TEMP%\hs09b\s26\`, deleted; PNGs there: `godot_match_<world>_<size>.png`, `behind_<world>_1280x720.png`, `overview_<world>_1280x720.png`, viewed next to `%LOCALAPPDATA%\hack_star\screens\09b\before\`). Seen: the canyon clearly warmer and brighter — orange-red rock, light apricot sand, vivid green cacti with yellow, orange and pink blossoms; flags on the walls, birds over the outside, the stream with its light bands beside the east wall; Glimmer Isles clearly more vivid — cyan and lilac tiles instead of grey-blue and lavender, deeper violet walls, brighter crystals and ferns, fireflies over the island, waterfalls under the islands; the fighters stand out on both floors. **Changed after looking:** the stream moved to the east wall (above); the Glimmer rim toned down (3fbf98 → 4aa892: from Overview, a large loud green slab around the arena).
**Done (2026-11-22 · ~13 min · Claude Opus 5.5)** — both worlds brighter and more saturated (the floors still the least saturated surfaces), four new kinds of decoration each — the canyon's blossoms, waving flags, circling birds and a flowing stream; Glimmer Isles' fireflies, pulsing crystals, waterfalls and turning islands —, no collider and the layouts unchanged; Glimmer Isles re-baked for the props' colours only. `tools/test.ps1` 507 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 8.86 M tokens · CHF 2.67 (318 credits)

---

## Step 27 — Lighting presets and saturation boost

### Goal
`L` cycles the lighting presets and `K` the saturation boost in both worlds, the name shows
briefly, and the default is the best-looking preset chosen from screenshots (L3–L7; D27).

### Tasks
- [x] Record the start time in Notes below.
- [x] `LightPresets` and `WorldLighting` (D27); `Arena` applies `GameState.light_preset` and `saturation_boost` at start and on `L` / `K`; `HudToast` shows the name.
- [x] Glow: try it in a windowed Compatibility run and in the web export (`tools/export_web.ps1`, `tools/serve_web.ps1`, a desktop browser); keep it only where both show it (D27), Notes say the result.
- [x] `tests/test_light_presets.gd` (D30); *How to play*, the start hint and the README controls name `L` and `K`.
- [x] Screenshots (D2): every preset × both worlds × 1280×720 and 820×1180, and the boost on for two of them; viewed; the default chosen and its reason written into D27 and the Notes; L7 checked on them (fighters, shots, health bars, cover, HUD).
- [x] Check: `tools/test.ps1`, `tools/lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 18:53
**Presets** (L3, L4, D27): `game/light_presets.gd` (`LightPresets`, static data) — in `L`'s order **Bright day**, **Golden sunset**, **Neon night**, **Candy pop** and **Classic** (the world's own light from before, to compare); per preset the sun's colour, energy and height, the ambient colour and energy, the sky's top, horizon and ground colours, the colour balance (brightness, contrast, saturation) and `glow`; `K` multiplies the saturation by 1.3 (`BOOST_SATURATION`) on top of any preset, Classic included. **Fog** (optional in D27) is not used: no preset needed it. `scenes/world_lighting.gd` (`WorldLighting`, the arena's child `Lighting`) remembers the world's own light after the world is built (the canyon's flat background, Glimmer Isles' violet sky, each world's sun and ambient), and applies a preset to a fresh copy of that environment (the scene's shared `Environment` is never changed — a test), the sun and a new sky gradient; each world keeps 30 % of its own sun, ambient and sky colours (`WORLD_SHARE`), so the canyon stays warm and Glimmer Isles violet. `Arena` applies `GameState.light_preset` and `GameState.saturation_boost` (memory only, reset to the default by `GameState.reset()`) in `_ready`, switches on `L` (`light_next`) and `K` (`saturation_boost`), also during the countdown, and names the preset or "Saturation boost on/off" in the `HudToast` (L5). The colour balance pass (`adjustment_enabled`) is off when it would change nothing (Classic without the boost).
**Glow** (D27): tried in Neon night — in a windowed Compatibility run (glow on and off compared on the same frame: at the first settings, threshold 0.75 and intensity 0.8, it was hardly visible; now `glow_hdr_threshold` 0.5, intensity 1.2, no bloom: a soft halo on Glimmer Isles' path stones, the crystal tips and the fireflies, the shots and the muzzle flashes) and in the **web export** (`tools/export_web.ps1` exit 0, `tools/serve_web.ps1 -Port 8061`, Microsoft Edge through Playwright with a window: Glimmer Isles' Training, `L` twice to Neon night, then `K`): the same halos, and `L`, `K` and the toast work in the browser. **Kept in Neon night only**; the other presets use emission and the colour balance. Step 28 measures it (L8).
**Texts** (L3, L4): the start hint's last line "View: V or 1-4, light: L and K" (still clear of the other controls at every size — `test_controls_hint.gd` green); *How to play*: "L switches the lighting (Bright day, Golden sunset, Neon night, Candy pop, Classic), K a saturation boost." (the names from `LightPresets`); the README's *Controls* gets a **Lighting** item.
**Tests** (D30): new `tests/test_light_presets.gd` (9): `L`'s order with the toast's names and back to the first; `K` on and off for every preset (saturation × 1.3 and back, the toast); the boost kept across `L`; every preset other than Classic changes the sun, the ambient light, the sky and the colour balance in both worlds; Classic brings back the world's own light exactly (and no colour balance pass); glow only in Neon night; `L` and `K` bound to no other action; preset and boost kept for the next match and Training, the default after `GameState.reset()`; the scene's shared environment unchanged. `test_controls_help.gd` checks the light keys and the preset names in both texts.
**Screenshots** (D2, L6, L7; windowed runs at 1280×720 and 820×1180 — capped at 820×1175 —, a 4-fighter match 4 s in with the game's own save (Blaze) moved into the nearest cover patch and shooting, every preset in each world, the boost on for Bright day, Candy pop, Golden sunset and Neon night, and the Behind view per preset for the sky; a temporary `-s` script under `%TEMP%\hs09b\s27\`, deleted; PNGs there, viewed as contact sheets and full size, plus `web_*.png` of the web check). Seen: Bright day a clear, warm-white light with the floor lighter and the rocks, cacti, crystals and fighters more vivid than Classic; Golden sunset orange light from low with long shadows of the walls and crystals over the floor; Neon night violet-blue with glowing path stones and crystals; Candy pop pink-and-cyan pastels; Classic as before. In every preset, with and without the boost (L7): the fighters (Blaze, Echo, Flarekid and the shape fighters) stand out with their outlines, the shots and muzzle stars show, the health bars and damage numbers are readable, the player in cover is see-through over the plants, and the HUD (on its own canvas, not affected by the light) is unchanged. **Changed after looking:** (1) Bright day and Candy pop at first washed the floors almost white (brightness 1.05/1.08, sun 1.0): brightness 1.0, sun 0.85; (2) Neon night turned Glimmer Isles' floor into a loud pure blue and the canyon pink: a softer violet ambient, saturation 1.4 → 1.2, darker sun; (3) Bright day's sky below the horizon (the void under Glimmer Isles' island in the Behind view) was tan: light blue; (4) Golden sunset's sun 24° → 30° (the shadows covered too much of the floor); (5) the stronger glow above.
**Default** (L6): **Bright day** — chosen from these screenshots; the reason is in D27 (brighter and more saturated than Classic in both worlds with the calmest floor and short shadows, so the fighters stand out most; Golden sunset's shadows cover the floor, Neon night darkens the fighters, Candy pop washes the floors pastel). `LightPresets.DEFAULT`; `GameState` starts with it and keeps the choice while the game is open.
**Done (2026-11-22 · ~17 min · Claude Opus 5.5)** — `L` switches Training and a match between Bright day (the default), Golden sunset, Neon night, Candy pop and Classic, `K` a saturation boost on top, each named in the toast and kept while the game is open; every preset changes the sun, the sky, the ambient light and the colour balance in both worlds, keeping a share of each world's own colours; glow only in Neon night, seen on the desktop and in the web export; the hint, *How to play* and the README name the keys. `tools/test.ps1` 516 tests passed, `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 11.93 M tokens · CHF 3.47 (414 credits)
---

## Step 28 — Performance comparison

### Goal
The new looks are measured against Step 21's baseline and stay within L8 (L8, C11; D28).

### Tasks
- [x] Record the start time in Notes below.
- [x] The D28 performance run for every preset × world, with and without the boost, in Classic and Overview, with Flarekid and Echo among the 4 fighters; a table in Notes (frame time average and worst, draw calls, primitives) next to the baseline.
- [x] Anything over L8 trimmed (particle counts, glow, decoration counts) and measured again; temporary scripts deleted.
- [x] Check: every row within L8 in Notes; `tools/test.ps1`, `tools/lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 19:11
**Method** (D28, as Step 21's baseline): a windowed Compatibility run at 1280×720, vsync off, `Engine.max_fps` 0, a 4-fighter match loaded fresh for every row, sampled for 10 s from 1 s after the scene loads (frame time from the frame-to-frame clock; `Performance` `RENDER_TOTAL_DRAW_CALLS_IN_FRAME` and `RENDER_TOTAL_PRIMITIVES_IN_FRAME` every frame), by a temporary `-s` script under `%TEMP%\hs09b\s28\` (deleted; the CSVs `perf_full.csv` and `perf_shapes.csv` stay there). **Fighters:** the player is **Flarekid**, the bots **Echo**, Luna and Turbo (the match's bot shuffle seeded with 5, the same fighters in every row). Every preset × both worlds × boost off and on × Classic and Overview = 40 rows, each run **twice** (two passes over all 40).
**Limits** (L8, against the higher of Step 21's two runs per world and number): **canyon** frame time ≤ 1.3 × 13.09 = **17.02 ms**, draw calls ≤ 1.3 × 1042 = **1355**; **Glimmer Isles** frame time ≤ 1.3 × 9.89 = **12.86 ms**, draw calls ≤ 1.3 × 570 = **741**; every frame time also under 33 ms.

| World | View | Preset | Boost | Avg frame ms (run 1 / run 2) | Worst ms | Draw calls avg (max) | Primitives avg |
|-------|------|--------|-------|------------------------------|----------|----------------------|----------------|
| Canyon | Classic | Bright day | off | 17.62 / 6.04 | 129.45 | 642 (699) | 838 k |
| Canyon | Classic | Bright day | on | 15.51 / 5.95 | 140.28 | 636 (698) | 834 k |
| Canyon | Classic | Golden sunset | off | 12.95 / 5.66 | 177.21 | 622 (663) | 830 k |
| Canyon | Classic | Golden sunset | on | 8.41 / 5.77 | 42.42 | 598 (662) | 807 k |
| Canyon | Classic | Neon night | off | 8.94 / 6.46 | 45.21 | 639 (699) | 834 k |
| Canyon | Classic | Neon night | on | 11.24 / 6.50 | 85.90 | 639 (699) | 835 k |
| Canyon | Classic | Candy pop | off | 7.86 / 6.07 | 30.79 | 639 (699) | 834 k |
| Canyon | Classic | Candy pop | on | 8.02 / 5.97 | 38.94 | 639 (699) | 835 k |
| Canyon | Classic | Classic | off | 7.09 / 5.26 | 49.67 | 641 (699) | 837 k |
| Canyon | Classic | Classic | on | 10.99 / 6.76 | 119.04 | 635 (702) | 834 k |
| Canyon | Overview | Bright day | off | 8.37 / 5.51 | 37.70 | 564 (586) | 609 k |
| Canyon | Overview | Bright day | on | 8.19 / 5.40 | 38.20 | 566 (585) | 609 k |
| Canyon | Overview | Golden sunset | off | 7.14 / 5.11 | 51.39 | 566 (586) | 609 k |
| Canyon | Overview | Golden sunset | on | 5.17 / 5.03 | 21.71 | 566 (586) | 609 k |
| Canyon | Overview | Neon night | off | 8.62 / 5.64 | 119.23 | 564 (586) | 609 k |
| Canyon | Overview | Neon night | on | 10.29 / 5.85 | 79.24 | 564 (586) | 609 k |
| Canyon | Overview | Candy pop | off | 9.13 / 5.51 | 51.28 | 566 (585) | 609 k |
| Canyon | Overview | Candy pop | on | 8.58 / 6.46 | 50.72 | 565 (585) | 609 k |
| Canyon | Overview | Classic | off | 8.64 / 4.74 | 38.46 | 566 (587) | 609 k |
| Canyon | Overview | Classic | on | 8.64 / 5.21 | 488.71 | 566 (586) | 609 k |
| Glimmer Isles | Classic | Bright day | off | 9.50 / 5.72 | 56.38 | 426 (506) | 716 k |
| Glimmer Isles | Classic | Bright day | on | 8.40 / 6.51 | 50.85 | 428 (504) | 718 k |
| Glimmer Isles | Classic | Golden sunset | off | 5.43 / 5.20 | 35.41 | 397 (469) | 697 k |
| Glimmer Isles | Classic | Golden sunset | on | 6.07 / 5.29 | 44.90 | 392 (469) | 688 k |
| Glimmer Isles | Classic | Neon night | off | 6.20 / 5.67 | 30.90 | 437 (495) | 741 k |
| Glimmer Isles | Classic | Neon night | on | 5.74 / 5.74 | 24.14 | 423 (495) | 717 k |
| Glimmer Isles | Classic | Candy pop | off | 5.27 / 5.27 | 24.18 | 422 (501) | 713 k |
| Glimmer Isles | Classic | Candy pop | on | 5.10 / 5.50 | 24.08 | 463 (549) | 766 k |
| Glimmer Isles | Classic | Classic | off | 4.78 / 4.56 | 22.54 | 420 (497) | 712 k |
| Glimmer Isles | Classic | Classic | on | 5.28 / 5.07 | 21.73 | 425 (497) | 718 k |
| Glimmer Isles | Overview | Bright day | off | 4.68 / 4.54 | 20.14 | 393 (408) | 546 k |
| Glimmer Isles | Overview | Bright day | on | 4.50 / 4.55 | 17.69 | 393 (408) | 546 k |
| Glimmer Isles | Overview | Golden sunset | off | 4.73 / 4.43 | 21.39 | 392 (408) | 546 k |
| Glimmer Isles | Overview | Golden sunset | on | 5.39 / 4.54 | 40.14 | 392 (408) | 546 k |
| Glimmer Isles | Overview | Neon night | off | 5.02 / 4.77 | 21.65 | 393 (408) | 546 k |
| Glimmer Isles | Overview | Neon night | on | 5.06 / 4.75 | 21.25 | 393 (408) | 546 k |
| Glimmer Isles | Overview | Candy pop | off | 4.50 / 4.39 | 16.92 | 393 (408) | 546 k |
| Glimmer Isles | Overview | Candy pop | on | 4.45 / 4.50 | 18.25 | 393 (408) | 546 k |
| Glimmer Isles | Overview | Classic | off | 3.77 / 3.86 | 17.79 | 393 (408) | 546 k |
| Glimmer Isles | Overview | Classic | on | 4.51 / 4.46 | 19.56 | 393 (408) | 546 k |
| *Baseline (Step 21, runs 1 / 2)* | *Classic* | *before* | — | *canyon 13.09 / 12.84; Glimmer Isles 9.89 / 7.16* | *131.43 / 65.86* | *canyon 792 / 1042; Glimmer Isles 570 / 533* | *canyon 926 k / 1.40 M; Glimmer Isles 810 k / 752 k* |

**Result — every row within L8, nothing trimmed:** draw calls at most 642 on average in the canyon (−38 % vs 1042; max 702) and 463 in Glimmer Isles (−19 % vs 570; max 549); frame time in the second run 3.9–6.8 ms everywhere (canyon ≤ 6.76 ms, Glimmer Isles ≤ 6.51 ms, at most 52 % of the baseline). The first run's first rows (canyon, Classic, Bright day: 17.62 and 15.51 ms, worst frames 129 and 140 ms) are the process's first matches — the shaders of every material are compiled while they play, as the baseline's worst frame was —; on average over the two runs that row is 11.83 ms (−10 %), within the 17.02 ms limit, and no row's average of the two runs is above 70 % of its world's limit. The worst single frames (one hitch of 489 ms in a Canyon Overview row of run 1, the rest ≤ 177 ms) are load and shader-compile frames at a row's start, as in the baseline; L8's numbers are the averages. **Glow** (Neon night) and the **boost** cost nothing measurable (they are one post-process pass in the Compatibility renderer). **Overview** draws less than Classic in both worlds.
**Judged per D32** (runner decision after the code review of the reopening, finding 4): L8 is judged on the second (warm) run of each pair; the first run's averages (up to 17.62 ms) and worst frames (up to 488.71 ms) include the one-time shader compilation and are reported here but not counted; shader pre-warm is in Deferred Items.
**Fair check with fighters of shapes** (a picture fighter is one quad, so Flarekid and Echo draw less than the fighters of the baseline's random matches): the same method with **Blaze** as the player and Turbo, Frosty and Rocko as the bots (seed 3), Bright day, Classic view, boost off and on, twice: canyon **797–810** draw calls (max 861), 7.21–10.69 ms; Glimmer Isles **543–566** (max 597), 7.29–8.56 ms — within the baseline's own range (canyon 792–1042, Glimmer Isles 533–570), so the brighter worlds' new decoration (Step 26) and the lighting add no measurable draw calls or frame time. The iPad check (≥ 30 fps, G14) stays with the author (Deferred Items).
**Done (2026-11-22 · ~22 min · Claude Opus 5.5)** — every preset in both worlds, with and without the boost, in Classic and Overview, measured twice with Flarekid and Echo among the four fighters (and once more with four fighters of shapes): every row within L8 — draw calls below the baseline, frame time on average under the baseline and far under 33 ms —, so nothing was trimmed. `tools/test.ps1` 516 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 3.17 M tokens · CHF 1.76 (210 credits)

---

## Step 29 — Final check of the reopening, README and architecture

### Goal
Everything that worked before still works, the size budget is met and reported, the after set is
recorded, and the documents describe the new fighters, views and lighting (C1–C11, V1–V7,
L1–L8, S2–S6).

### Tasks
- [x] Record the start time in Notes below.
- [x] Run `tools/check_tools.ps1`, `tools/test.ps1`, `tools/lint.ps1`, `tools/export_web.ps1` (all exit 0); every `.ps1` changed parses with `[System.Management.Automation.Language.Parser]::ParseFile`; nothing outside `hack_star_godot/` changed (S5); `git status` shows no zip and no `scenes/blaze_godot`.
- [x] Web export size report in Notes: total and `.pck` vs Step 1, Step 20 and Step 21; the two characters' share (C11 ≤ 1.0 MB); total ≤ 45,361,090 bytes (G15).
- [x] After set (D2) into `%LOCALAPPDATA%\hack_star\screens\09b\after\` with Step 21's file names; viewed next to the before set; Notes say what changed (L1).
- [x] `README.md`: the two new fighters, the reveal, the controls (`V`, `1`–`4`, `L`, `K`), the presets and the default, the link to *Picture fighters*; `docs/architecture.md`: `CutoutFighters` and the cut-out shader (*3D models*), the reveal (*UI foundation*), `CameraViews`, `HudToast`, `LightPresets`, `WorldLighting`, the new tests; `LICENSES.md` complete (S4).
- [x] Check: every statement C1–C11, V1–V7, L1–L8 has a Step that is ✅ Done (the iPad check of L8 in Deferred Items).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 19:34
**Checks** (S3): `tools/check_tools.ps1` exit 0 (all pinned tools OK), `tools/test.ps1` 516 tests passed, `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0. No `.ps1` changed in the reopening (`git diff --name-only bccd2ed..HEAD -- '*.ps1'` is empty); all seven `tools/*.ps1` parse with `Parser::ParseFile` with 0 errors anyway. **S5:** `git diff --name-only bccd2ed..HEAD` lists nothing outside `hack_star_godot/`. `git status --short` shows only ` M .spec-nx` (the submodule, not ours) and the author's untracked `characters/blaze_new/`, `echo_new/`, `magmax/`, `magmax_new/` (D31: not committed, modified or moved); no zip and no `scenes/blaze_godot` (`scenes/blaze_godot.zip` shows as ignored `!!` with `--ignored`; the folder `scenes/blaze_godot/` is no longer in the working tree).
**Web size** (G15, C11, D28; `tools/export_web.ps1` in the working tree with the author's four untracked folders present): `build/web` **41,244,423 bytes**, `index.pck` **1,123,292 bytes**. Against Step 1 (40,361,090 / 239,960): **+883,333 bytes (+0.88 MB)** total, +883,332 `.pck`; against Step 20 (clean copy 40,520,478 / 399,348): +723,945 total, +723,944 `.pck` (Step 20's working-tree export was 45,232,931 / 5,111,800, because it packed the author's untracked files; now the export filter keeps them out); against Step 21 (41,188,483 / 1,067,352): +55,940 total and `.pck` (Steps 22–28: the code, shaders and tests' scenes of the reopening). **The two characters' share:** their four imported pictures, 670,348 bytes (Flarekid's hero 210,596 and card 91,500, Echo's hero 258,378 and card 109,874; unchanged since Step 21) — **C11 ≤ 1.0 MB met**; the reopening as a whole +723,945 bytes vs Step 20 (≤ 1.5 MB, D28). **Total ≤ 45,361,090 met** with 4,116,667 bytes to spare (G15).
**After set** (D2, L1), `%LOCALAPPDATA%\hack_star\screens\09b\after\` (8 PNGs, Step 21's names: `godot_home_<size>.png`, `godot_fighter_<size>.png`, `godot_match_canyon_<size>.png`, `godot_match_glimmer_<size>.png` at `1280x720` and `820x1180` — capped at 820×1175 —; not committed): the same method as the before set (a windowed run, a temporary `-s` script under `%TEMP%\hs09b\s29\`, deleted; the game's own save with Blaze, the entrance skipped, the matches 4 s in), viewed side by side with `…\09b\before\` on contact sheets. **What changed:** home and the fighter screen — Blaze stands in front of a soft halo in his rarity colour (the reveal settled; it popped in with sparks); the canyon is clearly brighter and more saturated — orange-red rock and walls instead of brown-orange, vivid green cacti with yellow, orange and pink blossoms, flags on the walls, a light warm floor (still the calmest surface) — under the default Bright day; Glimmer Isles is clearly more vivid — cyan and pink tiles instead of pale blue and lavender, deeper violet walls and plinths, brighter crystals, fireflies over the island; the start hint names the view and light keys; in the match the bots now include the picture fighters (random as in every match). L1 met.
**Documents** (S4): `README.md` — the intro (nine fighters: Beatbolt from a drawing, Flarekid and Echo from the author's pictures), *Run in the editor* (nine fighters), *The look* (a new list for the reopening: the two picture fighters and how they move, with the link to [Picture fighters](../../../docs/drawing_to_fighter.md#picture-fighters-flarekid-echo) and the author's newer art; the reveal; the four views; the brighter worlds and their new decoration; the five presets, Bright day the default and why, glow only in Neon night, the boost), *Controls* (the start hint's new line, a **Camera views** item for `V` and `1`–`4`; the **Lighting** item for `L` and `K` came with Step 27). `docs/architecture.md` — *Layout* (`characters/`, the `scenes/` subfolders), *Screens* (the arena's views and light, `WorldLighting`, `CanyonDecor`, `GlimmerDecor`), *Input* (the view and light keys), *Game rules* (`CameraViews`, `LightPresets`, `Fighters` with the picture fighters), *UI foundation* (the reveal of `FighterStage`, the card picture of a picture fighter, `HudToast`), *3D models* (the pictures in `characters/`, a *Picture fighters* paragraph — `CutoutFighters`, `cutout.gdshader` and its uniforms, `CutoutMotion`, the bar over the picture — and a *Brighter worlds* paragraph), *Art and licences* (the pictures), *Tests and checks* (`test_cutout_fighters.gd`, `test_fighter_reveal.gd`, `test_camera_views.gd`, `test_light_presets.gd`, `test_world_decor.gd`). `LICENSES.md` — complete: the four pictures had their rows since Step 21; the own-work rows now name the cut-out, flag and flowing-water shaders and the reopening's decoration and effects built in code. **Missing art** (C8): `docs/drawing_to_fighter.md` § *Picture fighters* already said what one picture cannot do and what to deliver (Step 24); it gets a new part *Art the author has already dropped (for a follow-up)*: `characters/echo_new/` (new pictures and the directional `gameplay/frames/` — idle, two walk frames and a shoot pose looking down, to the side and up — a projectile and a preview), `characters/blaze_new/` (the same set for Flarekid), `characters/magmax/` and `characters/magmax_new/` (a new character, Magmax, with the same frame set), what a follow-up can do with each, and what such a spec must do (import within the web budget — the 36 frame PNGs are about 8.2 MB —, one texture per pose and direction in `CutoutFighters`/`CutoutMotion`, the preview files kept out of the export, credits in `LICENSES.md`); linked from the README's *The look* and *How to turn a drawing into a fighter*.
**Coverage of the statements** (the check task): C1 Step 22 · C2 21, 22 · C3 23 · C4 23 · C5 24 · C6 22 · C7 22 · C8 24, 29 · C9 21 · C10 21, 23, 25 (D31) · C11 21, 29 · V1–V6 25 · V7 25, 27, 29 · L1 26, 29 · L2 26 · L3–L7 27 · L8 28 — all ✅ Done. **With the author** (Deferred Items, unchanged): the iPad check of the reopened parts (L8, G14), the image tool for `LICENSES.md` (C9), more pictures or a 3D model for Flarekid and Echo (C8), a touch button for views and lighting (V6), and the newer art for a follow-up (D31).
**Done (2026-11-22 · ~8 min · Claude Opus 5.5)** — the reopening checked end to end: all Godot checks green, web export 41,244,423 bytes (+0.88 MB vs Step 1, the two characters 0.67 MB, 4.1 MB under the budget), the after set captured and compared (both worlds clearly brighter, the halo on the pedestal), README and `docs/architecture.md` describing the picture fighters, the reveal, the views, the brighter worlds and the lighting, `LICENSES.md` complete, the missing-art section naming the author's newer art; every statement C1–C11, V1–V7, L1–L8 covered. `tools/check_tools.ps1` exit 0, `tools/test.ps1` 516 tests passed, `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 6.04 M tokens · CHF 1.46 (174 credits)

---

## Step 30 — Delivery into the final folders, imports and export filter

### Goal
The before set exists, the author's three deliveries are moved into `characters/echo/`,
`characters/blaze2/` and `characters/magmax2/` with every path fixed, imported web-safe within
the size budget, credited, committed, and everything the game does not use is out of the export;
`characters/magmax/` and the zips are untouched (M2, M12, M13, M14; D35, D42, D43).

### Tasks
- [x] Record the start time in Notes below.
- [x] Before set (D42, D2) into `%LOCALAPPDATA%\hack_star\screens\09c\before\` **before moving anything**: home, the fighter list at the picture fighters, the fighter screen with Echo and with Flarekid, a 4-fighter match 4 s in with Echo as the player (canyon); 1280×720 and 820×1180; viewed; the capture script outside the repository, deleted. The SHA-256 list of `characters/magmax/` written in Notes.
- [x] Move (D35): `echo_new` → `echo/`, `flarekid_new` → `blaze2/`, `magmax_new` → `magmax2/` (`Move-Item`; the `_new` folders gone); paths `res://characters/blaze/` → `blaze2/`, `res://characters/magmax/` → `magmax2/` in every moved `.tscn`, `.tres`, `.gd` and README; the delivered `.import` files of moved pictures replaced by Godot's (the committed hero and card `.import` kept); `git grep` and a search of `characters/` find no `characters/blaze/`, `characters/magmax/` (other than the folder's own files) or `_new` path.
- [x] Imports (D35): frames lossy WebP 0.85, `size_limit` 512, mipmaps, not VRAM (also `detect_3d/compress_to` off); MagMax hero and card as D22; projectiles lossless; one frame of each fighter checked on a pedestal screenshot at 820×1180 for sharpness (the limit changed only if it is blurred or the size is over budget; the choice in Notes).
- [x] `.gitignore`: `/characters/magmax/`; `export_presets.cfg` `exclude_filter`: `characters/magmax*/*` → `characters/magmax/*`, plus the `characters/*/gameplay/` entries of D35; `LICENSES.md`: the rows of M13 (hero, card, frames, projectile of each of the three; the existing Echo and Flarekid rows updated).
- [x] `tools/export_web.ps1` in the working tree: total and `.pck` size, the three fighters' imported files (M14 ≤ 3.5 MB; total ≤ 45,361,090 bytes) in Notes; the `.pck` searched: no preview, animator, gameplay scene, projectile script, `magmax/` or `_new` path.
- [x] Check: `tools/test.ps1`, `tools/lint.ps1`, `tools/export_web.ps1` exit 0 (Echo and Flarekid look as before — the game does not use the frames yet); `git status --short` shows no `_new` folder, no zip and `characters/magmax/` as ignored; the moved folders committed with this Step.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 20:33
**Before set** (D42; `%LOCALAPPDATA%\hack_star\screens\09c\before\`, not committed): `godot_home_`, `godot_fighter_list_` (scrolled to the end: Luna, Pixel, Beatbolt, Flarekid, Echo), `godot_fighter_echo_`, `godot_fighter_flarekid_`, `godot_match_canyon_` (Echo the player, 4 s in) at `1280x720` and `820x1180` (captured 820×1175, the window's cap) — a windowed run with a temporary `-s` script under `%TEMP%\hs09c\`, deleted; viewed on contact sheets: Echo and Flarekid as the single hero picture on the pedestal and in the match, their cards on the list. Web export before the move (working tree): 41,244,583 bytes, `.pck` 1,123,452.
**`characters/magmax/` before the move** (SHA-256; never touched, compared again after the imports — identical): `d516d2fca91dfbf18162be4690747d2a004de617419286558e3a7515e6857d75` `character_preview.gd`, `e1ef2b782e37b6bea142de1ad3a57e6743a715962911b0659c3f25edab7a5722` `character_preview.gd.uid`, `8af2c434d64875d722959f3940671cf41e21a077e146c40f86aad4b432e8381b` `magmax_card.png`, `76d1c78f318b4d97c36e332d5b2df7087a7246530ce025b6bdb5a925d7df029b` `magmax_card.png.import`, `429acb564360b05712305f07232e8b62a529adfcf81b31abe2c3a10ce25c4253` `magmax_hero.png`, `2576933ed2feb81922d67658cfdd2c0f0e66a6d831ecf20b86ec0458741e4674` `magmax_hero.png.import`, `9ac51ba237d7109088b0769f083d6e40bbba4408d31e0ae8011dbef8370d74f6` `magmax_hero.tscn`, `71f8add3c7796ef7357d5e8769fcbb81bc34a9f4b5b00a69e975a01626f751b9` `magmax_hero_ui.tscn`, `8e9f808d1fc01fcd97dde5a0901c8379babf2c6d8636ac4d77f4aae702149d71` `README.md`. The zip `scenes/blaze_godot.zip`: `72a1cb9b8d14f29cadb7a9fe12db9d67ae67e3e3d7e941f9f39ef3102204ebe8` (untouched).
**Move** (D35, `Move-Item`): `echo_new` → `echo/`, `flarekid_new` → `blaze2/`, `magmax_new` → `magmax2/`; the three `_new` folders are gone. In `echo/` and `blaze2/` the hero and card PNGs of the delivery were the same bytes as the committed ones (checked by SHA-256), so the committed PNGs, their `.import` and the committed `character_preview.gd.uid` stay (uids kept) and the delivered duplicates were removed; `character_preview.gd` and `echo_hero*.tscn` were byte-identical; the delivered READMEs replace the committed ones; `gameplay/` moved in whole. Paths fixed in every moved `.tscn`, `.tres`, `.gd` and README: `characters/blaze/` → `characters/blaze2/` (6 files), `characters/magmax/` → `characters/magmax2/` (6 files; Echo's already said `characters/echo/`). Every delivered `.import` of a moved picture (all of `gameplay/`, MagMax's hero and card) was replaced by one Godot wrote. `git grep` in `characters/`, `scenes/`, `game/` and `export_presets.cfg` finds no `characters/blaze/`, `characters/magmax/` or `_new` path (only the `.gitignore` line and the filter's own `characters/magmax/*` and `characters/*_new/*`); `docs/drawing_to_fighter.md` still describes the `_new` folders as the author's dropped art — rewritten by Step 37 (M16).
**Imports and sharpness** (D35): frames lossy WebP 0.85, mipmaps, not VRAM (`detect_3d/compress_to=0`); projectiles lossless with mipmaps; MagMax's hero lossy 0.9 at 768 and card lossless at 256 (D22); the previews lossless (not exported). The frames are 592×503 (Echo), 592×479, 592×517 as delivered. At `size_limit` 512 the three fighters' imported files were **3,865,634 bytes — over M14's 3.5 MB**; at **448** they are **3,419,076 bytes** (Echo 1,259,632, Flarekid 1,070,234, MagMax 1,089,210; frames 36 × ~56 KB, heroes 661,904, cards 303,940, projectiles 262,202). A temporary script put the front idle frame of each (Echo, Flarekid, MagMax) on the fighter screen's pedestal at 820×1180, at 512 and at 448: on full-size crops the 448 frames are only a touch softer in the finest lines (Echo's hair strands, MagMax's lava cracks), the faces, outlines and colours are the same, nothing is blurred. **Chosen: `size_limit` 448** (within D35's 384–640), the size budget decides. (If Step 34 drops the hero pictures from the export, 0.66 MB come free.)
**Git and export**: `.gitignore` + `/characters/magmax/`; `exclude_filter` `characters/magmax*/*` → `characters/magmax/*` plus `characters/*/gameplay/*_animation_preview.png`, `*_animator.gd`, `*_gameplay.tscn`, `*_projectile.gd`, `*_projectile.tscn`. `LICENSES.md`: the section *Pictures of Flarekid, Echo and MagMax* with 12 rows (hero, card, the 12 frames, projectile of each) in M13's words; the preview sheets and example scripts named as kept but not exported.
**Web size** (`tools/export_web.ps1` in the working tree, the author's untracked `characters/magmax/` and the zip present): `build/web` **44,024,915 bytes**, `index.pck` **3,903,784** — +2,780,332 vs before the move (41,244,583 / 1,123,452) and +3,663,825 vs Step 1 (40,361,090); **≤ 45,361,090 met** (1,336,175 bytes to spare). The `.pck` searched as text: 0 × `animation_preview`, `_animator`, `_gameplay.tscn`, `_projectile.gd`, `_projectile.tscn`, `characters/magmax/`, `_new/`; the frames, the `*_frames.tres` and the projectile PNGs are in.
**Look** (D2): the before capture repeated after the move at 1280×720 (home, list, Echo's and Flarekid's fighter screens, the match) — the same as the before set: the game does not use the frames yet.
**Done (2026-11-22 · ~11 min · Claude Opus 5.5)** — before set and the SHA-256 list taken, the three deliveries moved into `characters/echo/`, `blaze2/` and `magmax2/` with every path fixed and the `_new` folders gone, imported web-safe (frames at 448 px for M14: 3,419,076 bytes for the three), the export filter and `.gitignore` updated, `LICENSES.md` with 12 rows; web export 44,024,915 bytes (≤ 45,361,090). `tools/test.ps1` 517 tests passed, `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 6.43 M tokens · CHF 2.11 (251 credits)

---

## Step 31 — MagMax joins and the frame table

### Goal
MagMax is an unlocked, playable fighter, and all three picture fighters are shown with their
delivered frames (the front idle frame for now) through the existing outlined cut-out, loaded
only when used (M1, M7; D34, D36).

### Tasks
- [x] Record the start time in Notes below.
- [x] `Fighters.LIST` row and `SampleProgress` numbers for MagMax (D34); `CutoutFighters` rows get `frames`, `projectile`, `figure_height`, the frames' feet point and the per-view `muzzle` (measured on the shoot frames); frames, projectiles and heroes loaded on first use and cached (D36); the quad sized to the frame's aspect; MagMax's card on his card and skin button.
- [x] `FighterModel` shows the `idle_down` frame of an animated fighter instead of the hero picture (outline, shadow, see-through, flash and knock-out unchanged); `FighterModel` stays under 1000 lines.
- [x] `tests/test_animated_fighters.gd` (D41: data, unlocked, old save, final-folder paths, 12 frames of one size, card); the tests that count fighters updated.
- [x] Screenshots (D2) at 1280×720 and 820×1180: home and the fighter screen with MagMax, the fighter list (three picture cards), a match with MagMax, Echo and Flarekid next to Blaze (outline width and height compared) and one of them in a bush; viewed; Notes say what was changed after looking.
- [x] Check: `tools/test.ps1`, `tools/lint.ps1` exit 0; MagMax selectable and playable in Training and a match (a test and the screenshots).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 20:45
**Data** (D34): `Fighters.LIST` gets MagMax after Echo (Epic, plays like Rocko, unlocked, one Default skin), `SampleProgress` 0 trophies and power 1. **Differs from D34:** his main colour is **`ff4500`** (lava orange-red), not `ff6a1a` — `test_fighter_model.gd`'s *no two fighters share a main colour* failed with `ff6a1a` (distance 0.06 to Flarekid's `ff7a1a`, at least 0.1 needed); `ff4500` is 0.21 from Flarekid and from Blaze's red.
**Frame table** (D36): `CutoutFighters` rows hold the card (preloaded) and the paths of `hero`, `frames` (the delivered `*_frames.tres`) and `projectile`, loaded on first use through `sprite_frames()`, `frame()`, `hero()`, `projectile()` and kept in a static dictionary (`is_loaded()`); `figure_height` 2.7 / 2.5 / 2.5 m (Flarekid, Echo, MagMax), `feet` (0.5, 0.993) for all (the frames' alpha ends at 0.990–0.994 of the height in every frame; the delivery puts the feet at the bottom centre), `top` measured on each `idle_down` frame (0.030 / 0.038 / 0.035), so the picture is `figure_height / (feet.y − top)` tall and as wide as the frame's aspect (`picture_size()`); `muzzle` per view measured on the shoot frames with a 10 % grid (Echo's blaster glow, Flarekid's fireball, MagMax's fist: e.g. MagMax down (0.30, 0.50), up (0.67, 0.43), side (0.75, 0.46)); `VIEWS` = down, up, side. The frames are 592×503 (Echo), 626×507 (Flarekid), 582×509 (MagMax) as delivered — all 12 of a fighter one size. `faces_left` is gone: the side frames look right, so the picture is mirrored when `facing_left` (until Step 32 replaces C5's flip). `FighterModel` (994 lines) only lost the `faces_left` look-up; the quad shows `idle_down`; `top_offset` uses `figure_height`, so the bar sits over the figure.
**Tests**: new `tests/test_animated_fighters.gd` (8 tests: MagMax's data and colour, an old save, every frame and projectile from its final folder with no old path and loaded once, 12 frames of one size in three views with a 4-frame walk, the model's front idle frame at the planned figure height and the frame's aspect, MagMax's card on his card and skin button, MagMax in Training and a match); `test_cutout_fighters.gd` (the front idle frame instead of the hero, the picture's height, Echo's flip now like Flarekid's) and `test_camera_views.gd` (`figure_height`) updated; the counting tests (`test_fighter_list`, `test_sample_progress`) count from the lists and pass unchanged.
**Screenshots** (D2; `%TEMP%\hs09c\`, a temporary `-s` script, deleted): home and the fighter screen with MagMax (the front idle frame on the pedestal, sharp at both sizes, his name and *Epic*), the fighter list scrolled to the end (Flarekid, Echo and MagMax cards with their card pictures), a match 1280×720 and 820×1180 with MagMax the player and the bots set to Blaze, Flarekid and Echo, Echo inside the nearest cactus patch: MagMax and Flarekid stand on their feet with their soft shadow, a dark outline as wide as Blaze's, and read about as tall as Blaze (on a 1280×720 crop: Blaze ~120 px crown to feet, MagMax ~125 px, Flarekid ~135 px); Echo in the patch is see-through; the bars sit over the figures. Nothing changed after looking (the swapped bots' stale bars are an artefact of the capture script changing their looks after the start).
**Done (2026-11-22 · ~15 min · Claude Opus 5.5)** — MagMax is an unlocked Epic fighter playing like Rocko (main colour `ff4500`, see above); `CutoutFighters` has the frame table (frames, projectile and hero loaded on first use, figure height, feet, top, per-view muzzle) and all three picture fighters show their front idle frame through the outlined cut-out at the planned height. `tools/test.ps1` 525 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 9.88 M tokens · CHF 2.52 (300 credits)
---

## Step 32 — Facing, walk and shoot pose in play

### Goal
In Training and a match the animated fighters — the player and the bots — show their back, front
or side view from the movement, walk with the walk loop, idle when still, and show the shoot pose
in the shot's direction, the same in all four camera views, with every effect kept (M3, M4, M5,
M7; D37).

### Tasks
- [x] Record the start time in Notes below.
- [x] `CutoutAnimator` (D37): view from the screen direction, mirrored left, last view kept, front at the start; walk loop with the pace and small hop; idle with breathing; `play_shoot(direction)` for 0.25 s; `Fighter` and `Arena.fire_from` hand it the input and the shot; the muzzle flash at the shoot frame's muzzle of that view; C5's flip, hop and lean removed for the animated fighters.
- [x] Camera orientation checked in code and pinned by a test: in Classic, Close, Behind and Overview the camera looks north with a fixed yaw, so W shows the back view, S the front, A and D the side (Notes say what was found per view).
- [x] `tests/test_cutout_animator.gd` (D41); `test_cutout_fighters.gd` and `test_fighter_reveal.gd` updated where they expected C5's flip and hop.
- [x] Screenshots (D2; frame sequences, 1280×720, and 820×1180 for Classic): each of the three walking up, down, left, right and diagonally, stopping, shooting in each direction, hit (white), knocked out at 0.25 s, in a bush — in Classic, and walking up and right in Close, Behind and Overview; viewed; Notes say what was changed after looking (feet steady, no size jump between frames, outline and bar over the figure).
- [x] Check: `tools/test.ps1`, `tools/lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 21:00
**`CutoutAnimator`** (`scenes/cutout/cutout_animator.gd`, D37): `view_for(direction)` — `side` when |x| > |y| (mirrored when x < 0), else `up` (back) for y < 0, else `down` (front); `face()` ignores a zero direction (the last view stays) and keeps the shot's view while the shoot pose shows; the start view is `down`; the walk loop is the delivered `walk_<view>` (walk 1, idle, walk 2, idle) at `clamp(8 · speed / 5, 6, 10)` frames a second (`Fighter` passes its speed), with a hop of 0.05 m highest in the middle of walk 1 and walk 2; standing shows `idle_<view>` at once and breathes and bobs (`CutoutMotion.pose`, no sway or lean any more); `play_shoot()` shows `shoot_<view>` for 0.25 s. It also holds the quad's material: it sets the frame and the mirror (`apply()`), the hit flash and the knock-out — moved out of `FighterModel`, which went from 1011 lines (after adding the forwarding) to **989** (gdlint's 1000). `FighterModel` forwards `face()`, `play_shoot()` and exposes `cutout_animator()`; `Fighter.face()` hands the input (and the aim) to it, `Arena.fire_from` calls `model.play_shoot(direction)` for the player and the bots; the muzzle star sits at the muzzle of the shoot frame of the shown view, mirrored with it (`CutoutMotion.place_muzzle_flash`). C5's `facing_left`, `faces_left`, the running hop with squash and lean, and the idle sway are gone (the shader's `tilt` stays 0).
**Camera orientation** (code and test): `Arena.view_pose` — Classic and Close use `_orbit_pose` (yaw fixed, looking north), Behind stands `distance` m south (+z) of the fighter looking at a point `look_ahead` m north, Overview orbits the arena's centre with the same yaw: in all four the camera's forward has x = 0 and z < 0, so −z (W) is up on the screen, +z (S) down, ±x (A, D) left and right. `test_up_on_the_screen_shows_the_back_in_all_four_camera_views` pins it (forward x = 0, z < 0; a point 1 m north projects higher on the screen; W gives the back view, S the front, in each view).
**Tests**: new `tests/test_cutout_animator.gd` (10: the view per direction and diagonal, the front at the start for all three, moving and standing keeps the last view with the mirror only for the left, the walk loop's order and pace limits, the hop and no sliding still, the shoot frame for 0.25 s in the shot's view, the player's shot up and down with the star, a bot's shot, the four camera views, flash and see-through kept while the frames change); `test_cutout_fighters.gd` lost the two C5 tests (look where it runs, the running hop and lean); `test_fighter_reveal.gd`'s idle test now checks breathing and bob without a sway, for MagMax too.
**Screenshots** (D2; a temporary `-s` script under `%TEMP%\hs09c\`, deleted; Training, the player's health bar shown): per fighter a contact sheet of 30 crops around the feet at 1280×720 and at 820×1180 (Classic) — the front at the start; walking up: the back view's walk loop; stopping: the back idle; walking down: the front walk; left: the side view mirrored; stopping: the side idle, still mirrored; right: the side unmirrored (checked also by the fireball's position: −9 px left of the feet walking left, +9 px right walking right); diagonals up-right → back, down-left → side mirrored; shooting up, down, left and right: the shoot frame of that view with the muzzle star at the fist / blaster / fireball; hit: white with the damage number; in a cactus patch: see-through; knocked out 0.25 s: tipping and half faded. Close, Behind and Overview (1280×720, all three fighters): walking up shows the back, walking right the side, as in Classic. The feet stay on the shadow in every frame, the figure does not change size between frames, the outline is there in every frame and the bar sits over the head. **Nothing changed after looking** (a first reading of Flarekid's right walk as mirrored was wrong — the hood's flame cape points back; the fireball check settled it).
**Seen in the working tree**: the author dropped a new untracked folder `scenes/glimmer_isles/` (palette, materials, a lighting scene, a README) at 21:02 during this Step; not touched or committed (Godot's test runs wrote its `.import` and `.uid`); it is not in the export filter yet — for the runner.
**Done (2026-11-22 · ~20 min · Claude Opus 5.5)** — `CutoutAnimator` gives the three animated fighters their back, front or side view from the movement (mirrored left, last view kept, front at the start), the walk loop with its pace and hop, the idle with breathing and the 0.25 s shoot pose in the shot's direction for the player and the bots, the same in all four camera views (pinned by a test); flash, see-through, knock-out, outline and bar kept; C5's flip, hop, lean and sway removed; `FighterModel` 989 lines. `tools/test.ps1` 533 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 15.11 M tokens · CHF 3.76 (448 credits)
---

## Step 33 — Own projectiles

### Goal
The shots of MagMax, Echo and Flarekid look like their delivered projectile pictures, turned along
their flight, readable in every view and preset, with the combat rules unchanged (M6; D38).

### Tasks
- [x] Record the start time in Notes below.
- [x] `Shot.launch` with an optional picture and `scenes/toon/projectile.gdshader` (D38); `Arena.fire_from` passes `CutoutFighters.projectile(id)`; other fighters keep the ball.
- [x] `tests/test_projectile_look.gd` (D41); `test_shot.gd` and `test_fighter_health.gd` green unchanged (same speed, range, damage, walls).
- [x] Screenshots (D2; 1280×720): each projectile in flight in Classic, Close, Behind and Overview, in Bright day and Neon night, and hitting a dummy; viewed; Notes say the size and what was changed after looking.
- [x] Check: `tools/test.ps1`, `tools/lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 21:21
**Look** (D38): `Shot.launch(…, picture)` — with a picture the shot builds one `Picture` quad (`Shot.PICTURE_LENGTH` 1.0 m long, as tall as the picture's aspect: 0.63 m Flarekid, 0.86 m Echo, 0.68 m MagMax) instead of the ball, halo, core and tail; the node's x axis is the flight. `scenes/toon/projectile.gdshader` (unshaded, alpha-blended, no depth write, no shadow, `skip_vertex_transform`) faces it to the camera, turns it on the screen along the flight (the delivered pictures fly to the right) and mirrors it top to bottom when it flies to the left of the screen, so its light stays on top; it is drawn 0.6 m nearer the camera so a steep view's floor never cuts it (`extra_cull_margin` covers the move). One quad and one material per picture, shared by every shot. `Arena.fire_from` passes `CutoutFighters.projectile(id)` for the picture fighters (player and bots); the others pass none and keep the ball. Ray, speed, range, damage and the hit burst are unchanged.
**Tests**: new `tests/test_projectile_look.gd` (6: the three shoot their own pictures and no ball, Blaze keeps the ball and tail, the picture turned along four directions and 1 m long at its aspect, mesh and material shared, as fast and as far as the ball, stops at a wall's face with `Combat.DAMAGE`); `test_shot.gd`, `test_fighter_health.gd` unchanged and green.
**Screenshots** (D2; a temporary `-s` script under `%TEMP%\hs09d\`, deleted; Training at 1280×720, the start hint hidden for the capture): per fighter a sheet of shots right, up and down-left 0.15 s after firing and a shot at a dummy 0.1 s in and at the hit, in Classic, Close, Behind and Overview (Bright day) and Classic and Overview (Neon night). The lava fist, the sound wave and the fireball fly head first in every direction (right: as drawn; up: turned upright; down-left: turned, light on top), sit at fist height ahead of the figure, are clearly readable in Classic, Close and Behind (about 70–110 px long) and as a small coloured streak in Overview, like the ball before; unshaded, so as bright in Neon night as in Bright day; at the wall the picture stops at its face; at the dummy the hit shows 480 and the white flash. **Nothing changed after looking** (1.0 m kept: larger pictures would cover the target in Close).
**Done (2026-11-22 · ~17 min · Claude Opus 5.5)** — the shots of MagMax, Echo and Flarekid show their delivered projectile pictures, turned along the flight and facing the camera, readable in all four views and both checked presets; the other fighters keep the ball; the combat rules are unchanged. `tools/test.ps1` 539 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 4.57 M tokens · CHF 1.67 (199 credits)

---

## Step 34 — Showcase on the pedestal, turn and shoot on the fighter screen

### Goal
On home, the fighter screen and the result an animated fighter pops in and then plays a lively
showcase (idle, a turn through its views, walk steps, a shot with its projectile and sparks); on
the fighter screen the player turns it by dragging and makes it shoot with a tap (M8, M9; D39).

### Tasks
- [x] Record the start time in Notes below.
- [x] `CutoutShowcase` (D39) and its use in `FighterStage` after the reveal (C3 unchanged; shapes unchanged); the projectile and the spark burst on the shot.
- [x] The fighter screen's drag (turn) and tap (shoot) with mouse and touch, the pause and the restart after 3 s.
- [x] The hero picture: a short hero pose before the loop tried on screenshots — kept only if the switch is smooth; otherwise unused and `characters/*/*_hero.png` added to the export filter (D39); the choice and the size change in Notes.
- [x] `tests/test_showcase.gd` (D41); `test_fighter_reveal.gd`, home and fighter-screen tests green.
- [x] Screenshots (D2; 1280×720 and 820×1180): a sequence through one loop (about every 0.4 s) on home and on the fighter screen for MagMax, Echo and Flarekid, and on the fighter screen after a drag and after a tap; viewed; Notes say what was changed after looking.
- [x] Check: `tools/test.ps1`, `tools/lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 21:38
**Showcase** (D39): `scenes/cutout/cutout_showcase.gd` (`CutoutShowcase`, static): `at(time)` gives the pose of the 7 s loop — 0–1.2 s idle front; 1.2–3.2 s front, side, back, the other side (mirrored), front, 0.4 s each; 3.2–4.8 s the front walk loop on the spot (with its hop); 4.8–5.4 s the side shoot frame; 5.4–7.0 s idle front — plus the turn's `RING`, `ring_index()` and `shot_direction()`. `FighterStage` starts it for an animated fighter on a pedestal (home, the fighter screen, the result) when it shows the fighter and again at the reveal (home's landing), so the reveal (C3) is unchanged and the first 1.2 s are the idle; it sets the animator's view and mirror and the model's `running` each frame (`step_showcase`). The shot (`shoot()`): the shoot frame for 0.6 s, the recoil and the muzzle star, the projectile (`ShowcaseShot`, the projectile picture through `projectile.gdshader`, its own material with a new `fade`, 1.0 m) flying 1.5 m in 0.45 s along the shot and fading over its second half, and a burst of 14 sparks (`ShotSparks`, the reveal's sparks made by one `_new_sparks()`) in the main colour at the muzzle. Fighters of shapes keep their idle (no showcase).
**Fighter screen** (M9): `FighterStage.interactive` (set by `fighter_screen.gd`): a press and a drag turns the figure one view of the ring per 80 px (right: front → side → back → other side), a press and release within 0.25 s and 10 px shoots in the shown view (front towards the viewer, back away, side to its side); mouse (left button) and touch (`InputEventScreenTouch`/`ScreenDrag`, index 0) — the mouse events emulated from a touch are ignored, so a touch counts once; each drag or tap holds the showcase and it starts again from the loop's start 3 s after the last one. Home and the result do not react.
**Hero picture** (D39): tried on screenshots — the hero picture on the pedestal's quad (at the idle frames' height) next to the front idle frame, for each of the three at 1280×720: Echo's hero crouches with his blaster forward, MagMax's flexes with bigger hair and fists, Flarekid's is close but larger in the head; switching to the frames jumps in pose and proportions for all three, so **not used**: `hero` and `CutoutFighters.hero()` removed, `characters/*/*_hero.png` added to the export's `exclude_filter`. Web export (`tools/export_web.ps1`, working tree): `build/web` **43,538,611 bytes**, `index.pck` **3,417,480** (−486,304 vs Step 30's 44,024,915; the heroes' 661,904 bytes out, this Step's and Step 33's code in); the `.pck` holds no `_hero.png`. The PNGs stay in the folders (the author's delivery, `LICENSES.md` rows kept; Step 37 says they are not exported).
**Tests**: new `tests/test_showcase.gd` (10: the loop's order within 8 s, never still over a whole loop with every pose shown, the shot with its projectile flying out, fading and gone and the sparks in the main colour, the drag through the ring both ways without a shot on release, a tap with the mouse and a touch drag and tap, the emulated mouse ignored, the restart 3 s after the last input from the loop's start, only the fighter screen reacts, home / fighter screen / result play it after the reveal, shapes unchanged); `test_animated_fighters.gd` no longer expects a `hero` path; `test_fighter_reveal.gd`, `test_home*.gd`, `test_fighter_screen.gd` and `test_result_screen.gd` unchanged and green.
**Screenshots** (D2; a temporary `-s` script under `%TEMP%\hs09d\`, deleted; home and the fighter screen of MagMax, Echo and Flarekid, 18 frames 0.4 s apart through one loop, at 1280×720 and 820×1180; the fighter screen with Echo after drags of 40, 90, 170, 250 and −90 px, a tap, and 3 s later): the pop with sparks and the halo, then the front idle, the turn through side, back and the other side (the back view shows the hair and the cape), the walk steps on the spot with the hop, the side shot with the lava fist / sound wave / fireball leaving the fist and the sparks, then the idle; the feet stay on the pedestal's top in every frame, the outline is there and the figure does not jump in size. The drag turns the figure view by view, the tap shoots left in the mirrored side view, and 3 s later the loop starts again from the front idle. The projectile leaves the stage's frame at its edge within its 1.5 m at the narrow 820×1180 stages — it reads as flying out. **Nothing changed after looking** except dropping the hero picture (above).
**Done (2026-11-22 · ~24 min · Claude Opus 5.5)** — on home, the fighter screen and the result the animated fighters pop in and then play a 7 s showcase that never stands still (idle, a turn through the views, walk steps, a shot with the projectile and sparks); on the fighter screen a drag turns them and a tap shoots, with the mouse and touch, and the showcase restarts 3 s later; the hero pictures are unused and out of the export (−0.66 MB). `tools/test.ps1` 549 tests passed, `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0 (43,538,611 bytes); suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 9.21 M tokens · CHF 3.52 (420 credits)

---

## Step 35 — Living cards on the fighter list

### Goal
On the fighter list the cards of the animated fighters move — the figure idles and walks, a light
sweep in the rarity colour crosses the card — while the list fits and scrolls as before (M10;
D40).

### Tasks
- [x] Record the start time in Notes below.
- [x] `FighterCard`'s `Figure` and `scenes/ui/card_sweep.gdshader` (D40); animated only while visible; locked cards grey and still.
- [x] `tests/test_living_cards.gd` (D41); `test_fighter_list.gd` and `test_screen_sizes.gd` green.
- [x] Screenshots (D2; 1280×720 and 820×1180): the list at the picture fighters at three moments 0.5 s apart (figure and sweep moving), and with a locked fighter (unlock-all off) for the grey card; viewed; Notes say what was changed after looking.
- [x] Check: `tools/test.ps1`, `tools/lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 22:02
**Living cards** (D40): `FighterCard` of an unlocked animated fighter builds, on its first `setup`, a `FigureBox` (a plain `Control`, so the card's layout never resets the figure's stretch) at the bottom right of the picture with a `Figure` (`TextureRect`, 60 % of the picture's height, the frame's aspect, 8 × 6 px from the edges) and a soft oval shadow under its feet, and a `Sweep` over the picture (`scenes/ui/card_sweep.gdshader`: added light in a soft diagonal band, the rarity's colour lightened 55 % towards white, only where the card picture is). Its loop: the front idle frame with breathing for 1.2 s, then the front walk loop (`walk_down`, 7.5 frames a second) with a 4 px hop for 1.6 s; the sweep crosses in 0.8 s once every 4 s, each card 0.6 s after the one before it in the list. The card moves on only while `is_on_screen()` (its rect meets the list's scroll area), so cards out of sight cost nothing but the check; a locked card is grey with its lock as before, without figure and sweep and with no processing. The frames come from `CutoutFighters.frame()` (loaded on first use).
**Differs from D40** (added after looking): the figure gets the fighters' dark outline (`scenes/ui/card_figure.gdshader`, 2.5 px, the ring of `cutout.gdshader`) and the oval shadow — without them the small figure melted into the card picture of the same fighter behind it (same colours), with them it stands out at both sizes.
**Tests**: new `tests/test_living_cards.gd` (6: only the three cards live, the figure idles with breathing, walks the four walk frames with a hop and idles again at 60 % height, the sweep in the rarity colour crosses once a period from the top left to the bottom right over the picture only and the next card later, a card below the visible part does not move until the list is scrolled to it, a locked card is grey and still and gets its figure back when unlocked, the figure stays on its card at the five sizes); `test_fighter_list.gd` and `test_screen_sizes.gd` unchanged and green.
**Screenshots** (D2; a temporary `-s` script under `%TEMP%\hs09d\`, deleted; the list scrolled to the end at 1280×720 and 820×1180, four moments 0.5 s apart, the Echo card every 0.2 s over 2.8 s at 1280×720, and Echo locked): MagMax, Echo and Flarekid stand at the bottom right of their portraits, idle and then walk towards the viewer with a small hop; the light band crosses the portrait diagonally in the rarity's colour and is gone after 0.8 s; the other cards are unchanged; the list fits and scrolls as before; locked Echo is a grey portrait with the lock, no figure, no sweep. **Changed after looking:** the outline and the shadow (above); the sweep made a little wider and brighter (band 0.2, strength 0.75) so it reads on the bright portraits.
**Done (2026-11-22 · ~15 min · Claude Opus 5.5)** — the cards of MagMax, Echo and Flarekid live on the fighter list: their outlined figure idles and walks on the card picture and a light sweep in the rarity colour crosses it every 4 s, only while the card is in the visible part of the list; locked cards stay grey and still; the list fits and scrolls at the five sizes. `tools/test.ps1` 555 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 7.81 M tokens · CHF 2.06 (246 credits)

---

## Step 36 — Performance and the after set

### Goal
Four animated fighters in a match stay within L8 of the baseline in both worlds, and the after set
shows that the animated fighters are clearly livelier than before (M11, M15; D42).

### Tasks
- [ ] Record the start time in Notes below.
- [x] Performance run (D42; warm run as D32): four animated fighters, both worlds, Classic and Overview, Bright day and Neon night; frame time average and worst, draw calls, primitives and texture memory in a table in Notes next to Step 21's baseline; anything over L8 trimmed (e.g. the frames' `size_limit`) and measured again; temporary scripts deleted.
- [x] After set into `%LOCALAPPDATA%\hack_star\screens\09c\after\` with Step 30's names plus MagMax (home, fighter screen, a match) and the frame sequences of Steps 32–35; viewed next to the before set; Notes say what changed (M11).
- [x] Check: every row within L8 in Notes; `tools/test.ps1`, `tools/lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 22:17
**Method** (D42, D28, D32): a windowed Compatibility run at 1280×720, vsync off, `Engine.max_fps` 0, a 4-fighter match loaded fresh for every row, sampled for 10 s from 1 s after the scene loads (frame time from the frame-to-frame clock; `Performance` `RENDER_TOTAL_DRAW_CALLS_IN_FRAME`, `RENDER_TOTAL_PRIMITIVES_IN_FRAME` and `RENDER_TEXTURE_MEM_USED` every frame), by a temporary `-s` script under `%TEMP%\hs09e\` (deleted; `perf.csv` and `perf_shapes.csv` stay there). **Fighters:** the player **Echo**, the bots set to **MagMax, Echo and Flarekid** after the match is built (`Fighter.set_look`); the countdown set to 0 so all four fight for the whole sample; the player walks in six directions (0.8 s each) and shoots about every 0.6 s (`Arena.fire`), so every fighter walks, idles and shows the shoot pose. Both worlds × Classic and Overview × Bright day and Neon night = 8 rows, each run **twice** (two passes); L8 judged on the second (warm) run (D32).
**Limits** (L8, the higher of Step 21's two runs per world): **canyon** frame time ≤ 1.3 × 13.09 = **17.02 ms**, draw calls ≤ 1.3 × 1042 = **1355**; **Glimmer Isles** frame time ≤ 1.3 × 9.89 = **12.86 ms**, draw calls ≤ 1.3 × 570 = **741**; every frame under 33 ms.

| World | View | Preset | Avg frame ms (run 1 / run 2) | Worst ms (run 1 / run 2) | Draw calls avg (max), run 2 | Primitives avg | Texture memory MB (avg), run 2 |
|-------|------|--------|------------------------------|--------------------------|-----------------------------|----------------|--------------------------------|
| Canyon | Classic | Bright day | 6.26 / 6.20 | 28.22 / 26.36 | 396 (421) | 513 k | 59.8 |
| Canyon | Classic | Neon night | 8.08 / 6.14 | 48.78 / 27.54 | 398 (424) | 513 k | 59.8 |
| Canyon | Overview | Bright day | 5.22 / 5.00 | 21.34 / 18.01 | 377 (390) | 367 k | 59.8 |
| Canyon | Overview | Neon night | 5.21 / 5.24 | 23.13 / 18.46 | 377 (392) | 367 k | 59.8 |
| Glimmer Isles | Classic | Bright day | 5.16 / 5.01 | 18.10 / 17.72 | 251 (273) | 474 k | 60.4 |
| Glimmer Isles | Classic | Neon night | 5.76 / 5.65 | 26.15 / 24.31 | 258 (276) | 474 k | 60.4 |
| Glimmer Isles | Overview | Bright day | 4.42 / 4.37 | 18.76 / 17.63 | 202 (220) | 305 k | 60.4 |
| Glimmer Isles | Overview | Neon night | 4.78 / 4.74 | 19.71 / 20.18 | 203 (218) | 305 k | 60.4 |
| *Baseline (Step 21, runs 1 / 2)* | *Classic* | *before* | *canyon 13.09 / 12.84; Glimmer Isles 9.89 / 7.16* | *131.43 / 65.86* | *canyon 792 / 1042; Glimmer Isles 570 / 533* | *canyon 926 k / 1.40 M; Glimmer Isles 810 k / 752 k* | *not measured* |

**Result — every row within L8, nothing trimmed:** in the warm run the frame time is 4.37–6.20 ms (at most 48 % of the baseline's 13.09 ms in the canyon and 57 % of 9.89 ms in Glimmer Isles), every frame under 33 ms (worst 27.54 ms); draw calls at most 398 on average in the canyon (max 424, −62 % vs 1042) and 258 in Glimmer Isles (max 276, −55 % vs 570): a picture fighter is one quad with one material, far fewer draw calls than a fighter of shapes. The first run's one-time shader compile shows only in its first Neon night row (8.08 ms, a 48.78 ms frame), not counted (D32). **Texture memory:** the monitor counts every texture alive in the process (render targets included); in the first row of a fresh process it is **55.1 MB** with the four animated fighters against **26.2 MB** with four fighters of shapes (the same run with Blaze, Turbo, Frosty and Rocko: canyon Classic 7.37 ms, 811 draw calls), so the three fighters' 36 frames, cards and projectiles take about **29 MB** of GPU memory — as D36 expected (≈ 9–10 MB per fighter at 448 px with mipmaps), and only for the fighters in use; the later rows of both runs settle at 58.6–60.4 MB (textures kept by the process between rows), the same with and without the animated fighters. The iPad check (≥ 30 fps, G14) stays with the author (Deferred Items).
**After set** (D42, D2, M11; `%LOCALAPPDATA%\hack_star\screens\09c\after\`, not committed; a temporary `-s` script under `%TEMP%\hs09e\`, deleted; the game's own save, the entrance skipped): Step 30's names — `godot_home_`, `godot_fighter_list_` (scrolled to the end), `godot_fighter_echo_`, `godot_fighter_flarekid_`, `godot_match_canyon_` (Echo the player, 4 s in: 0.6 s walking right and a shot) at `1280x720` and `820x1180` (captured 820×1175) — plus MagMax: `godot_home_magmax_`, `godot_fighter_magmax_`, `godot_match_canyon_magmax_`; and frame sequences at 1280×720: `seq_showcase_<id>_00…09` (the fighter screen every 0.75 s through the loop, each of the three), `seq_cards_00…07` (the list every 0.4 s), `seq_match_echo_00…11` (Echo walking up, right, down and left and shooting, every 0.22 s) — 66 PNGs, viewed on contact sheets next to `…\09c\before\`. **What changed:** before, Echo and Flarekid were one still hero picture on the pedestal, on the list only their card picture, and in the match the same front picture that hopped, leaned and flipped left and right. Now on home and the fighter screen they pop in and then turn through front, side, back and the other side, walk on the spot and shoot (MagMax's lava fist with its sparks), with the outline and feet on the pedestal in every frame; their list cards carry a small outlined figure that idles and walks and a light sweep in the rarity colour; in the match Echo walks with his back, front or side to the camera, stops in the idle of that view, and strikes the shoot pose with his own sound-wave projectile; the bots (Flarekid, MagMax) do the same. MagMax is new on home, the list, the fighter screen and in the match. The save's own fighter is now Flarekid (it was Blaze in the before set; changed by an earlier run, not by this Step), so `godot_home_` shows Flarekid in mid-turn. **Clearly livelier than the single pictures — M11 met** (the author's own verdict stays with the author, as G1). Nothing changed after looking.
**Done (2026-11-22 · ~13 min · Claude Opus 5.5)** — four animated fighters measured in both worlds, Classic and Overview, Bright day and Neon night, twice: every warm row within L8 (frame time ≤ 6.20 ms, draw calls ≤ 424, every frame under 33 ms), the frames take about 29 MB of texture memory, nothing trimmed; the after set (16 screens + 50 sequence frames) captured and compared with the before set: the fighters turn, walk, shoot and live on their cards. `tools/test.ps1` 555 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 3.82 M tokens · CHF 1.43 (171 credits)

---

## Step 37 — Final check of the animated characters, README, architecture and licences

### Goal
Everything that worked before still works, the size budget is met and reported, the author's
older files are untouched, and the documents describe the animated fighters (M1–M16, S2–S6).

### Tasks
- [x] Record the start time in Notes below.
- [x] Run `tools/check_tools.ps1`, `tools/test.ps1`, `tools/lint.ps1`, `tools/export_web.ps1` (all exit 0); every `.ps1` changed parses with `[System.Management.Automation.Language.Parser]::ParseFile`; nothing outside `hack_star_godot/` changed (S5); `characters/magmax/`'s SHA-256 list equals Step 30's; `git status` shows no `_new` folder, no zip, `characters/magmax/` ignored.
- [x] Web export size report in Notes: total and `.pck` vs the last close (41,244,583), Step 30 and Step 1; the three fighters' share (M14 ≤ 3.5 MB); total ≤ 45,361,090 bytes (G15); the `.pck` searched for files the game does not use (M12).
- [x] `README.md` (MagMax, the animated fighters in play, the showcase, turn and shoot on the fighter screen, the living cards), `docs/architecture.md` (`CutoutAnimator`, `CutoutShowcase`, the frame table and on-demand loading, the projectile look, the living cards, the new tests), `docs/drawing_to_fighter.md` *Picture fighters* rewritten (how the animated fighters work and how to add one from a delivery: folder, paths, imports, `CutoutFighters` row, `Fighters.LIST`, `SampleProgress`, `LICENSES.md`, the export filter) (M16); `LICENSES.md` complete (M13); Deferred Items: the image tool and per-character origin, the name MagMax, the iPad check.
- [x] Check: every statement M1–M16 has a Step that is ✅ Done (the iPad check of M15 in Deferred Items).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 22:32
**Checks** (S3): `tools/check_tools.ps1` exit 0 (all pinned tools OK), `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0 (twice: before and after the documents), `tools/test.ps1` **555 tests passed** (exit 0) in two runs in a row after the documents; one earlier run in the same Step, with the export running right after it and the machine slow (it took over 10 minutes), reported 1 failing test of 555 that the output filter did not name — no code changed in this Step (documents only), and the next two runs were green, so it is a timing-sensitive test under load, not a regression (noted for the review). No `.ps1` changed in this reopening (`git diff --name-only 6010bd0~1..HEAD -- '*.ps1'` is empty); all seven `tools/*.ps1` parse with `Parser::ParseFile` with 0 errors. **S5:** `git diff --name-only 6010bd0~1..HEAD` lists nothing outside `hack_star_godot/`. **`characters/magmax/`**: the SHA-256 of its nine files equal Step 30's list (e.g. `magmax_hero.png` `429acb56…4253`, `README.md` `8e9f808d…9d71`); `scenes/blaze_godot.zip` still `72a1cb9b…be8`. `git status --short --ignored`: no `_new` folder; `characters/magmax/`, `scenes/blaze_godot.zip` and the author's new `characters/glimmer_isles_godot_palette.zip` ignored (`!!`); untracked only the author's `scenes/glimmer_isles/` (not part of this spec, untouched) and the modified `.spec-nx` submodule (not ours).
**Web size** (G15, M14; `tools/export_web.ps1` in the working tree): `build/web` **43,544,883 bytes**, `index.pck` **3,423,752 bytes**. Against the last close (41,244,583 / 1,123,452): **+2,300,300** total and `.pck` (the frames, projectiles, MagMax's card and the code of Steps 30–35). Against Step 30 (44,024,915 / 3,903,784): **−480,032** (the hero pictures left the export in Step 34, the code of Steps 31–35 came in). Against Step 1 (40,361,090 / 239,960): **+3,183,793** total (+3,183,792 `.pck`). **Total ≤ 45,361,090 met** with 1,816,207 bytes to spare. **The author's untracked `scenes/glimmer_isles/`** (palette, materials, a lighting scene, a theme; not in the export filter, as asked) **is in this export**: its entries in the `.pck` (the palette picture imported, 11 materials, the environment, the lighting scene, the theme and the palette script, with their remaps) are **159,036 bytes**, so without it the export would be about **43,385,847 bytes** (`.pck` about 3,264,716). **The three fighters' share** (their files in the `.pck`: frames, `*_frames.tres`, projectiles, cards, with their `.import`/`.remap` entries; read from the `.pck`'s file table): Echo 1,007,523, Flarekid 865,964, MagMax 902,644 = **2,776,131 bytes — M14 ≤ 3.5 MB met** (Step 30's 3,419,076 included the heroes). **`.pck` searched (M12):** 0 × `animation_preview`, `_gameplay.tscn`, `_projectile.gd`, `_projectile.tscn`, `_hero.png`, `_hero.tscn`, `character_preview`, `README`, `characters/magmax/`, `_new/`, `.zip`, `blaze_godot`; the only `_animator` names are the game's own `scenes/cutout/cutout_animator.gd(c)`; in: the 36 frames, the three `*_frames.tres`, the three projectile PNGs and the three cards.
**Documents** (M16, M13): `README.md` — the intro (ten fighters; Flarekid, Echo and MagMax animated from the author's pictures), *Run in the editor* (ten fighters), *The look* (three animated picture fighters with MagMax; how they move in play, their projectiles; the showcase with drag and tap on the fighter screen; the living cards; the reveal now followed by the showcase), *How to turn a drawing into a fighter* (an animated picture fighter from a delivery), links to the new anchor `#picture-fighters-flarekid-echo-magmax`. `docs/architecture.md` — *Layout* (`scenes/cutout/` with `CutoutAnimator` and `CutoutShowcase`, the projectile shader; `characters/` with `blaze2/`, `echo/`, `magmax2/`, what is exported and what not, `magmax/` ignored — D43), *Screens* (`Shot` with the projectile picture, the fighter screen's interactive stage), *Game rules* (`Fighters` with MagMax), *UI foundation* (the showcase and the drag and tap of `FighterStage`, the living cards of `FighterCard`), *3D models* (*Picture fighters* rewritten: the frame table and on-demand loading, `CutoutAnimator`, the camera's fixed yaw, `CutoutMotion` now without sway and lean, the shots), *Art and licences* (the three, the heroes not exported), *Tests and checks* (`test_animated_fighters.gd`, `test_cutout_animator.gd`, `test_projectile_look.gd`, `test_showcase.gd`, `test_living_cards.gd`; `test_cutout_fighters.gd` updated). `docs/drawing_to_fighter.md` — *Picture fighters (Flarekid, Echo, MagMax)* rewritten: how the animated fighters work (frames, in play, projectiles, pedestal, living cards, what is not used), *Add an animated fighter from a delivery* (the delivery's files; folder and paths, imports, the `CutoutFighters` row, `Fighters.LIST` and `SampleProgress`, `LICENSES.md`, the export filter, the checks) and *Remove a picture fighter*; the old parts about one picture and the `_new` folders are gone. `LICENSES.md` — three fighters in the intro; the section says the pictures were generated by the author with an AI image tool from Mattia's drawing or the author's own idea (tool and origin per character to be confirmed by the author), and that the hero pictures are kept in the folders but no longer exported (since Step 34); the hero rows say so; the own-work row names the projectile, card-figure and card-sweep shaders. **Deferred Items** (unchanged, already there): the image tool and per-character origin (M13), the name MagMax (Q14), the iPad check (M15, G14).
**Coverage of the statements** (the check task): M1 Step 31 · M2 30 · M3 32 · M4 32 · M5 32 · M6 33 · M7 31, 32 · M8 34 · M9 34 · M10 35 · M11 36 · M12 30, 34, 37 · M13 30, 37 · M14 30, 37 · M15 36 (the iPad check in Deferred Items) · M16 37 — all ✅ Done. **With the author:** which AI image tool and, per character, Mattia's drawing or his own idea (`LICENSES.md`); whether the name MagMax is fine; the iPad check (≥ 30 fps with four animated fighters, the showcase and the living cards).
**Done (2026-11-23 · ~25 min of work, 22:32–07:19 on the clock with the machine idle overnight during a check run · Claude Opus 5.5)** — the animated characters checked end to end: all Godot checks green, web export 43,544,883 bytes (+2.30 MB vs the last close, 1.8 MB under the budget; the author's `scenes/glimmer_isles/` in it, about 159 kB), the three fighters 2.78 MB (≤ 3.5 MB), nothing unused in the `.pck`, `characters/magmax/` and the zip untouched; README, `docs/architecture.md`, `docs/drawing_to_fighter.md` and `LICENSES.md` describe the animated fighters; every statement M1–M16 covered. `tools/check_tools.ps1` exit 0, `tools/test.ps1` 555 tests passed, `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 7.99 M tokens · CHF 2.95 (352 credits)
---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| An own visual identity instead of matching the Svelte look | G18: match now, identity later | Root [Originality review](../../../../.specs/features/2026_11_14_4_originality_review_spec.md) (#22) |
| Saving the world choice, more worlds, sizes, world coins and prices | W2: only a minimal choice here | [Worlds and World Coins](../2026_11_22_18_worlds_and_world_coins_spec.md) (spec 18) |
| More skins for a drawn fighter | A2: one default skin | [Skins Shop](../2026_11_22_10_skins_shop_spec.md) (spec 10) |
| The new texts in every game language | S6: English until then | [Accounts, Fighters and Languages](../2026_11_22_15_accounts_fighters_and_languages_spec.md) (spec 15) |
| Overtime and closing walls in Glimmer Isles | W4: they come with spec 11 for every world | [Overtime and Match Options](../2026_11_22_11_overtime_and_match_options_spec.md) (spec 11) |
| Mattia's confirmation "this is my drawing" for Beatbolt (A3), from the Step 16 screenshots in `%LOCALAPPDATA%\hack_star\screens\09\step16\` | Needs the author and Mattia; the agent cannot ask them and does not invent the answer | This spec, Step 20 / author |
| The B6 trial with Google Flow + Meshy (free use) and the possible import of its GLB (Step 19; instructions in `docs/drawing_tools.md` § *Trial (B6)*) | Needs the author's own Google Flow and Meshy accounts (and Mattia's preference); the agent has neither | This spec's follow-up by the author / a later spec |
| The side-by-side verdict of the author and Mattia per screen (G1), from the before and after sets in `%LOCALAPPDATA%\hack_star\screens\09\before\` and `…\after\` (Step 20) | Needs the author and Mattia; the agent cannot judge for them and does not invent the verdict | This spec, Step 20 / author |
| The iPad (and phone) play-test: ≥ 30 fps with 4 fighters in the canyon and in Glimmer Isles with **Show FPS (play-test)**, and playable within 5 s after **Play** (G14, G15, W5) | Needs the author's iPad; the agent has no device | This spec, Step 20 / author |
| Lint and format-check `tools/*.gd` (first file: `tools/bake_world.gd`) and smoke-test `tools/check_tools.ps1` and `tools/bake_world.ps1` | Code review 2026-11-22 finding 8: outside this spec's scope (the Godot tooling) | A later Godot tooling spec |
| Allow letter-prefixed statement ids (G1, W1, A0, B1) in the kit's `change_record.schema.json` | Code review 2026-11-22 finding 9: the kit lives in the root `.specs/kit/`, which a Godot spec does not change | A kit spec in the root `.specs/` |
| The price tag on locked fighter cards and on the fighter screen (G5; D19) — and the skin prices | Code review 2026-11-22 finding 10: the game has no prices yet; the unlock price by rarity is that spec's S2, skin prices come with the shop | [Unlock and Upgrade](../2026_11_22_09_unlock_and_upgrade_spec.md) (S2) · [Skins Shop](../2026_11_22_10_skins_shop_spec.md) (spec 10) |
| A touch button to switch the camera view (and the lighting presets) | V6: touch players keep the default view in this spec (reopened 2026-11-22, Q11) | A later Godot UI spec |
| The iPad check of the reopened parts: ≥ 30 fps with Flarekid and Echo, every view and the default preset (L8, G14) | Needs the author's iPad; Step 28 measures on the desktop only | This spec, Step 29 / author |
| Side and back views, run, shot and hit frames, or a 3D model for Flarekid and Echo | C8: only one front picture each exists; `docs/drawing_to_fighter.md` *Picture fighters* says what to deliver | The author, then a later spec |
| Which AI image tool made the Flarekid and Echo pictures, for `LICENSES.md` | C9: "tool to be confirmed by the author" | The author |
| The author's newer art (echo_new directional gameplay frames, blaze_new — renamed by the author to `flarekid_new` during the close, still covered by the export filter `characters/*_new/*` —, magmax, magmax_new) — a follow-up can use them for Echo's and Flarekid's in-play animation and a new fighter | D31: dropped into `characters/` during the run (`characters/magmax/`, `characters/echo_new/` with `gameplay/frames/`, `characters/blaze_new/`, `characters/magmax_new/`, `characters/echo_godot_gameplay.zip`); not part of this reopening's request, kept untracked and out of the web export (`characters/*_new/*`, `characters/magmax*/*`, `characters/*.zip`) | A later Godot spec — _taken up by the second reopening of 2026-11-22 (part M, Steps 30–37; D43)_ |
| Pre-warm the shaders at load (e.g. draw every material once behind the loading screen), so the first match of a session has no compile hitch (up to ~489 ms in Step 28's first runs) | D32 (code review 2026-11-22 of the reopening, finding 4): L8 is judged on the warm run; the first-run hitch is a one-time cost, not part of this reopening | A later Godot performance spec |
| Which AI image tool made the MagMax, Echo and Flarekid pictures, frames and projectiles, and per character whether it comes from Mattia's drawing or the author's own idea, for `LICENSES.md` | M13: "to be confirmed by the author" (reopened again 2026-11-22) | The author |
| Whether the name **MagMax** is fine: a 1985 arcade game by Nichibutsu is called "MagMax" (no fighter, skin or brand of the repository uses it) | Q14: the author's name is kept; only the author can decide to rename | The author |
| The iPad check of the animated fighters: ≥ 30 fps with four of them in a match, the showcase and the living cards (M15, G14) | Needs the author's iPad; Step 36 measures on the desktop only | This spec, Step 37 / author |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|
| 2026-11-22 | AI assistant (Claude Opus 5.5) | semantic diff | — | [2026-11-22_better-graphics.html](../../review/2026-11-22_better-graphics.html) |
| 2026-11-22 | AI assistant (Claude Opus 5.5) | diff `91cc8be..060ff79` | Approve | 0 Blocking · 2 Should-fix · 8 Nit |
| 2026-11-22 | AI assistant (Claude Opus 5.5) | plan | re-planned | re-planned: spec reopened for the author's request — two new characters, views, lighting (C1–C11, V1–V7, L1–L8; Steps 1–20 kept, Steps 21–29 added, D20–D30) |
| 2026-11-22 | AI assistant (Claude Opus 5.5) | semantic diff (reopening) | — | [2026-11-22_better-graphics-2.html](../../review/2026-11-22_better-graphics-2.html) (change record `changes/done/better-graphics-2/`, 13 blocks; checks 6 pass · 3 n/a · 0 fail) |
| 2026-11-22 | AI assistant (Claude Opus 5.5) | diff `bccd2ed..f10d71c` | Approve | 0 Blocking · 1 Should-fix · 4 Nit |
| 2026-11-22 | AI assistant (Claude Opus 5.5) | review fixes of the reopening | handled | #1 and #2 fixed with tests (`Fix review findings (#35)`), #3 at `CLOSE:`, #4 → D32, #5 → D33 |
| 2026-11-22 | AI assistant (Claude Opus 5.5) | plan | re-planned | re-planned: spec reopened again for the author's request — animated characters (M1–M16; Steps 1–29 kept, Steps 30–37 added, D34–D43; D31 superseded by D43) |

### Code review 2026-11-22

Range `91cc8be..060ff79` (requirements, plan, Steps 1–20), layer by layer; page [2026-11-22_better-graphics.html](../../review/2026-11-22_better-graphics.html). Accepted as deferred, not findings: the G1 verdict, Mattia's A3 confirmation, the iPad G14/W5 play-test and the B6 trial (Step 19).

| # | Finding | Layer | Class | Severity | Target |
|---|---------|-------|-------|----------|--------|
| 1 | hack_star_godot/docs/architecture.md:363-400 — the Tests paragraph does not name the five look tests this spec added: test_theme_look.gd (Step 2), test_home_look.gd (Step 4), test_canyon_look.gd (Step 5), test_arena_framing.gd (Step 6) and test_screens_look.gd (Step 9), although those Steps say the architecture was updated and D18 lists them. Add one clause each | architecture | docs | Should-fix | fix now — **handled:** the Tests paragraph of `docs/architecture.md` names the five look tests and what each checks |
| 2 | hack_star_godot/tests/test_arena_framing.gd:58-79 — G11 (near wall at most 10 % of the screen height at the start of a match and Training) is measured only in the canyon (before_each resets to it); Glimmer Isles gets the same framing only because GlimmerIsles copies Canyon.CAMERA_SIDE_WALL_HEIGHT and Arena._near_wall_offset (scenes/arena.gd:311) reads the canyon's constant. Run both tests for every world in Worlds.ids() | code | test | Should-fix | fix now — **handled:** both tests of `test_arena_framing.gd` run for every world of `Worlds.ids()` (the arena checked to use it; the Glimmer Isles wall height from `GlimmerIsles`) |
| 3 | hack_star_godot/.specs/features/2026_11_21_09_better_graphics_spec.md:796-797 — Step 16's Done line is followed directly by '---' with no blank line, so Markdown renders the Done line as a heading instead of a paragraph and a rule. Add the blank line | spec | docs | Nit | fix now — **handled:** blank line added |
| 4 | hack_star_godot/.specs/features/README.md:32 — the ordered list still says 'planned' for spec 09 Better Graphics although every Step is done and the review runs; it also shares the number 09 with Unlock and Upgrade (next row). Set the status to the current stage (closed at CLOSE:) and say in the list's intro that two specs carry 09 | spec | docs | Nit | fix now — **handled:** *closed* at `CLOSE:`; the intro says why two specs carry 09 (numbers are not changed, as links and issues use them) |
| 5 | hack_star_godot/tests/test_home_look.gd:59-60 — assert_gt compares a float with an int (1280 - 64, 720 - 64), so every run prints two GUT 'Float/Int comparison' warnings; use 1280.0 - 64.0 and 720.0 - 64.0 | code | test | Nit | fix now — **handled:** float operands; the run prints no warning |
| 6 | Unused after this spec: Hacks.power_text (hack_star_godot/game/hacks.gd:155-157, now called only by test_hacks.gd), the theme variations BackgroundPanel (no screen uses it since Step 9) and IconButton (D7; only test_theme_look.gd uses it), and three Kenney icons that Icons names but no screen shows — gear.png ('settings'), star.png ('star'), singleplayer.png ('fighter') — although D4 says only the used icons are copied. Remove them (and their LICENSES.md names), or say in D4/D7 why they stay | code | dead-code | Nit | fix now — **handled:** all removed (grep: no other use): `Hacks.power_text` (its test now checks `power_amount`), the theme's `BackgroundPanel` and `IconButton` with their style boxes, the icons `gear`, `star`, `singleplayer` with their `.import` files; `LICENSES.md` (11 icons) and `docs/architecture.md` updated |
| 7 | hack_star_godot/game/arena_layout.gd:68-96 and scenes/autoload/game_state.gd:80-81 — the active layout is global static state that stays on the last world after its arena closes; GameState.reset() sets world back to the canyon but not ArenaLayout, so code that reads ArenaLayout without an arena (BotBrain, ControlsHelp, tests) depends on the last scene built, and tests reset it by hand (test_world_choice.gd:25, test_glimmer_isles.gd:29). Call ArenaLayout.use(world) in GameState.reset(), and drop 'Pure data' from the class comment | architecture | architecture | Nit | fix now — **handled:** `GameState.reset()` calls `ArenaLayout.use(world)`; the class comment says the active layout is static state that `reset()` sets back; test `test_game_state_reset_sets_the_active_layout_back_to_the_canyon` (`test_world_layouts.gd`) |
| 8 | Semantic-diff check C7: the changed command tools/check_tools.ps1 and the new tools/bake_world.ps1 / tools/bake_world.gd have no automated test, and tools/lint.ps1 lints only game/, scenes/ and tests/, so bake_world.gd (the first .gd in tools/) is never linted or format-checked. A Deferred Items row: lint tools/*.gd and smoke-test the tools | scan | test | Nit | deferred — **handled:** row in Deferred Items |
| 9 | The kit's change_record.schema.json accepts only S<n> statement ids, but this spec's statements are G1–G18, W1–W7, A0–A9 and B1–B6; the record lists S2–S6 and names the others in each block's note. A Deferred Items row for the kit (root .specs/kit, not changed by a Godot spec): allow letter-prefixed ids | spec | docs | Nit | deferred — **handled:** row in Deferred Items |
| 10 | Part 1 G5 asks for lock and price with icons, and the plan's Step 7 task says 'lock icon and price for locked fighters'; the game has no fighter prices yet, so Step 7 shows a 'Locked' chip without a price and says so only in its Notes. Record the deviation as a decision (price on locked cards comes with the shop spec) so Part 1, the plan and the result agree | spec | spec | Nit | plan decision — **handled:** D19 (no price before prices exist) and a Deferred Items row for Unlock and Upgrade (S2) and Skins Shop |

### Code review 2026-11-22 (second review: the reopening)

Range `bccd2ed..f10d71c` (requirements revision, re-plan, Steps 21–29; parts C, V, L; D20–D31), layer by layer; page [2026-11-22_better-graphics-2.html](../../review/2026-11-22_better-graphics-2.html). Ran: `tools/test.ps1` 516 passed, `tools/lint.ps1` and `tools/check_tools.ps1` exit 0, `tools/export_web.ps1` in clean worktrees of both revisions exit 0 (40,516,330 → 41,244,423 bytes; no excluded name in the `.pck`). First review's findings: 1–7 and 10 resolved, 8 and 9 still deferred. Accepted as deferred, not findings: the iPad check of the reopened parts (L8, G14), the image tool for `LICENSES.md` (C9), more pictures or a 3D model (C8), a touch button for views (V6), the author's newer art (D31).

| # | Finding | Layer | Class | Severity | Target |
|---|---------|-------|-------|----------|--------|
| 1 | hack_star_godot/scenes/cutout/cutout_fighters.gd:86-96 and scenes/fighter.gd:104-110 — in the Overview view (pitch 78°) the health bar and damage numbers of a picture fighter in the lower half of the screen show under the fighter, not over the picture: a point straight up comes nearer to the steep camera and so moves down the screen, and the clamp `maxf(…, 0.1)` allows up to ten times the picture's height (820×1180, both worlds: Flarekid's bar about 80 px under his feet; review page, camera-views block). `test_camera_views.gd:118-138` only checks that the bar is on the screen. Find the bar height from the picture's projected top (e.g. bisect like `Arena._near_wall_offset`, or cap it so the bar projects above the top), and test that the bar is above the picture's top on screen in every view | code | test | Should-fix | fix now — **handled:** the bar and the damage numbers sit over the picture along the camera's up (`CutoutFighters.top_offset`, `Fighter._bar_offset`; the numbers rise along it too), so they show over the picture anywhere on the screen in every view; new test `test_the_bar_and_the_numbers_show_over_the_picture_anywhere_in_every_view` (`test_camera_views.gd`: both worlds, 820×1180 and 1280×720, every view, the fighter at the centre, the south and north edges and two corners — the bar and the number above the picture's top on screen, the number rising up the screen; it fails on the old code) and `test_cutout_fighters.gd` compares on screen; checked on real screenshots (820×1180, Overview, Flarekid at the south edge, both worlds: bar and number just over his head; Classic unchanged) |
| 2 | hack_star_godot/scenes/worlds/glimmer_isles/glimmer_decor.gd:154-160 — the crystal pulse writes `emission_energy` on the crystal parts' `material_override`, which is the shared `ToonMaterials` cache entry keyed by colour and glow strength (`scenes/toon/toon_materials.gd:33-43`): every user of that key pulses with it and the cache keeps the last pulsed value (not the key's strength) after the arena closes. Give `GlimmerDecor` its own duplicates of the crystal materials (or a separate pulse uniform) so the cache stays immutable | architecture | architecture | Nit | fix now — **handled:** `GlimmerDecor` gives each glowing crystal part its own duplicate of the material before it pulses; `test_world_decor.gd` checks the crystals do not use the `ToonMaterials` entry and that the entry keeps its glow strength (fails on the old code) |
| 3 | hack_star_godot/.specs/features/README.md:32 — the ordered list says 'planned (reopened 2026-11-22 …)' for spec 09 although Steps 21–29 are done and the review runs (as the first review's finding 4). Set the current stage, *closed* at `CLOSE:` | spec | docs | Nit | fix now — **handled:** *closed* at `CLOSE:` |
| 4 | L8 and Step 28 — L8 says "frame time at most 30 % more and under 33 ms"; Step 28 judges each row by the mean of two runs and by averages, so run 1's first row (canyon, Classic, Bright day: 17.62 ms against the 17.02 ms limit) and every worst frame of 21–489 ms count as within L8. D28 does not say how runs are combined or that load and shader-compile hitches are left out. Record it in D28 (mean of the two runs' average frame time; the first frames of a process excluded) so "every row within L8" can be checked | spec | spec | Nit | plan decision — **handled:** D32 (L8 judged on the warm, second run of each pair; the first run's compile hitches reported, not counted) and a Deferred Items row (shader pre-warm) |
| 5 | hack_star_godot/scenes/arena.gd:446-466 — Overview is fitted with a 2 % bottom margin, so for the first 5 s of every match and Training (the start hint, `HINT_SECONDS`) the hint covers the south border wall at 1280×720 and the fighter starts at the hint's top edge (review page, camera-views block); with the view kept between matches (V6) this repeats on every start. V5 asks that Overview shows all four border walls. Decide: accept (the hint fades after 5 s) or keep Overview's bottom margin above the hint while it shows | spec | spec | Nit | plan decision — **handled:** D33 (V5 judged after the 5 s start hint has faded; no change) |

---

## Definition of Done

- [x] Requirements · Part 1 agreed (G1–G18, W1–W7, A0–A9, B1–B6, S1–S6 testable, open questions answered; reopened 2026-11-22: C1–C11, V1–V7, L1–L8 added, open questions answered; reopened again 2026-11-22: M1–M16 added, C2, C5, C8, C9, C11 superseded, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks (re-planned 2026-11-22: Steps 21–29; re-planned again 2026-11-22: Steps 30–37)
- [ ] Implementation · every Step's tasks checked; `tools/check_tools.ps1`, `tools/test.ps1`, `tools/lint.ps1` and `tools/export_web.ps1` pass; README / `docs/architecture.md` updated where affected; the author's parts (A0 photo, B6 trial, G1 verdict, G14/W5 play-test) recorded — *not ticked:* the checks pass and the documents are updated, the A0 photo is recorded, but Step 19 (B6 trial) is 🔜 Deferred and the G1 verdict, A3 and the G14/W5 play-test wait for the author (Deferred Items); the reopening's Steps 21–29 are all ✅ Done (`tools/test.ps1` 517 passed after the review fixes), its iPad check (L8, G14) waits for the author too
- [x] Review · review page written; no Blocking finding open (second review of the reopening: [2026-11-22_better-graphics-2.html](../../review/2026-11-22_better-graphics-2.html), 0 Blocking)
- [ ] Spec closed · moved to `hack_star_godot/.specs/features/done/` _(reopened in place 2026-11-22 for Steps 21–29; closed again 2026-11-22 after the second review's fixes; reopened in place again 2026-11-22 for the animated characters — closed again after the last new Step)_
- [ ] Pull request · opened with the spec summary ([#36](https://github.com/martinnordio/hack_star/pull/36), from `feature/better-graphics` to `main`); reviewed; merged; branch deleted — *not ticked:* opened, not merged (the author reviews and merges)
