CREATE TABLE dbo.etl_watermark_control (
    source_table         VARCHAR(150) PRIMARY KEY,
    watermark_column     VARCHAR(150) NOT NULL,
    last_watermark_value VARCHAR(100) NOT NULL,
    updated_at           DATETIME2 DEFAULT SYSDATETIME()
);