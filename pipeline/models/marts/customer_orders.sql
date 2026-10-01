select
    orders.order_id,
    orders.customer_id,
    customers.customer_name,
    customers.country,
    orders.order_date,
    orders.order_amount_eur
from {{ ref('stg_orders') }} as orders
inner join {{ ref('stg_customers') }} as customers
    on orders.customer_id = customers.customer_id
where orders.order_status = 'completed'
