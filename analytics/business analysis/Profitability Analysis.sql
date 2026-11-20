-- ============================================================
-- 4. PROFITABILITY ANALYSIS
-- Sales ? Profit
-- ============================================================


-- ============================================================
-- 4.1 HIGH SALES BUT LOW PROFITABILITY
-- ============================================================
-- Business Question:
--   Are the products generating the highest Sales also
--   generating strong Profit?
--
-- Purpose:
--   Identify products that generate significant revenue
--   but have weak or negative profitability.
-- ============================================================

SELECT TOP 20
    Product_Name,
    Product_Category,
    Product_Sub_Category,
    Total_Sales,
    Total_Profit,
    Profit_Margin,
    Average_Discount
FROM ANALYTICS.report_product_performance
WHERE Total_Sales > 0
ORDER BY
    Total_Sales DESC,
    Profit_Margin ASC;


-- ============================================================
-- 4.2 HIGH SALES BUT NEGATIVE PROFIT
-- ============================================================
-- Identify products that generate substantial revenue
-- while actually losing money.
-- ============================================================

SELECT
    Product_Name,
    Product_Category,
    Product_Sub_Category,
    Total_Sales,
    Total_Profit,
    Profit_Margin,
    Average_Discount
FROM ANALYTICS.report_product_performance
WHERE Total_Sales > 50000
  AND Total_Profit < 0
ORDER BY Total_Sales DESC;


-- ============================================================
-- 4.3 HIGH PROFITABILITY PRODUCTS
-- ============================================================
-- Identify products that convert Sales into Profit efficiently.
-- ============================================================

SELECT TOP 20
    Product_Name,
    Product_Category,
    Product_Sub_Category,
    Total_Sales,
    Total_Profit,
    Profit_Margin
FROM ANALYTICS.report_product_performance
WHERE Total_Sales > 0
  AND Total_Profit > 0
ORDER BY Profit_Margin DESC;


-- ============================================================
-- 4.4 SALES RANK VS PROFIT RANK
-- ============================================================
-- Compare product ranking by Sales and Profit.
--
-- Purpose:
--   Identify products whose Sales position differs significantly
--   from their Profit position.
-- ============================================================

WITH Product_Ranking AS
(
    SELECT
        Product_Name,
        Product_Category,
        Total_Sales,
        Total_Profit,
        Profit_Margin,

        RANK() OVER (
            ORDER BY Total_Sales DESC
        ) AS Sales_Rank,

        RANK() OVER (
            ORDER BY Total_Profit DESC
        ) AS Profit_Rank

    FROM ANALYTICS.report_product_performance
)

SELECT
    Product_Name,
    Product_Category,
    Total_Sales,
    Total_Profit,
    Profit_Margin,
    Sales_Rank,
    Profit_Rank,

    Sales_Rank - Profit_Rank AS Rank_Difference

FROM Product_Ranking

ORDER BY ABS(Sales_Rank - Profit_Rank) DESC;


-- ============================================================
-- 4.5 CATEGORY PROFITABILITY EFFICIENCY
-- ============================================================
-- Compare how efficiently each category converts
-- Sales into Profit.
-- ============================================================

SELECT
    Product_Category,

    SUM(Total_Sales) AS Total_Sales,
    SUM(Total_Profit) AS Total_Profit,

    CAST(
        SUM(Total_Profit)
        / NULLIF(SUM(Total_Sales), 0) * 100
        AS DECIMAL(10,2)
    ) AS Profit_Margin

FROM ANALYTICS.report_product_performance

GROUP BY Product_Category

ORDER BY Profit_Margin DESC;


-- ============================================================
-- END OF PROFITABILITY ANALYSIS
-- ============================================================