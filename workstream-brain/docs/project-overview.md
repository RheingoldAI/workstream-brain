# Project overview — Skylark × Insights telemetry onboarding

> **Fictional example.** Skylark is a made-up product and this workstream is invented to demonstrate the brain framework. Replace this file with your own workstream's overview.

## What this workstream is

The **Insights team** owns analytics and reporting for **Skylark**, a collaborative workspace app (shared documents + tasks, used by teams inside customer companies). We're onboarding Skylark's raw product telemetry into a trusted reporting layer: defining the core usage metrics, building dashboards leadership relies on, and keeping a shared definition of "what counts" so different teams stop reporting different numbers.

## Workstreams

| Workstream | Status | Owner | Notes |
|---|---|---|---|
| **Active-user definition** | ✅ Settled (as of 2026-06-10) | Insights PM | Canonical signal is `content_edited`. History of the debate in `methodology-learnings.md`. Treated as canon — but expect periodic re-litigation as new event types ship. |
| **Core usage dashboard** | 🟢 Shipped | Insights PM + Dana (data eng) | DAU/WAU/MAU, internal-vs-external split, scheduled-vs-interactive slice. Live. |
| **Retention dashboard** | 🟡 In progress | Insights PM | Week-over-week account retention. Denominator definition still under discussion (see open dependencies). |
| **Feature-adoption funnel** | 🟡 In progress | Insights PM | Onboarding → first-doc → first-share → habitual. Funnel-step events partly instrumented. |
| **Weekly cross-team update** | 🟢 Running | Insights PM | Published via `/weekly-update`; archive in `weekly-updates/`. |

## Stakeholders (fictional)

- **Insights PM** — owns the brain, the definitions, and the dashboards. (You.)
- **Dana** — data engineering; owns the `product_events` warehouse pipeline.
- **Marco** — Skylark engineering lead; source of truth on what each event *means* at emit time.
- **Priya** — leadership sponsor; consumes the dashboards and the weekly update.
- **Sam** — partner analyst on the Growth team; cares about the adoption funnel.

## Open dependencies

1. **Retention denominator** — do we count accounts or users in the denominator? Dana and Sam disagree; needs a decision before the retention dashboard ships. Tracked in the weekly update.
2. **`doc_shared` event reliability** — the share event under-fires on mobile (see `methodology-learnings.md`); blocks the adoption funnel's "first-share" step.
3. **Automated-edit labeling** — `properties.source` isn't populated on edits coming through the public API; makes the scheduled-vs-interactive slice incomplete for API traffic.

## Status (as of 2026-06-10)

- Active-user definition **settled** on `content_edited`; core usage dashboard live on it.
- Retention dashboard blocked on the denominator decision.
- Adoption funnel blocked on `doc_shared` reliability.
- Weekly update cadence steady; latest cycle archived in `weekly-updates/`.

See `methodology-learnings.md` for the gotchas behind these, and `working-queries.md` for the queries powering the live dashboards.
