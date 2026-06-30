with orders as (
    select * from "tpch"."stg"."stg_tpch__orders"
),

lineitems as (
    select * from "tpch"."stg"."stg_tpch__lineitem"
),

joined as (
    select
        -- keys
        o.order_id,
        o.customer_id,
        l.part_id,
        l.supplier_id,
        l.line_number,

        -- order attributes
        o.order_date,
        o.order_status,
        o.order_priority,
        o.ship_priority,

        -- lineitem attributes
        l.quantity,
        l.extended_price,
        l.discount,
        l.tax,
        l.return_flag,
        l.line_status,
        l.ship_date,
        l.commit_date,
        l.receipt_date,
        l.ship_mode,
        l.ship_instruct,

        -- derived metrics
        l.extended_price * l.discount as discount_amount,
        l.extended_price * (1 - l.discount) as net_price,
        l.extended_price * (1 - l.discount) * (1 + l.tax) as gross_price,

        -- delivery flags
        l.ship_date <= l.commit_date as is_shipped_on_time,
        l.receipt_date <= l.commit_date as is_received_on_time,
        l.return_flag = 'R' as is_returned

    from orders o
    join lineitems l on o.order_id = l.order_id
)

select * from joined