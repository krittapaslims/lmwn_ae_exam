{{ config(materialized='table') }}

WITH re AS (
    SELECT * FROM {{ ref('model_int_retargeted_customers') }}
)

SELECT 
    campaign_id,
    COUNT(DISTINCT customer_id) AS targeted_customers,
    COUNT(DISTINCT CASE WHEN return_order_date IS NOT NULL THEN customer_id END) AS returned_customers,
    ROUND(1.0 * COUNT(DISTINCT CASE WHEN return_order_date IS NOT NULL THEN customer_id END) / COUNT(DISTINCT customer_id), 2) AS return_rate,
    SUM(total_spend_after) AS total_revenue_after,
    ROUND(AVG(days_between_orders), 2) AS avg_days_between_orders,
    ROUND(AVG(num_orders_after), 2) AS avg_orders_after
FROM re
GROUP BY campaign_id
