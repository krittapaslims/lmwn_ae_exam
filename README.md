# lmwn_ae_exam

This repository contains the Analytics Engineering project for the **LINE MAN Wongnai AE Exam**.

## 📦 Project Overview

This project builds an end-to-end data modeling pipeline using [dbt](https://www.getdbt.com/) and [DuckDB](https://duckdb.org/) as the database engine.

Modular data models and reporting layers are designed to support business stakeholders, including:
- **Performance Marketing**
- **Fleet Management**
- **Customer Service**

---

## 📁 Repository Structure

```bash
ae_exam_main
├── Data Source                     # Data Source from LMWN
├── Requirements                    # Requirement from LMWN
├── dbt_ae_exam                     # DBT Project
    ├── ae_exam_db.duckdb           # Final output DuckDB file with all models and reports
    ├── dbt_project.yml             # dbt configuration
    ├── profiles.yml                # dbt connection profile (DuckDB)
    ├── models/                     # dbt models organized by layer
    │   ├── staging/                # Clean raw data from source tables
    │   ├── intermediate/           # Business logic transformations
    │   ├── mart/                   # Aggregated business-level facts/dims
    │   ├── report/                 # Final reporting tables
    │   └── schema.yml              # Tests & descriptions
    ├── seeds/                      # (if used) static lookup tables
    ├── snapshots/                  # (not used in this project)
    ├── macros/                     # Custom dbt macros
    ├── tests/                      # dbt tests
```

## 🚀 How to Use This Project

Follow these steps to clone, set up, and run the analytics engineering project using **dbt with DuckDB**.

---

### 1. Clone the repository

Clone the GitHub repo and move into the dbt project folder:

```bash
git clone https://github.com/<your-username>/lmwn_ae_exam.git
cd lmwn_ae_exam/ae_exam_main/dbt_ae_exam
```

### 2. Set up your Python environment

Create a virtual environment (optional but recommended) and install required packages:

```bash
# Create and activate virtual environment
python -m venv venv
source venv/bin/activate    # On Windows: venv\Scripts\activate

# Install dbt with DuckDB adapter
pip install dbt-duckdb
```

### 3. Check dbt profile configuration

Make sure your `profiles.yml` is correctly set to use DuckDB. Example:

```yaml
dbt_ae_exam:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: "ae_exam_db.duckdb"
```

### 4. Run dbt pipeline

Run all models and tests:

```bash
dbt build
```
Or run step-by-step:
```bash
dbt run    # Run only models
dbt test   # Run schema tests (e.g., not_null, unique)
```
### 5. View the results of your dbt models

After running `dbt build`, all models and reports will be materialized inside `ae_exam_db.duckdb`.

Here are 2 ways to view your results:

---

#### Option 1: DBeaver (Graphical Interface)

1. **Open DBeaver**  
   If not installed, download from [https://dbeaver.io](https://dbeaver.io)

2. **Create a DuckDB connection**  
   - Go to `Database` > `New Database Connection`
   - Search for **DuckDB**, click **Next**

3. **Browse for your file**  
   - Click the file picker and choose `ae_exam_db.duckdb`

4. **Connect and browse**  
   - Click **Finish**, then expand the database in the sidebar
   - You’ll see your models and reports under the `main` schema  
   - Right-click a table → **View Data** or **Edit Data**
---

#### Option 2: Python (with DuckDB)

Use Python to query and explore the result programmatically.

```python
import duckdb

# Connect to your database
con = duckdb.connect("ae_exam_db.duckdb")

# Run a sample query
df = con.sql("SELECT * FROM report_driver_performance_summary").df()
print(df)
```

## 🗺️ ERD Diagram (Lineage View)

To understand how staging, intermediate, mart, and report layers connect, please refer to:

👉 [ERD Diagram Link](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1&title=ERD_LMWN_AE_EXAM&dark=auto#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D1or5Vv6DrFH7Cf82XhCKe2hH6_56GQ050%26export%3Ddownload)

This visual shows how dbt models relate to one another and flow from raw data to final reports.
