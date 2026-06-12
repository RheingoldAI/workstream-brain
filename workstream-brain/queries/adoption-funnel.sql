-- Adoption funnel: onboarded -> first doc -> first share.
-- NOTE: doc_shared under-fires on mobile (~15-20% low) — restricted to web/desktop here.
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
    count(*)              AS onboarded,
    count(first_doc_at)   AS reached_first_doc,
    count(first_share_at) AS reached_first_share
FROM firsts
WHERE onboarded_at IS NOT NULL;
