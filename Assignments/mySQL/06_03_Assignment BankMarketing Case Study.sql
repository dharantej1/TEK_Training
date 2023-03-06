create database if not exists bankdb;
use bankdb;
drop table if exists bank;
create table if not exists bank(
	age int,
    job varchar(20),
    marital varchar(30),
    education varchar(30),
    default_value varchar(30),
    balance int,
    housing varchar(30),
    loan varchar(30),
    contact varchar(30),
    day int,
    month varchar(30),
    duration int,
    campaign int,
    pdays int,
    previous int,
    poutcome varchar(30),
    y varchar(10)
);
use bankdb;
select * from bank limit 10;
-- 1. give the max, mean and min age of the targeted customer
select max(age) as max_age, avg(age) as mean_age, min(age) as min_age from bank;

-- 2. chech the quality of the customers by checking average balance, median of the customers.
SET @rowindex := -1;
select avg(balance) as mean_balance, 
AVG(d.balance) as Median 
FROM (SELECT @rowindex:=@rowindex + 1 AS rowindex, bank.balance AS balance
    FROM bank
    ORDER BY bank.balance) AS d
WHERE d.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2));

-- 3. check if age matters in marketting subscription for deposit.
select age, count(y) as success_count from bank where y="yes" 
group by age
order by success_count desc;

-- 4. check if marital status mattered for a subscription to deposit.
select marital, count(y) as success_count from bank where y='yes' 
group by marital
order by success_count desc;


-- 5. check if age and marital status together mattered for a subscription to deposit the scheme.
select marital,age,count(y) as success from bank where y='yes'
group by marital,age
order by age desc;

-- 6. Do feature engineering for the bank and find the right age effect on the campaign.
select age, campaign, count(y) as success_count from bank where y="yes"
group by age, campaign with rollup
order by success_count desc;