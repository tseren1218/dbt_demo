with csv_data as (
    select 
        name as nation_name,
        "alpha-2" as alpha_2,
        "alpha-3" as alpha_3,
        "iso_3166-2" as iso_code
    from {{ source('tpch', 'country_iso_code') }}
),
    nation as(
        select 
            n_nationkey as nation_id,
            n_name as nation_name,
            n_regionkey as region_id,
            n_comment as comment
         from {{ source('tpch','nation')}}
    )


select
   n.nation_id,
   n.nation_name,
   n.region_id,
   cs.alpha_2,
   cs.alpha_3,
   cs.iso_code,
   n.comment
from nation n
left join csv_data cs on lower(n.nation_name) = lower(cs.nation_name)