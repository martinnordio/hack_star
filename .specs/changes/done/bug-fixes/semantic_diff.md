### Semantic diff
Players can create multiple fighters and keep saves current across tabs · checks 7 pass · 2 n/a · 0 fail · findings 0 open

**Review here first:** [review page](https://github.com/martinnordio/hack_star/raw/feature/bug-fixes/.specs/review/2026-11-14_feature-bug-fixes.html) — download it and open it in a browser

| Kind | Object | Change | Statements |
|------|--------|--------|------------|
| api | GET /api/hacks and POST /api/hacks/redeem | modified | S16, S17 |
| data-format | hack-star.accounts progress | modified | S4, S8, S19, S20, S21 |
| output | created-fighter creation and edit rules | modified | S1, S7, S8, S10, S11, S12, S15, S19, S20, S21, S22 |
| ui | Fighters list and created-fighter editor | modified | S2, S3, S6, S9, S10, S11, S12, S13, S15, S20, S21 |
| output | account-store cross-tab reconciliation | modified | S4 |
| ui | Hack screen and printable QR descriptions | modified | S13, S16, S17, S18 |
| message | room member payload | modified | S14 |

**Top findings:** None open. S4 same-ID additions are remapped only when the merged account allows another creation. Without CREATOR, credits, or a free slot, the stale creation is rejected, its charge is refunded, and the editor reports the applicable reason. Matched UI screenshots remain manual.
