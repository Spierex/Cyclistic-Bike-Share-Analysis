# Cyclistic Bike-Share Analysis

## Overview

A portfolio data analytics project based on the **Cyclistic case study from the Google Data Analytics Professional Certificate**.

The objective was to analyse how **member and casual riders use the bike-share service differently** and identify potential opportunities to increase membership.

The project follows an end-to-end analytics workflow:

**Python → PostgreSQL/SQL → Power BI → Business Insights**

> Cyclistic is a fictional company used in the Google Data Analytics case study. This is an independent portfolio project.

---

## Key Findings

- **Strong seasonality:** Ride activity increases through spring and summer, peaking in August, before declining during autumn and winter.
- **Different rider behaviour:** Members are particularly active during weekday morning and late-afternoon periods, while casual usage increases during weekend daytime periods.
- **Longer casual rides:** Casual riders generally have longer average ride durations than members.
- **Electric bike adoption:** Electric bikes became increasingly dominant during the later period of the dataset and generally had longer ride durations.
- **Station-level differences:** Casual riders are heavily concentrated around certain lakefront, recreational and visitor locations.
- **Weekend opportunity:** During warmer-month weekend daytime periods, approximately **65% of rides were from casual riders**, compared with roughly **35% overall**.

---

## Potential Business Opportunity

The analysis suggests that membership-conversion campaigns could potentially be targeted towards:

- Warmer months
- Weekend daytime periods
- High-volume stations
- Locations with high casual-rider shares

These are opportunities identified from observed patterns rather than proven causal effects.

---

## Technical Skills

**Python / Pandas**  
CSV consolidation and data preparation

**PostgreSQL / SQL**  
Data cleaning, transformation, validation, aggregation and analysis

**Power BI / DAX / Power Query**  
Data modelling, measures, interactive dashboards and visualisation

**Analysis**  
Exploratory analysis, segmentation, trend analysis and business-focused interpretation

---

## Project Structure

```text
cyclistic-bike-share-analysis/
├── README.md
├── python/
├── sql/
├── powerbi/
├── documentation/
└── screenshots/