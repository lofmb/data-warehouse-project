/*
=====================================================================================
Stored Procedure: load_bronze
Schema: bronze
=====================================================================================
Purpose:
  This stored procedure is responsible for initializing and loading the Bronze layer
  from external CSV files into the database. It ensures a consistent and repeatable 
  process for ingesting raw data at scale.

Process Overview:
  1. Truncate the existing Bronze tables to guarantee a clean state.
  2. Load new data from external CSV files into the Bronze schema using the BULK INSERT
     command, preserving raw fidelity for downstream processing.

Parameters:
  None
  - This procedure does not accept input parameters.
  - No result set is returned.

Execution:
  To invoke the procedure, run the following command:
    EXEC bronze.load_bronze;

Notes:
  - Intended as the first step in the ETL pipeline (Source → Bronze).
  - Should be executed prior to loading subsequent layers (Silver/Gold).
  - Requires access to external CSV files configured for BULK INSERT.
=====================================================================================
*/


EXEC bronze.load_bronze

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT'=============================================';
		PRINT 'Loading the Bronze layer';
		PRINT'=============================================';
		
		PRINT '--------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '--------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>> Inserting Data Into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Data Warehouse Project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>> --------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> Inserting Data Into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Data Warehouse Project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>> --------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>> Inserting Data Into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Data Warehouse Project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>> --------------'

		PRINT '--------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '--------------------------------------------';
	
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12.csv';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Data Warehouse Project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>> --------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101.csv';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Data Warehouse Project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>> --------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.px_cat_g1v2.csv';
		TRUNCATE TABLE bronze.px_cat_g1v2;

		PRINT '>> Inserting Data Into: bronze.px_cat_g1v2';
		BULK INSERT bronze.px_cat_g1v2
		FROM 'C:\Data Warehouse Project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>> --------------'

		SET @batch_end_time = GETDATE();
		PRINT '====================================='
		PRINT 'Loading of the Bronze Layer has been completed';
		PRINT 'Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '====================================='

	END TRY
	BEGIN CATCH
		PRINT '====================================================='
		PRINT 'ERROR OCURRED DURING THE LOADING OF THE BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE()
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR)
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR) 
		PRINT '====================================================='
	END CATCH
END
