CREATE TABLE dbo.etl_run_log (
    id INT IDENTITY(1,1) PRIMARY KEY,
    pipeline_name VARCHAR(150),
    source_table VARCHAR(150),
    rows_copied INT,
    status VARCHAR(50),
    error_message VARCHAR(1000),
    run_date DATETIME2 DEFAULT SYSDATETIME()
);