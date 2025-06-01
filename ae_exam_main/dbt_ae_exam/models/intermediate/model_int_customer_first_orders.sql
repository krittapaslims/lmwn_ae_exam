{{ config(materialized='view') }}

SELECT 
    customer_id,
    MIN(order_datetime) AS first_order_datetime
FROM {{ ref('model_stg_order_transactions') }}
GROUP BY customer_id
