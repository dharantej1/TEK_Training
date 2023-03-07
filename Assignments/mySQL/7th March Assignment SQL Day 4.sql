create database if not exists dharandb;
use dharandb;
-- 1. Employee table
drop table if exists employee;
create table if not exists employee(emp_id varchar(10),emp_name varchar(30),salary double,dept_id varchar(10),
    manager_id varchar(10));
insert into employee values("E1","Dharan",100000,"D1","M1");
insert into employee values("E2","PK",200000,"D1","M1");
insert into employee values("E3","Neel",300000,"D2","M2");
insert into employee values("E4","Madhab",400000,"D2","M2");
insert into employee values("E5","Puranjay",500000,"D3","M3");
insert into employee values("E6","Kwatra",200000,"D3","M1");
insert into employee values("E7","Tej",300000,"D1","M2");
insert into employee values("E8","Pusthakala",400000,"D1","M1");

-- 2. Department table
drop table if exists department;
create table if not exists department (dept_id varchar(20), dept_name varchar(20));
insert into department value('D1','it support');
insert into department value('D2','data insights');
insert into department value('D3','data analysis');
insert into department value('D4','salesforce');

-- 3. Manager table
drop table if exists manager;
create table if not exists manager (manager_id varchar(20), manager_name varchar(20), dept_id varchar(10));
insert into manager values('M1','sukesh','D1');
insert into manager values('M2','rahul','D2');
insert into manager values('M3','naveen','D3');
insert into manager values('M4','saurabh','D4');


-- 4. Project table
drop table if exists project;
create table if not exists project(project_id varchar(20), project_name varchar(20), team_id varchar(20));
insert into project values('P1','chatbot','T1');
insert into project values('P2','ai','T2');
insert into project values('P3','cloud','T3');
insert into project values('P4','blockchain','T4');

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
				left join project p on p.team_id=emp.emp_id;