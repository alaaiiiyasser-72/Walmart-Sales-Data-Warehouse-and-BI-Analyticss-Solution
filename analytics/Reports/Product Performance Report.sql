--=========================================================
-- Report: Product Performance Report
-- Purpose:
--   Analyze product sales, profitability and quantity.
--
-- Analysis Dimensions:
--   - Product
--   - Category
--   - Sub-Category
--
-- Source:
--   gold.fact_sales
--   gold.dim_products
--=========================================================

CREATE OR ALTER VIEW Analytics.report_product_performance
AS

SELECT
    p.Product_ID,
    p.Product_Name,
    p.Product_Category,
    p.Product_Sub_Category,
    p.Product_Container,

    -- Number of orders containing the product
    COUNT(DISTINCT f.Order_ID) AS Total_Orders,

    -- Quantity sold
    SUM(f.Order_Quantity) AS Total_Quantity_Sold,

    -- Revenue generated
    SUM(f.Sales) AS Total_Sales,

    -- Profit generated
    SUM(f.Profit) AS Total_Profit,

    -- Average selling price
    AVG(f.Unit_Price) AS Average_Unit_Price,

    -- Average discount
    AVG(f.Discount) AS Average_Discount,

    -- Profit margin
    CAST(
        SUM(f.Profit)
        / NULLIF(SUM(f.Sales), 0)
        * 100
        AS DECIMAL(10,2)
    ) AS Profit_Margin

FROM gold.fact_sales f

LEFT JOIN gold.dim_products p
    ON f.Product_ID = p.Product_ID

GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Product_Category,
    p.Product_Sub_Category,
    p.Product_Container;
GO