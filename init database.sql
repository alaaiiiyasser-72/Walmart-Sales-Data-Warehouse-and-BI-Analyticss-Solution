---Create Database and schemas
USE master;
GO

-- Drop and recreate the 'RetaiDW' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'walmart')
BEGIN
    ALTER DATABASE walmart SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE walmart;
END;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE walmart;
GO

USE walmart;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

CREATE SCHEMA Analytics;
GO