-- Weekly account return rate: of accounts active last week, what % are active again this week.
-- DENOMINATOR = accounts active last week. (The denominator choice is an OPEN decision —
-- see ../docs/project-overview.md. Always state it inline.)
-- Pre-aggregate to one row per (week, account) before self-joining (see methodology learnings).
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
