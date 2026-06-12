# workstream-brain — auto-loaded context

You are loaded into a **workstream brain** — a structured folder that makes you an instant collaborator on an ongoing workstream. This file is the index. It auto-loads on every session, so it stays short and routes you to the right file rather than holding the knowledge itself.

> **This brain is a worked example.** The workstream below ("Skylark × Insights") is **fictional** — invented to demonstrate the framework. If you are adapting this brain for a real workstream, replace everything below the line with your own content. See `ADAPTING.md`.

---

## The workstream (example)

The **Insights team** is onboarding product telemetry from **Skylark**, a collaborative workspace app (shared docs + tasks). The goal: define Skylark's core usage metrics (active users, retention, feature adoption), build dashboards leadership trusts, and run a weekly cross-team status update. This brain holds the schema knowledge, the working queries, the hard-won gotchas, and the rolling activity record for that effort.

## Where to look for what

| If the user asks about… | Read |
|---|---|
| Project status, what we're working on, who's involved, open dependencies | `docs/project-overview.md` |
| What a term means (active user, account vs workspace, internal vs external, session types) | `docs/domain-glossary.md` |
| Which event / table / field carries which signal | `docs/data-sources-and-schema.md` |
| A proven query for an existing metric | `docs/working-queries.md` (runnable copies in `queries/`) |
| Why a query is slow, empty, or wrong | `docs/methodology-learnings.md` |
| Day-by-day activity (meetings, email, chat — paraphrased, named attribution) | `context/daily/<date>.md` |
| The rolling 7-day activity rollup | `context/rolling/last-7-days.md` |
| Prior weekly status updates | `weekly-updates/` |

## Default working assumptions (example)

- **Active user (DAU/WAU/MAU) — canonical signal:** at least one `content_edited` event for that `(account_id, user_id)` on the day. This is the *intent* signal — it fires when the user commits a change, whether or not the autosave later succeeds. Do **not** use `app_opened` (too broad — fires on every tab focus) or `edit_saved` (too strict — drops in-flight edits). Full rationale + the three-signal table: `docs/methodology-learnings.md`.
- **Internal vs External:** Internal = the Skylark company's own account (dogfooding), `account_id = 'acct_skylark_internal'`. External = all other accounts. Cut is account-level, not user-level.
- **Scheduled / automated activity is a slice, not a filter.** Automated edits (templates, integrations) are real usage — label them via `properties.source`, don't exclude them from headline counts.
- **Query engine:** plain SQL against the `product_events` warehouse table. Always put the cheapest filters first (`event_name`, date range) before any JSON extraction on `properties`.
- **Generating a new query?** Start from the closest match in `docs/working-queries.md`, apply the patterns there, return runnable SQL.

## Skills in this brain

| Slash command | What it does |
|---|---|
| `/brain` | Deep-prime on the full workstream (state, schema, queries, gotchas). Use at the start of a heavy session. |
| `/daily-context` | Pull the day's relevant calendar/email/chat activity, summarize with named attribution, write `context/daily/<date>.md` + regenerate the 7-day rollup. Runs nightly or on demand. |
| `/weekly-update` | Two modes — **intake** (collect inputs as they arrive) and **publish** (synthesize all inputs against the prior weeks' format and render a clean status doc). |

## Conventions

- **Privacy:** capture activity with named attribution but **paraphrased — never verbatim quotes**.
- **Idempotency:** daily capture merges into the day's file; the rolling rollup is regenerated from scratch. Re-running is always safe.
- Treat `docs/` as canon for definitions. When a dashboard number and a doc definition disagree, the doc wins (or the doc is stale and should be fixed — flag it).
