# Semantic diff — rules

The semantic diff shows **which objects** a branch changes, each **Before | After** with the
smallest example, linked to the spec's statements. The idea comes from ReScript's semantic
diff ([rescript#8908](https://github.com/rescript-lang/rescript/pull/8908)).

## When a record is needed

| The branch changes … | Change record | Review page + pull-request text |
|----------------------|---------------|---------------------------------|
| What the project delivers: code, scripts, prompts it ships, styles, configuration, dependencies | **Required** | **Required** |
| Only specs and documents | Not needed | **Required** (summary, highlights) |

## Files

```
.specs/changes/<name>/
  change_record.yaml          judgement: why, objects, examples, breaking, Q&A
  before/<id>/<example>.<ext>  produced, never edited by hand
  after/<id>/<example>.<ext>   produced, never edited by hand
  semantic_diff.md            the text for the pull request's semantic-diff block
.specs/review/
  <yyyy-mm-dd>_<branch-slug>.html   the review page: the HTML report (from review_page.html)
  index.html                        all review pages, newest first (from index_page.html)
```

`<name>` = the branch without `feature/`, `/` → `-`. Moved to `.specs/changes/done/<name>/`
when the spec is closed.

## Writing the record

1. **Only judgement.** Why, which objects, which examples, breaking, Q&A. Never restate what
   the diff shows (files, line counts).
2. **One block per object** — a command, an endpoint, a file format, a screen — not per file.
3. **The smallest example** that shows the change and runs on both sides (for `added`, Before
   is absent).
4. **Link the spec:** each block lists its `S<n>`; the record lists all of them.
5. **`manual` is the exception,** always with `manual_reason`.
6. **Examples as block scalars** (`input: |`), because inputs contain `:` and `{`.
7. **Mask values that change on every run** (time stamps, ids, temporary paths), e.g.
   `"<timestamp>"`.

## Kinds

Each kind says what is captured and how both sides are produced. Use the project's own tools.

| Kind | Object | How Before / After are produced | Shown as |
|------|--------|--------------------------------|----------|
| `command` | A command of a CLI, script or prompt, with its arguments | Its help text (`--help`, `Get-Help`), or its usage block in the file that defines it | text |
| `api` | One endpoint's contract | The generated API description (e.g. OpenAPI) reduced to the path and the schemas it uses | JSON |
| `schema` | A data type or model | Its JSON schema, or the type declaration | JSON / code |
| `data-format` | A file the program writes or reads | Run the writer on a small input in a temporary folder; keep the file | JSON / text |
| `output` | A result for an input | Run the example (function call, command, request); for HTTP keep status and body | text / JSON / image |
| `ui` | A screen in a given state | A screenshot of the route and state, same viewport and mocked data on both sides | image pair |
| `tokens` | Design tokens / CSS custom properties | The resolved `{name: value}` per theme | table |
| `message` | A text shown to the user or logged | Trigger it and capture the text | text |
| `config` | Settings, environment variables, settings-file keys | The settings with their defaults | table |
| `dependency` | Direct dependencies | The dependency sections of the build files | table |
| `performance` | A measured number | Run the command three times per side; the median | table |

## Checks

| # | Check | Severity when it fails |
|---|-------|------------------------|
| C1 | A record exists when it is required | Should-fix |
| C2 | The record passes `change_record.schema.json` | Should-fix |
| C3 | Every `S<n>` exists in the linked spec | Should-fix |
| C4 | Every block's object really differs Before / After | Should-fix |
| C5 | Changes a tool can detect (commands, endpoints, settings, dependencies, tokens) have a block | Should-fix |
| C6 | `api` / `schema` changes come with changes of the API contracts / data model, if the project has them | Should-fix |
| C7 | `output` / `api` / `command` changes of code come with test changes | Nit |
| C8 | `ui` / `tokens` changes come with changes of the UI catalog / looks, if the project has them | Nit |
| C9 | Added dependencies have a plan decision or an ADR | Should-fix |
