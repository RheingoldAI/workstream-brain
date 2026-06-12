# How the brain works

> A single-page mental model of the `workstream-brain` framework — for someone landing here for the first time, or for someone deciding whether to build one for their own workstream.

A brain isn't a chatbot, a knowledge base, or a single magic file. It's an **architecture**: a folder of structured files that, when opened in an agentic coding tool (Claude Code), makes the agent an instant collaborator on your workstream — and *stays current* without anyone hand-curating it.

---

## The three layers

Everything in a brain falls into one of three layers, each doing a different job.

### Layer 1 — Auto-load surface (cheap, always-on)

When you open the brain folder, **`CLAUDE.md` auto-loads** as context. It's a one-page index — "where to look for what" — pointing at the docs, queries, and skills. This is the routine-answers layer: a question like *"where's the definition of an active user?"* gets answered instantly without any further loading.

| File | Role |
|---|---|
| `CLAUDE.md` | The auto-loaded index. Tells the agent what's in the brain and where to find it. Keep it short — it's paid for on every session. |
| `GETTING_STARTED.md` | New-user onboarding. |
| `docs/` | Glossary, schema reference, working queries, methodology learnings, project overview. The hand-curated knowledge base. |
| `README.md` | Public-facing overview + install. |

The art of Layer 1 is the **index, not the encyclopedia**. `CLAUDE.md` shouldn't *contain* the knowledge — it should route to it. A bloated auto-load file taxes every session; a good one is a table of contents that says "for X, read `docs/Y`."

### Layer 2 — Deep-prime + execute (skill-driven)

For heavier work, **slash commands** load deeper context or run multi-step flows on demand. This framework ships three:

| Slash command | What it does | When to use |
|---|---|---|
| `/brain` | Deep-prime for a work session — loads project state, schema, working queries, gotchas, methodology canon. | Starting a heavy analytical session, a doc draft, a methodology debate. |
| `/weekly-update` | Maintains an inbox of inputs through the week (intake mode), then synthesizes them into a clean status doc on demand (publish mode). | A recurring comms cycle. |
| `/daily-context` | Pulls the last 24h of relevant calendar / email / chat activity, summarizes with named attribution, writes a per-day file + regenerates the rolling rollup. | Nightly via a scheduler; on-demand for backfill. |

Each skill lives in `.claude/skills/<name>/SKILL.md` and stands alone with its own reference/config files.

### Layer 3 — Persistent archives (the durable record)

This is where the brain compounds. Output from Layer 2 is written *here* — not into chat, not into throwaway files.

| Archive | Contents | Refresh cadence |
|---|---|---|
| `weekly-updates/update-<date>.*` | Permanent archive of every published status update. | Every publish (~weekly). |
| `context/daily/<date>.md` | Per-day capture of relevant meetings, emails, threads. Named attribution, paraphrased. | Nightly. |
| `context/rolling/last-7-days.md` | Regenerated 7-day synthesis: trend themes, active decisions, open questions, people changes. | Nightly (rebuilt from scratch). |
| `docs/` snapshots, decision logs | Dated captures of anything worth freezing in time. | Per snapshot. |

The payoff: a fresh `git pull` of the brain is always a fresh state of the work. The agent reading it gets the same picture you have.

---

## How it stays current

Three loops keep the brain from going stale:

```
┌───────────────────────────────────────────────────────────────────┐
│                                                                   │
│   NIGHTLY                                                         │
│   /daily-context  ──►  context/daily/<date>.md                    │
│       │                context/rolling/last-7-days.md             │
│       └─►  pulls calendar + email + chat via MCP connectors       │
│           filters via .claude/skills/daily-context/config.md      │
│                                                                   │
│   WEEKLY                                                          │
│   /weekly-update  ──►  weekly-updates/update-<date>.*             │
│       │                .claude/skills/.../reference/history.md     │
│       └─►  reads inbox + reference/format.md → renders the doc     │
│                                                                   │
│   AS-NEEDED                                                       │
│   Direct edits to docs/, queries/ when new schema, gotchas,       │
│   or methodology learnings land.                                  │
│                                                                   │
└───────────────────────────────────────────────────────────────────┘
```

The nightly and weekly loops are the engine. The as-needed edits are how the *knowledge* (not just the activity log) deepens over time — every gotcha you hit once gets written into `docs/methodology-learnings.md` so neither you nor the agent rediscovers it.

---

## What runs where

| Action | Lives where | Triggered by |
|---|---|---|
| Auto-load index | `CLAUDE.md` | Opening the folder |
| Routine answers | `docs/` | Agent reads on demand |
| Heavy sessions | `/brain` | You invoke |
| Comms cycle | `/weekly-update` | You invoke (intake) + on publish day (publish) |
| Daily capture | `/daily-context` | Scheduler (nightly) or on demand |
| Permanent archives | `context/`, `weekly-updates/` | Written by skills + occasional hand commits |

---

## Two postures the framework bakes in

These aren't incidental — they're what make a brain safe to keep and trustworthy to read.

**Privacy posture.** The capture loops summarize with **named attribution but paraphrased — never verbatim quotes**. The brain records *that Dana raised a concern about the retention denominator*, not a transcript of what Dana said. This keeps the archive useful as a decision record without turning it into a surveillance log of your colleagues. (See any `context/daily/*.md` for the style.)

**Idempotency.** Loops are safe to re-run. Daily capture **merges** into the day's file rather than duplicating; the rolling rollup is **regenerated from scratch** every run rather than appended to. A failed or repeated run never corrupts the archive.

---

## How you'd adapt this for your own workstream

The architecture transfers cleanly to any workstream that has:

1. **Knowledge worth priming an agent on** (schemas, glossaries, methodology gotchas, working queries) → write your own `CLAUDE.md` + `docs/` + adjust the `/brain` skill.
2. **A recurring comms cycle** (weekly status, monthly review) → adapt `/weekly-update` by editing `reference/format.md` and dropping in a style template. The intake-then-publish pattern transfers as-is.
3. **Async activity worth capturing** (meetings, threads, decisions that evaporate) → adapt `/daily-context` by editing `config.md` — swap in your keywords, your people, your whitelisted meetings and channels. The skill re-reads config on every run, no code change needed.

**What you keep:** the shape, the privacy posture, the idempotency rules.
**What you replace:** only the content — your domain, vocabulary, cadences, people.

See [`ADAPTING.md`](ADAPTING.md) for the step-by-step.

---

## Where to read next

- **To set it up:** [`GETTING_STARTED.md`](GETTING_STARTED.md)
- **To adapt it to your workstream:** [`ADAPTING.md`](ADAPTING.md)
- **To see the example knowledge base:** [`docs/project-overview.md`](docs/project-overview.md) and [`docs/methodology-learnings.md`](docs/methodology-learnings.md)
