{#
    Module 9 — Macros & Jinja: a second custom macro, showing default arguments.

    Rounds a numeric column to `decimals` places (2 by default). Demonstrates
    that macros can take multiple args with defaults, just like Python:

        select {{ cents_to_dollars('retail_price') }} as price_usd from ...
#}
{% macro cents_to_dollars(column_name, decimals=2) -%}
    round({{ column_name }}, {{ decimals }})
{%- endmacro %}
