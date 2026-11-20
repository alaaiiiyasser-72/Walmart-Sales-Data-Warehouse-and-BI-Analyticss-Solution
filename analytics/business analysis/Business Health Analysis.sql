--=========================================================
-- BUSINESS HEALTH ANALYSIS
-- Analysis #1: Overall Business Performance
--
-- Source:
--     gold.report_executive
--
-- Purpose:
--     Evaluate the overall health of the business based
--     on the executive-level reporting layer.
--=========================================================

SELECT
    SUM(Total_Sales) AS Total_Sales,
    SUM(Total_Profit) AS Total_Profit,

    CAST(
        SUM(Total_Profit)
        / NULLIF(SUM(Total_Sales), 0) * 100
        AS DECIMAL(10,2)
    ) AS Profit_Margin,

    SUM(Total_Orders) AS Total_Orders,

    SUM(Total_Quantity_Sold) AS Total_Quantity_Sold,

    CAST(
        SUM(Total_Sales)
        / NULLIF(SUM(Total_Orders), 0)
        AS DECIMAL(18,2)
    ) AS Average_Order_Value,

    SUM(Total_Shipping_Cost) AS Total_Shipping_Cost

FROM Analytics.report_executive;

---- 14915600.8240	1521767.9601	10.20	5496	214777	2713.90	107831.0400


--=========================================================
-- BUSINESS HEALTH ANALYSIS
-- Analysis #3: Sales vs Profit
--
-- Purpose:
--     Identify regions where high sales translate into
--     strong profitability and regions where they do not.
--=========================================================

SELECT
    Region,

    Total_Sales,

    Total_Profit,

    Profit_Margin,

    Total_Sales - Total_Profit AS Sales_Not_Converted_To_Profit

FROM gold.report_executive

WHERE Region IS NOT NULL

ORDER BY Total_Profit DESC;

--=========================================================
-- BUSINESS HEALTH ANALYSIS
-- Analysis #2: Regional Performance
--
-- Purpose:
--     Compare regions based on Sales, Profit,
--     Orders and Profitability.
--=========================================================

SELECT
    Region,

    Total_Sales,

    Total_Profit,

    Total_Orders,

    Total_Quantity_Sold,

    Total_Shipping_Cost,

    Average_Order_Value,

    Profit_Margin

FROM Analytics.report_executive

WHERE Region IS NOT NULL

ORDER BY Total_Sales DESC;


--=========================================================
-- BUSINESS HEALTH ANALYSIS
-- Analysis #3: Sales vs Profit
--
-- Purpose:
--     Identify regions where high sales translate into
--     strong profitability and regions where they do not.
--=========================================================

SELECT
    Region,

    Total_Sales,

    Total_Profit,

    Profit_Margin,

    Total_Sales - Total_Profit AS Sales_Not_Converted_To_Profit

FROM Analytics.report_executive

WHERE Region IS NOT NULL

ORDER BY Total_Profit DESC;


--=========================================================
-- BUSINESS HEALTH ANALYSIS
-- Analysis #4: Regional Profitability Ranking
--
-- Purpose:
--     Rank regions based on Profit Margin rather than
--     revenue alone.
--=========================================================

SELECT
    Region,

    Total_Sales,

    Total_Profit,

    Profit_Margin,

    RANK() OVER (
        ORDER BY Profit_Margin DESC
    ) AS Profitability_Rank

FROM Analytics.report_executive

WHERE Region IS NOT NULL

ORDER BY Profitability_Rank;

--=========================================================
-- BUSINESS HEALTH ANALYSIS
-- Analysis #5: Shipping Cost Efficiency
--
-- Purpose:
--     Compare shipping costs relative to sales across
--     regions.
--=========================================================

SELECT
    Region,

    Total_Sales,

    Total_Shipping_Cost,

    CAST(
        Total_Shipping_Cost
        / NULLIF(Total_Sales, 0) * 100
        AS DECIMAL(10,2)
    ) AS Shipping_Cost_Rate,

    Total_Profit,

    Profit_Margin

FROM gold.report_executive

WHERE Region IS NOT NULL

ORDER BY Shipping_Cost_Rate DESC;

--=========================================================
-- BUSINESS HEALTH ANALYSIS
-- Analysis #6: Regional Business Health Classification
--
-- Purpose:
--     Classify regions according to their profitability
--     and sales performance.
--=========================================================

SELECT
    Region,

    Total_Sales,

    Total_Profit,

    Profit_Margin,

    CASE
        WHEN Profit_Margin >= 15
             AND Total_Sales >= (
                 SELECT AVG(Total_Sales)
                 FROM gold.report_executive
                 WHERE Region IS NOT NULL
             )
            THEN 'Strong Performer'

        WHEN Profit_Margin < 10
            THEN 'Low Profitability'

        ELSE 'Average Performer'
    END AS Business_Health

FROM Analytics.report_executive

WHERE Region IS NOT NULL

ORDER BY Total_Sales DESC;


-- ============================================================
-- BUSINESS HEALTH ANALYSIS - BUSINESS INSIGHTS
-- ============================================================

-- Insight 1:
-- Central is the strongest region in terms of overall Sales volume.
-- It generated approximately 4.70M in Sales, the highest among all regions,
-- along with the highest number of Orders and Quantity Sold.
-- This indicates strong overall business activity in the Central region.

-- Insight 2:
-- South has the highest Profit Margin at approximately 13.41%,
-- making it the most profitable region in terms of profit efficiency.
-- Despite generating the lowest Sales among the four regions,
-- South generated approximately 422.5K in Profit.

-- Insight 3:
-- West shows a profitability concern.
-- Although West generated the second-highest Sales (approximately 3.65M),
-- it achieved the lowest Profit Margin at approximately 8.21%
-- and the lowest Profit among the regions.
-- This indicates that high Sales volume is not translating efficiently into Profit.

-- Insight 4:
-- Sales performance does not directly determine profitability.
-- The Sales ranking is Central > West > East > South,
-- while the Profit Margin ranking is South > Central > East > West.
-- This indicates significant differences in profit efficiency across regions.

-- Insight 5:
-- East generated lower Sales than West but achieved higher Profit.
-- East generated approximately 3.42M in Sales and 317.9K in Profit,
-- while West generated approximately 3.65M in Sales but only 299.5K in Profit.
-- This suggests that East converts its revenue into profit more efficiently.

-- Insight 6:
-- Central combines strong revenue scale with relatively healthy profitability.
-- It generated the highest Sales and Profit while maintaining
-- a Profit Margin of approximately 10.25%.
-- This makes Central both a volume leader and a strong contributor to total Profit.

-- Insight 7:
-- Shipping Cost does not appear to be the primary explanation
-- for the differences in regional profitability at the aggregate level.
-- Shipping Cost represents less than 1% of Sales across all regions,
-- while Profit Margin differences are much larger.
-- Therefore, other factors such as Product Mix, Discount,
-- Pricing, or Order characteristics should be investigated.


-- ============================================================
-- BUSINESS HEALTH ANALYSIS - BUSINESS RECOMMENDATIONS
-- ============================================================

-- Recommendation 1:
-- Investigate the West region to identify the factors
-- behind its relatively low Profit Margin despite strong Sales.
-- Product Mix, Discount levels, Pricing, and individual Product performance
-- should be analyzed in the Product Analysis.

-- Recommendation 2:
-- Investigate the South region to understand the drivers
-- behind its high Profit Margin despite having the lowest Sales.
-- Successful pricing, product mix, or customer patterns
-- may provide opportunities that can be replicated in other regions.

-- Recommendation 3:
-- Use Profit and Profit Margin alongside Sales when evaluating
-- regional performance.
-- Focusing only on revenue may lead to incorrect conclusions
-- about business performance.

-- Recommendation 4:
-- Compare the Product and Customer performance of each region
-- to identify the operational and commercial factors
-- driving the differences in profitability.

-- Recommendation 5:
-- Use Central as a benchmark for balancing business scale
-- and profitability, while investigating South for profitability practices
-- and West for potential improvement opportunities.

-- ============================================================
-- END OF BUSINESS HEALTH ANALYSIS
-- ============================================================




