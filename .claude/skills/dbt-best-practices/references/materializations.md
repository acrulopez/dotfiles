# Materializations & BigQuery Optimization

## Materializations

**Rule: Storage is cheap, compute is expensive.**

| Layer | Default | When to Deviate |
|-------|---------|-----------------|
| **Staging** | View | Use `table`/`incremental` if source is expensive to process (e.g., single JSON column) |
| **Intermediate** | View | Use `table` when reused in multiple places; use `incremental` when downstream is incremental and window functions/grouping/complex joins block predicate pushdown |
| **Datamart** | Table | Use `incremental` for large `fct_` tables expensive to reprocess; use `materialized view` for near-real-time needs |

## Partitioning & Clustering in BigQuery

| Table Size | Strategy |
|------------|----------|
| **< 1 GB** | Do nothing. BigQuery is fast enough out of the box. |
| **1–30 GB** | Cluster on heavily filtered columns. |
| **> 30 GB** (with >1–10 GB per time unit) | Partition by time, and cluster by most-used filter columns. |
