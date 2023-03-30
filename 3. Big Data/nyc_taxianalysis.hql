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
set hive.exec.dynamic.partition=true;
-- Allow hive to do dynamic partition
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.enforce.bucketing = true;




-- x)
SELECT 
  month, 
  AVG(trip_distance/trip_time_in_secs) AS avg_speed
FROM (
  SELECT 
    CASE 
      WHEN month(tpep_pickup_timestamp) = 11 THEN 'November' 
      WHEN month(tpep_pickup_timestamp) = 12 THEN 'December' 
    END AS month, 
    trip_distance, 
    trip_time_in_secs
  FROM nyc_taxifare
  WHERE month(tpep_pickup_timestamp) IN (11, 12)
    AND trip_distance > 0 
    AND trip_time_in_secs > 0
  ) AS subquery
GROUP BY month;




















