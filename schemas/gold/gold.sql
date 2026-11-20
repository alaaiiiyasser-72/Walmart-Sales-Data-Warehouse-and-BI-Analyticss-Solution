
USE Walmart;
GO


--=============================================================================
-- GOLD LAYER
-- STAR SCHEMA
--=============================================================================
-- Purpose:
--   Create an analytical Star Schema directly from the Silver layer.
--
-- Dimensions:
--   - dim_customers
--   - dim_products
--   - dim_locations
--   - dim_date
--
-- Fact:
--   - fact_sales
--
-- Note:
--   Customer_ID, Product_ID and Location_ID are Surrogate Keys generated
--   using ROW_NUMBER() because the source dataset does not provide
--   dedicated Customer/Product/Location IDs.
--=============================================================================


--=============================================================================
-- 1. CUSTOMER DIMENSION
--=============================================================================
-- Purpose:
--   Store unique customer attributes.
--
-- Customer_ID:
--   Surrogate key generated for each unique customer record.
--=============================================================================

IF OBJECT_ID('gold.dim_customers','V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers
AS

SELECT

    -------------------------------------------------------------------------
    -- Surrogate Key
    -------------------------------------------------------------------------

    ROW_NUMBER() OVER
    (
        ORDER BY
            Customer_Name,
            Customer_Age,
            Customer_Segment
    ) AS Customer_ID,


    -------------------------------------------------------------------------
    -- Customer Attributes
    -------------------------------------------------------------------------

    Customer_Name,
    Customer_Age,
    Customer_Segment

FROM
(
    SELECT DISTINCT

        Customer_Name,
        Customer_Age,
        Customer_Segment

    FROM silver.walmart_sales

) AS customers;
GO



--=============================================================================
-- 2. PRODUCT DIMENSION
--=============================================================================
-- Purpose:
--   Store unique product attributes.
--
-- Product_ID:
--   Surrogate key generated for each unique product.
--=============================================================================

IF OBJECT_ID('gold.dim_products','V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products
AS

SELECT

    -------------------------------------------------------------------------
    -- Surrogate Key
    -------------------------------------------------------------------------

    ROW_NUMBER() OVER
    (
        ORDER BY
            Product_Name,
            Product_Category,
            Product_Sub_Category,
            Product_Container
    ) AS Product_ID,


    -------------------------------------------------------------------------
    -- Product Attributes
    -------------------------------------------------------------------------

    Product_Name,
    Product_Category,
    Product_Sub_Category,
    Product_Container,
    Product_Base_Margin

FROM
(
    SELECT DISTINCT

        Product_Name,
        Product_Category,
        Product_Sub_Category,
        Product_Container,
        Product_Base_Margin

    FROM silver.walmart_sales

) AS products;
GO



--=============================================================================
-- 3. LOCATION DIMENSION
--=============================================================================
-- Purpose:
--   Store unique geographical attributes.
--
-- Location_ID:
--   Surrogate key generated for each unique location.
--=============================================================================

IF OBJECT_ID('gold.dim_locations','V') IS NOT NULL
    DROP VIEW gold.dim_locations;
GO

CREATE VIEW gold.dim_locations
AS

SELECT

    -------------------------------------------------------------------------
    -- Surrogate Key
    -------------------------------------------------------------------------

    ROW_NUMBER() OVER
    (
        ORDER BY
            City,
            State,
            Region,
            Zip_Code
    ) AS Location_ID,


    -------------------------------------------------------------------------
    -- Location Attributes
    -------------------------------------------------------------------------

    City,
    State,
    Region,
    Zip_Code

FROM
(
    SELECT DISTINCT

        City,
        State,
        Region,
        Zip_Code

    FROM silver.walmart_sales

) AS locations;
GO



--=============================================================================
-- 4. DATE DIMENSION
--=============================================================================
-- Purpose:
--   Create a reusable Date Dimension for Order Date and Ship Date analysis.
--=============================================================================

IF OBJECT_ID('gold.dim_date','V') IS NOT NULL
    DROP VIEW gold.dim_date;
GO

CREATE VIEW gold.dim_date
AS

SELECT DISTINCT

    -------------------------------------------------------------------------
    -- Date Key (YYYYMMDD)
    -------------------------------------------------------------------------

    YEAR(full_date) * 10000 +
    MONTH(full_date) * 100 +
    DAY(full_date) AS Date_ID,


    -------------------------------------------------------------------------
    -- Calendar Attributes
    -------------------------------------------------------------------------

    full_date,

    YEAR(full_date) AS Year,

    DATEPART(QUARTER, full_date) AS Quarter,

    MONTH(full_date) AS Month,

    DATENAME(MONTH, full_date) AS Month_Name,

    DAY(full_date) AS Day,

    DATEPART(WEEKDAY, full_date) AS Day_Of_Week,

    DATENAME(WEEKDAY, full_date) AS Day_Name

FROM
(
    -------------------------------------------------------------------------
    -- Order Dates
    -------------------------------------------------------------------------

    SELECT Order_Date AS full_date

    FROM silver.walmart_sales

    WHERE Order_Date IS NOT NULL


    UNION


    -------------------------------------------------------------------------
    -- Ship Dates
    -------------------------------------------------------------------------

    SELECT Ship_Date AS full_date

    FROM silver.walmart_sales

    WHERE Ship_Date IS NOT NULL

) AS dates;
GO



--=============================================================================
-- 5. SALES FACT
--=============================================================================
-- Purpose:
--   Store sales transactions and measurable business metrics.
--
-- Grain:
--   One row represents one record from silver.walmart_sales.
--
-- Foreign Keys:
--   - Customer_ID
--   - Product_ID
--   - Location_ID
--   - Order_Date_ID
--   - Ship_Date_ID
--=============================================================================

IF OBJECT_ID('gold.fact_sales','V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales
AS

SELECT

    -------------------------------------------------------------------------
    -- Transaction Identifiers
    -------------------------------------------------------------------------

    s.Row_ID,

    s.Order_ID,


    -------------------------------------------------------------------------
    -- Customer Foreign Key
    -------------------------------------------------------------------------

    c.Customer_ID,


    -------------------------------------------------------------------------
    -- Product Foreign Key
    -------------------------------------------------------------------------

    p.Product_ID,


    -------------------------------------------------------------------------
    -- Location Foreign Key
    -------------------------------------------------------------------------

    l.Location_ID,


    -------------------------------------------------------------------------
    -- Order Date Foreign Key
    -------------------------------------------------------------------------

    CASE
        WHEN s.Order_Date IS NOT NULL
        THEN
            YEAR(s.Order_Date) * 10000 +
            MONTH(s.Order_Date) * 100 +
            DAY(s.Order_Date)
    END AS Order_Date_ID,


    -------------------------------------------------------------------------
    -- Ship Date Foreign Key
    -------------------------------------------------------------------------

    CASE
        WHEN s.Ship_Date IS NOT NULL
        THEN
            YEAR(s.Ship_Date) * 10000 +
            MONTH(s.Ship_Date) * 100 +
            DAY(s.Ship_Date)
    END AS Ship_Date_ID,


    -------------------------------------------------------------------------
    -- Order Attributes
    -------------------------------------------------------------------------

    s.Order_Priority,
    s.Ship_Mode,


    -------------------------------------------------------------------------
    -- Measures
    -------------------------------------------------------------------------

    s.Order_Quantity,
    s.Sales,
    s.Profit,
    s.Discount,
    s.Unit_Price,
    s.Shipping_Cost,
    s.Product_Base_Margin


FROM silver.walmart_sales AS s


--=============================================================================
-- Join Customer Dimension
--=============================================================================

LEFT JOIN gold.dim_customers AS c

    ON ISNULL(c.Customer_Name, '') =
       ISNULL(s.Customer_Name, '')

   AND ISNULL(c.Customer_Age, -1) =
       ISNULL(s.Customer_Age, -1)

   AND ISNULL(c.Customer_Segment, '') =
       ISNULL(s.Customer_Segment, '')



--=============================================================================
-- Join Product Dimension
--=============================================================================

LEFT JOIN gold.dim_products AS p

    ON ISNULL(p.Product_Name, '') =
       ISNULL(s.Product_Name, '')

   AND ISNULL(p.Product_Category, '') =
       ISNULL(s.Product_Category, '')

   AND ISNULL(p.Product_Sub_Category, '') =
       ISNULL(s.Product_Sub_Category, '')

   AND ISNULL(p.Product_Container, '') =
       ISNULL(s.Product_Container, '')

   AND ISNULL(p.Product_Base_Margin, -1) =
       ISNULL(s.Product_Base_Margin, -1)



--=============================================================================
-- Join Location Dimension
--=============================================================================

LEFT JOIN gold.dim_locations AS l

    ON ISNULL(l.City, '') =
       ISNULL(s.City, '')

   AND ISNULL(l.State, '') =
       ISNULL(s.State, '')

   AND ISNULL(l.Region, '') =
       ISNULL(s.Region, '')

   AND ISNULL(l.Zip_Code, '') =
       ISNULL(s.Zip_Code, '');

GO

