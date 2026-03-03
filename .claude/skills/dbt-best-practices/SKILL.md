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

See [Architecture Reference](references/architecture.md) for full layer table, model flow rules, and folder structure.

## General Rules

Key cross-layer rules: `stg_` uses `{{ source() }}`, all other models use `{{ ref() }}`. Staging is the **only** layer for renaming/casting raw fields. Every PK must be tested for `unique` + `not_null`.

See [General Rules Reference](references/general-rules.md) for macro/key/config rules, BigQuery partitioning & clustering, testing by column pattern, severity guidelines, and useful packages.

## Layers

| Layer | When to Read |
|-------|-------------|
| [Raw](references/raw.md) | Working with seeds, raw tables, or source freshness |
| [Staging](references/staging.md) | Writing `snp_` or `stg_` models |
| [Intermediate](references/intermediate.md) | Writing `int_` models, choosing suffix patterns |
| [Datamart](references/datamart.md) | Writing `dim_`, `fct_`, `brg_`, `mart_`, `agg_`, `rpt_`, or `util_` models |

Each layer file includes: models, refs, materialization defaults, and testing requirements.

## Naming & Style

| Type | Pattern | Example |
|------|---------|---------|
| Boolean | `is_*` / `has_*` | `is_active` |
| Date | `*_date` | `order_date` |
| Timestamp | `*_at` | `created_at` |
| ID / Key | `*_id` | `customer_id` |
| Amount | `*_amount` / `*_total` | `revenue_amount` |

Key rules: snake_case, no abbreviations, pluralized model names, leading commas, lowercase SQL keywords, import CTEs at top.

See [Naming & Style Reference](references/naming-and-style.md) for full column patterns, general naming rules, SQL/YAML/Jinja style conventions.
