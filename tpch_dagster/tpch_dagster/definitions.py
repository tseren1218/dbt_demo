from dagster import Definitions
from dagster_dbt import DbtCliResource
from .assets import tpch_dbt_dbt_assets
from .project import tpch_dbt_project
from .schedules import schedules

defs = Definitions(
    assets=[tpch_dbt_dbt_assets],
    schedules=schedules,
    resources={
        "dbt": DbtCliResource(project_dir=tpch_dbt_project),
    },
)