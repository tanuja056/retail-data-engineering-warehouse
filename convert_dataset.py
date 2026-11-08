import pandas as pd
from pathlib import Path

files = list(Path("data/raw").glob("*.xlsx"))

if not files:
    raise FileNotFoundError("No Excel file found in data/raw")

excel_file = files[0]
print("Reading:", excel_file)

sheets = pd.read_excel(excel_file, sheet_name=None)

for sheet_name, df in sheets.items():
    output = Path("data/raw") / (
        sheet_name.lower().replace(" ", "_") + ".csv"
    )

    df.to_csv(output, index=False)

    print("\nWorksheet:", sheet_name)
    print("Records:", len(df))
    print("Columns:", list(df.columns))
    print("Output:", output)

print("\nDATASET CONVERSION COMPLETED")
