-- BUCKETING:

-- bucketing allows you to do partitions which can be user defined, but in the partitioning they are done by the hive only
-- bucketing can be done to any column unline the partioning in hive
-- bucketing is better than partitioning
-- bucketing creates more number of blocks and these block are used to do more number of mapping jobs, which are parallel jobs
-- -- this inturn takes less time for processing of data (in mapping the data)
-- if bucket has insufficient data to be filled it tries to fit the data with another fields also (apart from a particular partition)
-- -- and fills the data untill all the buckets have the same amount of data

-- -- -- Partitioning is a Mapping Job
-- -- -- Bucketing is a Map + Reduce Job

-- bucketing is used for equal distribution of data



-- 1.use database
use hivedb;

-- 2. drop table
drop table if exists emptable;
drop table if exists bucketing_table;
-- 3. create external table
create external table if not  exists emptable(empid int,fname varchar(60),lname varchar(60),age int,gender varchar(40),department varchar(60),country varchar(60))
row format delimited
fields terminated by ','
lines terminated by'\n'
location '/Partition';

select * from emptable limit 5;

-- set properties To Enable Dynamic Partitioning
set hive.exec.dynamic.partition=true;
-- Allow hive to do dynamic partition
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.enforce.bucketing = true;

-- 3. Creating partition table
create external table if not exists bucketing_table(empid int,fname varchar(60),lname varchar(60),age int,gender varchar(40),department varchar(60))
partitioned by(country varchar(60))
clustered by (department) into 10 buckets
row format delimited
fields terminated by ','
lines terminated by'\n';

-- 4. Insert data from external table to partition table
insert overwrite table bucketing_table
partition(country)
select * from emptable;


-- No partition 

-- 3. Creating partition table
create external table if not exists bucketing_table2(empid int,fname varchar(60),lname varchar(60),age int,gender varchar(40),department varchar(60),
country varchar(60))
clustered by (department) into 10 buckets
row format delimited
fields terminated by ','
lines terminated by'\n';

-- 4. Insert data from external table to partition table
insert overwrite table bucketing_table2
select * from emptable;

