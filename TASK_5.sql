WITH merged_tables AS (
    SELECT 
        ad_date, 
        CASE 
            WHEN url_parameters LIKE '%nan%' THEN NULL 
            ELSE url_parameters 
        END AS url_parameters,
        COALESCE(spend, 0) AS spend,  
        COALESCE(impressions, 0) AS impressions, 
        COALESCE(reach, 0) AS reach, 
        COALESCE(clicks, 0) AS clicks, 
        COALESCE(leads, 0) AS leads, 
        COALESCE(value, 0) AS value 
    FROM facebook_ads_basic_daily 
    UNION ALL 
    SELECT 
        ad_date, 
        CASE 
            WHEN url_parameters LIKE '%nan%' THEN NULL 
            ELSE url_parameters 
        END AS url_parameters, 
        COALESCE(spend, 0) AS spend,  
        COALESCE(impressions, 0) AS impressions, 
        COALESCE(reach, 0) AS reach, 
        COALESCE(clicks, 0) AS clicks, 
        COALESCE(leads, 0) AS leads, 
        COALESCE(value, 0) AS value 
    FROM google_ads_basic_daily 
), 
processed_data AS (
    SELECT 
        ad_date,
        CASE 
            WHEN url_parameters LIKE '%utm_campaign%' THEN 
                SUBSTRING(url_parameters FROM 'utm_campaign=([^&]+)') 
            ELSE 
                NULL 
        END AS utm_campaign,
        SUM(spend) AS total_spend,
        SUM(impressions) AS total_impressions,
        SUM(clicks) AS total_clicks,
        SUM(value) AS total_value
    FROM merged_tables
    GROUP BY ad_date, utm_campaign
)
SELECT
    ad_date,
    utm_campaign,
    total_spend,
    total_impressions,
    total_clicks,
    total_value,
    CASE 
        WHEN SUM(total_impressions) > 0 THEN 
            SUM(total_clicks)::float / SUM(total_impressions)::float * 100
        ELSE 
            0 
    END AS ctr,
    CASE 
        WHEN SUM(total_clicks) > 0 THEN 
            SUM(total_spend)::float / SUM(total_clicks)::float
        ELSE 
            0 
    END AS cpc,
    CASE 
        WHEN SUM(total_impressions) > 0 THEN 
            SUM(total_spend)::float / (SUM(total_impressions)::float * 1000) 
        ELSE
            0 
    END AS cpm,
    CASE 
        WHEN SUM(total_spend) > 0 THEN 
            ((SUM(total_value) - SUM(total_spend)) / SUM(total_spend)) * 100
        ELSE 
            0 
    END AS romi
FROM
    processed_data
GROUP BY 
    ad_date,
    utm_campaign, 
    total_spend,
    total_impressions,
    total_clicks,
    total_value;




