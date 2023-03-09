-- CTE
-- CTE or Common Table Expression which is used to construct complex queries into a more readable format
-- Condition: MySQL version > 8.0
-- CTE is just like derived table. CTE is not stored as object amd last only during execution of the query statement
-- Syntax: 
-- -- with CTE_NAME (columns list) as (mention your query) select * from CTE_NAME;
use dharandb;
select * from employee;

-- fetch employee who earn more than average salary of all employee
with average_salary(avg_sal) as (select avg(salary) from employee) select * from employee emp, average_salary av
where emp.salary>av.avg_sal;

-- department id 
with salesdept as (
select emp_id, emp_name, manager_id
from employee
where dept_id="D1")
select emp_name, manager_id from salesdept
where manager_id="M1";


-- options with "WITH"
-- with ... select
-- with ... update
-- with ... delete

-- DERIVED TABLES
-- derived table is a virtual table returned from select statement
-- a derived table is similar to temporary table, but this is much simpler
-- Syntax: 
-- -- select column_list from (select column_list from table1) derived_table_name 
-- -- where derived_table_name.column > value;

-- Exercise: 
select emp_name, salary
from (select avg(salary) as avg_sal from employee) avg_derived_table
inner join employee 
where salary > avg_derived_table.avg_sal;

-- alternative option is: we can take multiple tables without using joins
select emp_name, salary
from (select avg(salary) as avg_sal from employee) avg_derived_table,employee -- from multiple tables 
where salary > avg_derived_table.avg_sal;

-- PARTITIONING and UNION
use accountsdb;
select * from employee;
select * from expense;

-- the union clause is used to combine two separate tables with your select statement an produce the result set as 
-- union of both select statements 
-- Note: the schema fields to be used in both select statements must be in same order, same number and data type

select id from employee union select id from expense;


-- select multiple fields from both the tables
select id, name from employee union all
select id, expense from expense;

-- PARTITION in MySQL
-- Syntax: 
-- create table table_name partition by range columns (columns_list)
-- partition part1_name values less than (val_list),
-- partition part2_name values less than (val_list));

drop table if exists part_employee;
create table if not exists part_employee(empid int, ename varchar(60), age int, address text, salary int)
-- partitioning mySQL table by range()
partition by range columns (salary)
(partition P0 values less than (30000),
partition P1 values less than (50000),
partition P2 values less than (70000),
partition P3 values less than (maxvalue)
);
describe part_employee;
INSERT INTO part_employee VALUES
(1,"Ramesh",32,"Delhi",80000.00),
(2,"Kiran",23,"Patna",60000.00),
(3,"Shilpa",21,"Ranchi",20000.00),
(4,"Chandan",23,"Patliputra",26000.00),
(5,"Harsha",24,"Chandighar",34000.00),
(6,"Manohar",20,"UP",180000.00),
(7,"Mufty",22,"Lucknow",40000.00);

-- show number of partitions and data rows in each partition
select partition_name, table_rows 
from information_schema.partitions
where table_schema="accountsdb" and table_name="part_employee";

-- Drop a specific partition from table
alter table part_employee truncate partition p2;

-- checking after the truncate statement implementation
select partition_name, table_rows 
from information_schema.partitions
where table_schema="accountsdb" and table_name="part_employee";

-- partition by LIST
-- product id (101,102,106)
-- product id (103,105,108)
-- product id (104,107,109)

drop table if exists part_products;
create table part_products (product_id int, product_name varchar(60), store_name varchar(50), price int)
partition by list(product_id)
(partition p0 values in (101,102,106),
partition p1 values in (103, 105, 108),
partition p2 values in (104, 107, 109)
);

select * from part_products partition(p0);

-- Partition by HASH value
-- partitioning table is used to distribute according to some predefined number of partitions
-- Distribute data into table evenly
-- hash(column) partitions 4;
-- Syntax:
-- -- create table partition_table(schema_of_table) 
-- -- partition by hash value (column_name) 
-- -- partitions 4;

drop table if exists partition_employee;
create table if not exists partition_employee(empid int, 
											  first_name varchar(20), 
                                              last_name varchar(20), 
                                              gender varchar(20),	
                                              city varchar(20), 
                                              country varchar(20))
partition by hash (empid)
partitions 5;   
-- Employee_part.csv table import from wizard

select partition_name, table_rows from information_schema.partitions
where table_schema="accountsdb" and table_name="partition_employee";

select * from partition_employee partition(p0);
select * from partition_employee partition(p1);

-- Partition by KEY
-- Syntax:
-- -- create table partition_table(schema_of_table) 
-- -- partition by key (column_name);
-- use partition by key when you have primary key, unique key
-- while creating the table dont mention key name in 
-- partition by key()
-- empty () takes the primary_key as the key

drop table if exists key_employee;
create table if not exists key_employee(empid int, 
									    first_name varchar(20), 
									    last_name varchar(20), 
									    gender varchar(20),	
									    city varchar(20), 
									    country varchar(20))
partition by key (country)
partitions 5;

select partition_name, table_rows from information_schema.partitions
where table_schema="accountsdb" and table_name="key_employee";

select * from key_employee partition(p1);



-- So totally, Partions are of 4 types:
-- 		partition by Range
--    	partition by List
--    	partition by Hash
--    	partition by Key
