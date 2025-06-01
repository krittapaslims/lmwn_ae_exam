{{ config(materialized='view') }}

SELECT
    log_id, 
    driver_id, 
    incentive_program, 
    bonus_amount, 
    applied_date, 
    delivery_target, 
    actual_deliveries, 
    bonus_qualified, 
    region
FROM {{ source("main", "order_log_incentive_sessions_driver_incentive_logs") }}