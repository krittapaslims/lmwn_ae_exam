{{ config(materialized='view') }}

SELECT 
    campaign_id,
    COUNT(DISTINCT CASE WHEN event_type = 'impression' THEN interaction_id END) AS impressions,
    COUNT(DISTINCT CASE WHEN event_type = 'click' THEN interaction_id END) AS clicks,
    COUNT(DISTINCT CASE WHEN event_type = 'conversion' THEN interaction_id END) AS conversions,
    SUM(CASE WHEN event_type IN ('impression', 'click', 'conversion') THEN ad_cost ELSE 0 END) AS total_ad_cost,
    SUM(CASE WHEN event_type = 'conversion' THEN revenue ELSE 0 END) AS total_revenue
FROM {{ ref('model_stg_campaign_interactions') }}
GROUP BY campaign_id
