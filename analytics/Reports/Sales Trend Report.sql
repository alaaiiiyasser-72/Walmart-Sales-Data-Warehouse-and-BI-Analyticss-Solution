--=========================================================
-- Report: Sales Trend Report
-- Purpose:
--   Analyze sales and profitability over time.
--
-- Analysis Level:
--   Year / Quarter / Month
--
-- Source:
--   gold.fact_sales
--   gold.dim_date
--=========================================================

CREATE OR ALTER VIEW Analytics.report_sales_trend
AS

SELECT
    d.Year,
    d.Quarter,
    d.Month,
    d.Month_Name,

    -- Number of unique orders
    COUNT(DISTINCT f.Order_ID) AS Total_Orders,

    -- Quantity sold
    SUM(f.Order_Quantity) AS Total_Quantity_Sold,

    -- Revenue
    SUM(f.Sales) AS Total_Sales,

    -- Profit
    SUM(f.Profit) AS Total_Profit,

    -- Shipping cost
    SUM(f.Shipping_Cost) AS Total_Shipping_Cost,

    -- Profit margin
    CAST(
        SUM(f.Profit)
        / NULLIF(SUM(f.Sales), 0)
        * 100
        AS DECIMAL(10,2)
    ) AS Profit_Margin

FROM gold.fact_sales f

LEFT JOIN gold.dim_date d
    ON f.Order_Date_ID = d.Date_ID

GROUP BY
    d.Year,
    d.Quarter,
    d.Month,
    d.Month_Name;
GO