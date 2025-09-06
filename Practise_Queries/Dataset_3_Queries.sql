-- 1. Rank students based on their scores for each exam.
SELECT 
    student_id, 
    student_name, 
    score, 
    exam_date,
    RANK() OVER (PARTITION BY exam_date ORDER BY score DESC) AS score_rank
FROM student_scores;


-- 2. Determine the dense rank of students based on their scores (overall).
SELECT 
    student_name, 
    score,
    DENSE_RANK() OVER (ORDER BY score DESC) AS score_rank
FROM student_scores;


-- 3. Calculate the score difference between the current and previous exam for each student.
SELECT 
    student_name, 
    exam_date, 
    score,
    LAG(score) OVER (PARTITION BY student_name ORDER BY exam_date) AS previous_score,
    score - LAG(score) OVER (PARTITION BY student_name ORDER BY exam_date) AS score_diff
FROM student_scores;


-- 4. List students who improved their score compared to the previous exam.
SELECT 
    student_name, 
    exam_date, 
    score,
    LAG(score) OVER (PARTITION BY student_name ORDER BY exam_date) AS previous_score,
    score - LAG(score) OVER (PARTITION BY student_name ORDER BY exam_date) AS score_diff
FROM student_scores
WHERE score > LAG(score) OVER (PARTITION BY student_name ORDER BY exam_date);


-- 5. Determine the highest score for each class.
SELECT DISTINCT 
    class,
    MAX(score) OVER (PARTITION BY class) AS highest_score
FROM student_scores;


-- 6. Reset the rank for students after every 5 students based on their scores.
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


-- 7. Show the count of students who improved their score compared to the previous exam.
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


-- 8. Find the percentage increase in scores for each student compared to their previous exam.
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


-- 9. List all students with their scores and whether they improved from the last exam (Yes/No).
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


-- 10. Rank students within their class, considering ties.
SELECT 
    student_id, 
    student_name, 
    class, 
    score,
    RANK() OVER (PARTITION BY class ORDER BY score DESC) AS class_rank
FROM student_scores;
