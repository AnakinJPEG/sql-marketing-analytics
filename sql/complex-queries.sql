-- Budget And Conversion Rates

WITH campaign_metrics AS (
    SELECT 
        camp.campaign_id,
        camp.name,
        camp.budget,
        COUNT(DISTINCT cc.customer_id) AS total_contacts,
        COUNT(DISTINCT CASE 
            WHEN DATEDIFF(conv.conversion_date, camp.start_date) <= 7 
            THEN conv.customer_id 
        END) AS conversions_7day,
        COUNT(DISTINCT CASE 
            WHEN DATEDIFF(conv.conversion_date, camp.start_date) <= 30 
            THEN conv.customer_id 
        END) AS conversions_30day,
        COUNT(DISTINCT CASE 
            WHEN DATEDIFF(conv.conversion_date, camp.start_date) <= 90 
            THEN conv.customer_id 
        END) AS conversions_90day
    FROM campaigns camp
    LEFT JOIN campaign_contacts cc ON camp.campaign_id = cc.campaign_id
    LEFT JOIN conversions conv ON camp.campaign_id = conv.campaign_id
    GROUP BY camp.campaign_id
)
SELECT 
    name,
    budget,
    total_contacts,
    conversions_7day,
    conversions_30day,
    conversions_90day,
    ROUND(conversions_7day / NULLIF(total_contacts, 0) * 100, 2) AS conversion_rate_7day,
    ROUND(conversions_30day / NULLIF(total_contacts, 0) * 100, 2) AS conversion_rate_30day,
    ROUND(conversions_90day / NULLIF(total_contacts, 0) * 100, 2) AS conversion_rate_90day
FROM campaign_metrics
ORDER BY conversion_rate_90day DESC;

-- Conversion Rate & ROI

WITH roi_analysis AS (
   SELECT 
   c.campaign_id,
   ROUND((SUM(revenue) - c.budget) / c.budget , 2) AS roi,
   budget,
   SUM(revenue) AS total_revenue
   FROM campaigns c, conversions conv
   WHERE c.campaign_id = conv.campaign_id
   GROUP BY c.campaign_id
),
   conversions_rates AS (
      SELECT
      c.campaign_id,
      COUNT(DISTINCT conv.customer_id) / COUNT(DISTINCT cc.customer_id) * 100 AS conversion_rate
      FROM campaigns c, conversions conv, campaign_contacts cc
      WHERE c.campaign_id = conv.campaign_id
      AND c.campaign_id = cc.campaign_id
      GROUP BY c.campaign_id
)
SELECT 
ra.campaign_id,
roi,
conversion_rate,
budget,
total_revenue,
RANK() OVER(ORDER BY roi DESC) AS roi_rank,
RANK() OVER(ORDER BY conversion_rate DESC) AS conv_rank 
FROM roi_analysis ra, conversions_rates cr
WHERE ra.campaign_id = cr.campaign_id
GROUP BY ra.campaign_id;

-- Funnel Analysis

WITH funnel AS (
    SELECT 
        camp.channel,
        COUNT(DISTINCT cc.customer_id) AS contacted,
        COUNT(DISTINCT conv.customer_id) AS converted,
        COUNT(DISTINCT CASE 
            WHEN conv.customer_id IN (
                SELECT customer_id 
                FROM conversions 
                GROUP BY customer_id 
                HAVING COUNT(*) >= 2
            ) THEN conv.customer_id 
        END) AS repeat_buyers
    FROM campaigns camp
    LEFT JOIN campaign_contacts cc ON camp.campaign_id = cc.campaign_id
    LEFT JOIN conversions conv ON camp.campaign_id = conv.campaign_id
    GROUP BY camp.channel
)
SELECT 
    channel,
    contacted,
    converted,
    contacted - converted AS drop_off,
    converted - repeat_buyers AS repeat_drop_off,
    repeat_buyers,
    ROUND(converted / NULLIF(contacted, 0) * 100, 2) AS conversion_rate,
    ROUND(repeat_buyers / NULLIF(converted, 0) * 100, 2) AS repeat_rate
FROM funnel
ORDER BY conversion_rate DESC;

-- Recency Analysis

WITH time_to_convert AS (
    SELECT 
        camp.channel,
        DATEDIFF(conv.conversion_date, cc.contact_date) AS days_to_convert
    FROM campaigns camp
    JOIN campaign_contacts cc ON camp.campaign_id = cc.campaign_id
    JOIN conversions conv ON camp.campaign_id = conv.campaign_id
    WHERE conv.customer_id = cc.customer_id
)
SELECT 
    channel,
    AVG(days_to_convert) AS avg_days_to_convert,
    MIN(days_to_convert) AS fastest,
    MAX(days_to_convert) AS slowest,
    COUNT(*) AS total_conversions,
    RANK() OVER (ORDER BY channel)
FROM time_to_convert
GROUP BY channel
ORDER BY avg_days_to_convert;  



