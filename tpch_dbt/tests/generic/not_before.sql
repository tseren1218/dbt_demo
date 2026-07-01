{#
    Generic test: asserts the tested column is not chronologically before
    `compare_column` on the same row (i.e. column >= compare_column).

    Useful for TPC-H date sequencing invariants, e.g. an item cannot be
    received before it was shipped, or shipped before the order was placed.

    Args:
      compare_column: the column that must be earlier-or-equal.
      or_equal:       when true (default) equal dates pass; set false to
                      require the tested column to be strictly later.

    Rows returned = violations, so zero rows means the test passes.
#}
{% test not_before(model, column_name, compare_column, or_equal=true) %}

with validation as (

    select
        {{ column_name }} as later_value,
        {{ compare_column }} as earlier_value
    from {{ model }}

)

select *
from validation
where later_value is not null
  and earlier_value is not null
  and later_value {{ '<' if or_equal else '<=' }} earlier_value

{% endtest %}
