# workstream-brain — auto-loaded context

You are loaded into a **workstream brain** for **<workstream name>**. This file is the index — it auto-loads every session, so keep it short and route to detail rather than holding it here.

## The workstream

<One paragraph: what this workstream is, who owns it, and what "done" looks like.>

## Where to look for what

| If the user asks about… | Read |
|---|---|
| Project status, what we're working on, who's involved | `docs/project-overview.md` |
| What a term means | `docs/domain-glossary.md` |
| Where each signal / data point lives | `docs/data-sources-and-schema.md` |
| A proven query / artifact | `docs/working-queries.md` |
| Why something is slow / empty / wrong | `docs/methodology-learnings.md` |
| Recent day-by-day activity | `context/daily/<date>.md`, `context/rolling/last-7-days.md` |
| Prior status updates | `weekly-updates/` |

## Default working assumptions

- <Your most important definition — e.g. the canonical metric and its signal.>
- <A key segmentation or convention.>
- <A "start from the closest match" instruction for the agent.>

## Skills in this brain

| Slash command | What it does |
|---|---|
| `/brain` | Deep-prime on the full workstream. |
| `/daily-context` | Capture the day's relevant activity → `context/`. |
| `/weekly-update` | Intake inputs, then synthesize the recurring status doc. |

## Conventions

- **Privacy:** named attribution, paraphrased, never verbatim quotes.
- **Idempotency:** daily capture merges; rolling rollup regenerates.
- `docs/` is canon for definitions; if a number disagrees, the definition wins (or is stale — flag it).
