-- 1. create database
create database if not exists hive_jsondb;

-- 2. use database
use hive_jsondb;

-- 3. create json format table
drop table if exists employee_table;
create external table if not exists employee_table (empid int, first_name varchar(60), last_name varchar(60), age int, 
						    gender varchar(30), salary bigint, department varchar(60), country varchar(60))
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe';

-- 4. load data into json table from local 
load data local inpath '/home/hadoop/Downloads/employee.json'
overwrite into table employee_table;

-- 5. display the data
select * from employee_table limit 5;


-- -- -- -- -- -- Alternative Method -- -- -- -- -- -- 
ADD JAR hdfs:///serde/json-serde-1.3.8-jar-with-dependencies.jar;
drop table if exists employee_table2;
create external table if not exists employee_table2 (empid int, first_name varchar(60), last_name varchar(60), age int, 
						    gender varchar(30), salary bigint, department varchar(60), country varchar(60))
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
location '/json_data/';

select * from employee_table2 limit 5;
