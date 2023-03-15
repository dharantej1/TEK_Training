create database if not exists salesdb;
use salesdb;
show tables;
create table if not exists employee(
	emp_id varchar(20),
    first_name varchar(50),
    last_name varchar(50),
    gernder varchar(10),
    salary int,
    primary key(emp_id)
);

create table if not exists hrtable(
	emp_id varchar(20),
    department_id varchar(10),
    department_name varchar(50),
    DOJ text,
    constraint foreign key(emp_id) references employee(emp_id) 
);