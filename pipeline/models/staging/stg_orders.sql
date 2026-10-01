select
    order_id,
    customer_id,
    ordered_at as order_date,
    lower(trim(status)) as order_status,
    cast(amount_cents * 0.01 as decimal(12, 2)) as order_amount_eur
from {{ ref('raw_orders') }}
