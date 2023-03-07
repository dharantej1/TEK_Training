-- JOINS

-- Joins helps us to obtains data from two diff tables
-- This joins uses a common link in both he tables 
-- the resultant table has the properties of both the tables

-- This concept can be understood from the concept of VENN DIAGRAMS from SET THEORY!

-- i. INNER JOIN:
-- Intersection part of two circles in the venn diagrams A^B part, 
-- considering the two circles as the tables 
-- the required information will be present in both the tables

-- ii. LEFT OUTER JOIN:
-- You need the information from the complete first circle 
-- you are given two tables, products and orders
-- Example: find all the products which have been ordered as well as not ordered from past 15 days

-- iii. RIGHT OUTER JOIN:
-- You need the information from the complete second circle
-- Example: fetch all the records present in orders.transactions for products whether its present
-- in product details or not 

-- iv. FULL OUTER JOIN:
-- Its the union of both left and right outer joins, it returns all the records from all the tables 
-- union of all rows present in all tables 
-- Example: products and orders will be merged

create database if not exists accountsdb;
use accountsdb;
drop table if exists employee, expense;

create table if not exists employee(
	id int,
	name varchar(30),
	age double,
	address varchar(50),
	salary double
);

create table if not exists expense(
	orderid int,
    date datetime,
    id int,
    expense int
);

-- load data into stocks
-- set global local_file=true;
-- load data local infile "C:/Users/pdharantej/Desktop/Intern Training/data_sets/employee.txt"
-- into table stocks
-- fields terminated by ","
-- lines terminated by "\n"
-- ignore 1 lines;

select * from employee, expense;

-- i. inner join
-- fetch all the orders placed by employees having matching id present in 
-- emp table
-- on clause: to define relation between both the tables
select * from employee emp join expense exp
on (emp.id=exp.id);

select emp.id, emp.name, emp.salary, exp.orderid, exp.expense from employee emp join expense exp on (emp.id=exp.id);

-- ii. left outer join
select emp.id, emp.name, emp.salary, exp.orderid, exp.expense from employee emp left outer join expense exp on (emp.id=exp.id);

-- iii. right outer join
select emp.id, emp.name, emp.salary, exp.orderid, exp.expense from employee emp right outer join expense exp on (emp.id=exp.id);

-- iv. full outer join - we use union to get the result 
-- union of left join and right join
select * from employee emp left join expense exp 
on emp.id=exp.id
					union
select * from employee emp right join expense exp
on emp.id=exp.id;

