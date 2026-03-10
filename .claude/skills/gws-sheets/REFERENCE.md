# Google Sheets Advanced Reference

This document contains advanced patterns for complex spreadsheet operations using the gws CLI.

## Table of Contents

1. [batchUpdate Request Patterns](#batchupdate-request-patterns)
2. [Formatting Operations](#formatting-operations)
3. [Sheet Management](#sheet-management)
4. [Formula Patterns](#formula-patterns)
5. [Error Handling](#error-handling)

## batchUpdate Request Patterns

The `batchUpdate` method allows complex operations that modify spreadsheet structure, formatting, and content in a single atomic transaction.

### Update Cell Values

```json
{
  "requests": [
    {
      "updateCells": {
        "rows": [
          {
            "values": [
              {"userEnteredValue": {"stringValue": "date"}},
              {"userEnteredValue": {"stringValue": "name"}},
              {"userEnteredValue": {"stringValue": "amount"}}
            ]
          }
        ],
        "fields": "userEnteredValue",
        "start": {"sheetId": 0, "rowIndex": 0, "columnIndex": 0}
      }
    }
  ]
}
```

**Parameters:**
- `rows` - Array of row objects containing values
- `fields` - Specifies which fields to update ("userEnteredValue" for cell content)
- `start` - Starting cell position (rowIndex, columnIndex are 0-based)
- `sheetId` - Usually 0 for the first sheet

### Merge Cells

```json
{
  "requests": [
    {
      "mergeCells": {
        "range": {
          "sheetId": 0,
          "startRowIndex": 0,
          "endRowIndex": 2,
          "startColumnIndex": 0,
          "endColumnIndex": 3
        }
      }
    }
  ]
}
```

### Add Sheet

```json
{
  "requests": [
    {
      "addSheet": {
        "properties": {
          "title": "New Sheet",
          "index": 1
        }
      }
    }
  ]
}
```

### Delete Sheet

```json
{
  "requests": [
    {
      "deleteSheet": {
        "sheetId": 1
      }
    }
  ]
}
```

### Conditional Format

```json
{
  "requests": [
    {
      "addConditionalFormat": {
        "ranges": [
          {
            "sheetId": 0,
            "startRowIndex": 0,
            "endRowIndex": 100,
            "startColumnIndex": 2,
            "endColumnIndex": 3
          }
        ],
        "booleanRule": {
          "condition": {
            "type": "CELL_NOT_EMPTY"
          },
          "format": {
            "backgroundColor": {
              "red": 0.9,
              "green": 0.8,
              "blue": 0.7
            }
          }
        }
      }
    }
  ]
}
```

## Formatting Operations

### Set Cell Format (Number, Currency, etc.)

```bash
gws sheets spreadsheets batchUpdate \
  --params '{"spreadsheetId":"ID"}' \
  --json '{
    "requests": [{
      "updateCells": {
        "range": {"sheetId": 0, "startRowIndex": 1, "endRowIndex": 100, "startColumnIndex": 2, "endColumnIndex": 3},
        "rows": [{
          "values": [
            {"userEnteredFormat": {"numberFormat": {"type": "CURRENCY", "pattern": "$#,##0.00"}}}
          ]
        }],
        "fields": "userEnteredFormat"
      }
    }]
  }'
```

Number format types:
- `TEXT` - Plain text
- `NUMBER` - Decimal numbers
- `CURRENCY` - Currency with symbol
- `DATE` - Date format
- `TIME` - Time format
- `DATE_TIME` - Timestamp

### Set Font Properties

```json
{
  "userEnteredFormat": {
    "textFormat": {
      "bold": true,
      "fontSize": 12,
      "fontFamily": "Arial"
    }
  }
}
```

### Set Background Color

```json
{
  "userEnteredFormat": {
    "backgroundColor": {
      "red": 0.8,
      "green": 0.2,
      "blue": 0.2
    }
  }
}
```

RGB values range from 0 to 1.

## Sheet Management

### Rename Sheet

```bash
gws sheets spreadsheets batchUpdate \
  --params '{"spreadsheetId":"ID"}' \
  --json '{
    "requests": [{
      "updateSheetProperties": {
        "properties": {"sheetId": 0, "title": "New Title"},
        "fields": "title"
      }
    }]
  }'
```

### Set Column Width

```json
{
  "updateDimensionProperties": {
    "range": {
      "sheetId": 0,
      "dimension": "COLUMNS",
      "startIndex": 0,
      "endIndex": 3
    },
    "properties": {
      "pixelSize": 200
    },
    "fields": "pixelSize"
  }
}
```

### Set Row Height

```json
{
  "updateDimensionProperties": {
    "range": {
      "sheetId": 0,
      "dimension": "ROWS",
      "startIndex": 0,
      "endIndex": 1
    },
    "properties": {
      "pixelSize": 30
    },
    "fields": "pixelSize"
  }
}
```

### Freeze Rows/Columns

```json
{
  "updateSheetProperties": {
    "properties": {
      "sheetId": 0,
      "gridProperties": {
        "frozenRowCount": 1,
        "frozenColumnCount": 1
      }
    },
    "fields": "gridProperties.frozenRowCount,gridProperties.frozenColumnCount"
  }
}
```

## Formula Patterns

### SUM Formula
```json
{
  "userEnteredValue": {
    "formulaValue": "=SUM(B2:B100)"
  }
}
```

### IF Statement
```json
{
  "userEnteredValue": {
    "formulaValue": "=IF(A1>10,\"High\",\"Low\")"
  }
}
```

### COUNTIF
```json
{
  "userEnteredValue": {
    "formulaValue": "=COUNTIF(A:A,\"*completed*\")"
  }
}
```

### VLOOKUP
```json
{
  "userEnteredValue": {
    "formulaValue": "=VLOOKUP(A1,Sheet2!A:B,2,FALSE)"
  }
}
```

**Note:** When using formulas, set `valueInputOption` to "USER_ENTERED" in your parameters.

## Error Handling

### Common Errors

**Invalid range**
- Error: Range like "A1:D100" exceeds sheet dimensions
- Solution: Check actual sheet size with `values get` first

**Spreadsheet not found**
- Error: spreadsheetId is incorrect or you lack access
- Solution: Verify ID and check permissions

**Invalid parameter value**
- Error: valueInputOption must be "RAW" or "USER_ENTERED"
- Solution: Ensure parameter values match API specification

### Validation

Use `--dry-run` to validate requests before execution:

```bash
gws sheets spreadsheets batchUpdate \
  --params '{"spreadsheetId":"ID"}' \
  --json '{...}' \
  --dry-run
```

This validates the request locally without calling the API.

## Performance Tips

1. **Use batch operations**: `batchUpdate` and `values.batchUpdate` are more efficient than multiple individual calls
2. **Bulk insert**: Use `values.update` with large arrays instead of looping `values.append`
3. **Combine formatting**: When possible, apply formatting in the same `batchUpdate` call as content updates
4. **Use appropriate ranges**: Specify exact ranges instead of entire columns when possible
