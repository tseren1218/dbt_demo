# dbt Course → This Project (Learning Guide)

This project implements the **DBT Course Topics** curriculum against the TPC-H
dataset on DuckDB. Below, each module points to the exact files and commands
where you can see the concept working. Everything is verified with `dbt build`.

> Setup: `source ../venv/bin/activate` then run commands from this `tpch_dbt/` dir.
> First time: `dbt deps` (installs dbt_utils), then `dbt build`.

| # | Module | Where to look |
|---|--------|---------------|
| 1 | Getting Started | `dbt_project.yml`, `profiles.yml`, `models/` structure |
| 2 | Models | `models/stg` (view), `models/int` (ephemeral), `models/marts` (table) |
| 3 | Sources & Seeds | `models/sources.yml`, `seeds/country_iso_code.csv` |
| 4 | Testing | `models/stg/schema.yml`, `models/marts/schema.yml`, `tests/` |
| 5 | Documentation | `models/docs.md`, `description:` fields in every `schema.yml` |
| 6 | Contracts & Governance | `models/stg/schema.yml` (contract), `models/governance.yml`, `dbt_project.yml` |
| 7 | Incremental | `models/marts/fact_orders_incremental.sql` |
| 8 | Snapshots | `snapshots/scd_orders.sql` |
| 9 | Macros & Jinja | `macros/clean_phone.sql`, `macros/cents_to_dollars.sql` |
| 10 | Packages | `packages.yml` + dbt-utils tests in `schema.yml` |
| 11 | Hooks & Operations | `dbt_project.yml` (on-run hooks), `fact_orders_incremental.sql` (post_hook), `macros/grant_select.sql` |
| 12 | Tags & Selectors | `{{ config(tags=...) }}` in marts; **Orchestration → `../tpch_dagster/`** |
| 13 | Advanced | `models/exposures.yml`, `models/marts/_unit_tests.yml`, `models/semantic/`, `.github/workflows/dbt_ci.yml` |
| 14 | Best Practices | this project (naming, CTEs, tests, contracts, CI) |

## Module notes & how to try each

**M3 — Source freshness.** `models/sources.yml` sets `loaded_at_field` +
`freshness` on `orders`. Try: `dbt source freshness`. It reports **STALE** on
purpose — TPC-H is 1990s data. In production `loaded_at_field` is an ingestion
timestamp that updates each load.

**M4 — Testing.** Generic tests (`not_null`, `unique`, `accepted_values`,
`relationships`) live in the `schema.yml` files. A custom generic test is in
`tests/generic/not_before.sql`; a singular test in
`tests/assert_no_future_orders.sql`; dbt-utils tests
(`unique_combination_of_columns`, `accepted_range`) on `stg_tpch__lineitem`.
Try: `dbt test`.

**M5 — Documentation.** Reusable descriptions in `models/docs.md`, referenced
with `{{ doc('...') }}`. Try: `dbt docs generate && dbt docs serve`.

**M6 — Contracts & Governance.** `stg_tpch__customer` enforces a **contract**
(column types + primary key). `models/governance.yml` defines **groups**;
`dbt_project.yml` assigns `+group` and `+access` (`protected` staging → `public`
marts). Note: `access: private` would block marts from ref-ing staging across
groups — that's why staging is `protected`.

**M7 — Incremental.** `fact_orders_incremental.sql` uses `is_incremental()`,
`unique_key`, and `delete+insert`. Try: run it twice (2nd run adds 0 rows since
data is historical), then `dbt run -s fact_orders_incremental --full-refresh`.

**M8 — Snapshots.** `snapshots/scd_orders.sql` uses the `check` strategy (no
`updated_at` in TPC-H). Try: `dbt snapshot`, then query `snapshots.scd_orders`
and filter `dbt_valid_to is null` for current rows.

**M9 — Macros.** `clean_phone` (used in `stg_tpch__customer` & `stg_tpch__supplier`)
strips non-digits from phone numbers. `cents_to_dollars` shows default args.

**M11 — Hooks & Operations.** `on-run-start` / `on-run-end` log at the start/end
of every run (see them in `dbt build` output). `fact_orders_incremental` has a
`post_hook` that builds an index. `macros/grant_select.sql` is an **operation**:
`dbt run-operation grant_select --args '{role: reporting}'`.

**M13 — Advanced.**
- *Exposures:* `models/exposures.yml` registers a BI dashboard. Try:
  `dbt build -s +exposure:executive_revenue_dashboard`.
- *Unit tests:* `models/marts/_unit_tests.yml` feeds fake rows into `dim_parts`
  and asserts the derived category. Runs during `dbt test` / `dbt build`.
- *Semantic Layer:* `models/semantic/` defines a semantic model + metrics
  (`net_revenue`, `order_count`, `avg_revenue_per_order`) and the required
  `metricflow_time_spine`.
- *CI/CD:* `.github/workflows/dbt_ci.yml` runs `dbt build` on every PR.

## What was intentionally left as-is

- **Orchestration (M12.3)** — already implemented with Dagster in
  `../tpch_dagster/` (schedules by tag). See that project's README.
- **Multi-project / dbt Mesh (M13.4)** and **dbt Cloud** features require more
  than one project / a Cloud account, so they're described but not built here.
