{{ config(materialized='table') }}

SELECT 
    f.campaign_id,
    d.campaign_name,
    d.campaign_type,
    d.objective,
    d.channel,
    d.cost_model,
    d.targeting_strategy,
    d.budget,
    d.is_active,
    d.start_date,
    d.end_date,
    f.impressions,
    f.clicks,
    f.conversions,
    f.total_ad_cost,
    f.total_revenue,
    f.roas,
    f.cac
FROM {{ ref('model_mart_fact_campaign_summary') }} f
LEFT JOIN {{ ref('model_mart_dim_campaign') }} d
  ON f.campaign_id = d.campaign_id
ORDER BY f.roas DESC
