with customers as (
    select * from {{ ref('stg_tpch__customer') }}
),

nations as (
    select * from {{ ref('stg_tpch__nation') }}
),

regions as (
    select * from {{ ref('stg_tpch__region') }}
),

joined as (
    select
        -- keys
        c.customer_id as customer_id,
        n.nation_id,
        r.region_id,

        -- customer attributes
        c.name as customer_name,
        c.address as customer_address,
        c.phone as customer_phone,
        c.account_balance as customer_account_balance,
        c.market_segment as customer_market_segment,
        c.comment as customer_comment,

        -- nation attributes
        n.nation_name,

        -- region attributes
        r.region_name

    from customers c
    join nations n on c.nation_id = n.nation_id
    join regions r on n.region_id = r.region_id
)

select * from joined