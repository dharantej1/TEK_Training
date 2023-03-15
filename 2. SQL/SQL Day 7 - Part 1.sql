-- Window functions
use hremployeedb;

select * from hr_employee;

-- write a sql query to display maximum income from hr table from each department
select department, max(income) from hr_employee group by department order by income;

-- 1. window function - over()
-- write a query to show employee id, age, job role, gender, of employee with department 
-- having the highest salary
select employeeid, age, department, jobrole, max(income) as max_income
from hr_employee 
group by department 
order by income; -- this would be normal implementation

-- using over()
-- adding over() after aggregate function it will work as analytical fucntion
-- over(): used to specify query to create window of records
select hremp.employeeid, hremp.age, hremp.department, hremp.jobrole, max(income)
over() from hr_employee as hremp; 

select *, max(income) over() from hr_employee;

-- show maximum salary from each job role
select hremp.employeeid, hremp.age, hremp.department, hremp.jobrole, max(income)
over(partition by jobrole order by employeeid desc) as max_job_role
from hr_employee hremp;

-- 2. row_number()
-- row_number() works only with aggregate functions
-- write a query which will show first 3 employee from each job role to join the company
select * from 
(select hremp.employeeid, hremp.age, hremp.department, hremp.jobrole,
row_number() over(partition by jobrole order by employeeid) as row_num
from hr_employee hremp) as sub_query
where sub_query.row_num<4;

-- 3. rank()
-- write a query to show top 3 employees from each job role
-- earning highest salary
select * from
(select hremp.employeeid, hremp.department, hremp.jobrole, hremp.gender, hremp.income,
rank() over(partition by jobrole order by income desc) as rank_val
from hr_employee hremp) as sub_query
where sub_query.rank_val<4;
-- rank() gives the ranking as 1,2,3,4,4,6,7,8,9
-- if two people have the same rank the missed rank is taken by the next number
-- to solve this we need dense_rank()

-- apply rank() on employee age
select hremp.employeeid, hremp.department, hremp.jobrole, hremp.gender, hremp.income, hremp.age,
rank() over(partition by jobrole order by age desc) as rank_val
from hr_employee hremp;

-- 4. dense_rank()
select hremp.employeeid, hremp.department, hremp.jobrole, hremp.gender, hremp.income, hremp.age,
dense_rank() over(partition by jobrole order by age desc) as rank_val
from hr_employee hremp;


select hremp.employeeid, hremp.department, hremp.jobrole, hremp.gender, 
	   hremp.income, hremp.age, hremp.workex,
dense_rank() over(partition by jobrole order by age desc, workex desc) as rank_val
from hr_employee hremp;

-- 5. lag()
-- shows the previous values of the particular columns
select hremp.employeeid, hremp.department, hremp.jobrole, hremp.gender, hremp.income,
	   hremp.workex,
	   lag(income,2,"NO DATA") over(partition by jobrole order by employeeid) as previous_income
from hr_employee as hremp;

-- 6. lead()
-- shows the next values of the particular columns
select hremp.employeeid, hremp.department, hremp.jobrole, hremp.gender, hremp.income,
	   hremp.workex,
	   lead(income,1,"NO DATA") over(partition by jobrole order by employeeid) as next_income
from hr_employee as hremp;

-- 7. combining the window functions with the over() function
select hremp.employeeid, hremp.department, hremp.jobrole, hremp.gender, hremp.income,
	   hremp.workex,
	   lag(income,2,"NO DATA") over(partition by jobrole order by employeeid) as previous_income,
	   lead(income,1,"NO DATA") over(partition by jobrole order by employeeid) as next_income
from hr_employee as hremp;

-- write a query to show if income of an employee is higher, lower or equal
-- to the previous value
select *, 
       case
       when income>previous_income then "Greater"
       when income<previous_income then "Lesser"
       when income=previous_income then "Equal"
       end as income_group from 
(select employeeid, department, jobrole, gender, income, workex,
		lag(income) over(partition by jobrole order by employeeid) as previous_income
 from hr_employee as hremp
) as sub;

-- or / alternative method

select employeeid, department, jobrole, gender, income, workex,
		lag(income) over(partition by jobrole order by employeeid) as previous_income,
        case
		when income>lag(income) over(partition by jobrole order by employeeid) then "Greater"
		when income<lag(income) over(partition by jobrole order by employeeid) then "Lesser"
		when income=lag(income) over(partition by jobrole order by employeeid) then "Equal"
		when lag(income) over(partition by jobrole order by employeeid) is null then "Equal"
        end as income_group
 from hr_employee
 order by income_group;
 
 
 alter table hr_employee add column Income_comparision varchar(20);
 set sql_safe_updates=0;
 select * from hr_employee limit 10;
with temp as  (
select employeeid,
lag(Income) over(partition by jobrole order by employeeid)  
as prevous_Income from hr_employee) 
update hr_employee , temp
set hr_employee.category = temp.prevous_income
where hr_employee.employeeid = temp.employeeid;

select * from hr_employee;