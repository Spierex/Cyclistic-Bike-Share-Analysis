"""
Cyclistic Bike-Share Analysis
CSV Consolidation Script

Purpose:
    Combine the Cyclistic source CSV files into one CSV file for
    subsequent PostgreSQL ingestion.

Notes:
    - The source folder should contain only the Cyclistic source CSV files
      intended for consolidation.
    - Files are processed one at a time so the script does not attempt
      to load the entire dataset into memory.
    - A Latin-1 fallback is used for files that cannot be read using
      pandas' default encoding.
"""

from pathlib import Path
import pandas as pd


# ------------------------------------------------------------
# File locations
# ------------------------------------------------------------
# Change these paths for your own environment.
# Keep the input folder limited to the source Cyclistic CSV files.

DATA_FOLDER = Path(r"D:\Data Analytics\Bicycle Case Study\Both")
OUTPUT_FILE = Path("cyclists.csv")


# ------------------------------------------------------------
# Find source CSV files
# ------------------------------------------------------------

csv_files = list(DATA_FOLDER.rglob("*.csv"))

print("Files found:", len(csv_files))


# ------------------------------------------------------------
# Combine files incrementally
# ------------------------------------------------------------
# Writing each dataframe immediately avoids storing the complete
# combined dataset in memory.

first = True

for i, file in enumerate(csv_files):
    try:
        df = pd.read_csv(file)

    except UnicodeDecodeError:
        # Some source files require Latin-1 decoding.
        df = pd.read_csv(file, encoding="latin1")

    if first:
        df.to_csv(
            OUTPUT_FILE,
            index=False,
            mode="w"
        )
        first = False

    else:
        df.to_csv(
            OUTPUT_FILE,
            index=False,
            mode="a",
            header=False
        )

    if i % 10 == 0:
        print(f"Processed {i}/{len(csv_files)} files")


print("Done!")
