CREATE TABLE stg_order_line (
    order_id VARCHAR NOT NULL,
    line_number INTEGER NOT NULL,
    booked_on DATE NOT NULL,
    customer_id VARCHAR NOT NULL,
    product_id VARCHAR NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price_usd NUMBER(12, 2) NOT NULL,
    PRIMARY KEY (order_id, line_number)
);

CREATE TABLE dim_customer_version (
    customer_version_id INTEGER NOT NULL PRIMARY KEY,
    customer_id VARCHAR NOT NULL,
    segment VARCHAR NOT NULL,
    valid_from DATE NOT NULL,
    valid_to DATE,
    UNIQUE (customer_id, valid_from)
);
