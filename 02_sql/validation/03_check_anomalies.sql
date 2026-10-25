-- Проверка на логические аномалии (отрицательная сумма, пустая корзина)
SELECT
    event_timestamp,
    user_pseudo_id,
    (SELECT value.float_value FROM UNNEST(event_params) WHERE key = 'value') AS order_value,
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'quantity') AS items_quantity
FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
    event_name = 'purchase'
    AND _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND (
        (SELECT value.float_value FROM UNNEST(event_params) WHERE key = 'value') < 0
        OR (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'quantity') = 0
        OR ARRAY_LENGTH(items) = 0
    )
LIMIT 50;