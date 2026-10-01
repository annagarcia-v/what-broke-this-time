-- Regression check for the fixed synthetic dataset, including filtering and joins.
with expected as (
    select * from (values
        ('ORD-1001', '001', 'Ada Stone', 'ES', date '2026-01-10', 120.00::decimal(12, 2)),
        ('ORD-1002', '001', 'Ada Stone', 'ES', date '2026-01-11', 45.50::decimal(12, 2)),
        ('ORD-1004', '002', 'Leo Reed', 'FR', date '2026-01-13', 25.00::decimal(12, 2)),
        ('ORD-1006', '003', 'Mia Lake', 'DE', date '2026-01-15', 10.00::decimal(12, 2))
    ) as rows(order_id, customer_id, customer_name, country, order_date, order_amount_eur)
),
actual as (
    select order_id, customer_id, customer_name, country, order_date, order_amount_eur
    from {{ ref('customer_orders') }}
),
missing as (
    select * from expected
    except all
    select * from actual
),
unexpected as (
    select * from actual
    except all
    select * from expected
)
select * from missing
union all
select * from unexpected
