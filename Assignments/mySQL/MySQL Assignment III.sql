create database if not exists atheletedb;
use atheletedb;
drop table if exists olympics;
select * from olympics limit 1;


-- 5. display the columns with null value count
select count(*) as number_of_null_values from olympics where medal=null or medal="";

-- 6. Find Number of Teams participating in Summer, Winter Olympics
