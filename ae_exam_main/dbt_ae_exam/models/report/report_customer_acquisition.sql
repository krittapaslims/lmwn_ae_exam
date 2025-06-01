{{ config(materialized='table') }}

SELECT 
    f.*,
    d.campaign_name,
    d.channel,
    d.campaign_type,
    d.objective
FROM {{ ref('model_mart_fact_customer_acquisition_summary') }} f
JOIN {{ ref('model_mart_dim_campaign') }} d
  ON f.campaign_id = d.campaign_id
ORDER BY f.new_customers DESC
