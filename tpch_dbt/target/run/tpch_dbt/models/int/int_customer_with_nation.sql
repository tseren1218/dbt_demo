
  
    
    

    create  table
      "tpch"."int"."int_customer_with_nation__dbt_tmp"
  
    as (
      with customers as (
    select * from "tpch"."stg"."stg_tpch__customer"
),



regions as (
    select * from "tpch"."stg"."stg_tpch__region"
),

joined as (
    select
        -- keys
        c.customer_id as customer_id,
        
        

        -- customer attributes
        c.name as customer_name,
        c.address as customer_address,
        c.phone as customer_phone,
        c.account_balance as customer_account_balance,
        c.market_segment as customer_market_segment,
        c.comment as customer_comment

        -- nation attributes
        

        -- region attributes
        

    from customers c
    
)

select * from joined
    );
  
  