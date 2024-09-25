-- Total salary by year and gender
SELECT year, 
    gender, 
    SUM(salary) AS total_salary
FROM earnings
GROUP BY year, gender
ORDER BY year, gender;

-- Average salary by job and gender
SELECT job, gender, 
    AVG(salary) AS average_salary
FROM earnings
GROUP BY job, gender
ORDER BY job, gender;

-- Salary growth by year for each job
SELECT job, year, 
    AVG(salary) AS average_salary
FROM earnings
GROUP BY job, year
ORDER BY job, year;

-- Highest salary recorded in each year
SELECT year, 
    MAX(salary) AS highest_salary
FROM earnings
GROUP BY year
ORDER BY year;

-- Job with the highest average salary
SELECT job, 
    AVG(salary) AS average_salary
FROM earnings
GROUP BY job
ORDER BY average_salary DESC
LIMIT 1;

-- Salary distribution by gender
SELECT gender, 
    MIN(salary) AS minimum_salary, 
    MAX(salary) AS maximum_salary, 
    AVG(salary) AS average_salary
FROM earnings
GROUP BY gender;

-- Checking the gender pay gap (the difference in average salary between genders for each job).
SELECT job, 
    MAX(male_avg_salary) - MAX(female_avg_salary) AS gender_pay_gap
FROM (SELECT job, gender, 
         AVG(salary) AS avg_salary,
         CASE 
             WHEN gender = 'Males' THEN AVG(salary)
             ELSE NULL 
         END AS male_avg_salary,
         CASE 
             WHEN gender = 'Females' THEN AVG(salary)
             ELSE NULL 
         END AS female_avg_salary
     FROM earnings
     GROUP BY job, gender) AS gender_avg_salaries
GROUP BY job;

-- Year-over-year salary growth
SELECT year, 
    AVG(salary) AS average_salary, 
    (AVG(salary) - LAG(AVG(salary)) OVER (ORDER BY year)) / LAG(AVG(salary)) OVER (ORDER BY year) * 100 AS yoy_growth
FROM earnings
GROUP BY year
ORDER BY year;

-- Highest paying jobs each year
SELECT year, job, 
    AVG(salary) AS average_salary
FROM earnings
GROUP BY year, job
ORDER BY year, average_salary DESC;

-- Median salary by job
SELECT job, salary
FROM earnings e1
WHERE 
    (SELECT COUNT(*) FROM earnings e2 
     WHERE e2.salary <= e1.salary AND e2.job = e1.job) 
    = (SELECT COUNT(*) FROM earnings e3 
       WHERE e3.job = e1.job) / 2;

-- Percentage of total salary by gender
SELECT gender, 
    SUM(salary) AS total_salary, 
    (SUM(salary) / (SELECT SUM(salary) FROM earnings) * 100) AS percentage_of_total
FROM earnings
GROUP BY gender;

-- Distribution of salary ranges by job
SELECT job, 
    CASE 
        WHEN salary < 20000 THEN 'Below 20k'
        WHEN salary BETWEEN 20000 AND 30000 THEN '20k-30k'
        WHEN salary BETWEEN 30001 AND 40000 THEN '30k-40k'
        ELSE 'Above 40k'
    END AS salary_range, 
    COUNT(*) AS count_in_range
FROM earnings
GROUP BY job, salary_range
ORDER BY job, salary_range;

-- Jobs with the most fluctuating salaries
SELECT job, 
    STDDEV(salary) AS salary_stddev
FROM earnings
GROUP BY job
ORDER BY salary_stddev DESC;

-- Gender representation in each job
SELECT job, gender, 
    COUNT(*) AS gender_count, 
    (COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY job) * 100) AS percentage
FROM earnings
GROUP BY job, gender
ORDER BY job, gender;

-- Comparing Salary Growth of Males vs Females Over Time
SELECT year, gender, 
    AVG(salary) AS average_salary, 
    (AVG(salary) - LAG(AVG(salary)) OVER (PARTITION BY gender ORDER BY year)) / LAG(AVG(salary)) OVER (PARTITION BY gender ORDER BY year) * 100 AS yoy_growth
FROM earnings
GROUP BY year, gender
ORDER BY year, gender;

-- Most common job by gender
SELECT gender, job, 
    COUNT(*) AS job_count
FROM earnings
GROUP BY gender, job
ORDER BY gender, job_count DESC;

-- Years with the most significant salary increase
SELECT year, 
    AVG(salary) - LAG(AVG(salary)) OVER (ORDER BY year) AS salary_increase
FROM earnings
GROUP BY year
ORDER BY salary_increase DESC
LIMIT 1;

-- Salary trend analysis by gender over time
SELECT year, gender, 
    AVG(salary) AS average_salary,
    SUM(salary) AS total_salary,
    COUNT(*) AS number_of_employees
FROM earnings
GROUP BY year, gender
ORDER BY year, gender;

