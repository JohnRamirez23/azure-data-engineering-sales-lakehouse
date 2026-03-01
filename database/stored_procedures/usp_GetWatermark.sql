CREATE OR ALTER PROCEDURE dbo.usp_GetWatermark
    @source_table VARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT watermark_column,
           last_watermark_value
    FROM dbo.etl_watermark_control
    WHERE source_table = @source_table;
END;