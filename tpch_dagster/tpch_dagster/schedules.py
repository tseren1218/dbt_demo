"""Schedules that materialize dbt models by refresh-cadence tag.

Tags are defined in ../tpch_dbt/dbt_project.yml:
  - "hourly" -> fact_orders, fact_revenue   (transactional facts)
  - "daily"  -> dim_customers, dim_parts, dim_supplier  (slowly-changing dims)
"""
from dagster_dbt import build_schedule_from_dbt_selection

from .assets import tpch_dbt_dbt_assets

schedules = [
    build_schedule_from_dbt_selection(
        [tpch_dbt_dbt_assets],
        job_name="hourly_dbt_models",
        cron_schedule="0 * * * *",  # top of every hour
        dbt_select="tag:hourly",
    ),
    build_schedule_from_dbt_selection(
        [tpch_dbt_dbt_assets],
        job_name="daily_dbt_models",
        cron_schedule="0 0 * * *",  # midnight every day
        dbt_select="tag:daily",
    ),
]
