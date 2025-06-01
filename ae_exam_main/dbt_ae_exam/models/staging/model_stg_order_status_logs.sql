{{ config(materialized='view') }}

SELECT
    log_id, 
    order_id, 
    status, 
    status_datetime, 
    updated_by
FROM {{ source("main", "order_log_incentive_sessions_order_status_logs") }}