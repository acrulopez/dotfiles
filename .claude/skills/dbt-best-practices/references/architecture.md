# Architecture & Model Organization

## Architecture & Layers

| Layer | Model | Prefix | Materialization | Naming | Description |
|-------|-------|--------|-----------------|--------|-------------|
| **Raw** | Seed | `seed_` | Table | `seed_<context>__<entity>` | dbt seeds |
| **Raw** | Raw Table | `raw_` | Table (managed) | `raw_<source>__<entity>` | Ingested tables |
| **Staging** | Snapshot | `snp_` | Snapshot (SCD2) | `snp_<entity>` | SCD2 history tracking (optional) |
| **Staging** | Staging | `stg_` | View | `stg_<source>__<entity>` | 1:1 cast + rename only |
| **Intermediate** | Intermediate | `int_` | View (default) | `int_<domain>__<entity>` | Optional transformation layer |
| **Datamart** | Dimension | `dim_` | Table | `dim_<entity>` | Dimension presentation |
| **Datamart** | Fact | `fct_` | Incremental / Table | `fct_<entity>` | Fact tables |
| **Datamart** | Bridge | `brg_` | Table | `brg_<entity1>_<entity2>` | N:M relationship PKs |
| **Datamart** | Mart | `mart_` | Table | `mart_<entity>` | Dims requiring fct computations (optional) |
| **Datamart** | Aggregate | `agg_` | Incremental / Table | `agg_<grain>_<entity>` | Re-grained facts (optional) |
| **Datamart** | Report | `rpt_` | Table / Incremental | `rpt_<dashboard>` | Dashboard-specific tables |
| **Datamart** | Utility | `util_` | Table | `util_<purpose>` | Date spines, calendars |

## Model Flow Rules

**Reference rules** (what each model type can query):

- `snp_` refs: `raw_`, `seed_` (optional layer - `stg_` can read `raw_`/`seed_` directly)
- `stg_` refs: `snp_`, or `raw_`/`seed_` directly if no snapshot exists
- `int_` refs: `stg_` (optional layer - datamart models can read `stg_` directly)
- `dim_`, `fct_`, `brg_` ref: `int_` or `stg_` directly
- `mart_`, `agg_` ref: `dim_`, `fct_`, `brg_` (both are optional - downstream models can skip them)
- `rpt_` refs: `mart_`, `agg_`, or `dim_`/`fct_`/`brg_` directly when no mart/agg is needed
- `util_` can be joined by any `int_` or datamart model

**Macro rules**:

- **Staging models** reference raw tables using `{{ source('<source_name>', '<table_name>') }}`. This is required for source freshness tracking and lineage.
- **All other models** reference upstream dbt models using `{{ ref('<model_name>') }}`.

**Key rules**:

- Use `{{ dbt_utils.generate_surrogate_key([...]) }}` when no natural key exists. Field ordering is part of the key contract — changing the order produces a different hash and breaks downstream joins.
- Staging is the **only** layer where renaming and casting of raw fields is allowed.
- When the intermediate layer is skipped, any source-specific fix logic that goes beyond renaming/casting belongs in the `dim_`/`fct_` model, not in staging.

**Config rules**:

- Do not define `materialization` or `tags` in the model file unless the value differs from the project default (`dbt_project.yml`).

## Intermediate Layer Patterns

The intermediate layer is **optional**. Keep things simple — skip it when `stg_` feeds cleanly into datamart.

### Simple (most cases)

| Suffix | Purpose | Materialization |
|--------|---------|-----------------|
| `_prep` | Source-specific fixes (join, calc, filter) to conform one source before combining | View / Table / Incremental |
| `_unioned` | Stack prepared tables from different sources vertically | View |

**Rule**: `_prep` applies source-specific logic only. Cross-source business rules belong in `dim_`/`fct_` models.

### Advanced (use only when needed)

| Suffix | Purpose | Typical Destination | Materialization |
|--------|---------|---------------------|-----------------|
| `_prep` | Technical fixes: timezone, currency, unit conversion | Fact | View |
| `_enriched` | Adding columns/attributes to a main entity | Dimension | View / Table |
| `_joined` | Bringing concepts together (e.g., order lines + headers) | Fact | View / Table |
| `_pivoted` | Transposing rows to columns | Dimension | View / Table |
| `_unioned` | Stacking identical tables from different sources | Fact | View |
| `_agg` | Pre-aggregating to fix fan-outs before a join | Fact | Incremental / Table |
| `_double_entry` | Duplicating rows for debit/credit pairs (GL logic) | Fact | View |
| `_spine` | Joining to a date spine to fill missing days/gaps | Fact | View |

## Folder Structure

```
models/
  sources/                    # one YAML per source system
    <source_system>.yml
  staging/
    <source_system>/
      stg_*.sql
      stg_*.yml              # tests for staging models
  intermediate/
    <domain>/
      int_*.sql
      int_*.yml
  datamart/
    <domain>/
      dim_*.sql
      dim_*.yml
      fct_*.sql
      fct_*.yml
      agg_*.sql
      agg_*.yml
      ...
```
