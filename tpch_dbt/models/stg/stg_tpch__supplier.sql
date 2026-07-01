with source as (
    select
        *
    from {{ source('tpch', 'supplier') }}
)

select
    s_suppkey as supplier_id,
    s_name as name,
    s_address as address,
    s_nationkey as nation_id,
    {{ clean_phone('s_phone') }} as phone,  -- Module 9: custom macro
    s_acctbal as account_balance,
    s_comment as comment
from source