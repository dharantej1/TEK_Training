-- 1. create new database
create database if not exists mynewdb;

-- 2. use the database created
use mynewdb;

-- 3. create a new external table
create external table if not exists emptable (empid int, first_name varchar(60), last_name varchar(60), hiredate date, gender varchar(40),
company varchar(100), salary int)
row format delimited
fields terminated by ","
lines terminated by "\n"
location "/hivedir"
tblproperties ("skip.header.line.count"="1");

-- 4. show data sets
select * from emptable limit 5;

-- 5. to run hive file command "hive -f external_tables.hql"
