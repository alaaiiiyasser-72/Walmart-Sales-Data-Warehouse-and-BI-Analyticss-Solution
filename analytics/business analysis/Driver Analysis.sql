USE walmart;
GO

-- ============================================================
-- 5. DRIVER ANALYSIS
-- WHY DID IT HAPPEN?
-- ============================================================
-- Objective:
--   Investigate the potential drivers behind differences
--   in product profitability.
--
-- Main Drivers:
--   1. Discount
--   2. Shipping Cost
--   3. Sales Volume
-- ============================================================


-- ============================================================
-- 5.1 DISCOUNT VS PROFITABILITY
-- ============================================================
-- Check whether categories with higher discounts
-- have weaker profitability.

SELECT
    Product_Category,

    CAST(
        AVG(Average_Discount) * 100
        AS DECIMAL(10,2)
    ) AS Average_Discount_Percentage,

    SUM(Total_Sales) AS Total_Sales,

    SUM(Total_Profit) AS Total_Profit,

    CAST(
        SUM(Total_Profit)
        / NULLIF(SUM(Total_Sales), 0) * 100
        AS DECIMAL(10,2)
    ) AS Profit_Margin

FROM ANALYTICS.report_product_performance

GROUP BY Product_Category

ORDER BY Average_Discount_Percentage DESC;


-- ============================================================
-- 5.2 PROFITABILITY BY DISCOUNT BAND
-- ============================================================
-- Check how profitability changes across different
-- discount levels.

SELECT
    CASE
        WHEN Average_Discount < 0.02 THEN '0% - 2%'
        WHEN Average_Discount < 0.04 THEN '2% - 4%'
        WHEN Average_Discount < 0.06 THEN '4% - 6%'
        WHEN Average_Discount < 0.08 THEN '6% - 8%'
        ELSE '8%+'
    END AS Discount_Band,

    COUNT(*) AS Number_of_Products,

    SUM(Total_Sales) AS Total_Sales,

    SUM(Total_Profit) AS Total_Profit,

    CAST(
        SUM(Total_Profit)
        / NULLIF(SUM(Total_Sales), 0) * 100
        AS DECIMAL(10,2)
    ) AS Profit_Margin

FROM ANALYTICS.report_product_performance

GROUP BY
    CASE
        WHEN Average_Discount < 0.02 THEN '0% - 2%'
        WHEN Average_Discount < 0.04 THEN '2% - 4%'
        WHEN Average_Discount < 0.06 THEN '4% - 6%'
        WHEN Average_Discount < 0.08 THEN '6% - 8%'
        ELSE '8%+'
    END

ORDER BY MIN(Average_Discount);


-- ============================================================
-- 5.3 SHIPPING COST VS PROFITABILITY
-- ============================================================
-- Identify products where shipping cost represents
-- a relatively large percentage of Sales.

SELECT TOP 30
    Product_Name,
    Product_Category,
    Product_Sub_Category,

    Total_Sales,
    Total_Profit,
    Profit_Margin,
    Total_Shipping_Cost,

    CAST(
        Total_Shipping_Cost
        / NULLIF(Total_Sales, 0) * 100
        AS DECIMAL(10,2)
    ) AS Shipping_Cost_Percentage

FROM ANALYTICS.report_product_performance

WHERE Total_Sales > 0

ORDER BY Shipping_Cost_Percentage DESC;


-- ============================================================
-- 5.4 SALES VOLUME VS PROFITABILITY
-- ============================================================
-- Identify high-volume products and evaluate
-- whether high sales volume translates into strong profit.

SELECT TOP 30
    Product_Name,
    Product_Category,
    Product_Sub_Category,

    Total_Quantity_Sold,
    Total_Sales,
    Total_Profit,
    Profit_Margin

FROM ANALYTICS.report_product_performance

WHERE Total_Quantity_Sold > 0

ORDER BY Total_Quantity_Sold DESC;


-- ============================================================
-- 5.5 PRODUCT PROFITABILITY DRIVER SUMMARY
-- ============================================================
-- Focus on products with meaningful Sales volume
-- but weak profitability.
--
-- These products are priority candidates for
-- further investigation.

SELECT TOP 30
    Product_Name,
    Product_Category,
    Product_Sub_Category,

    Total_Sales,
    Total_Profit,
    Profit_Margin,

    Average_Discount,
    Total_Shipping_Cost,

    CAST(
        Total_Shipping_Cost
        / NULLIF(Total_Sales, 0) * 100
        AS DECIMAL(10,2)
    ) AS Shipping_Cost_Percentage

FROM ANALYTICS.report_product_performance

WHERE Total_Sales > 50000

ORDER BY
    Profit_Margin ASC,
    Total_Sales DESC;


-- ============================================================
-- END OF DRIVER ANALYSIS
-- ============================================================