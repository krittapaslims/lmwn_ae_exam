{{ config(materialized='view') }}

SELECT DISTINCT ticket_id
FROM {{ ref('model_stg_support_ticket_status_logs') }}
GROUP BY ticket_id
HAVING SUM(CASE WHEN status = 'resolved' THEN 1 ELSE 0 END) = 0
