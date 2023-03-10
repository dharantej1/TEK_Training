-- SQL stored procedures
-- 1. stored procedure is a database object
-- 2. stored procudure is a series of declarative SQL statement
-- 3. these can be stored in a database and can be reused over and over again
-- 4. parameters can be passed to stored procedure, so that stored procedure can act based on
-- -- parameter value
-- 5. SQL creates an execution plan and stores it in the cache 
-- -- -- Types: 
-- Stored Procedures 1) User defined stored procedures: it is created by database developers,
-- 														admins, these stored procedures contain
-- 														one or more SQL statements to select,
-- 														delete, update from database tables
-- 					 2) System stored procedures: these are cerated and executed by SQL server
-- 												  for server admin activities
-- Syntax:
-- create procedure procedure_name()
-- begin
-- 	declare var varchar(20);
--     declare var1 float;

-- end;

-- create, alter, parameters, encrypt procedure 
-- these can be done with the procedure

use hremployeedb;
select * from hr_employee where Department="sales";



delimiter ##
drop procedure if exists sales_dept;
create procedure sales_dept(dept_id varchar(50), emp_age int)
begin 
select * from hr_employee where Department=dept_id and age>emp_age;
end ##
delimiter ;

call sales_dept("Sales",30);

-- -- -- -- -- -- -- -- -- -- -- 

delimiter ##
drop procedure if exists sales_dept_new;
create procedure sales_dept_new(dept_id varchar(50), emp_age int)
begin
select * from hr_employee where Department=dept_id and age>emp_age;
end ##
delimiter ;

call sales_dept_new("Human Resources",50);

-- delimiter ##
-- create procedure delete_procedure(proc_name varchar(20))
-- begin
-- drop procedure if exists proc_name;
-- end ##
-- delimiter ;

-- call delete_procedure(delete_procedure);