# workstream-brain

**A reusable framework for building a living, self-updating "brain" for any ongoing workstream — open it in [Claude Code](https://www.anthropic.com/claude-code) and your AI collaborator is instantly an expert on your project, and *stays* expert without anyone hand-curating it.**

> A "brain" is not a chatbot, a wiki, or a single magic prompt file. It's an **architecture**: a folder of structured files that, when opened in an agentic coding tool, makes the agent an instant collaborator on *your* workstream — schema, vocabulary, decisions, gotchas, history — and refreshes itself on a schedule so a fresh `git pull` is always a fresh picture of the work.

> **This is a real, working brain — not a toy demo.** The framework here is extracted from a brain I run daily inside a large enterprise organization, against live production data and real cross-team use cases. This public version has been **fully scrubbed**: the proprietary domain, data, schema, people, and infrastructure are replaced with a fictional product-analytics workstream ("Skylark"). The *architecture* is exactly what runs in production; only the *content* is invented.

This repo gives you both:

1. **The framework** — the file layout, the auto-load index, three reusable skill patterns, and an [`ADAPTING.md`](ADAPTING.md) guide for rewiring it to your own domain.
2. **A fully worked example** — a fictional product-analytics workstream ("Skylark") filled in end to end, so you can *see* the pattern working before you adapt it. Everything under the example is invented; swap it for your own content.

---

## Why this exists

If you do knowledge work on a long-running project — a PM, an analyst, a researcher, an eng lead — you've felt this:

- You re-explain the same context to your AI assistant every session.
- Hard-won lessons ("don't use *that* signal for active users", "this query times out unless you filter first") live in your head or scattered across chat logs, and evaporate.
- Status updates, daily context, and decisions get rewritten from scratch every cycle.

A brain fixes all three by giving your agent a **persistent, structured, self-refreshing memory of the workstream** that lives in version control next to the work.

---

## The three-layer architecture

Everything in a brain falls into one of three layers, each doing a different job. (Full mental model: [`HOW_IT_WORKS.md`](HOW_IT_WORKS.md).)

| Layer | What it is | Cost | Example files |
|---|---|---|---|
| **1 — Auto-load surface** | A one-page index that loads automatically when you open the folder, plus a hand-curated knowledge base. Answers routine questions instantly. | Cheap, always-on | `CLAUDE.md`, `docs/` |
| **2 — Skills** | Slash commands that load deep context or run multi-step flows on demand. | On invoke | `.claude/skills/*` |
| **3 — Persistent archives** | The durable record. Skills write *here*, not into chat — so the work compounds. | Written by skills | `context/`, `weekly-updates/` |

```
  open folder ──► CLAUDE.md auto-loads ──► agent knows the workstream
       │
       ├─ routine question?  ─► agent reads docs/ on demand               (Layer 1)
       ├─ heavy session?     ─► /brain deep-primes on full state          (Layer 2)
       ├─ nightly?           ─► /daily-context captures the day ─┐        (Layer 2)
       └─ weekly?            ─► /weekly-update synthesizes  ──────┤        (Layer 2)
                                                                  ▼
                                          context/, weekly-updates/        (Layer 3)
                                          (durable, version-controlled)
```

---

## The three skills (the "stays current" engine)

| Slash command | Pattern | What it does |
|---|---|---|
| `/brain` | **Deep-prime** | Loads full project state — overview, glossary, schema, working queries, gotchas — at the start of a heavy work session. |
| `/daily-context` | **Capture loop** | Pulls the day's activity from your connected sources (calendar / email / chat via MCP connectors), summarizes it with named attribution, and writes a per-day file + a regenerated rolling rollup. Runs nightly on a scheduler, or on demand. |
| `/weekly-update` | **Synthesis loop** | Collects inputs all week (intake mode), then on demand synthesizes them into a clean, formatted status doc against a style template (publish mode). |

Each skill is self-contained in `.claude/skills/<name>/` and carries its own config/reference files. Each ends with an **"Adapting this skill"** section telling you exactly what to edit for your workstream.

---

## Repository layout

```
workstream-brain/
├── README.md                  ← you are here
├── HOW_IT_WORKS.md            ← one-page architecture mental model
├── GETTING_STARTED.md         ← 10-minute setup walkthrough
├── ADAPTING.md                ← how to fork this for YOUR workstream
├── LICENSE
│
├── CLAUDE.md                  ← Layer 1: the auto-loaded index ("where to look for what")
│
├── .claude/
│   └── skills/                ← Layer 2: the three skills
│       ├── brain/SKILL.md
│       ├── daily-context/{SKILL.md, config.md}
│       └── weekly-update/{SKILL.md, reference/{format.md, history.md}}
│
├── docs/                      ← Layer 1: hand-curated knowledge base
│   ├── project-overview.md       workstreams, status, stakeholders, open dependencies
│   ├── domain-glossary.md        every term a newcomer would have to ask about
│   ├── data-sources-and-schema.md   where each signal lives + the gotchas
│   ├── working-queries.md        proven queries with caveats inline
│   └── methodology-learnings.md  every gotcha that wasted you hours, in one place
│
├── queries/                   ← runnable artifacts referenced by the docs
│
├── context/                   ← Layer 3: auto-generated daily/rolling activity record
│   ├── daily/<date>.md
│   └── rolling/last-7-days.md
│
├── weekly-updates/            ← Layer 3: permanent archive of every published update
│
└── templates/                 ← blank versions of every file, for adapting cleanly
```

> **Everything outside `templates/` is a worked fictional example** (the "Skylark" product-analytics workstream). It exists to show the pattern in motion. When you adapt this, you'll replace the example content with your own — `ADAPTING.md` walks you through it.

---

## Install & run

**Prerequisite:** [Claude Code](https://www.anthropic.com/claude-code) (or any agentic tool that auto-loads a context file from the project root).

```bash
git clone https://github.com/<you>/workstream-brain.git
cd workstream-brain
claude        # or: open the folder in your Claude Code IDE
```

`CLAUDE.md` auto-loads. Try:

> *"Give me an overview of where this workstream stands."*
> *"Write me a query for weekly active users."*
> *"This query returns no rows — what's wrong? [paste]"*
> `/brain` — explicit deep-prime for a heavy session.

Full walkthrough: [`GETTING_STARTED.md`](GETTING_STARTED.md).

Two skills (`/daily-context`, `/weekly-update`) reach external data through **MCP connectors** — calendar, email, chat, doc storage. They degrade gracefully if a connector isn't configured (they just skip that source). `/weekly-update`'s document render uses [Pandoc](https://pandoc.org/) (optional; falls back to Markdown). See each skill's SKILL.md.

---

## Make it yours

The architecture transfers to any workstream that has **(a)** knowledge worth priming an agent on, **(b)** recurring activity worth capturing, and **(c)** a recurring comms cycle. Read [`ADAPTING.md`](ADAPTING.md) — the short version:

1. Rewrite `CLAUDE.md` and `docs/` for your domain (this is 90% of the value and the only hard part).
2. Edit `.claude/skills/daily-context/config.md` — your keywords, your people, your meeting/channel whitelist.
3. Edit `.claude/skills/weekly-update/reference/format.md` and drop in a style template.
4. Delete the `context/` and `weekly-updates/` example contents — your loops will repopulate them.

What you **keep**: the shape (auto-load surface + skills + archives), the privacy posture (named attribution, paraphrased, no verbatim quotes), and the idempotency rules (merge on rerun, regenerate-from-scratch for rollups). What you **replace**: only the content.

---

## Design trade-offs

A few decisions I made building this, and what I traded away for what:

- **Flat Markdown files in git — not a database, vector store, or RAG index.** I wanted the brain to be human-readable, diff-able, reviewable in a PR, and runnable with zero infrastructure. The cost is no semantic retrieval and no scaling to millions of documents — but a workstream brain is meant to be *scoped*, and at that size legibility and version control beat retrieval sophistication. A fresh `git pull` being a fresh picture of the work is worth more than a fancier index.

- **`CLAUDE.md` is an index, not an encyclopedia.** It auto-loads on every session, so every token in it is paid for constantly. I kept it as a routing table that points at `docs/` rather than inlining the knowledge. The trade is one extra read-hop when the agent needs detail, in exchange for a cheap, fast, always-on surface.

- **Three deterministic skills, not a free-form agent.** The capture and synthesis loops are explicit, repeatable flows with strict idempotency rules (merge the daily file; regenerate the rollup from scratch). That's less flexible than letting the agent improvise each run, but it's what makes the loops safe to schedule unattended and safe to re-run — which is the whole point of a record that's supposed to compound rather than corrupt.

- **Named attribution, but paraphrased — never verbatim.** The activity record names who raised what; it never transcribes. This deliberately loses exact wording. I chose it because a brain that's safe to keep, share, and hand a new teammate is far more valuable than one that reads like a surveillance log of colleagues — and the *decisions*, not the quotes, are what you actually need three weeks later.

- **`docs/` definitions are canon; dashboards defer to them.** When a shipped number disagrees with a documented definition, the definition wins (or the doc is stale and gets fixed). This forces a single source of truth at the cost of discipline — someone has to keep the docs honest — but it's the only thing that stops three teams from quietly reporting three different "active user" numbers. (That exact problem is why the brain exists.)

- **Human-in-the-loop on the weekly publish.** Daily capture runs unattended; the outward-facing weekly update is human-triggered. I automated the gathering and the drafting but kept a person on the final synthesis — the cost of an automated status note being subtly wrong to leadership is higher than the time full automation would save.

- **Coupled to Claude Code's native mechanics.** The brain leans on `CLAUDE.md` auto-load and `.claude/skills/` rather than staying tool-agnostic. That limits portability to other agents, but using the native surface is exactly what makes "open the folder and you're primed" work with no glue code.

- **One brain per workstream, not one mega-brain.** I keep brains scoped to a single workstream so deep-priming stays cheap and relevant. A giant everything-brain dilutes the auto-load surface and makes every session more expensive. The trade is that cross-workstream knowledge lives in separate folders rather than one place.

---

## License

MIT — see [`LICENSE`](LICENSE). Use it, fork it, build your own brain.
