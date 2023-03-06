use bankingdb;
select * from banking;
-- 1. give the max, mean and min age of the average targeted customer
select max(age) as max_age, avg(age) as mean_age, min(age) as min_age from banking;

-- 2. chech the quality of the customers by checking average balance, median of the customers.

-- 3. check if age matters in marketting subscription for deposit.

-- 4. check if marital status mattered for a subscription to deposit.

-- 5. check if age and marital status together mattered for a subscription to deposit the scheme.