# Style Guide

## SQL Style

- **Linter**: SQLFluff
- **Indentation**: 4 spaces
- **Max line length**: 180 characters
- **Commas**: Leading
- **Keywords**: Lowercase (`select`, `from`, `where`)
- **Aliases**: Always use `as`
- **No `SELECT *`**: Explicitly list columns in all models. `SELECT *` is only permitted in the final CTE (`select * from <final_cte>`).
- **Comments**: Use Jinja comments (`{# ... #}`) when comments should not compile into SQL

### Fields & Aggregation

- Fields before aggregates and window functions in select
- Aggregate as early as possible (smallest dataset) before joining
- Prefer `group by all` over listing column names

### Joins

- Prefer `union all` over `union` (unless you explicitly need dedup)
- Prefix columns with table name when joining 2+ tables
- Be explicit: `inner join`, `left join` (never implicit)
- Avoid `right join` — switch table order instead

### Import CTEs

- All `{{ ref() }}` and `{{ source() }}` calls go in CTEs at the top of the file
- Name import CTEs after the table they reference
- Select only columns used and filter early
- *Reason:* This pattern allows instant debugging — you can query any CTE in the chain independently

### Functional CTEs

- Each CTE does one logical unit of work
- Name CTEs descriptively
- Repeated logic across models should become intermediate models
- End model with `select * from <final_cte>`

## YAML Style

- **Indentation**: 2 spaces
- **Max line length**: 80 characters
- Indent list items
- Prefer explicit lists over single-string values
- Blank line between list items that are dictionaries (when it improves readability)
- **One YAML per model**: Create a `.yml` file per model with the same name as the `.sql` file (e.g., `fct_orders.sql` → `fct_orders.yml`).
- **Descriptions**: Always add a `description` in the YAML for every model and its columns.
- **`doc()` blocks**: If a `doc` block exists for a column, reference it (`description: '{{ doc("product_category") }}'`). When a field is repeated across multiple models, add a `doc` block in the model that owns the field.
- **`data_tests` (not `tests`)**: Use the current `data_tests` key instead of the deprecated `tests` field. Use the `config` block inside `data_tests` for `meta`, `severity`, etc.

## Jinja Style

- Spaces inside delimiters: `{{ this }}` not `{{this}}`
- Newlines to separate logical Jinja blocks
- 4-space indent inside Jinja blocks
- Prioritize readability over whitespace control

```sql
{%- if this %}

    {{- that }}

{%- else %}

    {{- the_other_thing }}

{%- endif %}
```
