
  
    
    

    create  table
      "tpch"."int"."int_supplier_with_nation__dbt_tmp"
  
    as (
      with suppliers as (
    select * from "tpch"."stg"."stg_tpch__supplier"
),


regions as (
    select * from "tpch"."stg"."stg_tpch__region"
),

joined as (
    select
        -- keys
        s.supplier_id as supplier_id,
        
        

        -- supplier attributes
        s.name as supplier_name,
        s.address as supplier_address,
        s.phone as supplier_phone,
        s.account_balance as supplier_account_balance,
        s.comment as supplier_comment

        -- nation attributes
        

        -- region attributes
        

    from suppliers s
    
)

select * from joined
    );
  
  