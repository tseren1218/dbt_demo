# tpch_dagster

Dagster code location that orchestrates the sibling **`../tpch_dbt`** dbt project.
Each dbt model becomes a Dagster asset via `dagster-dbt`.

## How it's linked

- `tpch_dagster/project.py` — a `DbtProject` pointing at `../tpch_dbt`
  (`project_dir=.../tpch_dbt`). `prepare_if_dev()` regenerates the dbt
  `manifest.json` automatically when you run `dagster dev`.
- `tpch_dagster/assets.py` — `@dbt_assets` turns the dbt manifest into assets;
  running them executes `dbt build`.
- `tpch_dagster/schedules.py` — cadence-based schedules built from dbt tags (see below).
- `tpch_dagster/definitions.py` — wires the assets + schedules + a `DbtCliResource`
  into `Definitions`.

Only materialized dbt models appear as assets. The `int_*` models are
`ephemeral` in `dbt_project.yml`, so they're inlined by dbt and intentionally
do **not** show up as assets (14 assets: `stg/*`, `marts/*`, and the
`country_iso_code` seed).

## Schedules

`schedules.py` defines two schedules via `build_schedule_from_dbt_selection`, each
materializing dbt models selected by a **tag** set in the model's `{{ config() }}`
block (in `../tpch_dbt/models/marts/*.sql`):

| Schedule | Cron | dbt select | Models | Why |
|----------|------|------------|--------|-----|
| `hourly_dbt_models` | `0 * * * *` (top of every hour) | `tag:hourly` | `fact_orders`, `fact_revenue` | Transactional facts — high-velocity, refresh often |
| `daily_dbt_models` | `0 0 * * *` (midnight daily) | `tag:daily` | `dim_customers`, `dim_parts`, `dim_supplier` | Slowly-changing dimensions |

Rebuilding a tagged fact/dim pulls fresh source data through the upstream `stg_*`
views and ephemeral `int_*` models automatically, so only the persisted marts are
tagged.

Both schedules run in **UTC** and default to **STOPPED** — enable them in the UI
under **Automation** (or set `default_status=RUNNING` in `schedules.py`).

## Environment

Run everything with the **system `python3`** (`/Library/Frameworks/...`), which
has `dagster`, `dagster-dbt`, `dbt-core`, and `dbt-duckdb` installed. dbt reads
`../tpch_dbt/profiles.yml` (DuckDB) automatically because Dagster runs dbt from
the project dir.

> Note: the repo-root `venv/` has dbt but **not** Dagster — don't use it here.

## Run

```bash
cd tpch_dagster
dagster dev          # UI at http://localhost:3000
```

In the UI: open **Assets**, click **Materialize all** to run the full dbt DAG
(`dbt build`, which also runs tests). The DuckDB file is
`../tpch_dbt/data/tpch.duckdb` — close any other connection to it (e.g.
DataGrip) first, since DuckDB allows only one writer.
