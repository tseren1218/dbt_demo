with customers as (
    select * from {{ ref('int_customer_with_nation') }}
),

final as (
    select
        -- keys
        customer_id as customer_key,
        {# nation_id, #}
        {# region_id, #}

        -- attributes
        customer_name,
        customer_address,
        customer_phone,
        customer_market_segment,
        {# nation_name, #}
        {# region_name, #}

        -- financials
        customer_account_balance,
        customer_account_balance > 0     as is_positive_balance,
        customer_market_segment = 'BUILDING' as is_building_segment

    from customers
)

select * from final