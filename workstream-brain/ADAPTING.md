# Adapting this brain to your workstream

> This repo ships as a worked example (the fictional "Skylark × Insights" product-analytics workstream). This guide tells you exactly what to replace to make it *yours*. The architecture stays; only the content changes.

The whole adaptation is: **rewrite Layer 1 (your knowledge), retune Layer 2 (your skills' config), clear Layer 3 (your loops will repopulate it).** Budget an afternoon for a first pass — most of the time goes into the knowledge base, which is exactly where it should go.

---

## Before you start: is your workstream a fit?

A brain pays off when your workstream has at least two of these three. (If it has all three, it's an ideal fit.)

1. **Knowledge worth priming an agent on** — a schema, a glossary, methodology gotchas, working queries. The kind of thing you currently re-explain every session.
2. **A recurring comms cycle** — a weekly/bi-weekly status update, a monthly review.
3. **Async activity worth capturing** — meetings, threads, and decisions that evaporate if no one writes them down.

If your workstream has none of these, you probably want a single CLAUDE.md, not a brain.

---

## Step 1 — Rewrite Layer 1 (the knowledge). This is 90% of the value.

This is the only hard part, and it's hard because it's *yours* — no template can write your domain knowledge for you. Work through these files in order. The fastest way is to open the brain in Claude Code and **talk** the knowledge out — describe your workstream and have the agent draft each file, then correct it.

| File | Replace with | Tip |
|---|---|---|
| `CLAUDE.md` | Your one-paragraph workstream description + a "where to look for what" table pointing at your docs + your default working assumptions. | Keep it short. It loads every session. It's an **index**, not the encyclopedia. |
| `docs/project-overview.md` | Your workstreams, current status, stakeholders, open dependencies. | Date your status lines so staleness is visible. |
| `docs/domain-glossary.md` | Every term a newcomer (or the agent) would have to ask about. | If you've ever explained a term twice, it belongs here. |
| `docs/data-sources-and-schema.md` | Where each signal lives — tables, fields, log lines, APIs — and the gotchas. | Document the field-name traps; they're the ones that bite. |
| `docs/working-queries.md` | Your proven queries, with caveats inline, organized by metric. | Copy runnable versions into `queries/`. |
| `docs/methodology-learnings.md` | Every gotcha that has wasted you hours. | Start it now and add to it forever. Highest-leverage file in the brain. |

> Not analytics work? The doc names are suggestions. A design-system brain might have `docs/components.md` + `docs/tokens.md`; a research brain might have `docs/sources.md` + `docs/open-questions.md`. Keep the *shape* (a short index routing to focused docs); rename the contents.

Then delete the Skylark-specific files you don't need and update `CLAUDE.md`'s routing table to match.

---

## Step 2 — Retune Layer 2 (the skills)

You don't rewrite the skills — you retune their config. Each skill ends with an **"Adapting this skill"** section; here's the summary.

### `/brain` — `.claude/skills/brain/SKILL.md`

Edit the list of files it reads on deep-prime so it matches your `docs/`. If you renamed docs in Step 1, update the references. This is usually a 2-minute edit.

### `/daily-context` — `.claude/skills/daily-context/config.md`

This is the one you'll spend the most time on. Edit `config.md`:
- **Keywords** that mark activity as relevant to your workstream.
- **People** (your v-team / core collaborators) whose activity is always relevant.
- **Whitelisted meeting series and chat channels** that are always in-scope.

The skill re-reads `config.md` on every run — no code to touch. Confirm which data-source MCP connectors you have (calendar, email, chat, docs); the skill uses whatever is connected and skips the rest.

### `/weekly-update` — `.claude/skills/weekly-update/reference/`

- `reference/format.md` — the structure and tone of your update (sections, ordering, voice).
- `reference/history.md` — clear the example history; it'll grow as you publish.
- Drop in a **style template** for the rendered doc (the example uses a Pandoc reference doc). Point the skill's render step at it.
- Set the **inbox path** (where intake inputs are stored) and, if you publish to a shared doc, note its location.

---

## Step 3 — Clear Layer 3 (the archives)

The loops repopulate these, so just empty the example content:

- `context/daily/` — delete the example day files.
- `context/rolling/last-7-days.md` — will be regenerated on the next `/daily-context` run.
- `weekly-updates/` — delete the example updates (keep the `README.md`).

---

## Step 4 — Set the loops running

- **Nightly `/daily-context`:** schedule it. On Windows, Task Scheduler invoking Claude Code headless; on macOS/Linux, a `cron` entry or `launchd` job. Pick a time after your workday (e.g. 6 PM) so it captures the full day.
- **Weekly `/weekly-update`:** mostly human-triggered — intake through the week, publish on your comms day.

---

## What you keep vs. what you replace

| Keep (the framework) | Replace (the content) |
|---|---|
| The three-layer shape | Your domain, schema, vocabulary |
| The three skills' structure | The skills' config (keywords, people, format) |
| Named-attribution-but-paraphrased privacy posture | — |
| Idempotency rules (merge daily, regenerate rollups) | — |
| The "index, not encyclopedia" rule for `CLAUDE.md` | The index contents |

---

## A note on what *not* to put in a brain

A brain lives in version control and is meant to be shared and pulled. Keep out of it:

- **Secrets and credentials** — use your tool's auth (MCP connectors, env vars), never hardcode.
- **Verbatim private conversations** — paraphrase with attribution; don't transcribe.
- **Anything you wouldn't want a new teammate to read** — the brain *is* the new-teammate onboarding.

A good brain is something you'd be comfortable handing to someone on day one. Build it that way from the start.
