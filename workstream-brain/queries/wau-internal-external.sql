-- Weekly active users, internal vs external. Cut is ACCOUNT-level, not user-level.
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
