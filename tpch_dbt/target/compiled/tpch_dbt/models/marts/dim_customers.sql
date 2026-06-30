with customers as (
    select * from "tpch"."int"."int_customer_with_nation"
),

final as (
    select
        -- keys
        customer_id as customer_key,
        
        

        -- attributes
        customer_name,
        customer_address,
        customer_phone,
        customer_market_segment,
        
        

        -- financials
        customer_account_balance,
        customer_account_balance > 0     as is_positive_balance,
        customer_market_segment = 'BUILDING' as is_building_segment

    from customers
)

select * from final