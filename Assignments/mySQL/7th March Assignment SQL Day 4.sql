create database if not exists dharandb;
use dharandb;
-- 1. Employee table
drop table if exists employee;
create table if not exists employee(emp_id varchar(10),emp_name varchar(30),salary double,dept_id varchar(10),
    manager_id varchar(10));
INSERT INTO employee VALUES
('E1','Divya Parasher',15000,'D1','M1'),
('E2','Mukund',15000,'D1','M1'),
('E3','Tiyanshi',55000,'D2','M2'),
('E4','Pranshu',25000,'D2','M2'),
('E5','Bhavi',20000,'D10','M3'),
('E5','Tarandeep',35000,'D10','M3');

-- 2. Department table
drop table if exists department;
create table if not exists department (dept_id varchar(20), dept_name varchar(20));
INSERT INTO department VALUES
('D1','IT'),
('D2','HR'),
('D3','Finance'),
('D4','Admin');

-- 3. Manager table
drop table if exists manager;
create table if not exists manager (manager_id varchar(20), manager_name varchar(20), dept_id varchar(10));
INSERT INTO manager VALUES
('M1','Iron Man','D3'),
('M2','Captain America','D4'),
('M3','Thor','D1'),
('M4','Natasha','D1');

-- 4. Project table
drop table if exists project;
create table if not exists project(project_id varchar(20), project_name varchar(20), team_id varchar(20));
INSERT INTO project VALUES 
('P1','Data Migration','E1'),
('P1','Data Migration','E2'), 
('P1','Data Migration','M3'),
('P2','ETL Tool ','E1'), 
('P2','ETL Tool','M4');

-- 1. display all records from tables
select * from department;
select * from employee;
select * from manager;
select * from project;

-- 2. fetch the employee name and department name they belong to
-- inner join
select emp.emp_name, dept.dept_name from employee emp join department dept on (emp.dept_id=dept.dept_id);

-- 3. fetch all emp name and their dept name they are working
-- left outer join
select emp.emp_name, dept.dept_name from employee emp left outer join department dept on emp.dept_id=dept.dept_id;

-- 4. fetch all department name and employee name working in it
-- right outer join
select emp.emp_name, dept.dept_name from employee emp right outer join department dept on emp.dept_id=dept.dept_id;

-- 5. fetch all department name and all employee name working in it
-- full outer join / union
select emp.emp_name, dept.dept_name from employee emp left outer join department dept on emp.dept_id=dept.dept_id
union
select emp.emp_name, dept.dept_name from employee emp right outer join department dept on emp.dept_id=dept.dept_id;

-- 6. fetch details of all emp name, their manager, their department and projects they work on
select emp.emp_name, dept.dept_name, m.manager_name, p.project_name
from employee emp
left outer join department dept on emp.dept_id=dept.dept_id 
		inner join manager m on emp.manager_id=m.manager_id
			   inner join project p on p.team_id=emp.emp_id;
               
-- 7. display all employees who have been assigned with projects having manager and department
select emp.emp_name, dept.dept_name, m.manager_name, p.project_name
from employee emp inner join department dept on emp.dept_id=dept.dept_id
				  inner join manager m on emp.manager_id=m.manager_id
				  inner join project p on p.team_id=emp.emp_id;
                  
-- 8. display all employees who have been assigned with projects and also 
-- show all managers and all department.

select emp.emp_name, dept.dept_name, m.manager_name, p.project_name
from employee emp 
inner join project p on p.team_id=emp.emp_id
right join department dept on dept.dept_id=emp.dept_id
right join manager m on emp.manager_id=m.manager_id
union
select emp.emp_name, dept.dept_name, m.manager_name, p.project_name
from employee emp
inner join project p on p.team_id=emp.emp_id
right join department dept on dept.dept_id=emp.dept_id
left join manager m on emp.manager_id=m.manager_id; 


-- 9. SQL CROSS JOIN
-- result set will include all rows from both tables, where each rows is the combination of the row in the first table
-- with the row in the second table
-- returns the cartesian product
select * from employee;
select * from department;

select * -- emp.emp_name, dept.dept_name
from employee emp cross join department dept;
-- employee has 6 rows and 
-- department has 4 rows 
-- so cross join has 6*4=24 rows 

-- Exercise: write a query to fetch all employee name and their corresponding dept_name
-- also make sure to display the company name and company location corresponding to each employee. 

drop table if exists company;
create table if not exists company(	company_id varchar(20),    company_name varchar(50),    location varchar(50));
insert into company values ("C0001","TEK Systems","Hyderabad");

select * from company;
select emp.emp_name, dept.dept_name, comp.company_name,comp.location from employee emp join department dept on emp.dept_id=dept.dept_id
																					   cross join company comp;
-- 10. NATURAL JOIN
-- similar to inner join without condition (problem! - condition basis is unknown.)
select * -- emp.emp_name, dept.dept_name 
from employee emp natural join department dept;