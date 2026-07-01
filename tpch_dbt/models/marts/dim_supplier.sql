{{ config(tags=['daily']) }}

with suppliers as (
    select * from {{ ref('int_supplier_with_nation') }}
),

final as (
    select
        -- keys
        supplier_id,
        nation_id,
        region_id, 

        -- attributes
        supplier_name,
        supplier_address,
        supplier_phone,
        nation_name,
        region_name, 

        -- financials
        supplier_account_balance,
        supplier_account_balance > 0     as is_positive_balance

    from suppliers
)

select * from final