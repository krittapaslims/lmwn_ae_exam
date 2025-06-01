{{ config(materialized='view') }}

WITH ranked_status AS (
    SELECT
        ticket_id,
        status,
        status_datetime,
        ROW_NUMBER() OVER (
            PARTITION BY ticket_id 
            ORDER BY status_datetime DESC
        ) AS rn
    FROM {{ ref('model_stg_support_ticket_status_logs') }}
)

SELECT
    ticket_id,
    status AS latest_status,
    status_datetime AS latest_status_datetime
FROM ranked_status
WHERE rn = 1
