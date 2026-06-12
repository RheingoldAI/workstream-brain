# Working queries — Skylark

> **Fictional example.** Proven queries with caveats inline. Replace with your own. Each query here has a runnable copy in `queries/`. When you write a new proven query, add it here *and* drop a copy in `queries/` so it's reusable.

The golden rule (from `methodology-learnings.md`): **filter on `event_name` and date range first, reach into `properties` last.** JSON extraction is the expensive step.

---

## Daily active users (DAU)

Canonical signal: `content_edited`. (Runnable: `queries/dau.sql`.)

```sql
SELECT
    date_trunc('day', ts) AS day,
    count(DISTINCT user_id) AS dau
FROM product_events
WHERE event_name = 'content_edited'
  AND ts >= now() - interval '30 days'
GROUP BY 1
ORDER BY 1;
```

---

## Weekly active users, internal vs external

The internal/external cut is **account-level**. (Runnable: `queries/wau-internal-external.sql`.)

```sql
SELECT
    date_trunc('week', ts) AS week,
    CASE WHEN account_id = 'acct_skylark_internal'
         THEN 'internal' ELSE 'external' END AS segment,
    count(DISTINCT user_id) AS wau
FROM product_events
WHERE event_name = 'content_edited'
  AND ts >= now() - interval '12 weeks'
GROUP BY 1, 2
ORDER BY 1, 2;
```

---

## Interactive vs automated split

`properties.source` is **missing on API traffic** — treat missing as its own bucket, don't fold it into interactive. (Runnable: `queries/interactive-vs-automated.sql`.)

```sql
SELECT
    date_trunc('day', ts) AS day,
    coalesce(properties->>'source', 'unknown_or_api') AS source_bucket,
    count(DISTINCT user_id) AS active_users
FROM product_events
WHERE event_name = 'content_edited'
  AND ts >= now() - interval '14 days'
GROUP BY 1, 2
ORDER BY 1, 2;
```

---

## Weekly account retention

What % of accounts active in a week were also active the week before. Note the denominator question is still open (see `project-overview.md`) — this version uses *active accounts last week* as the denominator. (Runnable: `queries/account-retention.sql`.)

```sql
WITH weekly AS (
    SELECT DISTINCT
        date_trunc('week', ts) AS week,
        account_id
    FROM product_events
    WHERE event_name = 'content_edited'
      AND ts >= now() - interval '13 weeks'
)
SELECT
    this.week,
    count(DISTINCT this.account_id) FILTER (WHERE prev.account_id IS NOT NULL)::float
        / nullif(count(DISTINCT prev_base.account_id), 0) AS weekly_return_rate
FROM weekly this
LEFT JOIN weekly prev
       ON prev.account_id = this.account_id
      AND prev.week = this.week - interval '1 week'
LEFT JOIN weekly prev_base
       ON prev_base.week = this.week - interval '1 week'
GROUP BY 1
ORDER BY 1;
```

> ⚠ Retention queries are easy to get subtly wrong on the denominator. Always state explicitly whether the denominator is "active last week" or "active ever before". See methodology learnings.

---

## Adoption funnel (onboarded → first doc → first share → habitual)

`doc_shared` under-fires on mobile — restrict to web/desktop or annotate. (Runnable: `queries/adoption-funnel.sql`.)

```sql
WITH firsts AS (
    SELECT
        user_id,
        min(ts) FILTER (WHERE event_name = 'onboarding_completed') AS onboarded_at,
        min(ts) FILTER (WHERE event_name = 'doc_created')          AS first_doc_at,
        min(ts) FILTER (WHERE event_name = 'doc_shared'
                         AND platform IN ('web','desktop'))        AS first_share_at
    FROM product_events
    WHERE ts >= now() - interval '90 days'
    GROUP BY user_id
)
SELECT
    count(*)                                            AS onboarded,
    count(first_doc_at)                                 AS reached_first_doc,
    count(first_share_at)                               AS reached_first_share
FROM firsts
WHERE onboarded_at IS NOT NULL;
```
