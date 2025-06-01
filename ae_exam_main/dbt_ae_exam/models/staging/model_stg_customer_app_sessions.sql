{{ config(materialized='view') }}

SELECT
    session_id, 
    customer_id, 
    session_start, 
    session_end, 
    device_type, 
    os_version, 
    app_version, 
    location
FROM {{ source("main", "order_log_incentive_sessions_customer_app_sessions") }}