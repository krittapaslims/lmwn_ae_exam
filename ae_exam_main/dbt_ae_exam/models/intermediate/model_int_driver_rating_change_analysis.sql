{{ config(materialized='view') }}

WITH complaints AS (
    SELECT 
        driver_id,
        opened_datetime AS complaint_time
    FROM {{ ref('model_int_driver_complaint_summary') }}
),

driver_rating_base AS (
    SELECT 
        driver_id,
        driver_rating
    FROM {{ ref('model_stg_drivers_master') }}
),

rating_before_after AS (
    SELECT
        c.driver_id,
        c.complaint_time,
        r.driver_rating AS rating_snapshot,
        CASE 
            WHEN c.complaint_time < CURRENT_DATE - INTERVAL '180 days' THEN 'before'
            ELSE 'after'
        END AS rating_period
    FROM complaints c
    LEFT JOIN driver_rating_base r 
      ON c.driver_id = r.driver_id
)

SELECT 
    driver_id,
    rating_period,
    ROUND(AVG(rating_snapshot), 2) AS avg_rating
FROM rating_before_after
GROUP BY driver_id, rating_period
