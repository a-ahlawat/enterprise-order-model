SELECT
    segment,
    COUNT(*) AS order_lines,
    SUM(booked_value_usd) AS booked_usd
FROM v_order_line
GROUP BY segment
ORDER BY segment;
