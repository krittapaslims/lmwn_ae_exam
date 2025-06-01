{{ config(materialized='view') }}

SELECT
    log_id, 
    ticket_id, 
    status, 
    status_datetime, 
    agent_id
FROM {{ source("main", "support_ticket_status_logs") }}