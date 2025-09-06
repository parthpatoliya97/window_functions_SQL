CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    sale_date DATE,
    amount DECIMAL(10, 2),
    store_location VARCHAR(50)
);

INSERT INTO sales (sale_id, product_name, sale_date, amount, store_location)
VALUES
(1, 'Laptop', '2023-01-15', 1500.00, 'New York'),
(2, 'Headphones', '2023-02-03', 200.00, 'Chicago'),
(3, 'Laptop', '2023-03-10', 1600.00, 'San Francisco'),
(4, 'Phone', '2023-02-21', 800.00, 'New York'),
(5, 'Tablet', '2023-05-15', 600.00, 'Chicago'),
(6, 'Laptop', '2023-04-12', 1450.00, 'Chicago'),
(7, 'Phone', '2023-01-20', 850.00, 'San Francisco'),
(8, 'Headphones', '2023-03-18', 220.00, 'New York'),
(9, 'Tablet', '2023-04-25', 620.00, 'San Francisco'),
(10, 'Laptop', '2023-06-10', 1550.00, 'New York'),
(11, 'Phone', '2023-07-02', 790.00, 'Chicago'),
(12, 'Tablet', '2023-07-20', 640.00, 'New York'),
(13, 'Headphones', '2023-05-30', 210.00, 'San Francisco'),
(14, 'Laptop', '2023-08-15', 1620.00, 'Chicago'),
(15, 'Phone', '2023-09-01', 800.00, 'San Francisco'),
(16, 'Tablet', '2023-08-23', 650.00, 'New York'),
(17, 'Headphones', '2023-10-05', 230.00, 'Chicago'),
(18, 'Laptop', '2023-11-12', 1580.00, 'New York'),
(19, 'Phone', '2023-12-10', 815.00, 'Chicago'),
(20, 'Tablet', '2023-12-28', 680.00, 'San Francisco'),
(21, 'Laptop', '2023-11-22', 1650.00, 'San Francisco'),
(22, 'Headphones', '2023-11-30', 240.00, 'New York'),
(23, 'Phone', '2023-12-15', 820.00, 'New York'),
(24, 'Tablet', '2023-12-05', 670.00, 'Chicago'),
(25, 'Laptop', '2023-12-28', 1700.00, 'Chicago');
