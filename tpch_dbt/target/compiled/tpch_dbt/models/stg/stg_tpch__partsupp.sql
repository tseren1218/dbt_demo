with source as (
    select 
        *
    from "tpch"."main"."partsupp"
)

select
    ps_partkey as part_id,
    ps_suppkey as supplier_id,
    ps_availqty as availqty,
    ps_supplycost as supply_cost,
    ps_comment as comment
from source