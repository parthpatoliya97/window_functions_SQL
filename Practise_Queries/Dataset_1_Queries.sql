-- 1. Find the row number of each employee ordered by salary.
SELECT 
    emp_id,
    emp_name,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS salary_rnk
FROM employees;


-- 2. Rank employees based on salaries.
SELECT 
    emp_id, 
    emp_name, 
    salary,
    RANK() OVER (ORDER BY salary DESC) AS salary_rnk
FROM employees;


-- 3. Dense rank employees within each department by salary.
SELECT 
    emp_id, 
    emp_name, 
    salary, 
    department,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rnk
FROM employees;


-- 4. Rank employees by hire date.
SELECT 
    emp_id, 
    emp_name, 
    hire_date, 
    salary,
    RANK() OVER (ORDER BY hire_date ASC) AS hire_rnk
FROM employees;


-- 5. Row number by department based on hire date.
SELECT 
    emp_id, 
    emp_name, 
    salary, 
    department, 
    hire_date,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY hire_date) AS rnk
FROM employees;


-- 6. Highest-paid employee in each department.
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


-- 7. Rank difference between global vs. department ranks.
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


-- 8. 2nd highest salary in each department.
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


-- 9. Find the average salary of the top 3 highest-paid employees in each department.
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


-- 10. Assign a dense rank to employees based on their hire date, resetting at each department change.
SELECT 
    emp_id,
    emp_name,
    salary,
    department,
    hire_date,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY hire_date) AS ranking
FROM employees;



