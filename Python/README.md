# Python — CSV Consolidation

This folder contains the Python script used to consolidate the Cyclistic source CSV files before they were imported into PostgreSQL.

## Script

`combine_csv.py`

The script:

1. Finds CSV files within the specified source folder.
2. Reads each file with pandas.
3. Falls back to Latin-1 encoding if the default decoding fails.
4. Writes the first file with column headers.
5. Appends subsequent files without repeating the headers.
6. Processes files incrementally rather than keeping the complete combined dataset in memory.
7. Reports progress while the files are being processed.

## Important project note

The original project involved a large number of CSV files and a combined dataset of several gigabytes. Incremental writing was therefore used rather than concatenating every dataframe in memory.

The source folder should contain only the Cyclistic CSV files intended for consolidation. During the original project, a recursive CSV search also picked up an unrelated/generated CSV, so the portfolio version explicitly documents this requirement rather than hiding that part of the development history.

## Running the script

Open `combine_csv.py` and change:

```python
DATA_FOLDER = Path(r"D:\Data Analytics\Bicycle Case Study\Both")
```

to the location containing the Cyclistic source files.

The output will be written as:

```text
cyclists.csv
```

## Skills demonstrated

- Python
- pandas
- pathlib
- CSV file handling
- File-system traversal
- Character-encoding handling
- Incremental file processing

## Learning context

Python was used specifically for the CSV consolidation stage of this project. The broader analytical workflow was completed using PostgreSQL/SQL and Power BI/DAX.

This script is included to document the actual project workflow; it is not intended to suggest that the entire analysis was performed in Python.
