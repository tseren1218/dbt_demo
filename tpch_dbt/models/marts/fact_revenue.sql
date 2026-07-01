{{ config(tags=['hourly']) }}

with order_items as (
    select * from {{ ref('int_order_items') }}
),

fact_revenue as (
    select
        -- keys
        order_id,
        customer_id,
        order_date,

        -- dimensions to aggregate by
        order_status,
        order_priority,
        ship_mode,

        -- aggregated measures
        count(line_number)              as line_item_count,
        sum(quantity)                   as total_quantity,
        sum(extended_price)             as gross_revenue,
        sum(discount_amount)            as total_discount,
        sum(net_price)                  as net_revenue,
        sum(gross_price)                as total_revenue_with_tax,
        sum(case when is_returned
            then net_price else 0 end)  as returned_revenue,
        count(case when is_returned
            then 1 end)                 as return_count

    from order_items
    group by 1, 2, 3, 4, 5, 6
)

select * from fact_revenue