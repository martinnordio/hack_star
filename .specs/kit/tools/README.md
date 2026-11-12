# Tools

Hack star has no git host yet (`git_host` is `"none"`), so the kit has no issue or
pull-request scripts. The `PR:` stage builds the **summary** below and the user pastes it into
the pull request by hand. To get the scripts later, set `git_host` in `.specs/spec-nx.json`
(`"github"` or `"azure_devops"`) and run `GENERATE KIT --update`.

`spec_summary.ps1` is the shared helper the git-host scripts use to put a summary between the
markers of a description; it runs in Windows PowerShell 5.1 and PowerShell 7.

## The summary

Built by the stage prompt from the spec file, and placed between the markers

```
<!-- spec-summary:start -->
…
<!-- spec-summary:end -->
```

Text outside the markers (written by hand) is kept.

```markdown
### <Spec title>

**Spec:** [<file name>](<link to the spec on the branch>) · **Status:** <Status from the header>

**Requirements**
- **S1 — <name>:** <first sentence of S1>
- **S2 — <name>:** <first sentence of S2>

**Plan**
| Step | Description | Status |
|------|-------------|--------|
| 0 | <description> | ✅ Done |
| 1 | <description> | ⬜ Not started |
```

- Without a host, the link is the spec's path in the repository
  (`.specs/features/<file>`); with a host, a full URL to the spec on the feature branch while
  it is open, on the default branch once it is closed (in `.specs/features/done/`).
- While the spec has no plan yet, the **Plan** part is left out.
- Keep it short: Azure DevOps allows 4000 characters in a pull-request description.
