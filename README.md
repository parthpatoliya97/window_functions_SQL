### 30 SQL QUESTIONS ON WINDOW FUNCTIONS

#### 1. Dataset 1: Employee Salaries
```sql
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10, 2),
    hire_date DATE
);

INSERT INTO employees (emp_id, emp_name, department, salary, hire_date)
VALUES
(1, 'Alice', 'HR', 55000, '2018-01-15'),
(2, 'Bob', 'IT', 75000, '2017-05-23'),
(3, 'Charlie', 'Finance', 82000, '2019-03-12'),
(4, 'Diana', 'IT', 60000, '2020-07-19'),
(5, 'Eve', 'HR', 52000, '2021-11-05'),
(6, 'Frank', 'Finance', 72000, '2020-08-10'),
(7, 'Grace', 'HR', 61000, '2016-12-20'),
(8, 'Hank', 'IT', 69000, '2019-01-11'),
(9, 'Ivy', 'Finance', 73000, '2018-09-30'),
(10, 'Jack', 'HR', 54000, '2017-10-15'),
(11, 'Kate', 'IT', 78000, '2016-06-01'),
(12, 'Leo', 'HR', 59000, '2019-02-21'),
(13, 'Mia', 'Finance', 76000, '2019-04-10'),
(14, 'Nick', 'IT', 65000, '2018-12-05'),
(15, 'Olivia', 'HR', 53000, '2020-09-29'),
(16, 'Paul', 'Finance', 70000, '2021-03-22'),
(17, 'Quincy', 'IT', 72000, '2020-01-07'),
(18, 'Rita', 'HR', 60000, '2020-05-15'),
(19, 'Steve', 'Finance', 78000, '2019-08-18'),
(20, 'Tom', 'IT', 81000, '2018-07-23'),
(21, 'Uma', 'HR', 58000, '2020-02-17'),
(22, 'Victor', 'Finance', 75000, '2021-05-10'),
(23, 'Wendy', 'IT', 70000, '2020-10-05'),
(24, 'Xander', 'HR', 62000, '2017-11-22'),
(25, 'Yara', 'Finance', 82000, '2021-06-30');
```
#### 1. Find the row number of each employee ordered by salary.
```sql
SELECT 
    emp_id,
    emp_name,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS salary_rnk
FROM employees;
```

#### 2. Rank employees based on salaries.
```sql
SELECT 
    emp_id, 
    emp_name, 
    salary,
    RANK() OVER (ORDER BY salary DESC) AS salary_rnk
FROM employees;
```

#### 3. Dense rank employees within each department by salary.
```sql
SELECT 
    emp_id, 
    emp_name, 
    salary, 
    department,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rnk
FROM employees;
```

#### 4. Rank employees by hire date.
```sql
SELECT 
    emp_id, 
    emp_name, 
    hire_date, 
    salary,
    RANK() OVER (ORDER BY hire_date ASC) AS hire_rnk
FROM employees;
```

#### 5. Row number by department based on hire date.
```sql
SELECT 
    emp_id, 
    emp_name, 
    salary, 
    department, 
    hire_date,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY hire_date) AS rnk
FROM employees;
```

#### 6. Highest-paid employee in each department.
```sql
WITH salary_ranking AS (
    SELECT 
        emp_id, 
        emp_name, 
        department, 
        salary,
        DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rnk
    FROM employees
)
SELECT 
    emp_id, 
    emp_name, 
    department, 
    salary
FROM salary_ranking
WHERE salary_rnk = 1;
```

#### 7. Rank difference between global vs. department ranks.
```sql
SELECT 
    emp_id, 
    emp_name, 
    department, 
    salary,
    RANK() OVER (ORDER BY salary DESC) AS global_rank,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_rank,
    RANK() OVER (ORDER BY salary DESC) - 
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank_difference
FROM employees;
```

#### 8. 2nd highest salary in each department.
```sql
WITH cte AS (
    SELECT 
        emp_name, 
        department, 
        salary,
        DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rnk
    FROM employees
)
SELECT 
    emp_name, 
    department, 
    salary
FROM cte
WHERE salary_rnk = 2;
```

#### 9. Find the average salary of the top 3 highest-paid employees in each department.
```sql
WITH cte AS (
    SELECT 
        emp_id,
        emp_name,
        department,
        salary,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rnk
    FROM employees
)
SELECT 
    department,
    ROUND(AVG(salary), 2) AS avg_top3_salary
FROM cte
WHERE salary_rnk <= 3
GROUP BY department;
```

#### 10. Assign a dense rank to employees based on their hire date, resetting at each department change.
```sql
SELECT 
    emp_id,
    emp_name,
    salary,
    department,
    hire_date,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY hire_date) AS ranking
FROM employees;
```

#### 2. Dataset 2: Sales Data
```sql
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
```
#### 1. Calculate the difference in sales amount between consecutive sales.
```sql
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
```

#### 2. Find the sale amount for the next product sale.
```sql
SELECT 
    sale_id,
    sale_date,
    amount,
    LEAD(amount, 1) OVER (ORDER BY sale_date) AS following_amount
FROM sales;
```

#### 3. For each product, calculate the difference between the current and previous sale amount.
```sql
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
```

#### 4. Show the next product sold for each store location.
```sql
SELECT 
    product_name,
    sale_date,
    store_location,
    LEAD(product_name) OVER (PARTITION BY store_location ORDER BY sale_date) AS next_product
FROM sales;
```

#### 5. Find the previous sale amount for each store location.
```sql
SELECT 
    sale_id,
    store_location,
    amount,
    LAG(amount, 1) OVER (PARTITION BY store_location ORDER BY sale_date) AS previous_sale
FROM sales;
```

#### 6. Calculate the rolling difference between sales for each product.
```sql
SELECT 
    product_name,
    sale_date,
    amount,
    LAG(amount, 1) OVER (PARTITION BY product_name ORDER BY sale_date) AS previous_sale,
    LEAD(amount, 1) OVER (PARTITION BY product_name ORDER BY sale_date) AS next_sale
FROM sales;
```

#### 7. Identify sales where the previous sale amount was higher than the current sale.
```sql
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
```

#### 8. Show total sales for each month, with the amount sold in the previous month.
```sql
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
```

#### 9. Determine the percentage increase or decrease in sales compared to the previous sale.
```sql
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
```

#### 10. List all sales where the amount is greater than the average sales amount for that product.
```sql
SELECT 
    sale_id,
    product_name,
    sale_date,
    amount,
    AVG(amount) OVER (PARTITION BY product_name) AS avg_product_sales
FROM sales
WHERE amount > AVG(amount) OVER (PARTITION BY product_name);
```

#### 3. Dataset 3: Student Scores
```sql
CREATE TABLE student_scores (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    exam_date DATE,
    score INT,
    class VARCHAR(50)
);

INSERT INTO student_scores (student_id, student_name, exam_date, score, class)
VALUES
(1, 'Alice', '2023-01-15', 85, 'A'),
(2, 'Bob', '2023-01-15', 90, 'A'),
(3, 'Charlie', '2023-01-15', 78, 'A'),
(4, 'Diana', '2023-02-01', 88, 'B'),
(5, 'Eve', '2023-02-01', 95, 'B'),
(6, 'Frank', '2023-02-01', 84, 'B'),
(7, 'Grace', '2023-03-10', 92, 'A'),
(8, 'Hank', '2023-03-10', 87, 'A'),
(9, 'Ivy', '2023-03-10', 82, 'A'),
(10, 'Jack', '2023-04-15', 76, 'B'),
(11, 'Kate', '2023-04-15', 89, 'B'),
(12, 'Leo', '2023-04-15', 91, 'B'),
(13, 'Mia', '2023-05-12', 80, 'A'),
(14, 'Nick', '2023-05-12', 93, 'A'),
(15, 'Olivia', '2023-05-12', 87, 'A'),
(16, 'Paul', '2023-06-05', 86, 'B'),
(17, 'Quincy', '2023-06-05', 88, 'B'),
(18, 'Rita', '2023-06-05', 90, 'B'),
(19, 'Steve', '2023-07-07', 95, 'A'),
(20, 'Tom', '2023-07-07', 89, 'A'),
(21, 'Uma', '2023-07-07', 84, 'A'),
(22, 'Victor', '2023-08-10', 78, 'B'),
(23, 'Wendy', '2023-08-10', 90, 'B'),
(24, 'Xander', '2023-08-10', 85, 'B'),
(25, 'Yara', '2023-09-12', 92, 'A');
```         

#### 1. Rank students based on their scores for each exam.
```sql
SELECT 
    student_id, 
    student_name, 
    score, 
    exam_date,
    RANK() OVER (PARTITION BY exam_date ORDER BY score DESC) AS score_rank
FROM student_scores;
```

#### 2. Determine the dense rank of students based on their scores (overall).
```sql
SELECT 
    student_name, 
    score,
    DENSE_RANK() OVER (ORDER BY score DESC) AS score_rank
FROM student_scores;
```

#### 3. Calculate the score difference between the current and previous exam for each student.
```sql
SELECT 
    student_name, 
    exam_date, 
    score,
    LAG(score) OVER (PARTITION BY student_name ORDER BY exam_date) AS previous_score,
    score - LAG(score) OVER (PARTITION BY student_name ORDER BY exam_date) AS score_diff
FROM student_scores;
```

#### 4. List students who improved their score compared to the previous exam.
```sql
SELECT 
    student_name, 
    exam_date, 
    score,
    LAG(score) OVER (PARTITION BY student_name ORDER BY exam_date) AS previous_score,
    score - LAG(score) OVER (PARTITION BY student_name ORDER BY exam_date) AS score_diff
FROM student_scores
WHERE score > LAG(score) OVER (PARTITION BY student_name ORDER BY exam_date);
```

#### 5. Determine the highest score for each class.
```sql
SELECT DISTINCT 
    class,
    MAX(score) OVER (PARTITION BY class) AS highest_score
FROM student_scores;
```

#### 6. Reset the rank for students after every 5 students based on their scores.
```sql
WITH ranked AS (
    SELECT 
        student_id, 
        student_name, 
        score,
        ROW_NUMBER() OVER (ORDER BY score DESC) AS row_num
    FROM student_scores
)
SELECT 
    student_id, 
    student_name, 
    score,
    ((row_num - 1) / 5) + 1 AS group_no,
    ROW_NUMBER() OVER (
        PARTITION BY ((row_num - 1) / 5) 
        ORDER BY score DESC
    ) AS group_rank
FROM ranked;
```

#### 7. Show the count of students who improved their score compared to the previous exam.
```sql
WITH cte AS (
    SELECT 
        student_id, 
        student_name, 
        exam_date, 
        score,
        LAG(score) OVER (PARTITION BY student_name ORDER BY exam_date) AS prev_score
    FROM student_scores
) 
SELECT 
    COUNT(*) AS improved_students
FROM cte
WHERE score > prev_score;
```

#### 8. Find the percentage increase in scores for each student compared to their previous exam.
```sql
SELECT 
    student_name, 
    exam_date, 
    score,
    LAG(score) OVER (PARTITION BY student_name ORDER BY exam_date) AS prev_score,
    ROUND(
        (
            (score - LAG(score) OVER (PARTITION BY student_name ORDER BY exam_date)) 
            / NULLIF(LAG(score) OVER (PARTITION BY student_name ORDER BY exam_date), 0)
        ) * 100, 2
    ) AS pct_increase
FROM student_scores;
```

#### 9. List all students with their scores and whether they improved from the last exam (Yes/No).
```sql
SELECT 
    student_name, 
    exam_date, 
    score,
    CASE 
        WHEN score > LAG(score) OVER (PARTITION BY student_name ORDER BY exam_date) THEN 'Yes'
        WHEN score < LAG(score) OVER (PARTITION BY student_name ORDER BY exam_date) THEN 'No'
        ELSE 'N/A'
    END AS improved
FROM student_scores;
```

#### 10. Rank students within their class, considering ties.
```sql
SELECT 
    student_id, 
    student_name, 
    class, 
    score,
    RANK() OVER (PARTITION BY class ORDER BY score DESC) AS class_rank
FROM student_scores;
```
