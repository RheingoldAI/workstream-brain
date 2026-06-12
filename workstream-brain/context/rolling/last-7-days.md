# Rolling 7-day context (through 2026-06-11)

> Regenerated from scratch on each `/daily-context` run from the last 7 `daily/*.md` files. **Fictional example.**

## Trend themes
- The active-user definition reached closure and the core dashboard was rebuilt on it — the workstream's biggest open question this week, now settled.
- Two downstream dashboards (retention, adoption) are each blocked on a single specific dependency, not on broad uncertainty — good sign the work is converging.

## Active decisions / debates
- **Settled:** active-user signal = `content_edited` (intent), over `app_opened` (too broad) and `edit_saved` (too strict). [2026-06-10]
- **Open:** retention denominator — accounts active *last week* (Dana) vs *ever before* (Sam). Blocks the retention dashboard.
- **Open (leaning):** ship adoption funnel with a web/desktop-only first-share caveat vs wait for the mobile fix. Insights PM leaning ship-with-caveat, pending Priya.

## Open questions & who owes what
- Retention denominator decision — Dana / Sam — before retention ship.
- `doc_shared` mobile under-firing fix — Marco — no ETA.
- Adoption-funnel ship call — Priya (pending Insights PM's ask).

## People / v-team changes
- None this week. Core v-team: Insights PM, Dana, Marco, Priya, Sam.
