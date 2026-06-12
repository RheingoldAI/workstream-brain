# Data sources & schema — Skylark

> **Fictional example.** The schema below is invented to demonstrate how a brain documents "where each signal lives, and the traps." Replace with your own data sources. The *gotchas* section is the part that earns its keep — document the field-name traps and emit-time quirks that bite.

## The warehouse table

Everything flows into one wide event table in the warehouse:

```
product_events
├── event_name    text        e.g. 'content_edited', 'app_opened'
├── user_id       text
├── account_id    text
├── workspace_id  text         nullable (some events aren't workspace-scoped)
├── doc_id        text         nullable
├── ts            timestamptz  event time, UTC
├── platform      text         'web' | 'desktop' | 'mobile'
└── properties    jsonb        event-specific payload
```

Plain SQL warehouse. JSON extraction on `properties` is the expensive part — always filter on `event_name` and a date range **first**, then reach into `properties`.

## The events that matter

| Event | Fires when | Use for |
|---|---|---|
| `app_opened` | The app/tab gains focus | **Not** an engagement signal — fires on every tab switch. See gotchas. |
| `workspace_loaded` | A workspace finishes loading | Navigation analytics; not active-user counting. |
| `content_edited` | A user commits a change to a doc | **Canonical active-user signal.** The intent moment. |
| `edit_saved` | The autosave round-trip succeeds | Save-reliability metrics — **too strict** for active-user counting (drops in-flight/failed saves). |
| `doc_created` | A new doc is created | Adoption funnel "first doc". |
| `doc_shared` | A doc is shared with another user | Adoption funnel "first share". ⚠ Under-fires on mobile. |
| `onboarding_completed` | First-run setup finishes | Adoption funnel entry. |

## Key `properties` keys

| Key | On events | Meaning |
|---|---|---|
| `properties.source` | edit events | `'interactive'` (a person typed it) vs `'automation'` (template/integration/scheduled). ⚠ Missing on public-API traffic. |
| `properties.char_delta` | `content_edited` | Size of the change. Useful to filter out trivial no-op edits if needed. |
| `properties.share_target` | `doc_shared` | `'user'` vs `'link'`. |

## Gotchas (the field-name and emit-time traps)

### `app_opened` is not engagement
`app_opened` fires every time the tab regains focus — alt-tabbing back to a parked Skylark tab fires it. Counting it as "active" inflates DAU 3–4×. The orchestrating signal of *intent* is `content_edited`. (This is the single most common mistake newcomers make — see `methodology-learnings.md`.)

### `properties.source` is missing on API traffic
Edits coming through Skylark's public API don't populate `properties.source`. So `WHERE properties->>'source' = 'interactive'` silently **drops** all API edits. For headline active-user counts this doesn't matter (you count both). For the interactive-vs-automated *slice*, treat missing `source` as a third bucket ("unknown / API"), don't assume it's interactive.

### `workspace_id` is null on account-level events
`onboarding_completed` and some billing events aren't workspace-scoped. A `JOIN` or `GROUP BY workspace_id` silently drops them. Coalesce or branch when a query spans both kinds of event.

### `doc_shared` under-fires on mobile
The mobile client batches share actions and occasionally drops the event on backgrounding. Mobile `doc_shared` counts run ~15–20% low. Until the client fix ships (tracked in `project-overview.md`), annotate any share-based funnel number with this caveat or restrict it to `platform IN ('web','desktop')`.

### Timestamps are UTC; dashboards sometimes aren't
`ts` is UTC. If a dashboard buckets by local day, a late-evening US edit lands on the "next day" in UTC. Be explicit about the timezone in any day-bucketed query, and match whatever the dashboard claims.
