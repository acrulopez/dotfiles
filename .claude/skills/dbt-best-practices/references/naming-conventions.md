# Column Naming Conventions

| Type | Pattern | Examples | Notes |
|------|---------|----------|-------|
| Boolean | `is_*` / `has_*` / `can_*` | `is_active`, `has_purchased`, `can_edit` | Always verb prefix; avoid negatives (`is_active` not `is_not_active`) |
| Date | `*_date` | `order_date`, `signup_date` | `DATE` type (YYYY-MM-DD) |
| Timestamp | `*_at` | `created_at`, `loaded_at` | Use `TIMESTAMP` (UTC default). Non-UTC: suffix with tz (`created_at_pt`). Events: past-tense verb (`created_at`, `deleted_at`) |
| ID / Key | `*_id` | `customer_id`, `order_id` | PKs named `<entity>_id`. String data type unless performance requires otherwise |
| Amount / Metric | `*_amount` / `*_total` / `*_price` | `revenue_amount`, `total_tax` | Numeric currency/totals |
| Count | `*_count` | `login_count`, `order_count` | Integer counts |
| Categorical | `*_type` / `*_category` / `*_status` / `*_group` | `customer_type`, `order_status` | String fields for grouping/segmenting |
| Array | `[plural_noun]` | `tags`, `items` | BigQuery `REPEATED` fields |
| Struct | `*_details` / `*_record` | `customer_details`, `shipping_record` | BigQuery `STRUCT` fields |
| System / Audit | `_*` (leading underscore) | `_loaded_at`, `_dbt_updated_at` | Metadata, ELT sync timestamps, dbt audit columns |

## Units of Measure

When a column represents a unit, the unit **must** be a suffix: `duration_s`, `duration_ms`, `amount_usd`, `price_eur`, `weight_kg`, `size_bytes`.

## General Rules

- Models are **pluralized**: `dim_customers`, `fct_orders`
- Every model has a **primary key**
- All names in **snake_case**
- Use **consistent field names** across models: FK must match PK name (e.g., `customer_id` everywhere, not `user_id` or `cust_id`)
- Multiple FKs to same dim: prefix contextually (`sender_customer_id`, `receiver_customer_id`)
- **No abbreviations**: `customer` not `cust`, `orders` not `o`
- **No SQL reserved words** standalone: `order_date` not `date`
- Model versions: `_v1`, `_v2` suffix
- **Column ordering**: system/audit, ids, dates, timestamps, booleans, strings, arrays, structs, numerics
