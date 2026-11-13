# Commits — baseline

> Rules for commit messages in Hack star, for people and for an AI agent that is allowed to
> commit. `.specs/guidelines/commits.md` (project) wins over this file.

## One commit per Step

- Each Step of a spec is one commit; the spec's Done line is in the same commit.
- Closing the spec, the Stage log row of a stage, and review fixes are commits of their own.

## The message

```
Step <n>: <Step description> (#<issue>)

<why, up to three lines, only if the subject does not say it>
```

- **Subject:** imperative, at most ~72 characters, no period at the end.
- **Reference to the spec's GitHub issue** (`#<n>`, from the spec header) — always, so the
  commit appears on the issue. Use the closing word (`Closes #<n>`) only in the pull request,
  not in each commit — the issue closes when the pull request is merged.
- A spec without an issue: no reference; say so when you suggest the message, and offer
  `CREATE ISSUE:` (requirements stage).

## Who commits

- By default the **user** commits: the stage suggests the message, with the reference.
- If the user lets the AI agent commit, the agent follows the same rules and shows the message
  before it commits. Never push, merge or rewrite pushed history without the user's OK.

## Before the pull request

- `git log main..HEAD --oneline`: every commit has the reference. Missing references in
  commits that are **not pushed yet** can be added with an interactive rebase — only with the
  user's consent; pushed commits stay as they are.
- No secrets, tokens or personal data in messages.
