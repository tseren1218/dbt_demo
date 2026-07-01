select
    order_id,
    order_date
from {{ ref('stg_tpch__orders') }}
where order_date > current_timestamp