# Models (shared by every stage)

Which AI model runs a stage or a Step, and what to do when the chat runs on another one.
Every stage prompt follows this file before it does any work.

## Read the setting

`models` from `.specs/spec-nx.local.json` if the key is there (also when it is `null`),
otherwise from `.specs/spec-nx.json`:

| `models` | Meaning |
|----------|---------|
| missing or `null` | **No model handling.** Use the model selected in the tool; check, switch and ask nothing. Stop reading this file. |
| `{ "fixed": "<model>" }` | Every stage and Step runs on that model. |
| `{ "reasoning", "standard", "light", "guide" }` | **Per Step:** the tier below decides the model. |

## Which tier

| Stage | Tier |
|-------|------|
| requirements (`REQUIREMENTS:`, `CREATE ISSUE:`, `UPDATE ISSUE:`) | reasoning |
| plan (`PLAN:`) | reasoning |
| implementation (`IMPLEMENT:`) | the Step's tier in the **Model (suggested)** column of the spec; `standard` if the Step has none |
| implementation (`CLOSE:`) | standard |
| review (`REVIEW:`, `CODE REVIEW:`) | reasoning |
| improvement (`IMPROVE:`) | reasoning |
| documentation (`DOCS:` …) | standard |
| pr (`PR:`) | light |

## Check before any work

1. **Compare** the configured model with the model you run on (your runtime's name for it).
   Same model: go on.
2. **Another model:** run the stage's work as a **sub-agent** on the configured model where
   the tool allows it, and pass it the whole command, the files it needs and this rule set:
   - VS Code Copilot (agent mode): the sub-agent tool with the model `"<model> (copilot)"`;
   - Claude Code: a sub-agent (Task) with the model alias (`opus`, `sonnet`, `haiku`) or name.

   Where the tool has no sub-agents with a model choice, **stop and ask**: *"This stage is set
   to run on <model>; you are on <current>. Switch the model and run it again, or continue on
   <current>?"* — continue only when the user says so.
3. **The configured model does not exist** (the tool refuses it, or it is not in the tool's
   model list): stop before any work, show the mapping, suggest the nearest available model of
   the same kind and ask:
   *"<model> is not available. Use <suggestion> instead — for the team (`.specs/spec-nx.json`)
   or only for you (`.specs/spec-nx.local.json`)?"* Save the answer in that file, say so in
   the report, then continue. Never fall back to another model silently.

## Record what ran

- The Stage log row names the model that **ran** (the **Model name** rule of each prompt).
- When it differs from the configured one, the Note says `suggested: <tier> (<model>) · ran:
  <model>`.
- The implementation stage also writes this on every Done line (its prompt says how).
