-- create database
create database if not exists employeeDB ;

-- database changed
use employeedb;

show databases; -- to show the list of databases
show tables; -- to show list of tables present in the database

show tables in sys; -- to show all the tables present in a database without using "use"

create table if not exists Employee(empid varchar(20) not null,empname varchar(50),age int,gender varchar(10),department varchar(40),salary int,primary key(empid));
show tables;

-- syntax for inserting of values into the table
-- insert into [table name] values(); 

insert into employee values("TEK1001","Dharan",21,"Male","Data Insights",100000);
select * from employee;