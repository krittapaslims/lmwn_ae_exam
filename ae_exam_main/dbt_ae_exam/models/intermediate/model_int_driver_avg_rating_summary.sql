{{ config(materialized='view') }}

WITH rating_change AS (
    SELECT *
    FROM {{ ref('model_int_driver_rating_change_analysis') }}
),

pivoted AS (
    SELECT
        driver_id,
        MAX(CASE WHEN rating_period = 'before' THEN avg_rating END) AS avg_rating_before_complaint,
        MAX(CASE WHEN rating_period = 'after' THEN avg_rating END) AS avg_rating_after_complaint
    FROM rating_change
    GROUP BY driver_id
)

SELECT * FROM pivoted
