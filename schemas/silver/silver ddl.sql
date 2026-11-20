USE walmart ;
--====================================================================
-- SILVER LAYER
-- DDL: Create Silver Walmart Sales Table
--====================================================================
-- Purpose:
--   Create the Silver table for cleaned, standardized, and
--   analysis-ready Walmart sales data.
--
--   The Silver layer is responsible for:
--     1. Applying appropriate data types.
--     2. Preparing the data for analytical use.
--     3. Enforcing basic data integrity constraints.
--
--   Data cleaning and transformation will be performed during the
--   Silver loading process, not in the Bronze layer.
--====================================================================


--====================================================================
-- 1. CREATE SILVER SCHEMA
--====================================================================
-- Purpose:
--   Create the Silver schema if it does not already exist.
--====================================================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'silver'
)
BEGIN
    EXEC('CREATE SCHEMA silver');
END;
GO


--====================================================================
-- 2. DROP EXISTING SILVER TABLE
--====================================================================
-- Purpose:
--   Drop the existing table if it already exists.
--
--   This allows the DDL script to be safely re-run during development
--   and testing.
--====================================================================

IF OBJECT_ID('silver.walmart_sales', 'U') IS NOT NULL
    DROP TABLE silver.walmart_sales;
GO


--====================================================================
-- 3. CREATE SILVER TABLE
--====================================================================
-- Purpose:
--   Create the cleaned and typed Walmart Sales table.
--
--   Data types are selected based on the Bronze Quality Checks.
--====================================================================

CREATE TABLE silver.walmart_sales
(
    --==============================================================
    -- Customer Information
    --==============================================================

    City                    NVARCHAR(100),
    
    -- Customer_Age is stored as values such as '46.0' in Bronze.
    -- It will be converted through DECIMAL first, then INT in the
    -- Silver loading process.
    Customer_Age            INT,
    
    Customer_Name           NVARCHAR(150),
    Customer_Segment        NVARCHAR(100),


    --==============================================================
    -- Order Information
    --==============================================================

    Order_ID                NVARCHAR(50),
    Order_Date              DATE,
    Order_Priority          NVARCHAR(50),
    Order_Quantity          INT,
    Number_of_Records       INT,


    --==============================================================
    -- Product Information
    --==============================================================

    Product_Category        NVARCHAR(100),
    Product_Sub_Category    NVARCHAR(100),
    Product_Name            NVARCHAR(255),
    Product_Container       NVARCHAR(100),
    Product_Base_Margin     DECIMAL(10,4),


    --==============================================================
    -- Financial Information
    --==============================================================
    -- DECIMAL is used for financial and numeric measures to provide
    -- controlled precision instead of floating-point approximation.
    --================================================================

    Sales                   DECIMAL(18,4),
    Profit                  DECIMAL(18,4),
    Discount                DECIMAL(10,4),
    Unit_Price              DECIMAL(18,4),
    Shipping_Cost           DECIMAL(18,4),


    --==============================================================
    -- Shipping Information
    --==============================================================

    Ship_Date               DATE,
    Ship_Mode               NVARCHAR(100),


    --==============================================================
    -- Geographic Information
    --==============================================================

    Region                  NVARCHAR(100),
    State                   NVARCHAR(100),

    -- Zip_Code remains NVARCHAR because it is an identifier rather
    -- than a numeric measure.
    -- Keeping it as text also prevents loss of leading zeros.
    Zip_Code                NVARCHAR(50),


    --==============================================================
    -- Record Identifier
    --==============================================================
    -- Row_ID was validated in the Bronze Quality Checks:
    --   - No NULL values
    --   - No duplicate values
    --   - Total rows = Distinct Row_IDs
    --
    -- Therefore, Row_ID is used as the Primary Key in Silver.
    --================================================================

    Row_ID                  INT,


    --==============================================================
    -- PRIMARY KEY CONSTRAINT
    --==============================================================
    -- Purpose:
    --   Enforce uniqueness and prevent NULL values for Row_ID.
    --================================================================

    CONSTRAINT PK_silver_walmart_sales
        PRIMARY KEY (Row_ID)

);
GO

