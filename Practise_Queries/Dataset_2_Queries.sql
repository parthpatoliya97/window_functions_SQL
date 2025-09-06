-- 1. Calculate the difference in sales amount between consecutive sales.
WITH cte AS (
    SELECT 
        sale_id,
        sale_date,
        amount,
        LAG(amount, 1) OVER (ORDER BY sale_date) AS previous_amount
    FROM sales
)
SELECT 
    sale_id,
    sale_date,
    amount,
    previous_amount,
    (amount - previous_amount) AS difference_in_amount
FROM cte;


-- 2. Find the sale amount for the next product sale.
SELECT 
    sale_id,
    sale_date,
    amount,
    LEAD(amount, 1) OVER (ORDER BY sale_date) AS following_amount
FROM sales;


-- 3. For each product, calculate the difference between the current and previous sale amount.
WITH cte AS (
    SELECT 
        product_name,
        sale_date,
        amount AS current_sale,
        LAG(amount, 1) OVER (PARTITION BY product_name ORDER BY sale_date) AS previous_sale
    FROM sales
)
SELECT 
    product_name,
    sale_date,
    (current_sale - previous_sale) AS sale_difference
FROM cte;


-- 4. Show the next product sold for each store location.
SELECT 
    product_name,
    sale_date,
    store_location,
    LEAD(product_name) OVER (PARTITION BY store_location ORDER BY sale_date) AS next_product
FROM sales;


-- 5. Find the previous sale amount for each store location.
SELECT 
    sale_id,
    store_location,
    amount,
    LAG(amount, 1) OVER (PARTITION BY store_location ORDER BY sale_date) AS previous_sale
FROM sales;


-- 6. Calculate the rolling difference between sales for each product.
SELECT 
    product_name,
    sale_date,
    amount,
    LAG(amount, 1) OVER (PARTITION BY product_name ORDER BY sale_date) AS previous_sale,
    LEAD(amount, 1) OVER (PARTITION BY product_name ORDER BY sale_date) AS next_sale
FROM sales;


-- 7. Identify sales where the previous sale amount was higher than the current sale.
WITH cte AS (
    SELECT 
        product_name,
        sale_date,
        amount AS current_sale,
        LAG(amount, 1) OVER (PARTITION BY product_name ORDER BY sale_date) AS previous_sale
    FROM sales
)
SELECT 
    product_name,
    sale_date,
    current_sale,
    previous_sale
FROM cte
WHERE previous_sale > current_sale;


-- 8. Show total sales for each month, with the amount sold in the previous month.
WITH monthly AS (
    SELECT 
        DATE_FORMAT(sale_date, '%Y-%m') AS sale_month,
        SUM(amount) AS monthly_sales
    FROM sales
    GROUP BY DATE_FORMAT(sale_date, '%Y-%m')
)
SELECT 
    sale_month,
    monthly_sales,
    LAG(monthly_sales, 1) OVER (ORDER BY sale_month) AS previous_month_sales
FROM monthly;


-- 9. Determine the percentage increase or decrease in sales compared to the previous sale.
WITH cte AS (
    SELECT 
        sale_date,
        amount AS current_sale,
        LAG(amount, 1) OVER (ORDER BY sale_date) AS previous_sale
    FROM sales
)
SELECT 
    sale_date,
    current_sale,
    previous_sale,
    ROUND(((current_sale - previous_sale) / previous_sale) * 100, 2) AS growth_percent
FROM cte
WHERE previous_sale IS NOT NULL;


-- 10. List all sales where the amount is greater than the average sales amount for that product.
SELECT 
    sale_id,
    product_name,
    sale_date,
    amount,
    AVG(amount) OVER (PARTITION BY product_name) AS avg_product_sales
FROM sales
WHERE amount > AVG(amount) OVER (PARTITION BY product_name);
