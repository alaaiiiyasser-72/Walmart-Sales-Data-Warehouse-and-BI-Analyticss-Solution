USE walmart;
GO

-- ============================================================
-- Report: Monthly Performance
-- Purpose:
--   Analyze business performance over time at monthly level
--
-- Source:
--   gold.fact_sales
--   gold.dim_date
--
-- Used for:
--   Time Analysis
--   Monthly Trends
--   MoM Growth
--   Best / Worst Months
--   Seasonality
-- ============================================================

-- Drop the view if it already exists
IF OBJECT_ID('Analytics.report_monthly_performance', 'V') IS NOT NULL
    DROP VIEW Analytics.report_monthly_performance;
GO


CREATE VIEW Analytics.report_monthly_performance
AS
SELECT
    d.Year,
    d.Month,
    d.Month_Name,

    -- Business Volume
    COUNT(DISTINCT f.Order_ID) AS Total_Orders,
    SUM(f.Order_Quantity) AS Total_Quantity_Sold,

    -- Financial Performance
    SUM(f.Sales) AS Total_Sales,
    SUM(f.Profit) AS Total_Profit,

    -- Shipping
    SUM(f.Shipping_Cost) AS Total_Shipping_Cost,

    -- Average Order Value
    CAST(
        SUM(f.Sales)
        / NULLIF(COUNT(DISTINCT f.Order_ID), 0)
        AS DECIMAL(18,2)
    ) AS Average_Order_Value,

    -- Profit Margin
    CAST(
        SUM(f.Profit)
        / NULLIF(SUM(f.Sales), 0)
        * 100
        AS DECIMAL(10,2)
    ) AS Profit_Margin

FROM gold.fact_sales AS f

INNER JOIN gold.dim_date AS d
    ON f.Order_Date_ID = d.Date_ID

GROUP BY
    d.Year,
    d.Month,
    d.Month_Name;
GO


-- ============================================================
-- Validation
-- ============================================================

SELECT *
FROM ANALYTICS.report_monthly_performance
ORDER BY
    Year,
    Month;
