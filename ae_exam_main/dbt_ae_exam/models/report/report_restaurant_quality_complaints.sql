{{ config(materialized='table') }}

WITH base AS (
    SELECT *
    FROM {{ ref('model_mart_fact_restaurant_complaint_summary') }}
)

SELECT
    restaurant_id,
    restaurant_name,
    category,
    city,
    average_rating,
    issue_sub_type,
    total_complaints,
    avg_resolution_time_min,
    total_compensation_issued,
    complaint_to_order_ratio,
    affected_customers,
    returning_customers,
    ROUND(1.0 * returning_customers / NULLIF(affected_customers, 0), 2) AS repeat_purchase_rate
FROM base
ORDER BY total_complaints DESC
