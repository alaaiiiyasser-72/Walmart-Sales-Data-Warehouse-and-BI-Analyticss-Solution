USE walmart;
GO

-- ============================================================
-- TIME ANALYSIS 01
-- Monthly Sales & Profit Trend
--
-- Business Question:
-- How do Sales and Profit change from month to month?
-- ============================================================

WITH Monthly_Performance AS
(
    SELECT
        Year,
        Month,
        Month_Name,
        Total_Orders,
        Total_Sales,
        Total_Profit,
        Profit_Margin,

        -- Previous month's Sales
        LAG(Total_Sales) OVER (
            ORDER BY Year, Month
        ) AS Previous_Month_Sales,

        -- Previous month's Profit
        LAG(Total_Profit) OVER (
            ORDER BY Year, Month
        ) AS Previous_Month_Profit

    FROM Analytics.report_monthly_performance
)

SELECT
    Year,
    Month,
    Month_Name,

    Total_Orders,
    Total_Sales,
    Total_Profit,
    Profit_Margin,

    Previous_Month_Sales,
    Previous_Month_Profit,

    -- Month-over-Month Sales Growth %
    CAST(
        (Total_Sales - Previous_Month_Sales)
        / NULLIF(Previous_Month_Sales, 0)
        * 100
        AS DECIMAL(10,2)
    ) AS Sales_MoM_Growth,

    -- Month-over-Month Profit Growth %
    CAST(
        (Total_Profit - Previous_Month_Profit)
        / NULLIF(Previous_Month_Profit, 0)
        * 100
        AS DECIMAL(10,2)
    ) AS Profit_MoM_Growth

FROM Monthly_Performance
ORDER BY
    Year,
    Month;


-- ============================================================
-- TIME ANALYSIS 02
-- Best & Worst Months
-- ============================================================

SELECT
    Year,
    Month,
    Month_Name,
    Total_Sales,
    Total_Profit,
    Profit_Margin,

    -- Sales Ranking
    RANK() OVER (
        ORDER BY Total_Sales DESC
    ) AS Sales_Rank,

    -- Profit Ranking
    RANK() OVER (
        ORDER BY Total_Profit DESC
    ) AS Profit_Rank,

    -- Profit Margin Ranking
    RANK() OVER (
        ORDER BY Profit_Margin DESC
    ) AS Margin_Rank

FROM Analytics.report_monthly_performance
ORDER BY Sales_Rank;


USE walmart;
GO

-- ============================================================
-- TIME ANALYSIS 03
-- Seasonality Analysis
--
-- Business Question:
-- Is there a recurring seasonal pattern in monthly performance?
--
-- We compare the same month across different years.
-- Example:
-- January 2012 + January 2013 + January 2014 + January 2015
-- ============================================================

SELECT
    Month,
    Month_Name,

    -- Average performance across all available years
    CAST(AVG(Total_Sales) AS DECIMAL(18,2)) AS Avg_Monthly_Sales,

    CAST(AVG(Total_Profit) AS DECIMAL(18,2)) AS Avg_Monthly_Profit,

    CAST(AVG(Profit_Margin) AS DECIMAL(10,2)) AS Avg_Profit_Margin,

    CAST(AVG(Total_Orders) AS DECIMAL(10,2)) AS Avg_Monthly_Orders,

    CAST(AVG(Total_Quantity_Sold) AS DECIMAL(18,2)) AS Avg_Quantity_Sold

FROM ANALYTICS.report_monthly_performance

GROUP BY
    Month,
    Month_Name

ORDER BY
    Month;

-- ============================================================
-- TIME ANALYSIS 04
-- Seasonal Ranking
-- ============================================================

WITH Monthly_Averages AS
(
    SELECT
        Month,
        Month_Name,

        AVG(Total_Sales) AS Avg_Sales,
        AVG(Total_Profit) AS Avg_Profit,
        AVG(Profit_Margin) AS Avg_Margin

    FROM ANALYTICS.report_monthly_performance

    GROUP BY
        Month,
        Month_Name
)

SELECT
    Month,
    Month_Name,

    CAST(Avg_Sales AS DECIMAL(18,2)) AS Avg_Sales,
    CAST(Avg_Profit AS DECIMAL(18,2)) AS Avg_Profit,
    CAST(Avg_Margin AS DECIMAL(10,2)) AS Avg_Profit_Margin,

    RANK() OVER (
        ORDER BY Avg_Sales DESC
    ) AS Sales_Seasonal_Rank,

    RANK() OVER (
        ORDER BY Avg_Profit DESC
    ) AS Profit_Seasonal_Rank,

    RANK() OVER (
        ORDER BY Avg_Margin DESC
    ) AS Margin_Seasonal_Rank

FROM Monthly_Averages

ORDER BY
    Sales_Seasonal_Rank;


-- ============================================================
-- TIME ANALYSIS 05
-- Seasonal Performance vs Overall Average
--
-- Measures how each month performs relative to the
-- average monthly performance across the entire period.
-- ============================================================

WITH Monthly_Averages AS
(
    SELECT
        Month,
        Month_Name,

        AVG(Total_Sales) AS Avg_Sales,
        AVG(Total_Profit) AS Avg_Profit,
        AVG(Profit_Margin) AS Avg_Margin

    FROM ANALYTICS.report_monthly_performance

    GROUP BY
        Month,
        Month_Name
),

Overall_Average AS
(
    SELECT
        AVG(Total_Sales) AS Overall_Avg_Sales,
        AVG(Total_Profit) AS Overall_Avg_Profit,
        AVG(Profit_Margin) AS Overall_Avg_Margin

    FROM ANALYTICS.report_monthly_performance
)

SELECT
    m.Month,
    m.Month_Name,

    CAST(m.Avg_Sales AS DECIMAL(18,2)) AS Avg_Sales,

    CAST(
        (m.Avg_Sales - o.Overall_Avg_Sales)
        / NULLIF(o.Overall_Avg_Sales, 0) * 100
        AS DECIMAL(10,2)
    ) AS Sales_vs_Avg_Pct,

    CAST(m.Avg_Profit AS DECIMAL(18,2)) AS Avg_Profit,

    CAST(
        (m.Avg_Profit - o.Overall_Avg_Profit)
        / NULLIF(o.Overall_Avg_Profit, 0) * 100
        AS DECIMAL(10,2)
    ) AS Profit_vs_Avg_Pct,

    CAST(m.Avg_Margin AS DECIMAL(10,2)) AS Avg_Profit_Margin

FROM Monthly_Averages AS m
CROSS JOIN Overall_Average AS o

ORDER BY
    m.Month;


-- ============================================================
-- TIME ANALYSIS 06
-- Year-over-Year Monthly Comparison
--
-- Business Question:
-- How does each month perform compared with the same month
-- in the previous year?
-- ============================================================

WITH Monthly_Performance AS
(
    SELECT
        Year,
        Month,
        Month_Name,
        Total_Sales,
        Total_Profit,
        Profit_Margin,

        LAG(Total_Sales) OVER (
            PARTITION BY Month
            ORDER BY Year
        ) AS Previous_Year_Sales,

        LAG(Total_Profit) OVER (
            PARTITION BY Month
            ORDER BY Year
        ) AS Previous_Year_Profit

    FROM ANALYTICS.report_monthly_performance
)

SELECT
    Year,
    Month,
    Month_Name,

    Total_Sales,
    Total_Profit,
    Profit_Margin,

    Previous_Year_Sales,
    Previous_Year_Profit,

    CAST(
        (Total_Sales - Previous_Year_Sales)
        / NULLIF(Previous_Year_Sales, 0) * 100
        AS DECIMAL(10,2)
    ) AS YoY_Sales_Growth,

    CAST(
        (Total_Profit - Previous_Year_Profit)
        / NULLIF(Previous_Year_Profit, 0) * 100
        AS DECIMAL(10,2)
    ) AS YoY_Profit_Growth

FROM Monthly_Performance

ORDER BY
    Month,
    Year;

-- ============================================================
-- TIME ANALYSIS - BUSINESS INSIGHTS
-- ============================================================

-- Insight 1:
-- Monthly business performance is highly volatile.
-- Sales and Profit show significant month-to-month fluctuations
-- rather than a stable upward or downward trend.

-- Insight 2:
-- Revenue growth does not always translate into Profit growth.
-- Several months experienced Sales growth while Profit declined,
-- indicating that sales volume alone does not determine profitability.

-- Insight 3:
-- January has the highest average Sales among all months
-- (approximately 361K), while December also shows strong
-- average Sales performance (approximately 367K).
-- This indicates relatively strong revenue activity toward
-- the beginning and end of the year.

-- Insight 4:
-- October has the highest average Profit Margin (12.66%),
-- followed by September (12.29%) and January (11.54%).
-- These months demonstrate relatively strong profitability.

-- Insight 5:
-- August is the weakest month in terms of average Profit Margin
-- (7.09%) and average Profit (approximately 18.6K).
-- This pattern is also visible in multiple individual years,
-- suggesting a potential recurring seasonal weakness.

-- Insight 6:
-- March also shows relatively weak profitability, with an
-- average Profit Margin of 7.87%.
-- However, the weakness is not consistent across all years,
-- indicating that additional business factors may influence
-- March performance.

-- Insight 7:
-- March 2013 represents a major profitability anomaly.
-- Profit Margin dropped to only 0.51%, while Profit declined
-- by approximately 95% compared with March 2012.
-- This period should be investigated further using Product,
-- Customer, Discount, and other analytical reports.

-- Insight 8:
-- September 2013 experienced an exceptional performance spike,
-- with Sales increasing by approximately 101% and Profit by
-- approximately 129% compared with the previous month.
-- This represents a significant period for root-cause analysis.

-- Insight 9:
-- October shows historically strong profitability:
-- 15.28% margin in 2012, 13.30% in 2013, and 16.05% in 2014.
-- However, October 2015 experienced a sharp decline to 6.02%
-- despite Sales increasing by approximately 15% versus October 2014.
-- This indicates a deterioration in profit conversion rather
-- than a demand problem alone.

-- Insight 10:
-- Year-over-Year results show that monthly performance varies
-- substantially across years. Therefore, seasonality exists
-- only as a tendency rather than a perfectly consistent pattern.

-- ============================================================
-- BUSINESS RECOMMENDATIONS
-- ============================================================

-- Recommendation 1:
-- Investigate recurring weak periods, especially August,
-- to identify potential pricing, discount, product-mix,
-- or demand-related factors.

-- Recommendation 2:
-- Investigate major profitability anomalies such as March 2013
-- and October 2015 to identify the underlying business drivers.

-- Recommendation 3:
-- Analyze the drivers behind strong periods such as
-- September 2013 and October 2014 and determine whether
-- successful patterns can be replicated.

-- Recommendation 4:
-- Use profitability metrics alongside Sales when evaluating
-- monthly performance, since higher revenue does not always
-- result in higher profit.