{{ config(materialized='view') }}

WITH driver_incentive AS (
    SELECT * FROM {{ ref('model_int_driver_incentive_participation') }}
),
order_events AS (
    SELECT
        driver_id,
        order_id,
        assigned_time,
        accepted_time,
        delivered_time
    FROM {{ ref('model_int_driver_order_events_with_time') }}
)

SELECT
    i.driver_id,
    i.incentive_program,
    o.order_id,
    DATE_DIFF('minute', assigned_time, accepted_time) AS accept_delay_min,
    DATE_DIFF('minute', accepted_time, delivered_time) AS delivery_time_min
FROM driver_incentive i
JOIN order_events o
  ON i.driver_id = o.driver_id
 AND o.assigned_time BETWEEN i.incentive_start_datetime AND i.incentive_end_datetime
