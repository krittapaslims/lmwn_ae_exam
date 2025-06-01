{{ config(materialized='table') }}

SELECT 
    f.*,
    d.campaign_name,
    d.channel,
    d.targeting_strategy,
    d.objective
FROM {{ ref('model_mart_fact_retargeting_summary') }} f
JOIN {{ ref('model_mart_dim_campaign') }} d
  ON f.campaign_id = d.campaign_id
ORDER BY f.return_rate DESC
