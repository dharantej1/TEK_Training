create database if not exists bankingdb;
show databases;
use bankingdb;
drop table if exists banking;
create table if not exists banking(
	age int,
    job varchar(50),
    marital  varchar(50),
    education varchar(50),
    default_value varchar(50),
    housing varchar(10),
    loan varchar(10),
    contact varchar(50),
    contact_month varchar(30),
    day_of_week varchar(20),
    duration int,
    campaign int,
    pdays int,
    previous int,
    poutcome varchar(20),
    emp_var_rate decimal(3,1),
    cons_price_idx decimal(6,3),
    euribor3m decimal(5,3),
    nr_employed decimal(6,1),
    y int
);
describe banking;

-- DML
-- 1. SELECT

select 1+1;
select now();

-- 2. LIMIT - limit the number of records
select age,job, marital from banking limit 5;

select concat("harry","potter") as name;

-- enable read from local file
set global local_infile=true;
-- LOAD - it inserts records into table using csv files
-- -- local: represents data location in local disk
-- load data local infile "C:\Users\pdharantej\Desktop\Intern Training\data_sets\banking.csv" 
-- into table banking
-- fields terminated by "," -- delimiter of cols
-- lines terminated by "\n" -- lines are separated by \n or \r\n
-- ignore 1 lines;

select * from banking limit 5;

-- 4. COUNT
select count(*) as numrows from banking;

-- 5. display number of missing rows
select count(*) as "num(total)",
count(y) as "num(non-missing)",
count(*) - count(y) as "num(missing)",
(((count(*) - count(y))/count(*))*100) as "% missing"
from banking;

select count(*) as "num(total)",
count(campaign) as "num(non-missing)",
count(*) - count(campaign) as "num(missing)",
(((count(*) - count(campaign))/count(*))*100) as "% missing"
from banking;