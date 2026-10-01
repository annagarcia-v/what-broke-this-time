select order_id, order_amount_eur
from {{ ref('stg_orders') }}
where order_amount_eur < 0
