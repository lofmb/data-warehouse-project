/*
====================================================== 
Create Database and Schemas 
=======================================================
Purpose of Script:
This script creates a new Database named 'DataWareHouse' and after checking if it already exists.
If it does exist. It will be dropped and recreated.
Also the script sets up 3 schemas within the database 'bronze' 'silver' and 'gold'

*/
USE master;

GO
-- Drop and Recreate the 'DataWarehouse' database

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')

BEGIN
	ALTER DATABASE Datawarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

-- Create the 'DataWarehouse' database

CREATE DATABASE DataWarehouse;

GO 

USE DataWarehouse;
GO
-- Create Schemas 
CREATE SCHEMA bronze;

GO

CREATE SCHEMA silver;

GO

CREATE SCHEMA gold;
