-- Daily active users (DAU) — canonical signal: content_edited.
-- See ../docs/methodology-learnings.md for why this signal and not app_opened / edit_saved.
SELECT
    date_trunc('day', ts) AS day,
    count(DISTINCT user_id) AS dau
FROM product_events
WHERE event_name = 'content_edited'
  AND ts >= now() - interval '30 days'
GROUP BY 1
ORDER BY 1;
