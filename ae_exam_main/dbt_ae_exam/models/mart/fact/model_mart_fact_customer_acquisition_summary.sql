{{ config(materialized='table') }}

WITH acquisition AS (
    SELECT * FROM {{ ref('model_int_customer_acquisition_behavior') }}
)

SELECT 
    campaign_id,
    COUNT(DISTINCT customer_id) AS new_customers,
    ROUND(AVG(total_orders), 2) AS avg_orders_per_customer,
    ROUND(AVG(total_spent), 2) AS avg_total_spent,
    ROUND(AVG(avg_order_value), 2) AS avg_order_value,
    ROUND(AVG(days_active), 2) AS avg_active_days,
    ROUND(AVG(days_to_first_order), 2) AS avg_days_to_first_order,
    SUM(ad_cost) AS total_marketing_cost,
    ROUND(SUM(ad_cost) / NULLIF(COUNT(DISTINCT customer_id), 0), 2) AS cac
FROM acquisition
GROUP BY campaign_id
