CREATE OR ALTER PROCEDURE dbo.usp_UpdateWatermark
    @source_table VARCHAR(150),
    @new_watermark_value VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE dbo.etl_watermark_control
        SET last_watermark_value = @new_watermark_value,
            updated_at = SYSDATETIME()
        WHERE source_table = @source_table;

        IF @@ROWCOUNT = 0
        BEGIN
            THROW 50001, 'No watermark record found for given source_table.', 1;
        END

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;