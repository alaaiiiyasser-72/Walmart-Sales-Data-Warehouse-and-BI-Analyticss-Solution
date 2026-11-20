--=========================================================
-- Report: Shipping Performance Report
-- Purpose:
--   Analyze shipping modes, costs and their relationship
--   with sales and profitability.
--
-- Analysis Dimensions:
--   - Ship Mode
--   - Region
--
-- Source:
--   gold.fact_sales
--   gold.dim_location
--=========================================================




/* =========================================================
   3. SHIPPING PERFORMANCE REPORT
   ========================================================= */

CREATE OR ALTER VIEW Analytics.report_shipping_performance
AS

SELECT
    f.Ship_Mode,
    l.Region,

    -- Number of unique orders
    COUNT(DISTINCT f.Order_ID) AS Total_Orders,

    -- Total quantity shipped
    SUM(f.Order_Quantity) AS Total_Quantity,

    -- Revenue
    SUM(f.Sales) AS Total_Sales,

    -- Profit
    SUM(f.Profit) AS Total_Profit,

    -- Total shipping cost
    SUM(f.Shipping_Cost) AS Total_Shipping_Cost,

    -- Average shipping cost per sales row
    AVG(f.Shipping_Cost) AS Average_Shipping_Cost,

    -- Profit margin
    CAST(
        SUM(f.Profit)
        / NULLIF(SUM(f.Sales), 0)
        * 100
        AS DECIMAL(10,2)
    ) AS Profit_Margin

FROM gold.fact_sales f

LEFT JOIN gold.dim_locations l
    ON f.Location_ID = l.Location_ID

GROUP BY
    f.Ship_Mode,
    l.Region;
GO