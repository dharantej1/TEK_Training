create database if not exists nycdb;
use nycdb;

-- a)
-- drop table if exists nyc_taxifare;
-- CREATE EXTERNAL TABLE if not exists nyc_taxifare (
-- VendorID INT,    tpep_pickup_timestamp STRING,    tpep_dropoff_timestamp STRING,    passenger_count INT,    trip_distance FLOAT,
-- pickup_longitude FLOAT,    pickup_latitude FLOAT,    RatecodeID INT,    store_and_fwd_flag STRING,    dropoff_longitude FLOAT,
-- dropoff_latitude FLOAT,    payment_type INT,    fare_amount FLOAT,    extra FLOAT,    mta_tax FLOAT,    tip_amount FLOAT,
-- tolls_amount FLOAT,    improvement_surcharge FLOAT,    total_amount FLOAT)
-- ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' STORED AS TEXTFILE 
-- LOCATION '/nyctaxi/'
-- TBLPROPERTIES("skip.header.line.count" = "1");

-- b)
-- select * from nyc_taxifare limit 2;


-- c)
-- describe formatted nyc_taxifare;


-- d)
-- SELECT COUNT(*) FROM nyc_taxifare 
-- WHERE unix_timestamp(tpep_pickup_timestamp, 'yyyy-MM-dd HH:mm:ss') > unix_timestamp(tpep_dropoff_timestamp, 'yyyy-MM-dd HH:mm:ss');


-- e) Python question 
-- f) Python question 

-- g) 
-- SELECT passenger_count,        COUNT(*) AS count,        AVG(trip_distance) AS avg_distance,        AVG(fare_amount) AS avg_fare 
-- FROM nyc_taxifare GROUP BY passenger_count;

-- h)
-- SELECT RatecodeID, COUNT(*) AS count FROM nyc_taxifare 
-- GROUP BY RatecodeID ORDER BY RatecodeID;

-- SELECT * FROM nyc_taxifare WHERE RatecodeID=99 limit 10;


-- i)
-- SELECT payment_type, COUNT(*) AS count FROM nyc_taxifare
-- GROUP BY payment_type
-- ORDER BY count DESC;

-- SELECT payment_type, SUM(tip_amount) AS total_tip_amount, AVG(tip_amount/fare_amount) AS avg_tip_percentage
-- FROM nyc_taxifare WHERE payment_type = 1 -- only consider credit card payments
-- GROUP BY payment_type;


-- j)
-- SELECT AVG(extra) AS avg_extra_charges
-- FROM nyc_taxifare;


-- k)
-- SELECT mta_tax, COUNT(*) AS num_trips FROM nyc_taxifare
-- GROUP BY mta_tax
-- ORDER BY num_trips DESC;

-- l)
-- SELECT store_and_fwd_flag, COUNT(*) as count FROM nyc_taxifare
-- GROUP BY store_and_fwd_flag
-- ORDER BY count DESC;


-- m)
-- SELECT COUNT(*) as count FROM nyc_taxifare
-- WHERE payment_type = 2 AND tip_amount > 0;



-- n)
-- SELECT COUNT(*) as count FROM nyc_taxifare
-- WHERE improvement_surcharge <> 0.3;


-- o)

-- Drop table if exists orc_taxifare
-- DROP TABLE IF EXISTS orc_taxifare;

-- Create external table orc_taxifare in ORC format
-- CREATE EXTERNAL TABLE IF NOT EXISTS orc_taxifare (
--     VendorID INT,
--     tpep_pickup_datetime STRING,
--     tpep_dropoff_datetime STRING,
--     passenger_count INT,
--     trip_distance FLOAT,
--     pickup_longitude FLOAT,
--     pickup_latitude FLOAT,
--     RatecodeID INT,
--     store_and_fwd_flag STRING,
--     dropoff_longitude FLOAT,
--     dropoff_latitude FLOAT,
--     payment_type INT,
--     fare_amount FLOAT,
--     extra FLOAT,
--     mta_tax FLOAT,
--     tip_amount FLOAT,
--     tolls_amount FLOAT,
--     improvement_surcharge FLOAT,
--     total_amount FLOAT)
-- ROW FORMAT DELIMITED
-- FIELDS TERMINATED BY ','
-- LINES TERMINATED BY '\n'
-- STORED AS orcfile;

-- Insert data from taxifare to orc_taxifare
-- INSERT OVERWRITE TABLE orc_taxifare SELECT * FROM nyc_taxifare;

-- SELECT * FROM orc_taxifare limit 2;


-- p)
-- SELECT
--     AVG(fare_amount) AS avg_fare_charge,
--     CASE
--         WHEN MONTH(tpep_pickup_timestamp) = 1 THEN 'January'
--         WHEN MONTH(tpep_pickup_timestamp) = 3 THEN 'March'
--     END AS month
-- FROM nyc_taxifare
-- WHERE MONTH(tpep_pickup_timestamp) IN (1, 3)
-- GROUP BY MONTH(tpep_pickup_timestamp);


-- q)
-- SELECT passenger_count, COUNT(*) as num_trips
-- FROM nyc_taxifare
-- GROUP BY passenger_count
-- ORDER BY passenger_count ASC;



-- r)
-- SELECT 
--   CASE WHEN passenger_count = 1 THEN 'Solo' ELSE 'Group' END AS passenger_type,
--   COUNT(*) AS num_trips
-- FROM nyc_taxifare
-- WHERE passenger_count >= 1 AND passenger_count <= 6
-- GROUP BY 
--   CASE WHEN passenger_count = 1 THEN 'Solo' ELSE 'Group' END
-- ORDER BY num_trips DESC;



-- s)
-- SELECT payment_type, COUNT(*) as num_trips
-- FROM nyc_taxifare
-- GROUP BY payment_type
-- ORDER BY num_trips DESC
-- LIMIT 1;



-- t)
-- SELECT 
--   AVG(tip_amount) AS avg_tip,
--   percentile(bigint(tip_amount), 0.25) AS p25_tip,
--   percentile(bigint(tip_amount), 0.50) AS p50_tip,
--   percentile(bigint(tip_amount), 0.75) AS p75_tip
-- FROM nyc_taxifare
-- WHERE payment_type = 1;



-- u)
-- SELECT CASE WHEN extra > 0 THEN 'Extra Charge' ELSE 'No Extra Charge' END AS extra_charge,
--        COUNT(*) AS num_trips,
--        ROUND(COUNT(*) / SUM(COUNT(*)) OVER (), 4) AS fraction_of_total_trips
-- FROM nyc_taxifare
-- GROUP BY CASE WHEN extra > 0 THEN 'Extra Charge' ELSE 'No Extra Charge' END;



-- v)
-- SELECT 
--   CASE WHEN extra > 0 THEN 'Extra Charge Levied' ELSE 'Extra Charge Not Levied' END AS extra,
--   COUNT(*) AS num_trips,
--   COUNT(*) / SUM(COUNT(*)) OVER() AS fraction_of_trips
-- FROM nyc_taxifare
-- GROUP BY extra;



-- w)

-- set properties To Enable Dynamic Partitioning
-- set hive.exec.dynamic.partition=true;
-- Allow hive to do dynamic partition
-- set hive.exec.dynamic.partition.mode=nonstrict;
-- set hive.enforce.bucketing = true;

-- drop table if exists bucket_nyc_taxifare;
-- create external table if not exists bucket_nyc_taxifare
--	(Vendor ID Int, tpep pickup datetime tinestano, tpep dropoff datetime timestamp, passenger count int, trip distance tnt, pickup 
-- longitude double, pickup latitude double, Ratecode ID int, store and fwd flag varchar(10), dropoff longitude double, dropoff latitude 
-- double, paynent type int, fare_amount double, extra double, nta_tax double, ttp_amount double, tolls amount double, Improvement surcharge 
-- double, total amount double,ttp_grp varchar(20)) 
-- clustered by (ttp_grp) into 5 buckets 
-- row format delimited 
-- fields terminated by "," 
-- lines terminated by '\n'; 
-- insert overwrite table bucket_nyc_taxtfare select from (select case when tip_amount and tip_amount <5 then "zerotofive" when tip_amount>5 -- and tip_amount <10 then "fivetoten" when tip_amount >10 and tip_amount <15 then "tentofive" when ttp_amount 15 and ttp amount <20 then 
-- "fifteentotwenty when ttp_amount>20 then "morethantwenty end as ttp_grp from nyc taxtfare) as ti;



-- x)
-- with tbl1 as(select sum(case when tpep_pickup_timestamp like '_____01%' then 1 else 0 end ) as no_of_jan,sum(case when 
-- tpep_pickup_timestamp like '_____01%' then
-- trip_distance/((unix_timestamp(tpep_dropoff_timestamp)-unix_timestamp(tpep_pickup_timestamp))/3600)
-- else 0 end ) as sum_speed_of_jan,sum(case when tpep_pickup_timestamp like '_____03%' then 1 else 0 end ) as no_of_mar,sum(case when 
-- tpep_pickup_timestamp like '_____03%' then
-- trip_distance/((unix_timestamp(tpep_dropoff_timestamp)-unix_timestamp(tpep_pickup_timestamp))/3600)
-- else 0 end ) as sum_speed_of_mar from nyc_taxifare where unix_timestamp(tpep_dropoff_timestamp)>unix_timestamp(tpep_pickup_timestamp))
-- select sum_speed_of_jan/no_of_jan as Avg_jan,sum_speed_of_mar/no_of_mar as Avg_mar from tbl1;




-- y)
-- with tbl1 as(select count(*) as total,sum( trip_distance/((unix_timestamp(tpep_dropoff_timestamp)-unix_timestamp(tpep_pickup_timestamp))/
-- 3600)) as sum_speed,
-- sum(case when tpep_pickup_timestamp like '_____01_01%' then 1 else 0 end ) as no_of_jan1,sum(case when tpep_pickup_timestamp like
-- '_____01_01%' then
-- trip_distance/((unix_timestamp(tpep_dropoff_timestamp)-unix_timestamp(tpep_pickup_timestamp))/3600)
-- else 0 end ) as sum_speed_of_jan1,sum(case when tpep_pickup_timestamp like '_____01_18%' then 1 else 0 end ) as no_of_jan16,sum(case when 
-- tpep_pickup_timestamp like -- '_____01_18%' then
-- trip_distance/((unix_timestamp(tpep_dropoff_timestamp)-unix_timestamp(tpep_pickup_timestamp))/3600)
-- else 0 end ) as sum_speed_of_jan16
-- from nyc_taxifare where unix_timestamp(tpep_dropoff_datetime)>unix_timestamp(tpep_pickup_timestamp))
-- select total/sum_speed as total_avg ,sum_speed_of_jan1/no_of_jan1 as Avg_jan1,sum_speed_of_jan16/no_of_jan16 as Avg_jan16 from tbl1;
-- select count(*) from nyc_taxifare where ;


-- z)
-- drop table if exists partition_table_nyc;
-- set hive.exec.dynamic.partition=true;
-- set hive.exec.dynamic.partition.mode=nonstrict;

-- create external table if not exists partition_table_nyc(VendorID int, tpep_pickup_timestamp varchar(30), tpep_dropoff_timestamp varchar 
-- (50),
-- passenger_count int, trip_distance int,
-- pickup_longitude double, pickup_latitude double,
-- RatecodeID int, store_and_fwd_flag varchar(20), dropoff_longitude double, dropoff_latitude double, payment_type int, fare_amount double,
-- extra double, mta_tax double,
-- tip_amount double, tolls_amount double, improvement_surcharge double,total_amount double)
-- partitioned by(total_charge varchar(20))
-- row format delimited
-- fields terminated by ','
-- lines terminated by '\n';

-- insert overwrite table partition_table_nyc
-- partition(total_charge)
-- select * from (select *,case when total_amount<0 then "Not Paid" when total_amount<25 then "Decent price" when total_amount<100 then "high -- price"
-- else "Super High(Expensive)" end as total_charge from nyc_taxifare) subq











