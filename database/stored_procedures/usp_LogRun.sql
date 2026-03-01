CREATE OR ALTER PROCEDURE dbo.usp_LogRun
    @pipeline_name VARCHAR(150),
    @source_table VARCHAR(150),
    @rows_copied INT,
    @status VARCHAR(50),
    @error_message VARCHAR(1000) = NULL
AS
BEGIN
    INSERT INTO dbo.etl_run_log
    VALUES (
        @pipeline_name,
        @source_table,
        @rows_copied,
        @status,
        @error_message,
        SYSDATETIME()
    );
END;