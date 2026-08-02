-- ROI Per Campaign

SELECT
c.campaign_id,
ROUND((SUM(revenue) - c.budget) / c.budget, 2) AS roi
FROM campaigns c, conversions conv
WHERE c.campaign_id = conv.campaign_id
GROUP BY campaign_id;

-- Customer Journey

WITH customer_journey AS (
SELECT
conv.customer_id,
CONCAT(first_name, ' ', last_name) AS full_name,
COUNT(conversion_id) AS total_conversions,
SUM(revenue) AS total_revenue,
MAX(conversion_date) AS last_conversion_date
FROM customers c
INNER JOIN conversions conv ON conv.customer_id = c.customer_id
GROUP BY conv.customer_id
)
SELECT *,
RANK() OVER(ORDER BY total_revenue DESC) AS revenue_rank,
RANK() OVER(ORDER BY total_conversions DESC) AS conversion_rank
FROM customer_journey;

-- Channel Performance
WITH channel_performance_rank AS(
    SELECT
    c.channel,
    SUM(revenue)
    FROM campaigns c, conversions conv
    WHERE c.campaign_id = conv.campaign_id
    GROUP BY c.channel
)
SELECT * FROM channel_performance_rank;

-- Campaign Conversion Rate
WITH campaign_conv_rank AS (
SELECT
conv.campaign_id,
COUNT(DISTINCT conv.customer_id) / COUNT(DISTINCT cc.customer_id) * 100 AS conversion_rate
FROM campaigns c
INNER JOIN campaign_contacts cc
ON c.campaign_id = cc.campaign_id
INNER JOIN conversions conv
ON c.campaign_id = conv.campaign_id
GROUP BY c.campaign_id
)
SELECT *,
DENSE_RANK() OVER(ORDER BY conversion_rate) AS campaign_rank
FROM  campaign_conv_rank;
