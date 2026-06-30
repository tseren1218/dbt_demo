with suppliers as (
    select * from "tpch"."int"."int_supplier_with_nation"
),

final as (
    select
        -- keys
        supplier_id,
        

        -- attributes
        supplier_name,
        supplier_address,
        supplier_phone,
        

        -- financials
        supplier_account_balance,
        supplier_account_balance > 0     as is_positive_balance

    from suppliers
)

select * from final