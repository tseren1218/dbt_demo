{#
    Module 7 — Incremental Models.

    Instead of rebuilding the whole table every run, an incremental model only
    processes NEW rows and appends/merges them. The flow:

      1. First run (or `--full-refresh`): builds the whole table.
      2. Later runs: the is_incremental() block adds a WHERE that keeps only
         rows newer than what's already loaded, so we don't re-scan history.

    Key configs:
      • materialized='incremental'   -> turn on incremental behavior
      • unique_key                   -> how to identify a row (prevents dupes)
      • incremental_strategy         -> how new rows are written (delete+insert
                                        replaces matching keys; DuckDB supports
                                        'append' and 'delete+insert')
    Run `dbt run --select fact_orders_incremental` twice to see it in action,
    and `dbt run --select fact_orders_incremental --full-refresh` to rebuild.
#}
{{
    config(
        materialized='incremental',
        unique_key=['order_id', 'line_number'],
        incremental_strategy='delete+insert',
        tags=['hourly'],
        post_hook="create index if not exists idx_foi_order on {{ this }} (order_id)"
    )
}}

with order_items as (
    select * from {{ ref('int_order_items') }}
)

select
    order_id,
    line_number,
    customer_id,
    order_date,
    net_price,
    gross_price

from order_items

{% if is_incremental() %}
    -- Only pull orders newer than the latest one already in this table.
    -- {{ this }} refers to the existing table being built into.
    where order_date > (select coalesce(max(order_date), '1900-01-01') from {{ this }})
{% endif %}
