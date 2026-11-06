-- Each query returns violating rows. The release passes when all are empty.
SELECT order_id, line_number, COUNT(*) AS row_count
FROM stg_order_line
GROUP BY order_id, line_number
HAVING COUNT(*) > 1;

SELECT customer_version_id, COUNT(*) AS row_count
FROM dim_customer_version
GROUP BY customer_version_id
HAVING COUNT(*) > 1;

SELECT order_id, line_number
FROM stg_order_line
WHERE line_number < 1 OR quantity <= 0 OR unit_price_usd < 0;

SELECT customer_version_id
FROM dim_customer_version
WHERE valid_to <= valid_from;

SELECT a.customer_id, a.customer_version_id, b.customer_version_id AS overlapping_version_id
FROM dim_customer_version AS a
JOIN dim_customer_version AS b
  ON a.customer_id = b.customer_id
 AND a.customer_version_id < b.customer_version_id
 AND (a.valid_to IS NULL OR b.valid_from < a.valid_to)
 AND (b.valid_to IS NULL OR a.valid_from < b.valid_to);

SELECT line.order_id, line.line_number, COUNT(customer.customer_version_id) AS matches
FROM stg_order_line AS line
LEFT JOIN dim_customer_version AS customer
  ON customer.customer_id = line.customer_id
 AND line.booked_on >= customer.valid_from
 AND (line.booked_on < customer.valid_to OR customer.valid_to IS NULL)
GROUP BY line.order_id, line.line_number
HAVING COUNT(customer.customer_version_id) <> 1;

WITH source_totals AS (
    SELECT COUNT(*) AS lines, COALESCE(SUM(quantity * unit_price_usd), 0) AS booked_usd
    FROM stg_order_line
),
published_totals AS (
    SELECT COUNT(*) AS lines, COALESCE(SUM(booked_value_usd), 0) AS booked_usd
    FROM v_order_line
)
SELECT source.lines AS source_lines, published.lines AS published_lines,
       source.booked_usd AS source_usd, published.booked_usd AS published_usd
FROM source_totals AS source
CROSS JOIN published_totals AS published
WHERE source.lines <> published.lines OR source.booked_usd <> published.booked_usd;
