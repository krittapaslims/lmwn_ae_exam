{{ config(materialized='table') }}

WITH base AS (
    SELECT * 
    FROM {{ ref('model_mart_fact_driver_complaint_summary') }}
)

SELECT
    driver_id,
    total_complaints,
    common_issue_type,
    avg_resolution_time_min,
    avg_csat_score,
    total_orders,
    complaint_to_order_ratio,
    avg_rating_before_complaint,
    avg_rating_after_complaint,
    ROUND(avg_rating_after_complaint - avg_rating_before_complaint, 2) AS rating_change,
    CASE 
        WHEN avg_rating_after_complaint < avg_rating_before_complaint THEN 'declined'
        WHEN avg_rating_after_complaint > avg_rating_before_complaint THEN 'improved'
        ELSE 'no change'
    END AS rating_trend
FROM base
ORDER BY total_complaints DESC
