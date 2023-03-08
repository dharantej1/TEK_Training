-- 1.	Write SQL command to create a database named hremployeeDB and a table named HR_Employee with columns for 
-- EmployeeID, Department, JobRole, Attrition, Gender, Age, MaritalStatus, Education, EducationField, BusinessTravel,
-- JobInvolvement, JobLevel, JobSatisfaction, Hourlyrate, Income, Salaryhike, OverTime, Workex, YearsSinceLastPromotion,
-- EmpSatisfaction, TrainingTimesLastYear, WorkLifeBalance, Performance_Rating, and set EmployeeID as the primary key.
create database if not exists hremployeeDB;
use hremployeeDB;
-- table imported from import table wizard

-- 2.	Return the shape of the table
select count(*) as size_of_table from hr_employee;

-- 3.	Show the count of Employee & percentage Workforce in each Department.
select department,count(*) as dept_count from hr_employee group by department order by department;

-- 4.	Which gender have higher strength as workforce in each department?
select gender,department,count(*) as gender_count from hr_employee group by gender,department order by gender;

-- 5.	Show the workforce in each Job Role
select jobrole,count(*) as workforce from hr_employee group by jobrole order by jobrole;

-- 6. Show Distribution of Employee's Age Group.
select age,count(*) as age_group from hr_employee group by age order by age;

-- 7.	Compare all marital status of employee and find the most frequent marital status.
select maritalstatus,count(*) as most_fregquent  from hr_employee group by maritalstatus;

-- 8. What is Job satisfaction level of employee?
select jobsatisfaction,count(*) as job_satisfaction_rate from hr_employee group by jobsatisfaction;

-- 9.How frequently employee is going on Business Trip.
select businesstravel,count(*) as business_travel_rate from hr_employee group by businesstravel;

-- 10.	Show the Department with Highest Attrition Rate (Percentage)
select department, COUNT(*) AS total_count, SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS attrition_rate from hr_employee group by department order by attrition_rate DESC LIMIT 5;

-- 11 .Show the Job Role with Highest Attrition Rate (Percentage)
select jobrole, COUNT(*) AS total_count, SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS attrition_rate
from hr_employee
group by jobrole
order by attrition_rate DESC
LIMIT 5;

-- 12.Show Distribution of Employee's Promotion, Find the maximum chances of employee getting promoted
select yearssincelastpromotion,count(*) as promotion_distribution 
from hr_employee 
group by yearssincelastpromotion order by yearssincelastpromotion asc;

-- 13 Find the Attrition Rate for Marital Status.
select maritalstatus, COUNT(*) AS total_count, SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count, (SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS attrition_rate
from hr_employee
group by maritalstatus;

-- 14.	Find the Attrition Count & Percentage for Different Education Levels
select education, COUNT(*) AS total_count, SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count, (SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS attrition_rate
from hr_employee
group by education;

-- 15 Find the Attrition & Percentage Attrition for Business Travel.
select businesstravel, COUNT(*) AS total_count, SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count, (SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS attrition_rate
from hr_employee
group by businesstravel;

-- 16 Find the Attrition & Percentage Attrition for Various JobInvolvement
select jobinvolvement, COUNT(*) AS total_count, SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count, (SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS attrition_rate
from hr_employee
group by  jobinvolvement;

-- 17 Show Attrition Rate for Different JobSatisfaction
select jobsatisfaction, COUNT(*) AS total_count, SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count
from hr_employee
group by  jobsatisfaction;
-- 18 Find key reasons for attrititon in a company
-- As income can be a reason for attrition lets make a column for income-group
alter table hr_employee add column SPYTRENDS varchar(20);

select jobinvolvement,jobsatisfaction, COUNT(*) AS total_count, (SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS attrition_rate
from hr_employee
group by jobinvolvement,jobsatisfaction
order by attrition_rate;

-- 19 Return all employee where WorkEx greater than 10, provided that they travel frequently, 
-- WorkLifeBalance as Good and JobSatisfaction is Very High.
select * from hr_employee 
where workex>10 and businesstravel="Travel_Frequently" and worklifebalance="Good" and jobsatisfaction="Very High";

-- 20 Write query to display who has better WorkLifeBalance , Married, Single or Divorced 
-- provided that Performace_Rating is Outstanding. 
select worklifebalance,maritalstatus,performance_rating,count(*) as res_dis
from hr_employee 
where performance_rating="Outstanding"
group by worklifebalance, maritalstatus, performance_rating;
