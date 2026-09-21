-- ============================================================
-- Cyclistic Bike-Share Analysis
-- 01 - Data Cleaning
-- ============================================================
-- Purpose:
--   Prepare the imported Cyclistic dataset for analysis.
--
-- Source table:
--   cyclistic_2020
--
-- Working table:
--   cyclistic_2020_deduped
--
-- Notes:
--   The cleaning decisions are documented separately in the
--   Cyclistic Data Cleaning Log.
-- ============================================================


-- ------------------------------------------------------------
-- 1. Handle missing start-station information
-- ------------------------------------------------------------

UPDATE cyclistic_2020
SET start_station_name = 'Unknown'
WHERE start_station_name IS NULL;

UPDATE cyclistic_2020
SET start_station_id = 'Unknown'
WHERE start_station_id IS NULL;


-- ------------------------------------------------------------
-- 2. Create a deduplicated working table
-- ------------------------------------------------------------
-- Keep one record per ride_id. When duplicates exist, retain
-- the earliest started_at record.

CREATE TABLE cyclistic_2020_deduped AS
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY ride_id
               ORDER BY started_at
           ) AS rn
    FROM cyclistic_2020
) t
WHERE rn = 1;


-- ------------------------------------------------------------
-- 3. Handle missing end-station information
-- ------------------------------------------------------------

UPDATE cyclistic_2020_deduped
SET end_station_name = 'Unknown'
WHERE end_station_name IS NULL;

UPDATE cyclistic_2020_deduped
SET end_station_id = 'Unknown'
WHERE end_station_id IS NULL;


-- ------------------------------------------------------------
-- 4. Convert timestamps
-- ------------------------------------------------------------

ALTER TABLE cyclistic_2020_deduped
ADD COLUMN started_at_ts TIMESTAMP;

UPDATE cyclistic_2020_deduped
SET started_at_ts = started_at::timestamp;

ALTER TABLE cyclistic_2020_deduped
ADD COLUMN ended_at_ts TIMESTAMP;

UPDATE cyclistic_2020_deduped
SET ended_at_ts = ended_at::timestamp;


-- ------------------------------------------------------------
-- 5. Calculate ride duration
-- ------------------------------------------------------------

ALTER TABLE cyclistic_2020_deduped
ADD COLUMN ride_duration INTERVAL;

UPDATE cyclistic_2020_deduped
SET ride_duration = ended_at_ts - started_at_ts;

ALTER TABLE cyclistic_2020_deduped
ADD COLUMN ride_duration_minutes NUMERIC;

UPDATE cyclistic_2020_deduped
SET ride_duration_minutes = EXTRACT(EPOCH FROM ride_duration) / 60;


-- ------------------------------------------------------------
-- 6. Remove invalid or extreme ride durations
-- ------------------------------------------------------------
-- Negative durations were treated as invalid.
-- Rides over 24 hours were treated as extreme outliers.
-- Rides under one minute were treated as likely incomplete/
-- accidental unlocks or test rides.

DELETE FROM cyclistic_2020_deduped
WHERE ride_duration_minutes < 0;

DELETE FROM cyclistic_2020_deduped
WHERE ride_duration_minutes > 1440;

DELETE FROM cyclistic_2020_deduped
WHERE ride_duration_minutes < 1;


-- ------------------------------------------------------------
-- 7. Remove invalid geographic records
-- ------------------------------------------------------------

DELETE FROM cyclistic_2020_deduped
WHERE end_lat = 0;


-- The project also identified:
--   * 41 implausible-coordinate records
--   * 7 further suspicious longitude records with
--     Unknown destination stations
--
-- Their exact original SQL predicates were not preserved in the
-- available project documentation. They are therefore not
-- reconstructed here.


-- ------------------------------------------------------------
-- 8. Standardise station-name capitalisation
-- ------------------------------------------------------------

UPDATE cyclistic_2020_deduped
SET start_station_name = 'LaSalle St & Washington St'
WHERE start_station_name = 'Lasalle St & Washington St';

UPDATE cyclistic_2020_deduped
SET start_station_name = 'Navy Pier'
WHERE start_station_name = 'NAVY PIER';


-- ============================================================
-- End of data cleaning
-- ============================================================
