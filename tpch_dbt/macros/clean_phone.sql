{#
    Module 9 — Macros & Jinja: a custom, reusable macro.

    clean_phone() strips every non-digit character from a phone column so
    "25-989-741-2988" becomes "259897412988". Call it from any model:

        select {{ clean_phone('phone') }} as phone from ...

    `column_name` is the column (or SQL expression) to clean. Jinja substitutes
    it into the SQL at compile time, so nothing here runs in Python — dbt just
    builds a regexp_replace() call and hands it to the warehouse.
#}
{% macro clean_phone(column_name) -%}
    regexp_replace({{ column_name }}, '[^0-9]', '', 'g')
{%- endmacro %}
