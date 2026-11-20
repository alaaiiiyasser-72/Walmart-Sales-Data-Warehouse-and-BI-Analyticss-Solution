
--====================================================================
-- SILVER LAYER
-- STORED PROCEDURE: Load Silver Walmart Sales
--====================================================================
-- Purpose:
--   Clean, standardize, and transform data from the Bronze layer
--   into the Silver Walmart Sales table.
--
-- Main Transformations:
--   1. Remove unwanted spaces using TRIM().
--   2. Standardize State values using UPPER().
--   3. Convert numeric columns to appropriate data types.
--   4. Convert date columns from NVARCHAR to DATE.
--   5. Convert Customer_Age from values such as '46.0' to INT.
--   6. Preserve missing values as NULL.
--
-- Source:
--   bronze.walmart_sales_raw
--
-- Target:
--   silver.walmart_sales
--====================================================================

GO

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN

    --==============================================================
    -- Declare variables for process logging
    --==============================================================

    DECLARE @StartTime      DATETIME,
            @EndTime        DATETIME,
            @BatchStartTime DATETIME,
            @BatchEndTime   DATETIME,
            @RowCount       INT;


    BEGIN TRY

        --==========================================================
        -- START PROCESS
        --==========================================================

        SET @BatchStartTime = GETDATE();

        PRINT '=========================================================';
        PRINT 'Loading Silver Layer';
        PRINT '=========================================================';


        --==========================================================
        -- STEP 1: TRUNCATE SILVER TABLE
        --==========================================================
        -- Purpose:
        --   Remove previously loaded data before reloading the
        --   cleaned dataset.
        --
        --   Bronze remains untouched because it contains the
        --   original raw data.
        --==========================================================

        SET @StartTime = GETDATE();

        PRINT '>> Truncating Silver Table...';

        TRUNCATE TABLE silver.walmart_sales;

        SET @EndTime = GETDATE();

        PRINT '>> Truncate completed in: '
              + CAST(DATEDIFF(SECOND, @StartTime, @EndTime) AS NVARCHAR)
              + ' seconds';


        --==========================================================
        -- STEP 2: LOAD SILVER TABLE
        --==========================================================
        -- Purpose:
        --   Clean and convert Bronze data before inserting it
        --   into Silver.
        --==========================================================

        SET @StartTime = GETDATE();

        PRINT '>> Inserting data into Silver...';


        INSERT INTO silver.walmart_sales
        (
            City,
            Customer_Age,
            Customer_Name,
            Customer_Segment,

            Order_ID,
            Order_Date,
            Order_Priority,
            Order_Quantity,
            Number_of_Records,

            Product_Category,
            Product_Sub_Category,
            Product_Name,
            Product_Container,
            Product_Base_Margin,

            Sales,
            Profit,
            Discount,
            Unit_Price,
            Shipping_Cost,

            Ship_Date,
            Ship_Mode,

            Region,
            State,
            Zip_Code,

            Row_ID
        )

        SELECT

            --======================================================
            -- Customer Information
            --======================================================

            TRIM(City) AS City,

            -- Customer_Age is stored in Bronze as values such as
            -- '46.0'. Convert to DECIMAL first, then INT.
            --
            -- Empty values become NULL.
            TRY_CONVERT(
                INT,
                TRY_CONVERT(
                    DECIMAL(10,2),
                    NULLIF(TRIM(Customer_Age), '')
                )
            ) AS Customer_Age,

            TRIM(Customer_Name) AS Customer_Name,

            TRIM(Customer_Segment) AS Customer_Segment,


            --======================================================
            -- Order Information
            --======================================================

            TRIM(Order_ID) AS Order_ID,

            TRY_CONVERT(
                DATE,
                NULLIF(TRIM(Order_Date), '')
            ) AS Order_Date,

            TRIM(Order_Priority) AS Order_Priority,

            TRY_CONVERT(
                INT,
                NULLIF(TRIM(Order_Quantity), '')
            ) AS Order_Quantity,

            TRY_CONVERT(
                INT,
                NULLIF(TRIM(Number_of_Records), '')
            ) AS Number_of_Records,


            --======================================================
            -- Product Information
            --======================================================

            TRIM(Product_Category) AS Product_Category,

            TRIM(Product_Sub_Category) AS Product_Sub_Category,

            TRIM(Product_Name) AS Product_Name,

            TRIM(Product_Container) AS Product_Container,

            TRY_CONVERT(
                DECIMAL(10,4),
                NULLIF(TRIM(Product_Base_Margin), '')
            ) AS Product_Base_Margin,


            --======================================================
            -- Financial Information
            --======================================================

            TRY_CONVERT(
                DECIMAL(18,4),
                NULLIF(TRIM(Sales), '')
            ) AS Sales,

            TRY_CONVERT(
                DECIMAL(18,4),
                NULLIF(TRIM(Profit), '')
            ) AS Profit,

            TRY_CONVERT(
                DECIMAL(10,4),
                NULLIF(TRIM(Discount), '')
            ) AS Discount,

            TRY_CONVERT(
                DECIMAL(18,4),
                NULLIF(TRIM(Unit_Price), '')
            ) AS Unit_Price,

            TRY_CONVERT(
                DECIMAL(18,4),
                NULLIF(TRIM(Shipping_Cost), '')
            ) AS Shipping_Cost,


            --======================================================
            -- Shipping Information
            --======================================================

            TRY_CONVERT(
                DATE,
                NULLIF(TRIM(Ship_Date), '')
            ) AS Ship_Date,

            TRIM(Ship_Mode) AS Ship_Mode,


            --======================================================
            -- Geographic Information
            --======================================================

            TRIM(Region) AS Region,

            -- Standardize State values to uppercase.
            UPPER(TRIM(State)) AS State,

            -- Zip_Code remains NVARCHAR because it is an identifier
            -- and may contain leading zeros.
            TRIM(Zip_Code) AS Zip_Code,


            --======================================================
            -- Record Identifier
            --======================================================

            TRY_CONVERT(
                INT,
                NULLIF(TRIM(Row_ID), '')
            ) AS Row_ID


        FROM bronze.walmart_sales_raw;


        SET @EndTime = GETDATE();

        PRINT '>> Insert completed in: '
              + CAST(DATEDIFF(SECOND, @StartTime, @EndTime) AS NVARCHAR)
              + ' seconds';


        --==========================================================
        -- STEP 3: GET LOADED ROW COUNT
        --==========================================================
        -- Store the count in a variable before using it in PRINT.
        -- This avoids using a subquery directly inside PRINT.
        --==========================================================

        SELECT @RowCount = COUNT(*)
        FROM silver.walmart_sales;

        PRINT '>> Silver Row Count: '
              + CAST(@RowCount AS NVARCHAR);


        --==========================================================
        -- END PROCESS
        --==========================================================

        SET @BatchEndTime = GETDATE();

        PRINT '=========================================================';
        PRINT 'Silver Layer Load Completed Successfully';

        PRINT 'Total Duration: '
              + CAST(
                    DATEDIFF(
                        SECOND,
                        @BatchStartTime,
                        @BatchEndTime
                    )
                    AS NVARCHAR
                )
              + ' seconds';

        PRINT '=========================================================';


    END TRY


    --==============================================================
    -- ERROR HANDLING
    --==============================================================

    BEGIN CATCH

        PRINT '=========================================================';
        PRINT 'ERROR OCCURRED WHILE LOADING SILVER LAYER';
        PRINT '=========================================================';

        PRINT 'Error Number: '
              + CAST(ERROR_NUMBER() AS NVARCHAR);

        PRINT 'Error Message: '
              + ERROR_MESSAGE();

        PRINT 'Error Line: '
              + CAST(ERROR_LINE() AS NVARCHAR);

        PRINT 'Error Procedure: '
              + ISNULL(ERROR_PROCEDURE(), 'N/A');

        PRINT '=========================================================';

        THROW;

    END CATCH;

END;
GO

EXEC silver.load_silver;