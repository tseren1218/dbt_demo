with partsupps as (
    select * from {{ ref('stg_tpch__partsupp') }}
),

parts as (
    select * from {{ ref('stg_tpch__part') }}
),

suppliers as (
    select * from {{ ref('int_supplier_with_nation') }}
),

joined as (
    select
        -- keys
        ps.part_id,
        ps.supplier_id,

        -- part-supplier attributes
        ps.availqty as available_quantity,
        ps.supply_cost,
        ps.comment,

        -- part attributes
        p.name as part_name,
        p.manufacturer as part_manufacturer,
        p.brand as part_brand,
        p.type as part_type,
        p.size as part_size,
        p.container as part_container,
        p.retail_price as part_retail_price,

        -- supplier attributes (already has nation + region)
        s.supplier_name,
        {# s.nation_name,
        s.region_name, #}

        -- derived
        ps.availqty * ps.supply_cost as inventory_value

    from partsupps ps
    join parts p on ps.part_id = p.part_id
    join suppliers s on ps.supplier_id = s.supplier_id
)

select * from joined