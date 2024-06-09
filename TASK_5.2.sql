create or replace function decode_cyrylic_url(encoded_text text) returns text as $$
declare 
	temp_text text;
begin 
    temp_text := REPLACE(encoded_text, '%D0%90', 'А');
    temp_text := REPLACE(temp_text, '%D0%B0', 'а');
    temp_text := REPLACE(temp_text, '%D0%91', 'Б');
    temp_text := REPLACE(temp_text, '%D0%B1', 'б');
    temp_text := REPLACE(temp_text, '%D0%92', 'В');
    temp_text := REPLACE(temp_text, '%D0%B2', 'в');
    temp_text := REPLACE(temp_text, '%D0%93', 'Г');
    temp_text := REPLACE(temp_text, '%D0%B3', 'г');
    temp_text := REPLACE(temp_text, '%D0%94', 'Д');
    temp_text := REPLACE(temp_text, '%D0%B4', 'д');
    temp_text := REPLACE(temp_text, '%D0%95', 'Е');
    temp_text := REPLACE(temp_text, '%D0%B5', 'е');
    temp_text := REPLACE(temp_text, '%D0%96', 'Ж');
    temp_text := REPLACE(temp_text, '%D0%B6', 'ж');
    temp_text := REPLACE(temp_text, '%D0%97', 'З');
    temp_text := REPLACE(temp_text, '%D0%B7', 'з');
    temp_text := REPLACE(temp_text, '%D0%98', 'И');
    temp_text := REPLACE(temp_text, '%D0%B8', 'и');
    temp_text := REPLACE(temp_text, '%D0%99', 'Й');
    temp_text := REPLACE(temp_text, '%D0%B9', 'й');
    temp_text := REPLACE(temp_text, '%D0%9A', 'К');
    temp_text := REPLACE(temp_text, '%D0%BA', 'к');
    temp_text := REPLACE(temp_text, '%D0%9B', 'Л');
    temp_text := REPLACE(temp_text, '%D0%BB', 'л');
    temp_text := REPLACE(temp_text, '%D0%9C', 'М');
    temp_text := REPLACE(temp_text, '%D0%BC', 'м');
    temp_text := REPLACE(temp_text, '%D0%9D', 'Н');
    temp_text := REPLACE(temp_text, '%D0%BD', 'н');
    temp_text := REPLACE(temp_text, '%D0%9E', 'О');
    temp_text := REPLACE(temp_text, '%D0%BE', 'о');
    temp_text := REPLACE(temp_text, '%D0%9F', 'П');
    temp_text := REPLACE(temp_text, '%D0%BF', 'п');
    temp_text := REPLACE(temp_text, '%D0%A0', 'Р');
    temp_text := REPLACE(temp_text, '%D1%80', 'р');
    temp_text := REPLACE(temp_text, '%D0%A1', 'С');
    temp_text := REPLACE(temp_text, '%D1%81', 'с');
    temp_text := REPLACE(temp_text, '%D0%A2', 'Т');
    temp_text := REPLACE(temp_text, '%D1%82', 'т');
    temp_text := REPLACE(temp_text, '%D0%A3', 'У');
    temp_text := REPLACE(temp_text, '%D1%83', 'у');
    temp_text := REPLACE(temp_text, '%D0%A4', 'Ф');
    temp_text := REPLACE(temp_text, '%D1%84', 'ф');
    temp_text := REPLACE(temp_text, '%D0%A5', 'Х');
    temp_text := REPLACE(temp_text, '%D1%85', 'х');
    temp_text := REPLACE(temp_text, '%D0%A6', 'Ц');
    temp_text := REPLACE(temp_text, '%D1%86', 'ц');
    temp_text := REPLACE(temp_text, '%D0%A7', 'Ч');
    temp_text := REPLACE(temp_text, '%D1%87', 'ч');
    temp_text := REPLACE(temp_text, '%D0%A8', 'Ш');
    temp_text := REPLACE(temp_text, '%D1%88', 'ш');
    temp_text := REPLACE(temp_text, '%D0%A9', 'Щ');
    temp_text := REPLACE(temp_text, '%D1%89', 'щ');
    temp_text := REPLACE(temp_text, '%D0%AA', 'Ъ');
    temp_text := REPLACE(temp_text, '%D1%8A', 'ъ');
    temp_text := REPLACE(temp_text, '%D0%AB', 'Ы');
    temp_text := REPLACE(temp_text, '%D1%8B', 'ы');
    temp_text := REPLACE(temp_text, '%D0%AC', 'Ь');
    temp_text := REPLACE(temp_text, '%D1%8C', 'ь');
    temp_text := REPLACE(temp_text, '%D0%AD', 'Э');
    temp_text := REPLACE(temp_text, '%D1%8D', 'э');
    temp_text := REPLACE(temp_text, '%D0%AE', 'Ю');
    temp_text := REPLACE(temp_text, '%D1%8E', 'ю');
    temp_text := REPLACE(temp_text, '%D0%AF', 'Я');
    temp_text := REPLACE(temp_text, '%D1%8F', 'я');
    return temp_text;
end;
$$ language plpgsql; 
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

