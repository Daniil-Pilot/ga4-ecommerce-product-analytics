-- Проверка полноты параметров для события purchase
WITH purchase_events AS (
    SELECT
        event_timestamp,
        user_pseudo_id,
        (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'transaction_id') AS transaction_id,
        (SELECT value.float_value FROM UNNEST(event_params) WHERE key = 'value') AS value,
        (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'currency') AS currency
    FROM
        `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE
        event_name = 'purchase'
        AND _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
)
SELECT
    COUNT(*) AS total_purchases,
    COUNTIF(transaction_id IS NULL) AS missing_transaction_id,
    COUNTIF(value IS NULL OR value <= 0) AS missing_or_invalid_value,
    COUNTIF(currency IS NULL) AS missing_currency
FROM
    purchase_events;