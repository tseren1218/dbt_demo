with order_items as (
    select * from {{ ref('int_order_items') }}
),

fact_orders as (
    select
        -- keys (foreign keys to dims)
        order_id,
        customer_id,
        part_id,
        supplier_id,
        line_number,

        -- dates
        order_date,
        ship_date,
        commit_date,
        receipt_date,

        -- order attributes
        order_status,
        order_priority,
        ship_priority,
        ship_mode,
        ship_instruct,
        return_flag,
        line_status,

        -- flags
        is_shipped_on_time,
        is_received_on_time,
        is_returned,

        -- measures
        quantity,
        extended_price,
        discount,
        tax,
        discount_amount,
        net_price,
        gross_price

    from order_items
)

select * from fact_orders