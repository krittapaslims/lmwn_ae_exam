{{ config(materialized='view') }}

WITH complaint_events AS (
    SELECT 
        driver_id,
        opened_datetime AS complaint_datetime
    FROM {{ ref('model_int_driver_complaint_summary') }}
),

driver_rating_snapshot AS (
    SELECT
        d.driver_id,
        c.complaint_datetime,
        d.driver_rating
    FROM complaint_events c
    LEFT JOIN {{ ref('model_stg_drivers_master') }} d
        ON c.driver_id = d.driver_id
)

SELECT
    driver_id,
    complaint_datetime,
    driver_rating AS rating_at_complaint_time
FROM driver_rating_snapshot
