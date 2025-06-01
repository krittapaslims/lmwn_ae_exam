{{ config(materialized='view') }}

SELECT
    customer_id,
    restaurant_id,
    COUNT(*) AS total_orders,
    MAX(order_datetime) AS last_order_date
FROM {{ ref('model_stg_order_transactions') }}
GROUP BY restaurant_id, customer_id
