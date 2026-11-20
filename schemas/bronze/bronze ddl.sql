/*
===========================================================
Bronze Layer - Raw Data Ingestion
===========================================================

Purpose:
The Bronze layer is responsible for ingesting raw data from
the source CSV files into SQL Server without applying any
business rules or transformations.

Features:
- Load raw data from source files.
- Preserve the original dataset as received.
- Maintain data fidelity for auditing and traceability.
- No data cleansing or business transformations.
- Perform basic data quality assessment after loading.

Source:
CSV Files

Target:
Bronze Layer

===========================================================
*/

USE walmart;
GO

-- Drop table if exist

DROP TABLE IF EXISTS bronze.walmart_sales_raw

-- ============================================
-- Create walmart_dataset Table
-- ============================================

DROP TABLE IF EXISTS bronze.walmart_sales_raw;
GO

CREATE TABLE bronze.walmart_sales_raw
(
    City                    NVARCHAR(100),
    Customer_Age            NVARCHAR(50),
    Customer_Name           NVARCHAR(150),
    Customer_Segment        NVARCHAR(100),
    Discount                NVARCHAR(50),
    Number_of_Records       NVARCHAR(50),
    Order_Date              NVARCHAR(50),
    Order_ID                NVARCHAR(50),
    Order_Priority          NVARCHAR(50),
    Order_Quantity          NVARCHAR(50),
    Product_Base_Margin     NVARCHAR(50),
    Product_Category        NVARCHAR(100),
    Product_Container       NVARCHAR(100),
    Product_Name            NVARCHAR(255),
    Product_Sub_Category    NVARCHAR(100),
    Profit                  NVARCHAR(50),
    Region                  NVARCHAR(100),
    Row_ID                  NVARCHAR(50),
    Sales                   NVARCHAR(50),
    Ship_Date               NVARCHAR(50),
    Ship_Mode               NVARCHAR(100),
    Shipping_Cost           NVARCHAR(50),
    State                   NVARCHAR(100),
    Unit_Price              NVARCHAR(50),
    Zip_Code                NVARCHAR(50)
);
GO