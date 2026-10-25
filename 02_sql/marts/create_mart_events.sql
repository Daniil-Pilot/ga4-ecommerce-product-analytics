-- Создание плоской витрины данных из вложенных структур GA4
CREATE OR REPLACE TABLE `groovy-camera-512621-r3.analysis_marts.mart_events` AS
SELECT
    user_pseudo_id,
    event_name,
    TIMESTAMP_MICROS(event_timestamp) AS event_timestamp,
    device.category AS device_category,
    (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'transaction_id') AS transaction_id,
    (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'currency') AS currency,
    COALESCE(
        (SELECT value.float_value FROM UNNEST(event_params) WHERE key = 'value'),
        (SELECT value.double_value FROM UNNEST(event_params) WHERE key = 'value'),
        (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'value')
    ) AS event_value,
    ARRAY_LENGTH(items) AS items_count
FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
    _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'