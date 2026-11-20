
--====================================================================
-- SILVER LAYER
-- QUICK DATA QUALITY CHECK
--====================================================================
-- Purpose:
--   Validate that the Silver layer was successfully cleaned,
--   standardized, and loaded from the Bronze layer.
--
-- Checks:
--   1. Total Rows
--   2. Missing Values
--   3. Invalid Numeric Values
--   4. Invalid Dates
--   5. Business Rule Violations
--   6. Duplicate Row_ID
--====================================================================


--====================================================================
-- 1. ROW COUNT
--====================================================================

SELECT 
    COUNT(*) AS Total_Rows
FROM silver.walmart_sales;


--====================================================================
-- 2. MISSING VALUES
--====================================================================

SELECT
    SUM(CASE WHEN Customer_Age IS NULL THEN 1 ELSE 0 END) 
        AS Missing_Customer_Age,

    SUM(CASE WHEN Product_Base_Margin IS NULL THEN 1 ELSE 0 END) 
        AS Missing_Product_Base_Margin,

    SUM(CASE WHEN Order_ID IS NULL THEN 1 ELSE 0 END) 
        AS Missing_Order_ID,

    SUM(CASE WHEN Product_Name IS NULL THEN 1 ELSE 0 END) 
        AS Missing_Product_Name,

    SUM(CASE WHEN Row_ID IS NULL THEN 1 ELSE 0 END) 
        AS Missing_Row_ID

FROM silver.walmart_sales;


--====================================================================
-- 3. NUMERIC VALIDATION
--====================================================================
-- Check for unexpected negative values in measures.
--====================================================================

SELECT
    SUM(CASE WHEN Order_Quantity <= 0 THEN 1 ELSE 0 END)
        AS Invalid_Order_Quantity,

    SUM(CASE WHEN Sales < 0 THEN 1 ELSE 0 END)
        AS Invalid_Sales,

    SUM(CASE WHEN Shipping_Cost < 0 THEN 1 ELSE 0 END)
        AS Invalid_Shipping_Cost,

    SUM(CASE WHEN Unit_Price < 0 THEN 1 ELSE 0 END)
        AS Invalid_Unit_Price,

    SUM(CASE WHEN Discount < 0 OR Discount > 1 THEN 1 ELSE 0 END)
        AS Invalid_Discount

FROM silver.walmart_sales;


--====================================================================
-- 4. DATE VALIDATION
--====================================================================
-- Verify that shipping does not occur before the order.
--====================================================================

SELECT
    SUM(
        CASE
            WHEN Ship_Date < Order_Date THEN 1
            ELSE 0
        END
    ) AS Ship_Date_Before_Order_Date

FROM silver.walmart_sales;


--====================================================================
-- 5. DUPLICATE CHECK
--====================================================================
-- Row_ID should be unique because it is the Primary Key.
--====================================================================

SELECT
    COUNT(*) - COUNT(DISTINCT Row_ID) AS Duplicate_Row_ID_Count
FROM silver.walmart_sales;


--====================================================================
-- 6. FINAL QUALITY SUMMARY
--====================================================================
-- Quick overview of the most important Silver quality checks.
--====================================================================

SELECT
    COUNT(*) AS Total_Rows,

    SUM(CASE WHEN Customer_Age IS NULL THEN 1 ELSE 0 END)
        AS Missing_Customer_Age,

    SUM(CASE WHEN Product_Base_Margin IS NULL THEN 1 ELSE 0 END)
        AS Missing_Product_Base_Margin,

    SUM(CASE WHEN Row_ID IS NULL THEN 1 ELSE 0 END)
        AS Missing_Row_ID,

    SUM(CASE WHEN Order_Quantity <= 0 THEN 1 ELSE 0 END)
        AS Invalid_Order_Quantity,

    SUM(CASE WHEN Sales < 0 THEN 1 ELSE 0 END)
        AS Invalid_Sales,

    SUM(CASE WHEN Shipping_Cost < 0 THEN 1 ELSE 0 END)
        AS Invalid_Shipping_Cost,

    SUM(CASE WHEN Ship_Date < Order_Date THEN 1 ELSE 0 END)
        AS Invalid_Date_Relationship

FROM silver.walmart_sales;

