-- Построение воронки продаж
WITH funnel_data AS (
  SELECT
    user_pseudo_id,
    MAX(CASE WHEN event_name = 'view_item' THEN 1 ELSE 0 END) AS step_1_view,
    MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS step_2_cart,
    MAX(CASE WHEN event_name = 'begin_checkout' THEN 1 ELSE 0 END) AS step_3_checkout,
    MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS step_4_purchase
  FROM
    `groovy-camera-512621-r3.analysis_marts.mart_events`
  GROUP BY
    user_pseudo_id
)
SELECT
  SUM(step_1_view) AS users_view_item,
  SUM(step_2_cart) AS users_add_to_cart,
  SUM(step_3_checkout) AS users_begin_checkout,
  SUM(step_4_purchase) AS users_purchase,
  ROUND(SUM(step_2_cart) / SUM(step_1_view) * 100, 2) AS cr_view_to_cart,
  ROUND(SUM(step_3_checkout) / SUM(step_2_cart) * 100, 2) AS cr_cart_to_checkout,
  ROUND(SUM(step_4_purchase) / SUM(step_3_checkout) * 100, 2) AS cr_checkout_to_purchase,
  ROUND(SUM(step_4_purchase) / SUM(step_1_view) * 100, 2) AS cr_overall
FROM
  funnel_data;