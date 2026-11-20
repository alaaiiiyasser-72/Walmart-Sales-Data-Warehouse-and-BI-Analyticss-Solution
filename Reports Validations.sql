-- =============================================
-- Reports Data Validation
-- =============================================

-- 1. Row Count
SELECT 'Customer Report' AS Report_Name, COUNT(*) AS Row_Count
FROM Analytics.report_customer_performance

UNION ALL

SELECT 'Geographic Report', COUNT(*)
FROM Analytics.report_geographic_performance

UNION ALL

SELECT 'Shipping Report', COUNT(*)
FROM Analytics.report_shipping_performance;


-- 2. NULL Check
SELECT
    'Customer Report' AS Report_Name,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Null_Customer_Key,
    SUM(CASE WHEN Customer_Name IS NULL THEN 1 ELSE 0 END) AS Null_Customer_Name
FROM Analytics.report_customer_performance

UNION ALL

SELECT
    'Geographic Report',
    SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END),
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END)
FROM Analytics.report_geographic_performance

UNION ALL

SELECT
    'Shipping Report',
    SUM(CASE WHEN Ship_Mode IS NULL THEN 1 ELSE 0 END),
    SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END)
FROM Analytics.report_shipping_performance;


-- 3. Negative / Invalid Measures
SELECT 'Customer Report' AS Report_Name,
       COUNT(*) AS Invalid_Rows
FROM Analytics.report_customer_performance
WHERE Total_Sales < 0
   OR Total_Orders < 0
   OR Total_Quantity_Purchased < 0

UNION ALL

SELECT 'Geographic Report',
       COUNT(*)
FROM Analytics.report_geographic_performance
WHERE Total_Sales < 0
   OR Total_Orders < 0
   OR Total_Quantity_Sold < 0

UNION ALL

SELECT 'Shipping Report',
       COUNT(*)
FROM Analytics.report_shipping_performance
WHERE Total_Sales < 0
   OR Total_Orders < 0
   OR Total_Quantity < 0;