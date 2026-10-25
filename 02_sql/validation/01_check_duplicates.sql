-- Проверка на полные дубликаты событий
SELECT
    user_pseudo_id,
    event_name,
    event_timestamp,
    COUNT(*) AS events_count
FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
    _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
GROUP BY
    user_pseudo_id, event_name, event_timestamp
HAVING
    COUNT(*) > 1
ORDER BY
    events_count DESC
LIMIT 10;