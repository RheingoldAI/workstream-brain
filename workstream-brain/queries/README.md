# queries/

Runnable copies of the proven queries documented in [`../docs/working-queries.md`](../docs/working-queries.md). Plain SQL against the `product_events` warehouse table (schema in [`../docs/data-sources-and-schema.md`](../docs/data-sources-and-schema.md)).

> **Fictional example.** These query a made-up Skylark schema. Replace with your own.

| File | Metric |
|---|---|
| `dau.sql` | Daily active users (canonical `content_edited` signal) |
| `wau-internal-external.sql` | Weekly active users, internal vs external |
| `interactive-vs-automated.sql` | Interactive vs automated edit split |
| `account-retention.sql` | Weekly account return rate |
| `adoption-funnel.sql` | Onboarded → first doc → first share |

When you add a proven query: document it in `../docs/working-queries.md` with its caveats, then drop the runnable copy here.
