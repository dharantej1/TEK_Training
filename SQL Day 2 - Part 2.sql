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
    cons_conf_idx decimal(6,3),
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
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Day 3
-- 7. max, min, avg/ mean
select * from banking;
select min(age) as min_age, max(age) as max_age, avg(age) as mean_age from banking;

select min(duration) as min_duration, max(duration) as max_duration, avg(duration) as mean_duration from banking;

-- 8. sum
select sum(duration)/3600 as total_duration_hours from banking;

-- 9. std, var
select variance(duration) as variance, std(duration) as std_duration from banking;
select variance(age) as variance_age, std(age) as std_age from banking;

-- 10. WHERE clause
-- where clause allows you to specify a search condition for my rows returned by a query.
-- where clause to filter rows based on specified conditions. 
select * from banking;
select count(*) as customers from banking where y=1;

-- show only not null values from education
select education, duration from banking where y=1 and education is not null;

-- 11. ORDER BY
-- to sort the rows in the result set, you add order by clause select
-- order by asc, desc
-- first month in desc order and then duration om asce order
select age, contact_month, duration from banking where y=1 order by contact_month desc, duration asc;

-- 12. DISTINCT - shows unique values from each column
-- to drop duplicate set from result set
-- my SQL evaluates distinct clause after from, where and select 
-- and before order by clause
select distinct(education) as education from banking ;

select distinct(marital) as marital from banking;

-- 13. LIKE
-- like operator is a logical operator that tests whether a string contains specified pattern or not.
select count(*) as success_costomer from banking where poutcome like "s%";

-- Exercise: Count of customer where the education basic 6 years
select count(*) as basic6years_education from banking where education like "b%6y";

-- 14. GROUP BY
-- mySQL evaluated group by clause after from and where and before having, select, disinct, order by and limit

-- order of execution
-- from, where, group by, having, select, distinct, order by, limit
-- total customers contacted in each month
select contact_month, count(*) as target_customer from banking 
group by contact_month order by target_customer desc;

-- total target customers contacted every week for each month
select contact_month, day_of_week, count(*) as target_customer from banking 
group by contact_month, day_of_week order by contact_month, day_of_week asc;


-- Exercise: Show the duration of call in hours for each week day in each month
select contact_month, day_of_week, sum(duration)/3600 as duration_in_hours from banking
group by contact_month, day_of_week
order by duration_in_hours desc;

-- 15. HAVING
-- mySQL evaluates having clause after from, where, group by
-- before select, distinct, order by and limit
-- find total duration in hrs , customer contacted in a month and total number of positive customers
select contact_month, sum(y) as ordercount, sum(duration)/3600 as total_duration_hours from banking 
group by contact_month;

-- same question as above, but for positive customers
select contact_month, sum(y) as ordercount, sum(duration)/3600 as total_duration_hours from banking 
where y=1
group by contact_month;

-- use having clause on the group by result set
select contact_month, sum(y) as ordercount, sum(duration)/3600 as total_duration_hours from banking 
where y=1
group by contact_month
having ordercount>100 and contact_month like "a%";

-- 16. ROLL UP
-- roll up generates multiple grouping sets based on cols or expression specified in group by clause
-- roll up clause generates not only the subtotals, but it also generates the grand totals of cols clause(acc to order)
-- the roll up assumes that there is folllowing hierarchy: c1 > c2 > c3.
-- it generates the grouping sets: (c1, c2, c3)
--                                 (c1, c2)
--                                 (c1)
--                                 ()

select job, sum(y) as success_count from banking
group by job with rollup order by success_count;

select job, day_of_week, sum(y) as success_count from banking
group by job, day_of_week with rollup order by job;

-- access the row with "management" and "null" from the above query
select job, day_of_week, sum(y) as success_count from banking
group by job, day_of_week with rollup
having job like "m%" and day_of_week is null;
