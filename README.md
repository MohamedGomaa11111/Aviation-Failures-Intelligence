<div align="center">

# ✈️ Aviation Safety & Fleet Reliability Command Center
### End-to-End Operational Risk, Fleet Aging & Hardware Failure Telemetry (2019–2026)

![Python](https://img.shields.io/badge/Python-Pandas_&_Jupyter-3776AB?style=for-the-badge&logo=python&logoColor=white)
![SQL Server](https://img.shields.io/badge/SQL_Server-T--SQL_&_Star_Schema-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-DAX_&_HTML_HUD-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Dataset](https://img.shields.io/badge/FAA_SDR_Data-496K+_Records-0F172A?style=for-the-badge)

**`496,000+ Validated Incidents`**  •  **`2019–2026 Operational Span`**  •  **`Star Schema Data Warehouse`**  •  **`3-Page Executive HUD`**

</div>

---

## 🎯 Executive Summary

Commercial aviation safety depends on identifying structural fatigue and mechanical anomalies **before** an aircraft enters high-stress flight phases. This project transforms **496,000+ raw Federal Aviation Administration (FAA) Service Difficulty Reports (SDR)** spanning **2019–2026** into an end-to-end **Aviation Safety Command Center**.

Engineered across a complete **Python ➔ SQL Server ➔ Power BI** pipeline, the solution connects raw regulatory maintenance logs to executive decision-making—isolating critical flight-phase risks, fleet aging inflection points, OEM defect distributions, and hardware-level failure modes.

> **Core Operational Takeaway:** While **76.62%** of total defects are intercepted proactively during ground maintenance, anomalies occurring during **Takeoff** carry a **76.53%** critical emergency conversion rate—and **72.19%** of all reported defects originate from airframes exceeding **30,000 flight hours**.

---

## 📊 Key Telemetry Benchmarks

| Telemetry Metric | Measured Value | Operational & Safety Significance |
| :--- | :---: | :--- |
| **Validated Defect Reports** | **`496K`** | Multi-year FAA SDR incident volume across commercial & regional fleets |
| **Critical Emergencies** | **`31K`** | High-severity anomalies requiring immediate precautionary procedures (`Codes A–D`) |
| **Overall Emergency Rate** | **`6.23%`** | Baseline conversion rate from reported defect to critical operational emergency |
| **Takeoff Emergency Rate** | **`76.53%`** | Highest-risk flight phase (`67.91%` during Climb vs. `14.31%` on Approach) |
| **Ground Inspection Capture** | **`76.62%`** | Share of total defects detected proactively prior to aircraft dispatch |
| **Aging Fleet Share (`30k+ hrs`)** | **`72.19%`** | Majority of defects concentrated in Mature (`30k–60k`) & High-Time (`>60k`) fleets |
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
