with parts as (
    select * from {{ ref('stg_tpch__part') }}
),

final as (
    select
        -- keys
        part_id,

        -- attributes
        name,
        manufacturer,
        brand,
        type,
        size,
        container,

        -- financials
        retail_price,

        -- derived
        split_part(type, ' ', -1)  as part_type_category
    from parts
)

select * from final