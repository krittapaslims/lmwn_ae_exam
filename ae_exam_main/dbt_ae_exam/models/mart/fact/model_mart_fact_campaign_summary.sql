{{ config(materialized='table') }}

WITH interactions AS (
    SELECT * FROM {{ ref('model_int_campaign_interaction_summary') }}
)

SELECT 
    campaign_id,
    
    -- Metrics from interactions
    impressions,
    clicks,
    conversions,
    total_ad_cost,
    total_revenue,

    -- Calculated KPIs
    ROUND(NULLIF(total_revenue, 0) / NULLIF(total_ad_cost, 0), 2) AS roas,
    ROUND(NULLIF(total_ad_cost, 0) / NULLIF(conversions, 0), 2) AS cac

FROM interactions