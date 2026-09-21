-- ============================================================
-- Cyclistic Bike-Share Analysis
-- 02 - Feature Engineering & Reporting View
-- ============================================================
-- Purpose:
--   Create reusable analytical fields and define the dataset
--   used by Power BI and the reporting queries.
-- ============================================================


-- ------------------------------------------------------------
-- 1. Extract ride-start hour
-- ------------------------------------------------------------

ALTER TABLE cyclistic_2020_deduped
ADD COLUMN hour INTEGER;

UPDATE cyclistic_2020_deduped
SET hour = EXTRACT(HOUR FROM started_at_ts);


-- ------------------------------------------------------------
-- 2. Extract ride-end hour
-- ------------------------------------------------------------

ALTER TABLE cyclistic_2020_deduped
ADD COLUMN end_hour INTEGER;

UPDATE cyclistic_2020_deduped
SET end_hour = EXTRACT(HOUR FROM ended_at_ts);


-- ------------------------------------------------------------
-- 3. Extract month
-- ------------------------------------------------------------

ALTER TABLE cyclistic_2020_deduped
ADD COLUMN month INTEGER;

UPDATE cyclistic_2020_deduped
SET month = EXTRACT(MONTH FROM started_at_ts);


-- ------------------------------------------------------------
-- 4. Extract day of week
-- ------------------------------------------------------------
-- PostgreSQL DOW convention:
--   0 = Sunday
--   1 = Monday
--   ...
--   6 = Saturday

ALTER TABLE cyclistic_2020_deduped
ADD COLUMN dow INTEGER;

UPDATE cyclistic_2020_deduped
SET dow = EXTRACT(DOW FROM started_at_ts);


-- ------------------------------------------------------------
-- 5. Create the reporting view
-- ------------------------------------------------------------
-- Power BI analysis was restricted to rides starting from
-- 1 January 2024 onward.

CREATE VIEW cyclistic_analysis AS
SELECT *
FROM cyclistic_2020_deduped
WHERE started_at_ts >= '2024-01-01';


-- ============================================================
-- End of feature engineering
-- ============================================================
