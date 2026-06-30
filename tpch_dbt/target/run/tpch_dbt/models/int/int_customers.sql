
  
    
    

    create  table
      "tpch"."int"."int_customers__dbt_tmp"
  
    as (
      with source as (
    select 
        c_custkey as customer_id,
        c_name as name,
        c_address as address,
        c_nationkey as nation_id,
        c_phone as phone,
        c_acctbal as account_balance,
        'USD' as account_balance_currency,
        c_mktsegment as market_segment,
        c_comment as comment
    from "tpch"."stg"."stg_tpch__customer"
)

select
    *
from source
    );
  
  