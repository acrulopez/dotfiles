# Testing

## Principles

- Every model **must** have its PK tested for `unique` + `not_null`
- Test strategically — don't overtest pass-through columns validated upstream
- Use `severity: warn` for non-critical tests
- Test **extensively** on datamart models (exposed to end users)

## Tests by Layer

| Layer | Required | Recommended |
|-------|----------|-------------|
| **Sources** | Source freshness (`loaded_at` field) | `not_null` on primary identifier |
| **Staging** | `unique` + `not_null` on PK | `not_null` on critical business columns; `accepted_values` for status/type fields |
| **Intermediate** | `unique` + `not_null` on PK (especially when re-graining) | `accepted_values` on derived fields |
| **Datamart** | `unique` + `not_null` on PK; `relationships` on FKs; `accepted_values` on business-critical fields | `not_null` on business fields; `unit tests` for complex logic |

## Tests by Column Pattern

| Column Pattern | Detected As | Tests |
|----------------|-------------|-------|
| `<entity>_id` (first column, matches model name) | Primary key | `unique`, `not_null` |
| `<other_entity>_id` (not PK) | Foreign key | `not_null`; `relationships` (datamart only) |
| `is_*` / `has_*` / `can_*` | Boolean | `not_null` |
| `*_date` | Date | `not_null` (if in incremental logic) |
| `*_at` | Timestamp | `not_null` (if in incremental logic) |
| `*_amount` / `*_total` / `*_price` | Monetary | `dbt_utils.accepted_range` (use `min_value: 0` for revenue; omit for refunds/credits/adjustments); `not_null` |
| `*_count` | Count | `dbt_utils.accepted_range: {min_value: 0}`; `not_null` |
| `*_type` / `*_category` / `*_status` / `*_group` | Categorical | `accepted_values` with explicit list |

## Test Severity

| Severity | When |
|----------|------|
| `error` (default) | PK tests, critical business logic |
| `warn` | Accepted values on low-impact fields, optional relationship tests |
| `warn` + `error_if` | Volume anomalies (e.g., `error_if: ">1000"`) |

## Useful Packages

- **dbt core**: `unique`, `not_null`, `accepted_values`, `relationships`
- **dbt_utils**: `generate_surrogate_key`, `expression_is_true`, `recency`, `at_least_one`, `unique_combination_of_columns`, `accepted_range`, `equal_rowcount`, `not_null_proportion`
- **dbt_expectations**: `expect_column_values_to_be_between`, `expect_table_row_count_to_be_between`
- **elementary**: `volume_anomalies`

## Unit Tests (dbt Core 1.8+)

Use only for complex business logic (pricing, conditional categorization, incremental logic). Do not unit test simple select/rename. Run in dev/CI only, not production.

```yaml
unit_tests:
  - name: test_order_status_logic
    model: fct_orders
    given:
      - input: ref('stg_shop__orders')
        rows:
          - {order_id: "1", status: "P", amount: 100}
    expect:
      rows:
        - {order_id: "1", status: "pending", amount_usd: 100.00}
```
