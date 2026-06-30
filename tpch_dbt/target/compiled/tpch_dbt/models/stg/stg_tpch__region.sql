with source as (
    select 
        *
    from "tpch"."main"."region"
)

select
    r_regionkey as region_id,
    r_name as name,
    r_comment as comment
from source