-- ============================================================
-- Cyclistic Bike-Share Analysis
-- 03 - Analysis
-- ============================================================
-- Purpose:
--   SQL queries used to investigate rider behaviour, seasonality,
--   ride duration, rideable type, stations and journeys.
--
-- Main reporting source:
--   cyclistic_analysis
--
-- The Power BI report contains additional DAX-based analysis and
-- visualisations built from the same reporting view.
-- ============================================================


-- ------------------------------------------------------------
-- 1. Basic ride count
-- ------------------------------------------------------------

SELECT
    COUNT(DISTINCT ride_id) AS total_rides
FROM cyclistic_analysis;


-- ------------------------------------------------------------
-- 2. Ride-duration distribution
-- ------------------------------------------------------------

SELECT
    MIN(ride_duration_minutes) AS min_duration,
    MAX(ride_duration_minutes) AS max_duration,
    PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY ride_duration_minutes) AS median_duration,
    PERCENTILE_CONT(0.9)
        WITHIN GROUP (ORDER BY ride_duration_minutes) AS p90_duration,
    PERCENTILE_CONT(0.99)
        WITHIN GROUP (ORDER BY ride_duration_minutes) AS p99_duration
FROM cyclistic_analysis;


-- ------------------------------------------------------------
-- 3. Average duration by rider type
-- ------------------------------------------------------------

SELECT
    member_casual,
    AVG(ride_duration_minutes) AS avg_duration
FROM cyclistic_analysis
GROUP BY member_casual
ORDER BY avg_duration DESC;


-- ------------------------------------------------------------
-- 4. Total rides by rider type
-- ------------------------------------------------------------

SELECT
    member_casual,
    COUNT(DISTINCT ride_id) AS total_rides
FROM cyclistic_analysis
GROUP BY member_casual
ORDER BY total_rides DESC;


-- ------------------------------------------------------------
-- 5. Total rides by hour and rider type
-- ------------------------------------------------------------

SELECT
    hour,
    member_casual,
    COUNT(DISTINCT ride_id) AS total_rides
FROM cyclistic_analysis
GROUP BY hour, member_casual
ORDER BY hour, member_casual;


-- ------------------------------------------------------------
-- 6. Total rides by month and rider type
-- ------------------------------------------------------------

SELECT
    month,
    member_casual,
    COUNT(DISTINCT ride_id) AS total_rides
FROM cyclistic_analysis
GROUP BY month, member_casual
ORDER BY month, member_casual;


-- ------------------------------------------------------------
-- 7. Rideable type by rider type
-- ------------------------------------------------------------

SELECT
    member_casual,
    rideable_type,
    COUNT(DISTINCT ride_id) AS total_rides
FROM cyclistic_analysis
GROUP BY member_casual, rideable_type
ORDER BY member_casual, total_rides DESC;


-- ------------------------------------------------------------
-- 8. Start-station popularity by rider type
-- ------------------------------------------------------------

SELECT
    start_station_name,
    member_casual,
    COUNT(DISTINCT ride_id) AS total_rides
FROM cyclistic_analysis
WHERE start_station_name <> 'Unknown'
GROUP BY start_station_name, member_casual
ORDER BY total_rides DESC;


-- ------------------------------------------------------------
-- 9. Station-level casual share
-- ------------------------------------------------------------

SELECT
    start_station_name,
    COUNT(DISTINCT ride_id) AS total_rides,
    COUNT(DISTINCT ride_id)
        FILTER (WHERE member_casual = 'casual') AS casual_rides,
    ROUND(
        100.0 *
        COUNT(DISTINCT ride_id)
            FILTER (WHERE member_casual = 'casual')
        / NULLIF(COUNT(DISTINCT ride_id), 0),
        2
    ) AS casual_percentage
FROM cyclistic_analysis
WHERE start_station_name <> 'Unknown'
GROUP BY start_station_name
ORDER BY total_rides DESC;


-- ------------------------------------------------------------
-- 10. Journey type
-- ------------------------------------------------------------
-- Same Station means the recorded start and end station names
-- are identical. This does not establish the rider's intent.

SELECT
    CASE
        WHEN start_station_name = end_station_name
            THEN 'Same Station'
        ELSE 'Point-to-Point'
    END AS journey_type,
    COUNT(DISTINCT ride_id) AS total_rides
FROM cyclistic_analysis
WHERE start_station_name <> 'Unknown'
  AND end_station_name <> 'Unknown'
GROUP BY journey_type
ORDER BY total_rides DESC;


-- ------------------------------------------------------------
-- 11. Journey type by rider type
-- ------------------------------------------------------------

SELECT
    CASE
        WHEN start_station_name = end_station_name
            THEN 'Same Station'
        ELSE 'Point-to-Point'
    END AS journey_type,
    member_casual,
    COUNT(DISTINCT ride_id) AS total_rides
FROM cyclistic_analysis
WHERE start_station_name <> 'Unknown'
  AND end_station_name <> 'Unknown'
GROUP BY journey_type, member_casual
ORDER BY journey_type, member_casual;


-- ------------------------------------------------------------
-- 12. Top 20 individual journeys
-- ------------------------------------------------------------

SELECT
    start_station_name || ' → ' || end_station_name AS journey,
    COUNT(DISTINCT ride_id) AS total_rides
FROM cyclistic_analysis
WHERE start_station_name <> 'Unknown'
  AND end_station_name <> 'Unknown'
GROUP BY start_station_name, end_station_name
ORDER BY total_rides DESC
LIMIT 20;


-- ------------------------------------------------------------
-- 13. Check station-name inconsistencies
-- ------------------------------------------------------------
-- Used to identify differences caused only by capitalisation.

SELECT
    LOWER(start_station_name) AS normalized_name,
    COUNT(DISTINCT start_station_name) AS name_variations,
    STRING_AGG(
        DISTINCT start_station_name,
        ' | '
    ) AS variations
FROM cyclistic_analysis
WHERE start_station_name <> 'Unknown'
GROUP BY LOWER(start_station_name)
HAVING COUNT(DISTINCT start_station_name) > 1
ORDER BY name_variations DESC;


-- ------------------------------------------------------------
-- 14. Prepare start-station coordinates for Power BI mapping
-- ------------------------------------------------------------
-- One row per station name with representative coordinates.
-- The table is based on the 2024+ reporting view.

CREATE TABLE start_stations AS
SELECT
    start_station_name,
    AVG(start_lat) AS station_lat,
    AVG(start_lng) AS station_lng
FROM cyclistic_analysis
WHERE start_station_name <> 'Unknown'
  AND start_lat IS NOT NULL
  AND start_lng IS NOT NULL
GROUP BY start_station_name;


-- Verify that the station table contains one row per station name.

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT start_station_name) AS unique_station_names
FROM start_stations;


-- ============================================================
-- Portfolio notes
-- ============================================================
-- * Unknown station records remain in overall ride-level
--   analysis but are excluded where station identity is required.
--
-- * Station IDs were not treated as stable physical-station
--   identifiers because the same station name appeared with
--   multiple historical IDs.
--
-- * Some exploratory queries were run interactively during the
--   project and their exact original SQL was not preserved.
--   Those queries have not been invented here.
--
-- * Power BI contains additional analysis using DAX, filters,
--   matrices and visual interactions. This SQL file represents
--   the documented PostgreSQL analysis layer.
-- ============================================================
