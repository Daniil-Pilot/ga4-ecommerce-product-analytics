-- Подготовка данных для RFM-анализа
WITH user_stats AS (
  SELECT
    user_pseudo_id,
    DATE_DIFF(DATE('2021-01-31'), MAX(DATE(event_timestamp)), DAY) AS recency,
    COUNT(DISTINCT transaction_id) AS frequency,
    SUM(event_value) AS monetary
  FROM
    `groovy-camera-512621-r3.analysis_marts.mart_events`
  WHERE
    event_name = 'purchase'
    AND transaction_id IS NOT NULL
  GROUP BY
    user_pseudo_id
)
SELECT * FROM user_stats
WHERE monetary IS NOT NULL;