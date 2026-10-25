-- Симуляция A/B-теста (разбивка по хэшу user_pseudo_id)
WITH user_groups AS (
  SELECT
    user_pseudo_id,
    MOD(ABS(FARM_FINGERPRINT(user_pseudo_id)), 2) AS group_id
  FROM
    `groovy-camera-512621-r3.analysis_marts.mart_events`
  GROUP BY user_pseudo_id
),
funnel_simulation AS (
  SELECT
    g.group_id,
    g.user_pseudo_id,
    MAX(CASE WHEN event_name = 'view_item' THEN 1 ELSE 0 END) AS viewed,
    MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS added_to_cart
  FROM
    user_groups g
  LEFT JOIN
    `groovy-camera-512621-r3.analysis_marts.mart_events` e
  ON g.user_pseudo_id = e.user_pseudo_id
  GROUP BY g.group_id, g.user_pseudo_id
)
SELECT
  CASE WHEN group_id = 0 THEN 'Control' ELSE 'Test' END AS ab_group,
  SUM(viewed) AS users_viewed,
  SUM(added_to_cart) AS users_added_to_cart,
  ROUND(SUM(added_to_cart) / SUM(viewed) * 100, 2) AS conversion_rate
FROM funnel_simulation
WHERE viewed = 1
GROUP BY ab_group;