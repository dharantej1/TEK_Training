-- 1. use database;
use hivedb;

drop table if exists emptable;
-- 2. create external table
create external table if not exists emptable(empid int, firstname varchar(60), lastname varchar(60), age int, 
gender varchar(60), department varchar(60), country varchar(60))
row format delimited
fields terminated by ","
lines terminated by "\n"
location "/Partition";

select * from emptable;

-- Set properties to Enable Dynamic Partitioning
set hive.exec.dynamic.partition=True;
-- allow hive to do dynamic partition
set hive.exec.dynamic.partition.mode=nonstrict;

-- 3. create partitioned table
create external table if not exists partition_table (empid int, first_name varchar(60), last_name varchar(60), 
age int, gender varchar(40),department varchar(60))
partitioned by (country varchar(60))
row format delimited
fields terminated by ","
lines terminated by "\n";

-- 4. insert data from External Table to Partition Table
insert overwrite table partition_table
partition(country)
select * from emptable;


-- 5. RUN QUERY
-- -- checking whether which query is faster from one another (normal query VS partitioning one)

select avg(age) from emptable where country="India";

select avg(age) from partition_table where country="India";

