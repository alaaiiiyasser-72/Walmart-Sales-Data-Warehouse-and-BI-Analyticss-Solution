USE walmart;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN

    DECLARE @start_time DATETIME,
            @end_time DATETIME,
            @batch_start_time DATETIME,
            @batch_end_time DATETIME;

    DECLARE @data_dir NVARCHAR(255)
        = 'D:\walmart project\raw data';

    DECLARE @sql NVARCHAR(MAX);

    BEGIN TRY

        SET @batch_start_time = GETDATE();

        PRINT 'Start Loading Bronze Layer';
        PRINT '-----------------------------';


        ---------------------------------------------------------
        -- Load Walmart Sales Table
        ---------------------------------------------------------
        PRINT 'Loading Walmart Dataset Table';

        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze.walmart_sales_raw;

        SET @sql = '
        BULK INSERT bronze.walmart_sales_raw
        FROM ''' + @data_dir + '\walmart_dataset.csv''
        WITH
        (
                FORMAT = ''CSV'',
				FIRSTROW = 2,
				FIELDQUOTE = ''"'',
				FIELDTERMINATOR = '','',
				ROWTERMINATOR = ''0x0a'',
				CODEPAGE = ''65001'',
				TABLOCK
        );';

        EXEC sp_executesql @sql;

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(
                DATEDIFF(
                    SECOND,
                    @start_time,
                    @end_time
                ) AS NVARCHAR
              )
            + ' seconds';

        PRINT '>> -------------';


        ---------------------------------------------------------
        -- Bronze Layer Loading Completed
        ---------------------------------------------------------
        SET @batch_end_time = GETDATE();

        PRINT '==========================================';
        PRINT 'Loading Bronze Layer is Completed';

        PRINT 'Total Load Duration: '
            + CAST(
                DATEDIFF(
                    SECOND,
                    @batch_start_time,
                    @batch_end_time
                ) AS NVARCHAR
              )
            + ' seconds';

        PRINT '==========================================';

    END TRY


    ---------------------------------------------------------
    -- Error Handling
    ---------------------------------------------------------
    BEGIN CATCH

        PRINT '==========================================';
        PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';

        PRINT 'Error Message: '
            + ERROR_MESSAGE();

        PRINT 'Error Number: '
            + CAST(ERROR_NUMBER() AS NVARCHAR(10));

        PRINT 'Error State: '
            + CAST(ERROR_STATE() AS NVARCHAR(10));

        PRINT '==========================================';

    END CATCH

END
GO


---------------------------------------------------------
-- Execute Bronze Load Procedure
---------------------------------------------------------
EXEC bronze.load_bronze;
GO

