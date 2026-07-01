{#
    Module 8 — Snapshots (Slowly Changing Dimensions, Type 2).

    A snapshot records how a row changes over time. Each time you run
    `dbt snapshot`, dbt compares the current source row to the stored version
    and, if it changed, closes the old record (sets dbt_valid_to) and inserts a
    new one — giving you full history instead of just the latest value.

    Strategy:
      • timestamp -> trust an `updated_at` column to detect changes (preferred).
      • check     -> compare specific columns for any change. Used here because
                     TPC-H orders has no updated_at column.

    Type 1 (overwrite, no history) vs Type 2 (keep history) — snapshots give you
    Type 2. Query the result and filter `dbt_valid_to is null` for current rows.
#}
{% snapshot scd_orders %}

{{
    config(
        target_schema='snapshots',
        unique_key='order_id',
        strategy='check',
        check_cols=['order_status', 'total_price'],
    )
}}

select
    order_id,
    customer_id,
    order_status,
    total_price,
    order_date
from {{ ref('stg_tpch__orders') }}

{% endsnapshot %}
