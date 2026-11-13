| 1 | requirements | `REQUIREMENTS: <name> — <what you want>` | Part 1 of `.specs/features/<date>_<name>_spec.md`; answer its open questions with `REQUIREMENTS: <spec file> — <answers>` |
| 2 | plan | `PLAN: <spec file>` | Part 2: Steps, decisions, Definition of Done |
| 3 | implementation | `IMPLEMENT: <spec file>` — once per Step, commit after each | Server / UI code + the Step marked done |
| 4 | review | `REVIEW: <spec file>`, `CODE REVIEW: <spec file>` | HTML review page in `.specs/review/` (index: `.specs/review/index.html`), semantic diff for the pull request; findings in the Review Log |
| 5 | implementation | `CLOSE: <spec file>` | Spec moved to `.specs/features/done/` |
| 6 | pr | `PR: <spec file>` | Pull request (with the semantic diff) and issue updated with the spec summary |
