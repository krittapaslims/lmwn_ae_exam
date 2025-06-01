{{ config(materialized='view') }}

WITH driver_tickets AS (
  SELECT
    driver_id,
    csat_score,
    CASE 
      WHEN csat_score >= 4 THEN 'positive'
      WHEN csat_score <= 2 THEN 'negative'
      ELSE 'neutral'
    END AS feedback_type
  FROM {{ ref('model_stg_support_tickets') }}
  WHERE driver_id IS NOT NULL
)

SELECT
  driver_id,
  COUNT(*) AS total_feedback,
  COUNT(CASE WHEN feedback_type = 'positive' THEN 1 END) AS positive_feedback,
  COUNT(CASE WHEN feedback_type = 'negative' THEN 1 END) AS negative_feedback
FROM driver_tickets
GROUP BY driver_id
