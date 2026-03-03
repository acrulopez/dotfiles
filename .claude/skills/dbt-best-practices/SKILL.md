---
name: dbt-best-practices
description: dbt data modeling best practices following Kimball/dimensional modeling. Use when writing or reviewing dbt models, adding tests, choosing materializations, or following SQL/YAML/Jinja style conventions. Covers architecture layers, naming conventions, testing strategy, SQL style, and BigQuery optimization.
---

# dbt Best Practices

Approach: **Kimball / dimensional modeling (star schema)**.

## Architecture

| Layer | Prefix | Materialization | Description |
|-------|--------|-----------------|-------------|
| **Raw** | `seed_`, `raw_` | Table | Seeds and ingested tables |
| **Staging** | `snp_`, `stg_` | Snapshot, View | SCD2 history (optional), 1:1 cast + rename |
| **Intermediate** | `int_` | View | Optional transformation layer |
| **Datamart** | `dim_`, `fct_`, `brg_`, `mart_`, `agg_`, `rpt_`, `util_` | Table / Incremental | Dimensions, facts, aggregates, reports |

Key rules:
- `stg_` uses `{{ source() }}`, all other models use `{{ ref() }}`
- Staging is the **only** layer for renaming/casting raw fields
- Do not define `materialization` or `tags` in model files unless overriding `dbt_project.yml` defaults

See [Architecture Reference](references/architecture.md) for full layer table, model flow rules, intermediate patterns, and folder structure.

## Naming Conventions

| Type | Pattern | Example |
|------|---------|---------|
| Boolean | `is_*` / `has_*` | `is_active` |
| Date | `*_date` | `order_date` |
| Timestamp | `*_at` | `created_at` |
| ID / Key | `*_id` | `customer_id` |
| Amount | `*_amount` / `*_total` | `revenue_amount` |
| Count | `*_count` | `order_count` |
| Unit of measure | suffix with unit | `duration_s`, `amount_usd` |

Key rules: snake_case, no abbreviations, pluralized model names, FK matches PK name, no SQL reserved words standalone.

See [Naming Conventions Reference](references/naming-conventions.md) for full column pattern table, general rules, and column ordering.

## Testing

Every model **must** have its PK tested for `unique` + `not_null`. Test extensively on datamart models. Use `severity: warn` for non-critical tests.

See [Testing Reference](references/testing.md) for tests by layer, by column pattern, severity guidelines, useful packages, and unit test examples.

## Style

**SQL**: Leading commas, lowercase keywords, 4-space indent, always use `as` for aliases. No `SELECT *` except in final CTE. All `{{ ref() }}`/`{{ source() }}` calls in import CTEs at top. Prefer `group by all`. End model with `select * from <final_cte>`.

**YAML**: 2-space indent, one `.yml` per model, always add descriptions, use `data_tests` (not `tests`).

**Jinja**: Spaces inside delimiters (`{{ this }}`), 4-space indent inside blocks.

See [Style Guide Reference](references/style-guide.md) for full SQL, YAML, and Jinja conventions.

## Materializations

**Storage is cheap, compute is expensive.** Staging defaults to view, intermediate to view, datamart to table. Use incremental for large facts. Partition tables >1 GB by date; always cluster on filter/join columns.

See [Materializations Reference](references/materializations.md) for deviation guidelines and BigQuery optimization details.
