-- This is comment in mysql
-- command to login into mysql shell
-- -- mysql -u root -p <Enter>

-- 1. SHOW
show databases; -- crrl+enter to execute the command

-- 2. CREATE database
create database if not exists emptempDB;

-- 3. DROP database
drop database if exists emptempDB;

-- 4. USE command
create database amitDB;
use amitDB;
show tables;

-- 5. CREATE TABLE
drop table if exists emp;
create table if not exists emp(
	empid varchar(12) not null,
    empname varchar(30) not null,
    designation varchar(40) not null,
    department varchar(50) not null,
    salary decimal(8,2),
    city varchar(80),
    primary key(empid)    
);

-- 6. DESCRIBE - displays the schema of the table
describe amitdb.emp;
-- another way for describing
desc amitdb.emp;

-- 7. INSERT - insert new values into existing tables
insert into emp values("TEK1001","ABC","Associate Developer","IT","200000","Hyderabad");
insert into emp values("TEK1002","DEF","Sr. Developer","IT","200000","Hyderabad");
insert into emp values("TEK1003","GHI","Manager","IT","200000","Hyderabad");
insert into emp values("TEK1004","JKL","Director","IT","200000","Hyderabad");
insert into emp values("TEK1005","ABC","Associate Developer","IT",NULL,"Hyderabad");
insert into emp values("TEK1006","ABC","Associate Developer","IT","200000",NULL);

-- -- another method: insert into emp(column names) values();

-- Query to show all rows and cols
select * from emp;

-- Replace null values by Central Tendency
-- -- Replace the null values by three means of central tendency
-- Data is of two types:
-- -- Categorical (Qualitative)
-- -- -- Nominal 
-- -- -- Ordinal
-- -- -- Dichotomous
-- -- Numerical (Quantitative)
-- -- -- Continuous
-- -- -- Discrete


-- -- If the data is:
-- -- -- Continuous: replace with mean()
-- -- -- Discrete: replace with mean() or median()
-- -- -- Categorical: replace with mode()
-- -- -- -- Nominal: Names only
-- -- -- -- Ordinal: Rank, Grades, Position, Economic Status
-- -- -- -- Dichotomous: Male/Female, Yes/No, True/False

-- 8. CHECK constraint
create table if not exists employee(
	empid varchar(12) not null,
    empname varchar(30) not null,
    age int,
    designation varchar(40) not null,
    department varchar(50) not null,
    salary decimal(8,2),
    city varchar(80),
    primary key(empid),
    check  (age>20)
);
insert into employee values("TEK1001","ABC",19,"Associate Developer","IT","200000","Hyderabad");
insert into employee values("TEK1002","DEF",21,"Sr. Developer","IT","200000","Hyderabad");
insert into employee values("TEK1003","GHI",22,"Manager","IT","200000","Hyderabad");
select * from employee;

-- 9. DEFAULT constraint
drop table if exists emp_trainee;
create table if not exists emp_trainee(
	empid varchar(12) not null,
    empname varchar(30) not null,
    age int,
    designation varchar(40) not null default "Trainee",
    department varchar(50) not null,
    salary decimal(8,2),
    city varchar(80),
    primary key(empid),
    check  (age>20)
);
describe emp_trainee;
insert into emp_trainee values("TEK1001","ABC",25,default,"IT","200000","Hyderabad");
insert into emp_trainee values("TEK1002","DEF",21,default,"IT","200000","Hyderabad");
insert into emp_trainee values("TEK1003","GHI",22,default,"IT","200000","Hyderabad");
insert into emp_trainee(empid,empname,age,designation,department,salary,city) values("TEK1004","GHI",22,"Operation","IT","200000","Hyderabad");
select * from emp_trainee;

-- 10. INDEX constraint: Used to retrieve records quickly from database
create index personaldetails on emp_trainee(empname, age, salary, city);
create index hrdetails on emp_trainee(empid, designation,department, salary, city);
-- display only the required fields using  indexes
show indexes from emp_trainee;
show indexes from emp_trainee where Key_name="personaldetails";
show indexes from emp_trainee where Key_name="hrdetails";

-- 11. DROP
-- drop table from current working database
drop table if exists emp;
-- drop table from another database
drop table if exists employee.emptable;
-- drop an index from the table 
-- -- syntax: drop index [index_name] on [table_name]
drop index hrdetails on emp_trainee;

-- 12. ALTER - used to update the existing table
-- adding new cols in existing table
alter table emp_trainee 
add column gender varchar(10),
add column DOJ varchar(60) not null;
alter table emp_trainee modify columN DOJ varchar(30);
describe amitdb.emp_trainee;

-- drop database if exists amitdb;
-- rename a column using alter(rename column)

alter table emp_trainee rename column DOJ to DateOfJoining;
describe emp_trainee;

select * from emp_trainee;

-- 13. UPDATE - Modify existing value with new value
update emp_trainee set
empname="",gender="",DateOfJoining=""
where empid="TEK1001";

update emp_trainee set
empname="Enid",Gender="Female",DateOfJoining="2023-01-01"
where empid="TEK1001";

select empname, gender, DateOfJoining from emp_trainee;