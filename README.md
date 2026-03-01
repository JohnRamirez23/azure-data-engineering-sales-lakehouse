# 🚀 Azure Incremental Ingestion Architecture  
### Azure Data Factory + Azure SQL + Azure Data Lake Storage Gen2

---

## 📌 Project Overview

This project implements a production-style incremental ingestion architecture using:

- Azure Data Factory (ADF)
- Azure SQL Database
- Azure Data Lake Storage Gen2 (ADLS)
- Watermark-based incremental extraction
- Execution logging & observability

The solution simulates a real-world enterprise ingestion pattern using a two-phase architecture:

1️⃣ Landing ingestion (External CSV → Operational SQL)  
2️⃣ Incremental extraction (SQL → Bronze Data Lake in Parquet)

This design ensures scalability, idempotency, and traceability.

---

# 🏗 Architecture

![Architecture](docs/architecture-diagram.png)

---

## 🔹 Architecture Layers

### 1️⃣ External Source
- GitHub Repository
- File: `sales_data.csv`
- Acts as external data provider

---

### 2️⃣ Landing Layer (Initial Load)

**Pipeline:** `pl_stg_sales_from_github_dev`

Responsibilities:
- Reads CSV from GitHub
- Loads data into Azure SQL Database
- Performs initial operational ingestion

Flow:
GitHub CSV → Azure Data Factory → Azure SQL Database

---

### 3️⃣ Operational Layer

**Azure SQL Database**

Table:
`source_cars_data`

Acts as the operational source for incremental extraction.

---

### 4️⃣ Incremental Extraction Layer

**Pipeline:** `pl_brz_sales_from_sql_inc_dev`

Implements watermark-based incremental logic.

Flow:
Azure SQL → ADF Incremental Pipeline → ADLS Bronze (Parquet)

---

### 5️⃣ Bronze Layer (Data Lake Storage)

**Azure Data Lake Storage Gen2**

Container structure:

<img width="172" height="104" alt="image" src="https://github.com/user-attachments/assets/5c86b2ac-88ad-4172-adf4-1ba9778ab77e" />

Full storage path:

/bronze/incremental/


Characteristics:

- Format: Parquet
- Append-only incremental files
- Optimized for analytics workloads
- Idempotent incremental writes
- Designed for future Silver/Gold expansion

---

### 6️⃣ Control & Observability Layer

Control tables:

- `etl_watermark_control`
- `etl_run_log`

These enable:

- Incremental state tracking
- Execution logging
- Error capture
- Operational auditing

---

# 🔁 Incremental Flow

![Incremental Flow](docs/incremental-flow.png)

---

## 🔄 Incremental Process Logic

### Step 1 – Retrieve Last Watermark
Stored Procedure:
`usp_GetWatermark`

Reads last processed value from:
`etl_watermark_control`

---

### Step 2 – Retrieve Current Max Watermark
Query executed against:
`source_cars_data`

Example:
SELECT MAX(date_column)

---

### Step 3 – Compare Watermarks

Condition:
MaxWatermark > LastWatermark

---

## ✅ If New Data Exists

1. Copy incremental records
2. Write Parquet files to:
   `/bronze/incremental/`
3. Update watermark using:
   `usp_UpdateWatermark`
4. Log execution using:
   `usp_LogRun`

---

## ❌ If No New Data

- Log execution with status:
  `NO_NEW_DATA`

---

## 🚨 If Failure Occurs

- Capture error message
- Log failure in:
  `etl_run_log`

---

### ✔ Engineering Guarantees

- Idempotent execution
- No duplicate ingestion
- Stateful incremental control
- Full execution traceability
- Operational observability

---

# 📊 Data Model

![Data Model](docs/data-model.png)

---

## 🗄 Operational Table

### `source_cars_data`

Columns:

- Branch_ID
- Dealer_ID
- Model_ID
- Revenue
- Units_Sold
- Date_ID
- Year
- Month
- Day

---

## 🧩 Control Tables

### `etl_watermark_control`

- source_table (PK)
- watermark_column
- last_watermark_value
- updated_at

---

### `etl_run_log`

- id (PK)
- pipeline_name
- source_table
- rows_copied
- status (SUCCESS / FAILED / NO_NEW_DATA)
- error_message
- run_date

---

# 🧩 Design Decisions

- Watermark strategy chosen over full load to improve scalability.
- Parquet format selected for storage efficiency and analytics optimization.
- Control tables implemented for observability.
- Logging layer added to simulate production-grade monitoring.
- Two-phase ingestion model reflects enterprise architecture patterns.
- Append-only Bronze design prepared for downstream Silver/Gold layers.

---

# ⚙ Technologies Used

- Azure Data Factory (V2)
- Azure SQL Database
- Azure Data Lake Storage Gen2
- Parquet
- T-SQL Stored Procedures
- Git integration with ADF

---

# 🧠 Engineering Concepts Demonstrated

- Incremental ingestion architecture
- Watermark-based extraction strategy
- Idempotent pipeline execution
- Operational state management
- Structured logging & observability
- Enterprise-style ingestion layering

---

# 📁 Repository Structure

<img width="380" height="426" alt="image" src="https://github.com/user-attachments/assets/5b8b81ac-9686-43d2-a42b-8e9df5aba6f0" />

---

# 👨‍💻 Author

John Ramirez  
Data Engineer – Azure Data Engineering
