USE walmart;
GO

-- ============================================================
-- 03 - SEGMENT ANALYSIS
-- PRODUCT ANALYSIS
-- ============================================================
-- Objective:
--   Analyze product performance and identify:
--   - Best and worst performing categories
--   - Top and bottom products
--   - Sales vs Profit differences
--   - Product profitability
-- ============================================================


-- ============================================================
-- 1. PRODUCT PERFORMANCE OVERVIEW
-- ============================================================
-- Business Questions:
--   1. Which products generate the highest Sales?
--   2. Which products generate the highest Profit?
--   3. Are the products with high Sales also highly profitable?
-- ============================================================

SELECT TOP 20
    Product_Name,
    Product_Category,
    Product_Sub_Category,
    Total_Sales,
    Total_Profit,
    Profit_Margin,
    Total_Quantity_Sold,
    Total_Orders
FROM ANALYTICS.report_product_performance
ORDER BY Total_Sales DESC;


-- ============================================================
-- 2. TOP PRODUCTS BY PROFIT
-- ============================================================
-- Identify products that contribute the most to profitability.
-- ============================================================

SELECT TOP 20
    Product_Name,
    Product_Category,
    Product_Sub_Category,
    Total_Sales,
    Total_Profit,
    Profit_Margin,
    Total_Quantity_Sold
FROM ANALYTICS.report_product_performance
ORDER BY Total_Profit DESC;


-- ============================================================
-- 3. LOW-PROFIT / LOSS-MAKING PRODUCTS
-- ============================================================
-- Identify products with negative or very low profitability.
-- These products require further investigation.
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
WHERE Total_Profit <= 0
ORDER BY Total_Profit ASC;


-- ============================================================
-- 4. CATEGORY PERFORMANCE
-- ============================================================
-- Business Questions:
--   Which product categories generate the most Sales?
--   Which categories generate the most Profit?
--   Which categories have the strongest Profit Margin?
-- ============================================================

SELECT
    Product_Category,

    SUM(Total_Orders) AS Total_Orders,
    SUM(Total_Quantity_Sold) AS Total_Quantity_Sold,
    SUM(Total_Sales) AS Total_Sales,
    SUM(Total_Profit) AS Total_Profit,

    CAST(
        SUM(Total_Profit)
        / NULLIF(SUM(Total_Sales), 0) * 100
        AS DECIMAL(10,2)
    ) AS Profit_Margin

FROM ANALYTICS.report_product_performance

GROUP BY Product_Category

ORDER BY Total_Sales DESC;


-- ============================================================
-- 5. SUB-CATEGORY PERFORMANCE
-- ============================================================
-- Analyze performance at a more detailed product level.
-- ============================================================

SELECT
    Product_Category,
    Product_Sub_Category,

    SUM(Total_Orders) AS Total_Orders,
    SUM(Total_Quantity_Sold) AS Total_Quantity_Sold,
    SUM(Total_Sales) AS Total_Sales,
    SUM(Total_Profit) AS Total_Profit,

    CAST(
        SUM(Total_Profit)
        / NULLIF(SUM(Total_Sales), 0) * 100
        AS DECIMAL(10,2)
    ) AS Profit_Margin

FROM ANALYTICS.report_product_performance

GROUP BY
    Product_Category,
    Product_Sub_Category

ORDER BY Total_Sales DESC;


-- ============================================================
-- 6. SALES VS PROFITABILITY
-- ============================================================
-- Identify products with:
--   High Sales but Low Profit Margin.
--
-- These products may represent revenue-heavy but
-- inefficient products.
-- ============================================================

SELECT TOP 20
    Product_Name,
    Product_Category,
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
-- 7. HIGH-PROFIT-MARGIN PRODUCTS
-- ============================================================
-- Identify products with strong profit efficiency.
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
ORDER BY Profit_Margin DESC;


-- ============================================================
-- 8. DISCOUNT VS PROFITABILITY
-- ============================================================
-- Investigate whether products with higher discounts
-- tend to have weaker profitability.
-- ============================================================

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
-- END OF PRODUCT ANALYSIS
-- ============================================================

-- ============================================================
-- PRODUCT ANALYSIS - BUSINESS INSIGHTS
-- ============================================================

-- Insight 1:
-- Technology is the strongest product category in terms of
-- both Sales and Profitability.
-- It generated approximately 5.98M in Sales and 886.3K in Profit,
-- with a Profit Margin of 14.81%.

-- Insight 2:
-- Furniture represents a major profitability concern.
-- Although it generated approximately 5.18M in Sales,
-- its Profit was only 117.4K, resulting in a low Profit Margin
-- of approximately 2.27%.
-- This indicates that strong Sales volume is not translating
-- efficiently into Profit.

-- Insight 3:
-- Furniture profitability problems are concentrated in specific
-- Sub-Categories, particularly Tables and Bookcases.
-- Tables generated approximately 1.90M in Sales but resulted
-- in a loss of approximately 99.1K, with a Profit Margin of -5.22%.
-- Bookcases also generated a loss of approximately 33.6K.

-- Insight 4:
-- Office Supplies demonstrates strong profitability efficiency.
-- Despite generating lower Sales than Technology and Furniture,
-- it generated approximately 518K in Profit with a Margin of 13.80%.

-- Insight 5:
-- Binders and Binder Accessories is one of the strongest
-- Sub-Categories, generating approximately 1.02M in Sales,
-- 307.4K in Profit, and a high Profit Margin of 30.05%.

-- Insight 6:
-- Product Sales ranking does not always reflect profitability.
-- Some high-revenue products generate negative Profit,
-- while products with lower Sales can generate substantially
-- higher Profit.
-- Therefore, Product performance should be evaluated using
-- both Sales and Profitability metrics.

-- Insight 7:
-- Several individual products generate significant losses.
-- Examples include Polycom ViewStation, Canon imageCLASS 2200,
-- and several Furniture Tables and Technology printers.
-- These products require further investigation to understand
-- the causes of their negative profitability.

-- Insight 8:
-- Some products demonstrate exceptionally high Profit Margins,
-- indicating potential opportunities to identify and replicate
-- successful product characteristics.
-- However, very high margins on low-sales products should be
-- interpreted carefully because their overall business impact
-- may be limited.

-- Insight 9:
-- Average Discount levels are relatively similar across the
-- three major categories, around 5%.
-- Therefore, category-level profitability differences cannot
-- be attributed to discount alone based on the current analysis.
-- Further analysis of discount at Product and Sub-Category level
-- is required.


-- ============================================================
-- PRODUCT ANALYSIS - BUSINESS RECOMMENDATIONS
-- ============================================================

-- Recommendation 1:
-- Investigate Furniture profitability, especially Tables and
-- Bookcases, to identify the underlying causes of negative margins.
-- Pricing, discounts, product costs, and product mix should be examined.

-- Recommendation 2:
-- Review loss-making products individually and evaluate whether
-- they should be repriced, renegotiated with suppliers, promoted
-- differently, or potentially discontinued.

-- Recommendation 3:
-- Protect and expand high-profit product lines such as
-- Binders and Binder Accessories and selected Technology products
-- that demonstrate strong Profit Margins.

-- Recommendation 4:
-- Avoid evaluating product success based on Sales alone.
-- Product decisions should consider Sales, Profit, Profit Margin,
-- and Quantity Sold together.

-- Recommendation 5:
-- Perform a deeper Discount Analysis to determine whether
-- specific products or Sub-Categories experience excessive
-- discounts that negatively affect profitability.

-- Recommendation 6:
-- Investigate highly profitable products to identify common
-- characteristics that could be replicated across other
-- products or categories.