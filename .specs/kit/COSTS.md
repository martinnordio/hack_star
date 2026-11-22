# Tokens and cost

> **All costs are estimates and may be wrong.** The prices, the plan, the exchange rate and
> the method below can be outdated or edited by anyone in the settings, so a spec can carry
> wrong numbers — also in public repositories. The real usage is on your GitHub billing page
> (Settings → Billing → Usage), or your tool's own usage page.

With cost tracking on, every stage writes the tokens it used and their price into the spec:
in its **Stage log** row, on every Step's **Done** line, and — when the spec is closed — in a
**Cost summary** above Part 1 and in `.specs/costs.md`, the list of all specs.

## Switch it on or off

The `cost` block of `.specs/spec-nx.json` (written by the first `GENERATE KIT`, changed by
hand). **No `cost` block, or `"enabled": false`: nothing is calculated or written.**

```json
"cost": {
  "enabled": true,
  "plan": "Copilot Business",
  "monthly_price_usd": 19,
  "monthly_credits": 1900,
  "currency": "CHF",
  "rate": 0.8384,
  "rate_date": "2026-11-13"
}
```

A developer can override any key in `.specs/spec-nx.local.json` (for example another
currency and rate, or `"enabled": false`). Optional keys: `prices` (credits per 1 M tokens per
model, for tools that do not publish them) and `base_tokens` (see below).

## What the numbers mean

- **Cost = the value of the GitHub AI credits used,** at GitHub Copilot's per-token rates for
  the model that ran (1 credit = $0.01). It is **not an invoice**: within your plan's monthly
  credits nothing extra is paid; only usage beyond them is billed.
- **Share of the plan** = credits ÷ the plan's monthly **base** credits (Business 1,900,
  Enterprise 3,900, Pro 1,000, Pro+ 3,900, Max 10,000). The variable "flex" part of the
  individual plans is left out.
- **Local currency** = USD × `rate` (units of your currency per USD, from `rate_date`).
- **Not counted:** discounts (for example for auto model selection), promotions, and work
  done outside the chat of the stage.

## How tokens are counted

The script `tools/usage.ps1` does it; the stages copy its output and never
compute by hand.

| Tool | Tokens are | How |
|------|------------|-----|
| Copilot CLI (also the VS Code "agent host" chats it runs) | **measured** | The session log (`~/.copilot/session-state/<session>/events.jsonl`) records every model request with its tokens and the AI credits billed (`session.usage_record`), sub-agents included; the script adds them up. No price list needed. |
| Claude Code | **measured** | The session file (`~/.claude/projects/<project>/*.jsonl`) logs the tokens of every model response; each response is counted once. |
| VS Code Copilot | **estimated** (`~`) | The chat transcript has the text of every turn but no token counts, so the script estimates them (below). |

Without `-Transcript`, the script checks every log of **this project** (CLI sessions whose
folder is the project or inside it, VS Code chats of this workspace, Claude Code sessions)
written since the start time, and uses the one with the most requests in the time range. It
names that log in its `Source:` line. If it finds no request, it **stops with an error** and
lists the logs it checked — it never reports 0.

**The estimate**, for every model request in the time range of the stage or Step:

1. **Context** = `base_tokens` (system prompt, tools and summary; default 35,000) + the text
   of every event of the chat so far ÷ 4 characters per token — counted from the start of the
   chat, and set back to `base_tokens` when it passes the context cap (200,000 tokens by
   default), where the tool summarizes the chat.
2. **Cached input** = the context of the previous request (the tool re-sends it; the model
   reads it from its cache).
3. **New input** = context − cached input, priced at the cache-write rate (input rate if the
   model has none).
4. **Output** = the text of the assistant's messages and tool calls ÷ 4.
5. **Credits** = (new input × cache-write rate + cached × cached rate + output × output rate)
   ÷ 1,000,000, with the rates in credits per 1 M tokens.

Known limits: 4 characters per token is an average; the real system prompt size is unknown;
the real summary point is unknown; a cold cache after a break costs more than counted; work of
sub-agents may be missing from the transcript. **VS Code transcripts hold no tool results**
(only `"success": true`), so file contents, test and terminal output are not counted — the
estimate can be several times too low. The model list has only the list price, so requests
billed at a higher tier (for example Claude Haiku above ~100 k prompt tokens, 5×) are counted
too low. Measured numbers (Copilot CLI, Claude Code) have none of these limits.

## Where prices and values come from

| Value | Source | Date |
|-------|--------|------|
| Model rates (credits per 1 M tokens) | The tool's model list (VS Code Copilot keeps it next to the transcript); GitHub's public page *Models and pricing for GitHub Copilot*; otherwise `cost.prices` | read at run time |
| Plans, prices, credits | docs.github.com/en/copilot/get-started/plans | 2026-11-14 |
| 1 credit = $0.01 | docs.github.com/en/copilot/concepts/billing-and-usage/individuals/billing | 2026-11-14 |
| CHF per USD 0.8384 | European Central Bank reference rate | 2026-11-13 |

## What the stages write (rules for the stage prompts)

Only when cost tracking is on.

1. **At the start** of a command, note the time (`Started:` for a Step).
2. **At the end**, run `tools/usage` with that time and your model (and `-Until` when the
   command is over before the next one starts), then copy:
   - Stage log columns **Tokens (estimate — see COSTS.md)** and **Cost (<currency>)**:
     `~379 k (40 k in · 334 k cached · 5 k out)` and `~CHF 0.30 (36 credits)` — measured
     numbers have no `~`;
   - a Step's Done line ends with `· ~<tokens> · ~<currency> <amount>`.
   A Step run by a sub-agent is counted from the sub-agent's start to its end; the script
   includes the sub-agent's requests. In a **per-Step run** with a Copilot CLI log, measure
   each Step with `-Agent subagents` over its sub-agent's time, and add one Stage log row
   for the **orchestrator** (the chat that starts the sub-agents, checks and commits) with
   `-Agent main` over the whole run — so Steps plus orchestrator equal the run's total and
   nothing is counted twice or left out. The `Split:` line shows both parts. When agents run
   other agents (a spec runner), give every agent a unique name and count each one with
   `-AgentName <name>` — every Stage log row is then exactly one agent's requests.
3. **Never leave the cells empty, and never guess.** If the script stops with an error, read
   it: fix the start time, or pass the right log with `-Transcript` (for the Copilot CLI:
   `~/.copilot/session-state/<session>/events.jsonl`; the current session's folder is the
   newest one whose `workspace.yaml` names this project). Only if it still fails, write `N/A`
   and copy the script's error into the Note column and the report. `—` (dash) is only for a
   command that used no model.
4. **One run, several specs:** when one command writes several specs, the first spec's row
   gets the numbers and the others say `included in <spec>`, so nothing is counted twice.
5. Every cost number in a spec, the cost list or a pull request comes with the link to this
   page.
