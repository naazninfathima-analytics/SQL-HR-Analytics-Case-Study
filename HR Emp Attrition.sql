CREATE DATABASE EMP;
USE EMP;

SELECT * FROM hr_attrition LIMIT 10;
DESCRIBE hr_attrition;

-- Business Problem: HR needs to know the total 
-- headcount for workforce planning.

SELECT COUNT(*) AS Total_Employees 
FROM hr_attrition;

-- Insight: "The company has 1,470 total employees."

-- Business Problem: HR wants to measure how many 
-- employees have left the company.

SELECT Attrition, COUNT(*) AS Count,
ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM hr_attrition), 2) AS Percentage
FROM hr_attrition
GROUP BY Attrition;

-- Insight: "16% of employees have left, indicating 
-- a moderate attrition rate."

-- Business Problem: Management wants to know 
-- headcount distribution across departments.

SELECT Department, COUNT(*) AS Employee_Count
FROM hr_attrition
GROUP BY Department
ORDER BY Employee_Count DESC;

-- Insight: "Research & Development has the highest 
-- headcount with 961 employees."

-- Business Problem: Finance team wants to compare 
-- salary levels across departments.

SELECT Department, 
ROUND(AVG(MonthlyIncome), 2) AS Avg_Income
FROM hr_attrition
GROUP BY Department
ORDER BY Avg_Income DESC;

-- Insight: "Manager-level roles in R&D earn the 
-- highest average monthly income."

-- Business Problem: HR wants to assess gender 
-- diversity across the organization.

SELECT Gender, COUNT(*) AS Count,
ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM hr_attrition), 2) AS Percentage
FROM hr_attrition
GROUP BY Gender;

-- Insight: "60% of employees are male, highlighting 
-- a gender imbalance worth addressing."

-- Business Problem: HR wants to identify which 
-- department loses the most employees.

SELECT Department,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS Attrition_Rate
FROM hr_attrition
GROUP BY Department
ORDER BY Attrition_Rate DESC;

-- Insight: "Sales has the highest attrition rate 
-- at 20%, requiring urgent retention strategies."

-- Business Problem: Workforce planning team wants 
-- to understand age profile across roles.

SELECT JobRole, ROUND(AVG(Age), 1) AS Avg_Age
FROM hr_attrition
GROUP BY JobRole
ORDER BY Avg_Age DESC;

-- Insight: "Managers have the highest average age 
-- of 45, indicating senior experienced profiles."

-- Business Problem: HR wants to identify employees 
-- at risk due to low satisfaction scores.

SELECT JobRole, COUNT(*) AS Low_Satisfaction_Count
FROM hr_attrition
WHERE JobSatisfaction = 1
GROUP BY JobRole
ORDER BY Low_Satisfaction_Count DESC;

-- Insight: "Sales Executives have the highest count 
-- of dissatisfied employees — a retention risk."

-- Business Problem: HR wants to measure employee 
-- loyalty and tenure across departments.

SELECT Department, 
ROUND(AVG(YearsAtCompany), 1) AS Avg_Tenure
FROM hr_attrition
GROUP BY Department
ORDER BY Avg_Tenure DESC;

-- Insight: "R&D employees stay the longest with 
-- an average tenure of 7.4 years."

-- Business Problem: HR wants to check if overtime 
-- is a major driver of employee attrition.

SELECT OverTime, Attrition, COUNT(*) AS Count
FROM hr_attrition
GROUP BY OverTime, Attrition
ORDER BY OverTime;

-- Insight: "Employees doing overtime are 3x more 
-- likely to leave than those who don't."

-- Business Problem: Compensation team wants a 
-- ranked view of salaries across all job roles.

SELECT JobRole,
ROUND(AVG(MonthlyIncome), 2) AS Avg_Income,
RANK() OVER (ORDER BY AVG(MonthlyIncome) DESC) AS Income_Rank
FROM hr_attrition
GROUP BY JobRole;

-- Insight: "Managers rank 1st in income while 
-- Sales Representatives rank last."

-- Business Problem: HR wants to know which age 
-- group has the highest attrition risk.

SELECT 
CASE 
  WHEN Age < 25 THEN 'Under 25'
  WHEN Age BETWEEN 25 AND 35 THEN '25-35'
  WHEN Age BETWEEN 36 AND 45 THEN '36-45'
  ELSE 'Above 45'
END AS Age_Group,
COUNT(*) AS Total,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrited,
ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS Attrition_Rate
FROM hr_attrition
GROUP BY Age_Group
ORDER BY Attrition_Rate DESC;

-- Insight: "Employees under 25 have the highest 
-- attrition rate at 38%, likely due to career exploration."

-- Business Problem: HR wants to check if lower 
-- income directly leads to higher attrition.

SELECT Attrition,
ROUND(AVG(MonthlyIncome), 2) AS Avg_Income,
ROUND(AVG(YearsAtCompany), 1) AS Avg_Tenure
FROM hr_attrition
GROUP BY Attrition;

-- Insight: "Employees who left earned on average 
-- 20% less than those who stayed."

-- Business Problem: HR wants to understand the 
-- educational background of the workforce.

SELECT EducationField,
COUNT(*) AS Count,
ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER (), 2) AS Percentage
FROM hr_attrition
GROUP BY EducationField
ORDER BY Percentage DESC;

-- Insight: "Life Sciences graduates make up 41% 
-- of the workforce, the largest education group."

-- Business Problem: HR wants to identify the 
-- exact profile most likely to leave the company.

SELECT JobRole, Department, OverTime, 
ROUND(AVG(MonthlyIncome), 2) AS Avg_Income,
COUNT(*) AS Total,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrited,
ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS Attrition_Rate
FROM hr_attrition
WHERE OverTime = 'Yes'
GROUP BY JobRole, Department, OverTime
HAVING Attrition_Rate > 20
ORDER BY Attrition_Rate DESC;

-- Insight: "Sales Reps doing overtime with low income 
-- are the highest attrition risk group in the company."