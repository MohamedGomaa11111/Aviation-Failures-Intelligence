--Year-over-Year Defects Growth Analysis
WITH YearlyDefects AS (
    SELECT 
        d.[Year],
        d.Aviation_Era,
        COUNT(*) AS Total_Defects,
        AVG(CAST(f.Reporting_Lag_Days AS FLOAT)) AS Avg_Reporting_Lag_Days,
        COUNT(DISTINCT f.Aircraft_Key) AS Affected_Aircraft_Count
    FROM Fact_Defects f
    JOIN Dim_Date d ON f.DifficultyDate = d.[Date]
    GROUP BY d.[Year], d.Aviation_Era
)
SELECT 
    [Year],
    Aviation_Era,
    Total_Defects,
    LAG(Total_Defects) OVER (ORDER BY [Year]) AS Prev_Year_Defects,
    ROUND(
        (CAST(Total_Defects - LAG(Total_Defects) OVER (ORDER BY [Year]) AS FLOAT) / 
        NULLIF(LAG(Total_Defects) OVER (ORDER BY [Year]), 0)) * 100, 2
    ) AS YoY_Growth_Pct,
    ROUND(Avg_Reporting_Lag_Days, 1) AS Avg_Lag_Days,
    Affected_Aircraft_Count
FROM YearlyDefects
ORDER BY [Year];
GO 

----Critical Systems by Manufacturer
WITH ManufacturerSystems AS (
    SELECT 
        a.Manufacturer_Clean,
        s.ATA_Chapter,
        s.System_Category,
        COUNT(*) AS Defect_Count,
        SUM(COUNT(*)) OVER (PARTITION BY a.Manufacturer_Clean) AS Total_Mfg_Defects
    FROM Fact_Defects f
    JOIN Dim_Aircraft a ON f.Aircraft_Key = a.Aircraft_Key
    JOIN Dim_System s   ON f.System_Key   = s.System_Key
    WHERE a.Manufacturer_Clean <> 'OTHER'
    GROUP BY a.Manufacturer_Clean, s.ATA_Chapter, s.System_Category
),
RankedSystems AS (
    SELECT 
        Manufacturer_Clean,
        ATA_Chapter,
        System_Category,
        Defect_Count,
        ROUND((CAST(Defect_Count AS FLOAT) / Total_Mfg_Defects) * 100, 2) AS Share_Of_Mfg_Pct,
        DENSE_RANK() OVER (PARTITION BY Manufacturer_Clean ORDER BY Defect_Count DESC) AS System_Rank
    FROM ManufacturerSystems
)
SELECT *
FROM RankedSystems
WHERE System_Rank <= 3
ORDER BY Manufacturer_Clean, System_Rank;
GO 

-- Fleet Age & Operational Stress Analysis
SELECT 
    CASE 
        WHEN AircraftTotalTime IS NULL OR AircraftTotalTime <= 0 THEN '0. Unknown'
        WHEN AircraftTotalTime < 10000 THEN '1. New (< 10k hrs)'
        WHEN AircraftTotalTime BETWEEN 10000 AND 30000 THEN '2. Mid-Life (10k - 30k hrs)'
        WHEN AircraftTotalTime BETWEEN 30001 AND 60000 THEN '3. Mature (30k - 60k hrs)'
        ELSE '4. High-Time / Aging (> 60k hrs)'
    END AS Fleet_Age_Tier,
    COUNT(*) AS Total_Defects,
    ROUND(CAST(COUNT(*) AS FLOAT) * 100 / SUM(COUNT(*)) OVER (), 2) AS Pct_Of_Total,
    ROUND(AVG(AircraftTotalCycles), 0) AS Avg_Flight_Cycles,
    ROUND(AVG(CAST(Reporting_Lag_Days AS FLOAT)), 1) AS Avg_Reporting_Lag
FROM Fact_Defects
GROUP BY 
    CASE 
        WHEN AircraftTotalTime IS NULL OR AircraftTotalTime <= 0 THEN '0. Unknown'
        WHEN AircraftTotalTime < 10000 THEN '1. New (< 10k hrs)'
        WHEN AircraftTotalTime BETWEEN 10000 AND 30000 THEN '2. Mid-Life (10k - 30k hrs)'
        WHEN AircraftTotalTime BETWEEN 30001 AND 60000 THEN '3. Mature (30k - 60k hrs)'
        ELSE '4. High-Time / Aging (> 60k hrs)'
    END
ORDER BY Fleet_Age_Tier;
GO 
--Flight Phase Risk Analysis
WITH PhaseRisk AS (
    SELECT 
        CASE StageOfOperationCode
            WHEN 'IN' THEN 'Inspection / Maintenance'
            WHEN 'NR' THEN 'Normal / Ground Ops'
            WHEN 'TX' THEN 'Taxi'
            WHEN 'CR' THEN 'Cruise'
            WHEN 'CL' THEN 'Climb'
            WHEN 'UK' THEN 'Unknown Phase'
            WHEN 'DE' THEN 'Descent'
            WHEN 'TO' THEN 'Takeoff'
            WHEN 'AP' THEN 'Approach'
            WHEN 'LD' THEN 'Landing'
            ELSE COALESCE(StageOfOperationCode, 'Other')
        END AS Flight_Phase,
        COUNT(*) AS Total_Defects,
        SUM(CASE 
            WHEN PrecautionaryProcedureA IN ('A', 'B', 'C', 'D') THEN 1 
            ELSE 0 
        END) AS Critical_Emergency_Count,
        SUM(CASE 
            WHEN HowDiscoveredCode = 'C' THEN 1 
            ELSE 0 
        END) AS Crew_Discovered_Count,
        AVG(CAST(Reporting_Lag_Days AS FLOAT)) AS Avg_Lag_Days
    FROM Fact_Defects
    GROUP BY StageOfOperationCode
)
SELECT 
    Flight_Phase,
    Total_Defects,
    ROUND(CAST(Total_Defects AS FLOAT) * 100 / SUM(Total_Defects) OVER (), 2) AS Share_Of_Defects_Pct,
    Critical_Emergency_Count,
    ROUND(CAST(Critical_Emergency_Count AS FLOAT) * 100 / NULLIF(Total_Defects, 0), 2) AS Critical_Emergency_Rate_Pct,
    Crew_Discovered_Count,
    ROUND(Avg_Lag_Days, 1) AS Avg_Reporting_Lag,
    DENSE_RANK() OVER (ORDER BY CAST(Critical_Emergency_Count AS FLOAT) / NULLIF(Total_Defects, 0) DESC) AS Risk_Rank
FROM PhaseRisk
WHERE Total_Defects >= 500
ORDER BY Risk_Rank;
GO



SELECT TOP 10 PrecautionaryProcedureA, COUNT(*) AS Cnt 
FROM Fact_Defects 
GROUP BY PrecautionaryProcedureA 
ORDER BY Cnt DESC;

SELECT TOP 10 HowDiscoveredCode, COUNT(*) AS Cnt 
FROM Fact_Defects 
GROUP BY HowDiscoveredCode 
ORDER BY Cnt DESC;