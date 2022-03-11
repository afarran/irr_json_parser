# irr_json_parser

Tool that converts IRR entries in JSON format to CSV and flags IRR entries that have advertised routes and are `ARIN-NONAUTH` only.
This can help identify routes in that are still in the ARIN NONAUTH IRR, which was announced to [be retired in April 2022](https://www.arin.net/announcements/20220225-irr). These routes should be migrated to ARIN AUTH IRR or other IRR to avoid potential outages.

## Usage

The input to the tool is an IRR file in JSON format (e.g. [irr_example.json](irr_example.json) and the output is a CSV file with the same file name and file path (e.g. [irr_example.csv](irr_example.csv)). The output CSV file has a boolean field that would show `TRUE` for advertised routes that exist only in `ARIN-NONAUTH` IRR.

```PowerShell
>lua.exe irr_json_parser.lua <JSON source file name>
```
