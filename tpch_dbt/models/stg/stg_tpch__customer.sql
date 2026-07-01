with source as (
    select 
        *
    from {{ source('tpch', 'customer') }}
)

select
    c_custkey as customer_id,
    c_name as name,
    c_address as address,
    c_nationkey as nation_id,
    {{ clean_phone('c_phone') }} as phone,  -- Module 9: custom macro
    c_acctbal as account_balance,
    'USD' as account_balance_currency,
    c_mktsegment as market_segment,
    c_comment as comment
from source