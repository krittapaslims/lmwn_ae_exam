{{ config(materialized='table') }}

SELECT 
    d.driver_id,
    d.tasks_assigned,
    d.tasks_completed,
    d.avg_accept_delay_min,
    d.avg_delivery_time_min,
    d.late_deliveries,
    f.total_feedback,
    f.positive_feedback,
    f.negative_feedback,
    m.vehicle_type,
    m.region AS driver_region
FROM {{ ref('model_int_driver_delivery_events') }} d
LEFT JOIN {{ ref('model_int_driver_feedback_summary') }} f
  ON d.driver_id = f.driver_id
LEFT JOIN {{ ref('model_stg_drivers_master') }} m
  ON d.driver_id = m.driver_id

