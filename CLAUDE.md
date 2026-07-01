# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A dbt (data build tool) project modeling the TPC-H benchmark dataset. It runs against a local **DuckDB** database via the `dbt-duckdb` adapter. The actual dbt project lives in `tpch_dbt/`; all dbt commands must be run from that directory. (`tpch_airflow/` is an empty placeholder for future orchestration.)

## Environment & Commands

A Python virtualenv at repo root (`venv/`) holds the pinned toolchain (`requirements.txt`, dbt-core 1.11). Either activate it or call binaries directly. **All dbt commands run from `tpch_dbt/`.**

```bash
source venv/bin/activate          # from repo root
cd tpch_dbt

dbt deps            # install packages (dbt_utils) — required before first run
dbt build           # run all models + tests + seeds in DAG order (most common)
dbt run             # build models only
dbt test            # run tests only
dbt seed            # load CSV seeds (seeds/country_iso_code.csv)

dbt run -s stg_tpch__orders          # single model
dbt run -s +fact_orders              # a model and all its upstream deps
dbt run -s stg+                      # a model and everything downstream
dbt test -s int_order_items          # tests for one model
dbt build -s marts                   # everything in the marts layer
```

The DuckDB file is created at `tpch_dbt/data/tpch.duckdb` (gitignored). Source tables (`tpch` schema, e.g. `customer`, `orders`, `lineitem`) are expected to already exist in `main` — they are declared in `models/sources.yml`, not created by this project.

## Configuration notes

- **`profiles.yml` lives inside `tpch_dbt/`** (not the usual `~/.dbt/`) and is **gitignored**. It hard-codes an absolute `path` to the DuckDB file — this path is machine-specific and must be updated when cloning. dbt finds it because commands run from the project dir.
- `macros/generate_schema_name.sql` overrides dbt's default so a model's `+schema` is used **verbatim** (no `main_stg` prefixing). Models land in schemas `stg`, `int`, `marts`.

## Model architecture

Three layers, configured in `dbt_project.yml`, each with its own schema and materialization:

| Layer | Dir | Schema | Materialization | Purpose |
|-------|-----|--------|-----------------|---------|
| Staging | `models/stg/` | `stg` | **view** | 1:1 with sources; rename raw TPC-H columns (`o_orderkey` → `order_id`), no joins |
| Intermediate | `models/int/` | `int` | **ephemeral** (inlined as CTEs, not persisted) | joins + derived metrics/flags |
| Marts | `models/marts/` | `marts` | **table** | final `dim_*` / `fact_*` star-schema tables for consumption |

Data flows staging → intermediate → marts, always via `ref()` (never `source()` outside staging). Example lineage: `stg_tpch__orders` + `stg_tpch__lineitem` → `int_order_items` → `fact_orders`.

### Conventions

- Staging models are named `stg_tpch__<table>` (double underscore separates source system from table).
- SQL is written as a chain of named CTEs ending in `select * from <final_cte>`; columns are grouped by comment headers (`-- keys`, `-- measures`, `-- flags`, `-- derived metrics`).
- Marts rename primary keys to `<entity>_key` and add boolean feature flags inline (e.g. `customer_account_balance > 0 as is_positive_balance`).

## Tests

- **Generic/schema tests** go in `schema.yml` files per model dir (e.g. `models/stg/schema.yml` — currently empty/being populated).
- **Singular tests** are standalone SQL in `tests/` that must return **zero rows** to pass (e.g. `tests/assert_no_future_orders.sql` flags orders dated in the future).

## Packages

`dbt_utils` (dbt-labs/dbt_utils 1.4.0) is declared in `packages.yml`. Run `dbt deps` to install into `dbt_packages/` (gitignored) before building.
