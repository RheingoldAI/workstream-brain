# Getting started with workstream-brain

> From "I just cloned this" to "I'm working with the brain" in about 10 minutes. This walks you through the **example** brain. To rewire it for your own workstream, read [`ADAPTING.md`](ADAPTING.md) afterward.

---

## What this is, in one sentence

A folder of files that, when you open it in [Claude Code](https://www.anthropic.com/claude-code), makes the agent an instant expert on a workstream — its schema, queries, gotchas, and history — and keeps that expertise current through scheduled skills.

---

## Step 1 — Get it locally

```bash
git clone https://github.com/<you>/workstream-brain.git
cd workstream-brain
```

---

## Step 2 — Open it in Claude Code

```bash
claude
```

…from the repo root, or open the folder in the Claude Code IDE extension. When it opens, `CLAUDE.md` auto-loads as context. The agent now knows it's working on the (example) Skylark × Insights workstream.

> **Important:** open the **repo root**, not a parent or subfolder — otherwise `CLAUDE.md` won't auto-load and the agent won't be primed.

---

## Step 3 — Confirm orientation worked

Ask:

> *"Give me a quick overview of where this workstream stands."*

You should get a summary mentioning the active-user definition, the retention dashboard, and the open dependencies — pulled from `docs/project-overview.md`. If you get a generic "I don't have context" answer, you're not in the repo root (see Step 2).

---

## Step 4 — Try the core moves

**Get a working query:**

> *"Write me a query for weekly active users, split internal vs external."*

The agent produces runnable SQL that uses the canonical `content_edited` signal, filters cheaply first, and classifies internal vs external at the account level — because those patterns are in `docs/working-queries.md` and `docs/methodology-learnings.md`.

**Debug a query:**

> *"This returns way more users than expected: `SELECT count(distinct user_id) ... WHERE event_name = 'app_opened'`. What's wrong?"*

The agent cross-references `methodology-learnings.md` and tells you `app_opened` is the wrong signal (fires on every tab focus) — use `content_edited`.

**Deep-prime explicitly:**

Type `/brain` to load the full project state for a heavy session.

---

## Step 5 — The skills that keep it current

**`/daily-context`** — pulls the day's relevant calendar / email / chat activity through your MCP connectors, summarizes it (named attribution, paraphrased), and writes `context/daily/<date>.md` plus a regenerated `context/rolling/last-7-days.md`. Designed to run nightly on a scheduler; invoke it by hand to backfill. If you haven't connected any data sources, it'll say so and skip them — the framework still stands.

**`/weekly-update`** — two modes:
- **Intake:** drop inputs as they arrive ("here's the note from eng", a pasted update, a file path). Each is saved to a local inbox.
- **Publish:** say "publish" and it synthesizes everything into the new week's section against the prior weeks' format, renders a clean doc, and archives it in `weekly-updates/`.

Optional for a polished rendered doc: install [Pandoc](https://pandoc.org/) (`winget install --id JohnMacFarlane.Pandoc` on Windows, `brew install pandoc` on macOS). Without it, `/weekly-update` falls back to Markdown.

---

## Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| Agent doesn't know about the workstream | `CLAUDE.md` not auto-loading | Open the **repo root** in Claude Code, not a sub/parent folder |
| `/brain`, `/daily-context`, `/weekly-update` not recognized | Skills not picked up | Confirm `.claude/skills/<name>/SKILL.md` exists; restart Claude Code |
| `/daily-context` returns nothing | No data-source MCP connectors configured | Connect calendar/email/chat MCPs, or run it on a day with activity |
| `/weekly-update` render fails | Pandoc not installed | Install Pandoc, or accept the Markdown fallback |

---

## Once you're comfortable

- Read [`HOW_IT_WORKS.md`](HOW_IT_WORKS.md) for the architecture mental model.
- Read [`ADAPTING.md`](ADAPTING.md) to rewire this for your own workstream.
- Browse `docs/methodology-learnings.md` — it's the highest-leverage file; it's where "things that wasted hours" go to never waste hours again.
