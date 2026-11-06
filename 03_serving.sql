CREATE VIEW v_order_line AS
WITH candidates AS (
    SELECT
        line.order_id,
        line.line_number,
        line.booked_on,
        line.product_id,
        customer.customer_version_id,
        customer.segment,
        line.quantity,
        line.unit_price_usd,
        line.quantity * line.unit_price_usd AS booked_value_usd,
        COUNT(*) OVER (PARTITION BY line.order_id, line.line_number) AS candidate_count
    FROM stg_order_line AS line
    JOIN dim_customer_version AS customer
      ON customer.customer_id = line.customer_id
     AND line.booked_on >= customer.valid_from
     AND (line.booked_on < customer.valid_to OR customer.valid_to IS NULL)
)
SELECT
    order_id, line_number, booked_on, product_id, customer_version_id,
    segment, quantity, unit_price_usd, booked_value_usd
FROM candidates
WHERE candidate_count = 1;
