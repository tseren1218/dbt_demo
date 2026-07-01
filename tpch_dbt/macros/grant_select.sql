{#
    Module 11 — Operations: a macro you invoke with `dbt run-operation`.

    Unlike a model, an operation runs ad-hoc SQL on demand. Run it with:

        dbt run-operation grant_select --args '{role: reporting}'

    DuckDB (this project's warehouse) doesn't enforce GRANTs, so this logs the
    statement instead of failing — the point is to show the run-operation
    pattern you'd use on Snowflake/BigQuery/Postgres to manage permissions.
#}
{% macro grant_select(role='reporting') %}
    {% set schemas = ['stg', 'marts'] %}
    {% for schema in schemas %}
        {% set sql = 'grant select on all tables in schema ' ~ schema ~ ' to ' ~ role %}
        {{ log('[grant_select] would run: ' ~ sql, info=true) }}
    {% endfor %}
{% endmacro %}
