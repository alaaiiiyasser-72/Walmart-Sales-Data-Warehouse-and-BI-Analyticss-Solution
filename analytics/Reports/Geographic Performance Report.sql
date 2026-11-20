--=========================================================
-- Report: Geographic Performance Report
-- Purpose:
--   Analyze sales and profitability by geographic location.
--
-- Geographic Hierarchy:
--   Region
--   State
--   City
--
-- Source:
--   gold.fact_sales
--   gold.dim_location
--=========================================================

/* =========================================================
   2. GEOGRAPHIC PERFORMANCE REPORT
   ========================================================= */

CREATE OR ALTER VIEW Analytics.report_geographic_performance
AS

SELECT
    l.Region,
    l.State,
    l.City,
    l.Zip_Code,

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

LEFT JOIN gold.dim_locations l
    ON f.Location_ID = l.Location_ID

GROUP BY
    l.Region,
    l.State,
    l.City,
    l.Zip_Code;
GO