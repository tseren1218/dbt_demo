{#
    Module 13.2 — the Semantic Layer needs a "time spine": a table with one row
    per day. MetricFlow joins to it to fill gaps and roll metrics up to
    week/month/quarter. Built here with dbt_utils.date_spine (Module 10).
#}
{{ config(materialized='table') }}

with days as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('1990-01-01' as date)",
        end_date="cast('2000-01-01' as date)"
    ) }}
)

select cast(date_day as date) as date_day
from days
