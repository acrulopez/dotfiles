---
name: gws-sheets
version: 2.0.0
description: "Google Sheets: Comprehensive read, write, create, and manage spreadsheets. Use for creating new sheets, reading cell ranges, updating values, appending rows, formatting, and advanced batch operations. Essential for spreadsheet automation, data management, and reporting workflows."
metadata:
  openclaw:
    category: "productivity"
    requires:
      bins: ["gws"]
    cliHelp: "gws sheets --help"
---

## Quick Start: Common Workflows

### 1. Create a Spreadsheet
```bash
gws sheets spreadsheets create --json '{"properties":{"title":"My Sheet"}}'
```
Returns: `spreadsheetId` and `spreadsheetUrl`

### 2. Read Values
```bash
gws sheets spreadsheets values get \
  --params '{"spreadsheetId":"ID","range":"A1:C10"}' \
  --format table
```

### 3. Update Values (Multiple Rows)
```bash
gws sheets spreadsheets values update \
  --params '{"spreadsheetId":"ID","range":"A1:C1","valueInputOption":"RAW"}' \
  --json '{"values":[["date","name","amount"]]}'
```

### 4. Append a Row
```bash
gws sheets spreadsheets values append \
  --params '{"spreadsheetId":"ID","range":"A:C","valueInputOption":"RAW"}' \
  --json '{"values":[["2026-03-01","Client","1000"]]}'
```

## Parameter Passing Guide

The gws CLI uses **two separate flags** for API parameters:

| Flag | Purpose | Format |
|------|---------|--------|
| `--params` | Path and query parameters | JSON: `'{"key":"value"}'` |
| `--json` | Request body | JSON: `'{"key":"value"}'` |

### Common Parameters

| Parameter | Type | Use When |
|-----------|------|----------|
| `spreadsheetId` | path | Every operation needs the sheet ID |
| `range` | path | Specifying which cells to read/write (e.g., "A1:C10", "Sheet1!A1:B2") |
| `valueInputOption` | query | Writing values: "RAW" (literal) or "USER_ENTERED" (formulas) |
| `includeValuesInResponse` | query | Want updated values returned (true/false) |

**Example: Parameters in a real command**
```bash
gws sheets spreadsheets values update \
  --params '{"spreadsheetId":"1yjfIgzXwpwsOSma-VdthNnVFZ_LnxzAm5iNnUX0l0eE","range":"A2:C11","valueInputOption":"RAW"}' \
  --json '{"values":[["2026-03-01","Acme Corp","12505.00"]]}'
```

## API Operations

### Create & Manage

**Create a spreadsheet**
```bash
gws sheets spreadsheets create \
  --json '{"properties":{"title":"Invoice Tracker"}}'
```

**Get spreadsheet details**
```bash
gws sheets spreadsheets get \
  --params '{"spreadsheetId":"ID"}'
```

**Batch update (formatting, formulas, structure)**
```bash
gws sheets spreadsheets batchUpdate \
  --params '{"spreadsheetId":"ID"}' \
  --json '{"requests":[{"updateCells":{...}}]}'
```
See [REFERENCE.md](REFERENCE.md) for batchUpdate request patterns.

### Read Data

**Get range of values**
```bash
gws sheets spreadsheets values get \
  --params '{"spreadsheetId":"ID","range":"Sheet1!A1:D100"}'
```

**Get multiple ranges**
```bash
gws sheets spreadsheets values batchGet \
  --params '{"spreadsheetId":"ID","ranges":["A1:C5","E1:F10"]}'
```

### Write Data

**Update values (replace existing)**
```bash
gws sheets spreadsheets values update \
  --params '{"spreadsheetId":"ID","range":"A1:C10","valueInputOption":"RAW"}' \
  --json '{"values":[["a","b","c"],[1,2,3]]}'
```
- `valueInputOption: "RAW"` — Store literal values
- `valueInputOption: "USER_ENTERED"` — Interpret formulas (e.g., "=SUM(A1:A10)")

**Append rows**
```bash
gws sheets spreadsheets values append \
  --params '{"spreadsheetId":"ID","range":"A:C","valueInputOption":"RAW"}' \
  --json '{"values":[["row1col1","row1col2","row1col3"]]}'
```

**Batch update multiple ranges**
```bash
gws sheets spreadsheets values batchUpdate \
  --params '{"spreadsheetId":"ID","valueInputOption":"RAW"}' \
  --json '{"data":[{"range":"A1:C1","values":[["col1","col2","col3"]]},{"range":"A2:C2","values":[["val1","val2","val3"]]}]}'
```

### Clear Data

**Clear a range**
```bash
gws sheets spreadsheets values clear \
  --params '{"spreadsheetId":"ID","range":"A1:C10"}'
```

## Data Format Tips

### Values Array Structure
Values use a 2D array format (rows × columns):
```json
{
  "values": [
    ["date", "name", "amount"],
    ["2026-03-01", "Client A", "1000"],
    ["2026-03-02", "Client B", "2000"]
  ]
}
```

### Output Formats
```bash
# JSON (default)
gws sheets spreadsheets values get ... --format json

# Table (human-readable)
gws sheets spreadsheets values get ... --format table

# CSV
gws sheets spreadsheets values get ... --format csv

# YAML
gws sheets spreadsheets values get ... --format yaml
```

## Advanced Patterns

**Bulk insert multiple rows efficiently**
```bash
gws sheets spreadsheets values update \
  --params '{"spreadsheetId":"ID","range":"A2:C11","valueInputOption":"RAW"}' \
  --json '{"values":[["2026-03-01","Acme","12505.00"],["2026-03-03","Tech","34000.00"]]}'
```
This is faster than appending rows individually.

**Update with formulas**
```bash
gws sheets spreadsheets values update \
  --params '{"spreadsheetId":"ID","range":"D1:D10","valueInputOption":"USER_ENTERED"}' \
  --json '{"values":[["=SUM(B1:C1)"],["=SUM(B2:C2)"]]}'
```

**Conditional updates with batchUpdate**
See [REFERENCE.md](REFERENCE.md) for conditionalFormat, merging, and other advanced formatting.

## Common Patterns & Solutions

### Pattern: Create sheet, add headers, populate data
1. Create: `spreadsheets create`
2. Add headers: `values update` with range "A1:C1"
3. Add data: `values update` with range "A2:Cn" or `values append`
4. Verify: `values get` to read back

### Pattern: Bulk import
Use `values update` with large 2D arrays instead of append loops. Much faster.

### Pattern: Multiply all values by 10
For each value V, use `values update` with formula-safe approach:
```bash
gws sheets spreadsheets values update \
  --params '{"spreadsheetId":"ID","range":"C2:C11","valueInputOption":"RAW"}' \
  --json '{"values":[[v*10 for v in original_values]]}'
```

## Discovering More Operations

Before using an unfamiliar method:

```bash
# List all sheets operations
gws sheets --help

# Inspect a specific method signature
gws schema sheets.spreadsheets.<method>

# Example: inspect values.update
gws schema sheets.spreadsheets.values.update
```

The schema output shows all required/optional parameters, types, and defaults.

## Security Notes

- Never output spreadsheet IDs or URLs in logs/output that may be exposed
- Confirm with user before executing write/delete operations
- Use `--dry-run` to validate requests before execution
- Sensitive data: consider using `--sanitize` flag for PII screening
- After every change, verify the data with `values get`

## See Also

- [gws-shared](../gws-shared/SKILL.md) — Authentication and global flags
- [REFERENCE.md](REFERENCE.md) — Advanced API patterns and batchUpdate examples
