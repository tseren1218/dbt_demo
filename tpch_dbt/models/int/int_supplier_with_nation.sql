with suppliers as (
    select * from {{ ref('stg_tpch__supplier') }}
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
        s.supplier_id as supplier_id,
        n.nation_id,
        r.region_id,

        -- supplier attributes
        s.name as supplier_name,
        s.address as supplier_address,
        s.phone as supplier_phone,
        s.account_balance as supplier_account_balance,
        s.comment as supplier_comment,

        -- nation attributes
        n.nation_name,

        -- region attributes
        r.region_name

    from suppliers s
    join nations n on s.nation_id = n.nation_id
    join regions r on n.region_id = r.region_id
)

select * from joined