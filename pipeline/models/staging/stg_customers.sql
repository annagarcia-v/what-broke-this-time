select
    customer_id,
    trim(customer_name) as customer_name,
    upper(trim(country)) as country
from {{ ref('raw_customers') }}
