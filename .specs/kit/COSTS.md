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
| Claude Code | **measured** | The session file (`~/.claude/projects/<project>/*.jsonl`) logs the tokens of every model response; each response is counted once. |
| VS Code Copilot | **estimated** (`~`) | The chat transcript has the text of every turn but no token counts, so the script estimates them (below). |

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
sub-agents may be missing from the transcript.

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
2. **At the end**, run `tools/usage` with that time and your model, then copy:
   - Stage log columns **Tokens (estimate — see COSTS.md)** and **Cost (<currency>)**:
     `~379 k (40 k in · 334 k cached · 5 k out)` and `~CHF 0.30 (36 credits)`;
   - a Step's Done line ends with `· ~<tokens> · ~<currency> <amount>`.
3. If the script fails or finds no transcript, write `N/A` and say why in the report — never
   a guessed number.
4. Every cost number in a spec, the cost list or a pull request comes with the link to this
   page.
