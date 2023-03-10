create database if not exists atheletedb;
use atheletedb;
drop table if exists olympics;
select * from olympics limit 1;


-- 5. display the columns with null value count
select count(*) as number_of_null_values from olympics where medal=null or medal="";

-- 6
select Season,count(*) from olympics group by Season;

-- 7
select sport from olympics group by sport;

-- 8
select year,count(*) from olympics where Season like 'S%' group by year;
-- 9 

select year,Season,count(distinct event) from olympics group by year,Season order by year,Season;

-- 10
select sport,count(*) as NO_OF_Athelit from olympics group by sport;

-- 11
select name,age from olympics order by age desc limit 10;

-- 12
select name,weight from olympics order by weight desc limit 10;

-- 13
select name, age, medal from olympics where medal like "g%" order by age limit 10;

-- 14
select name,weight,medal from olympics where medal like "G%" order by weight desc limit 10;

-- 15
select name, weight, medal from olympics where medal like "G%" and weight != 0 order by weight limit 10;

-- 16 
select id,(sum(case when medal like 'G%' then 1 else 0 end)) as gold_medals,(sum(case when medal like 'S%' then 1 else 0 end)) as Silver_medals,(sum(case when medal like 'B%' then 1 else 0 end)) as Bronze_medals from olympics group by id order by Gold_medals desc ,Silver_medals desc,Bronze_medals desc limit 10;

-- 17
select Team,(sum(case when medal like 'G%' then 1 else 0 end)) as gold_medals,(sum(case when medal like 'S%' then 1 else 0 end)) as Silver_medals,(sum(case when medal like 'B%' then 1 else 0 end)) as Bronze_medals from olympics group by Team order by Gold_medals desc ,Silver_medals desc,Bronze_medals desc limit 10;

-- 18
desc olympics;