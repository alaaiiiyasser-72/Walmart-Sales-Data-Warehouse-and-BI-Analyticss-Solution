--=========================================================
-- Report: Executive Sales Report
-- Purpose:
--   Provide high-level business KPIs and regional performance.
--
-- Main KPIs:
--   - Total Sales
--   - Total Profit
--   - Total Orders
--   - Total Quantity Sold
--   - Average Order Value
--   - Profit Margin
--   - Total Shipping Cost
--
-- Source:
--   gold.fact_sales
--   gold.dim_locations
--=========================================================

CREATE OR ALTER VIEW Analytics.report_executive
AS

SELECT
    l.Region,

    ---------------------------------------------------------
    -- Total number of unique orders
    ---------------------------------------------------------
    COUNT(DISTINCT f.Order_ID) AS Total_Orders,

    ---------------------------------------------------------
    -- Total quantity of products sold
    ---------------------------------------------------------
    SUM(f.Order_Quantity) AS Total_Quantity_Sold,

    ---------------------------------------------------------
    -- Total revenue generated
    ---------------------------------------------------------
    SUM(f.Sales) AS Total_Sales,

    ---------------------------------------------------------
    -- Total profit generated
    ---------------------------------------------------------
    SUM(f.Profit) AS Total_Profit,

    ---------------------------------------------------------
    -- Total shipping cost
    ---------------------------------------------------------
    SUM(f.Shipping_Cost) AS Total_Shipping_Cost,

    ---------------------------------------------------------
    -- Average order value
    ---------------------------------------------------------
    CAST(
        SUM(f.Sales)
        / NULLIF(COUNT(DISTINCT f.Order_ID), 0)
        AS DECIMAL(18,2)
    ) AS Average_Order_Value,

    ---------------------------------------------------------
    -- Profit margin percentage
    ---------------------------------------------------------
    CAST(
        SUM(f.Profit)
        / NULLIF(SUM(f.Sales), 0)
        * 100
        AS DECIMAL(10,2)
    ) AS Profit_Margin

FROM gold.fact_sales AS f

LEFT JOIN gold.dim_locations AS l
    ON f.Location_ID = l.Location_ID

GROUP BY
    l.Region;
GO