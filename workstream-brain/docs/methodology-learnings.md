# Methodology learnings — Skylark

> **Fictional example.** Every gotcha that wasted us hours, in one place. Read this before debugging a query or a number — chances are good the answer is here. This is the highest-leverage file in the brain: every lesson written here is one neither you nor the agent has to rediscover.
>
> Replace the content with your own learnings, but **keep this file and keep adding to it forever.** It is the compounding asset.

---

## Active user definition (DAU/WAU/MAU) — the canonical signal

This is the most-relitigated definition in the workstream. Here is where it landed and why, so the next time someone proposes a change you can place it against a stable baseline.

**A user is "active" on day D if they committed at least one meaningful change on D — interactive or automated — regardless of whether the change later saved successfully.**

**Concretely:** at least one `content_edited` event for that `(account_id, user_id)` on day D. This event fires at the moment the user *commits an edit* — it captures intent even when the autosave round-trip later fails, the tab closes, or the client crashes before `edit_saved`.

```sql
SELECT date_trunc('day', ts) AS day,
       count(DISTINCT user_id) AS dau
FROM product_events
WHERE event_name = 'content_edited'
  AND ts >= now() - interval '30 days'
GROUP BY 1 ORDER BY 1;
```

### The three lookalike signals — when to use which

| Signal | Lifecycle stage | Use for |
|---|---|---|
| `app_opened` | App/tab gains focus | **Nothing user-counting.** Fires on every tab switch — inflates DAU 3–4×. |
| `content_edited` | Change committed (intent) | **Canonical DAU/WAU/MAU.** |
| `edit_saved` | Autosave round-trip succeeds | Save-reliability metrics only — too strict for active-user counting (silently drops every failed/in-flight save). |

### Why each rejected alternative is wrong

1. **`app_opened` (too broad).** Many users park a Skylark tab and alt-tab back to it all day without doing anything; each focus fires `app_opened`. Counting it conflates "had the tab open" with "did work." This is the most common newcomer mistake.
2. **`edit_saved` (too strict).** Anchoring on the *successful save* silently drops every edit where the user committed a change but the save round-trip failed, timed out, or was still in flight when they closed the tab. Those are real active users. Using `edit_saved` undercounts and makes outages look like usage drops.
3. **Excluding automated edits.** Automated activity (templates, integrations, scheduled tasks) is real product value the user configured. **Automated is a slice, not a filter** — label it via `properties.source`, report it separately if useful, but don't remove it from the headline.

### How to evaluate the *next* proposed change

Every proposed redefinition moves the anchor along one of two axes. When a new one comes in, ask:

- **Which lifecycle stage is it anchoring on?** (focus → intent → success). Earlier = broader, later = stricter. The chosen anchor is *intent* (`content_edited`) — broad enough to count real users, strict enough to exclude idle tabs.
- **Is it filtering automated traffic out of the headline?** If so, that's a slice masquerading as a definition — push back.

Holding those two axes fixed is how you keep a year of dashboards comparable.

---

## Query performance

### Filter cheap, extract last
JSON extraction on `properties` is the expensive operation. Always narrow by `event_name` and a date range *before* reaching into `properties`. A query that filters `WHERE properties->>'source' = ...` without an `event_name` filter first scans and parses JSON for the entire table.

### Pre-aggregate before joining for retention
Retention queries that self-join the raw event table blow up. Reduce to one row per `(week, account_id)` in a CTE first (a `DISTINCT`), then join the small result to itself. (See `working-queries.md` → account retention.)

---

## Schema traps (cross-referenced from the schema doc)

- **`properties.source` is missing on public-API edits** — `WHERE source = 'interactive'` silently drops all API traffic. Treat missing as a third bucket. Only matters for the interactive/automated *slice*, not headline counts (which include everything).
- **`workspace_id` is null on account-level events** — `GROUP BY workspace_id` drops `onboarding_completed` and billing events.
- **`doc_shared` under-fires on mobile (~15–20% low)** — restrict share-based metrics to `platform IN ('web','desktop')` or annotate.
- **`ts` is UTC** — be explicit about timezone in day-bucketed queries; match the dashboard's stated convention.

Full detail on each in `data-sources-and-schema.md`.

---

## Measurement traps

### State the retention denominator out loud
"Weekly return rate" is meaningless until you say what's in the denominator: accounts active *last week*, or accounts active *ever before*? They give very different numbers and both are "retention." This is currently an open dependency (`project-overview.md`) — until it's decided, every retention number must carry its denominator definition inline.

### Don't compare numbers across a definition change without restating both
When the active-user definition changed, week-over-week DAU appeared to drop — but it was the definition moving, not usage. Any time a definition changes, recompute the prior period on the **new** definition before claiming a trend. A "drop" that coincides exactly with a definition change is almost always the definition.

---

## A worked debugging example (for posterity)

DAU looked ~3× too high for a week. Running `summarize count() by event_name` on the underlying query revealed it was counting `app_opened`, not `content_edited` — someone had copied an old query. Lesson, now a habit: **when a metric looks wrong, first print the breakdown by the dimension you're aggregating** (here, `event_name`). The root cause usually lives in one category that doesn't belong.
