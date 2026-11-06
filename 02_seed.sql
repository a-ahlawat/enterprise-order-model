INSERT INTO dim_customer_version VALUES
    (1, 'C001', 'Consumer', DATE '2025-01-01', DATE '2025-04-01'),
    (2, 'C001', 'Small Business', DATE '2025-04-01', NULL),
    (3, 'C002', 'Consumer', DATE '2025-01-01', NULL);

INSERT INTO stg_order_line VALUES
    ('O100', 1, DATE '2025-03-31', 'C001', 'P001', 1, 15.00),
    ('O100', 2, DATE '2025-03-31', 'C001', 'P004', 1, 15.00),
    ('O101', 1, DATE '2025-04-01', 'C001', 'P002', 1, 40.00),
    ('O102', 1, DATE '2025-04-01', 'C002', 'P003', 1, 25.00);
