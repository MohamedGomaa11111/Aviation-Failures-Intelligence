<div align="center">

# ✈️ Aviation Safety & Fleet Reliability Command Center
### End-to-End Operational Risk, Fleet Aging & Hardware Failure Telemetry (2019–2026)

[![Python](https://img.shields.io/badge/Python-Pandas_&_Jupyter-3776AB?style=for-the-badge&logo=python&logoColor=white)](scripts/02_clean_and_model.ipynb)
[![SQL Server](https://img.shields.io/badge/SQL_Server-T--SQL_&_Star_Schema-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)](Sql/aviation_reliability_analysis.sql)
[![Power BI](https://img.shields.io/badge/Power_BI-DAX_&_HTML_HUD-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)](Aviation_Safety_Command_Center%20(2).pbix)
[![Executive Report](https://img.shields.io/badge/Executive_Dossier-PDF_Report-0F172A?style=for-the-badge&logo=adobeacrobatreader&logoColor=white)](Aviation%20Safety%20Command%20Center%20Executive%20Report%20(1).pdf)

**[Executive Summary](#-executive-summary) • [Architecture & Star Schema](#-system-architecture--star-schema) • [SQL & DAX Engineering](#-sql--dax-engineering-proof-of-work) • [Dashboard Gallery](#-interactive-dashboard-gallery) • [Strategic Recommendations](#-strategic-recommendations)**

</div>

---

## 🎯 Executive Summary

Commercial aviation safety relies on detecting structural fatigue and mechanical anomalies **before** an aircraft enters critical flight phases. This project transforms **496,000+ raw Federal Aviation Administration (FAA) Service Difficulty Reports (SDR)** spanning **2019–2026** into a unified **Aviation Safety Command Center**.

By engineering a full **Python ➔ SQL Server ➔ Power BI** pipeline, the solution bridges raw regulatory maintenance logs with executive decision-making—isolating high-risk flight phases, fleet age stress inflection points, OEM defect distributions, and hardware-level failure modes.

### 📊 Core Telemetry Benchmarks

| Telemetry Metric | Measured Value | Operational & Safety Significance |
| :--- | :---: | :--- |
| **Validated Defect Reports** | **`496K`** | Multi-year FAA SDR incident volume across commercial & regional airframes |
| **Critical Emergencies** | **`31K`** | High-severity anomalies triggering immediate precautionary procedures (`Codes A–D`) |
| **Overall Emergency Rate** | **`6.23%`** | Baseline conversion rate from reported defect to critical operational emergency |
| **Takeoff Emergency Rate** | **`76.53%`** | Highest-risk operational window (`67.91%` during Climb vs. `14.31%` on Approach) |
| **Ground Inspection Capture** | **`76.62%`** | Share of total defects intercepted proactively prior to flight dispatch |
| **Aging Fleet Share (`30k+ hrs`)** | **`72.19%`** | Majority of defects originate from Mature (`30k–60k`) & High-Time (`>60k`) airframes |
| **Primary Structural Vulnerability** | **`53.01%`** | **Fuselage Structure** share of Top 5 systems; **SKIN** (`24.2K`) is the #1 failing part |
| **Mean Reporting Latency** | **`30.77 Days`** | Average regulatory reporting lag between defect occurrence and FAA submission |

---

## 🏗️ System Architecture & Star Schema

### 1. End-to-End Data Pipeline
```mermaid
flowchart LR
    A[(Raw FAA SDR Logs<br/>496K+ Records)] --> B[Python ETL<br/>Schema Check and Cleaning]
    B --> C[(SQL Server DW<br/>AviationFailuresDW)]
    C --> D[T-SQL Analytics<br/>CTEs, LAG, DENSE_RANK]
    C --> E[Power BI Dashboard<br/>DAX and HTML Telemetry]
    D --> E
