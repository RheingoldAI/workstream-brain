-- Interactive vs automated edit split.
-- NOTE: properties.source is missing on public-API traffic — treat missing as its
-- own bucket ('unknown_or_api'); do NOT fold it into interactive. Automated is a
-- slice, not a filter: it stays in headline active-user counts.
SELECT
    date_trunc('day', ts) AS day,
    coalesce(properties->>'source', 'unknown_or_api') AS source_bucket,
    count(DISTINCT user_id) AS active_users
FROM product_events
WHERE event_name = 'content_edited'
  AND ts >= now() - interval '14 days'
GROUP BY 1, 2
ORDER BY 1, 2;
