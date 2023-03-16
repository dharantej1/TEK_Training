create database if not exists flightsdb;
use flightsdb;
select * from flights;

-- a)	Create external table “flights” using Database “airline_delayDB”
-- imported the cleaned data (from pandas) using import data wizard

-- b)	Describe the table schema & show top 10 rows of Dataset
describe flights;
select * from flights limit 10;

-- c)	Find duplicates rows present in dataset.
SELECT *
FROM flights
WHERE (ID, YEAR, MONTH, DAY, DAY_OF_WEEK, AIRLINE, FLIGHT_NUMBER, TAIL_NUMBER, ORIGIN_AIRPORT, DESTINATION_AIRPORT, SCHEDULED_DEPARTURE, DEPARTURE_TIME, DEPARTURE_DELAY, TAXI_OUT, WHEELS_OFF, SCHEDULED_TIME, ELAPSED_TIME, AIR_TIME, DISTANCE, WHEELS_ON, TAXI_IN, SCHEDULED_ARRIVAL, ARRIVAL_TIME, ARRIVAL_DELAY, DIVERTED, CANCELLED)
IN (
    SELECT *
    FROM flights
    GROUP BY ID, YEAR, MONTH, DAY, DAY_OF_WEEK, AIRLINE, FLIGHT_NUMBER, TAIL_NUMBER, ORIGIN_AIRPORT, DESTINATION_AIRPORT, SCHEDULED_DEPARTURE, DEPARTURE_TIME, DEPARTURE_DELAY, TAXI_OUT, WHEELS_OFF, SCHEDULED_TIME, ELAPSED_TIME, AIR_TIME, DISTANCE, WHEELS_ON, TAXI_IN, SCHEDULED_ARRIVAL, ARRIVAL_TIME, ARRIVAL_DELAY, DIVERTED, CANCELLED
    HAVING COUNT(*) > 1
);

-- d)	Average arrival delay caused by airlines
select avg(arrival_delay) as avg_dalay_caused from flights;

-- e)	Days of months with respected to average of arrival delays
SELECT DAY, AVG(ARRIVAL_DELAY) AS AVG_DELAY
FROM flights
GROUP BY DAY
ORDER BY DAY ASC;

-- f)	Arrange weekdays with respect to the average arrival delays caused
SELECT DAY_OF_WEEK, AVG(ARRIVAL_DELAY) AS AVG_DELAY
FROM flights
GROUP BY DAY_OF_WEEK
ORDER BY AVG_DELAY desc;

-- g)	Arrange Days of month as per cancellations done in Descending
SELECT day, COUNT(*) AS num_cancellations
FROM flights
WHERE cancelled = 1
GROUP BY day
ORDER BY num_cancellations DESC;

-- h)	Finding busiest airports with respect to day of week
SELECT day_of_week, origin_airport, COUNT(*) AS num_flights
FROM flights
GROUP BY day_of_week, origin_airport
ORDER BY day_of_week ASC, num_flights DESC
LIMIT 10;

-- i)	Finding airlines that make the maximum number of cancellations
SELECT airline, sum(cancelled) 
from flights
group by airline
order by sum(cancelled) desc
limit 10;
-- or
SELECT airline, COUNT(*) AS num_cancellations
FROM flights
WHERE cancelled = 1
GROUP BY airline
ORDER BY num_cancellations DESC
LIMIT 10;

-- j)	Find and order airlines in descending that make the most number of diversions
select airline, count(*) as num_of_diversions
from flights 
where diverted=1
group by airline
order by num_of_diversions desc
limit 10;

-- k)	Finding days of month that see the most number of diversion
select airline, day as days_of_month, count(*) as number_of_diversions
from flights
WHERE diverted=1
group by airline
order by number_of_diversions desc
limit 5;

-- l)	Calculating mean and standard deviation of departure delay for all flights in minutes
select airline, avg(departure_delay) as mean_delay, std(departure_delay) as std_dev_delay 
from (
	select airline, departure_delay
    from flights 
    where departure_delay>0
) t
group by airline
-- having mean_delay > 0
order by mean_delay desc;

-- m)	Calculating mean and standard deviation of arrival delay for all flights in minutes
select airline, avg(arrival_delay) as mean_arrival, std(arrival_delay) as std_dev_arrival 
from (
	select airline, arrival_delay
    from flights 
    where arrival_delay>0
) t
group by airline
-- having mean_arrival > 0
order by mean_arrival desc;

-- n)	Create a partitioning table “flights_partition” using suitable partitioned by schema.
CREATE TABLE flights_partition (
  id int,  year int,  month int,  day int,  day_of_week int,  airline text,  flight_number int,  tail_number text,  origin_airport text,  destination_airport text,  scheduled_departure int,  departure_time int,  departure_delay int,  taxi_out int,  wheels_off int,  scheduled_time int,  elapsed_time int,  air_time int,  distance int,  wheels_on int,  taxi_in int,  scheduled_arrival int,  arrival_time int,  arrival_delay int,  diverted int,  cancelled int
)PARTITION BY list (month)(
	partition month1 values in (1),
	partition month2 values in (2),
	partition month3 values in (3)
);

select * from flights_partition partition(month1);

-- o)	Finding all diverted Route from a source to destination Airport & which route is the most diverted
select origin_airport, destination_airport, count(*) as diverted
from flights
group by origin_airport, destination_airport
order by diverted desc
limit 10;

-- p)	Write a query to show Top 3 airlines from each airport making most Delays.(Use Dense Rank/ Rank)
select * from (
	select origin_airport as airport, airline, count(*) as num_delays,
    dense_rank() over(partition by origin_airport order by count(*) desc) as rank_val
    from flights
    where departure_delay>0
    group by origin_airport, airline
) as t
where rank_val>3
order by airport, rank_val, num_delays desc
limit 3;

-- q)	Write a query to show Top 10 airlines from each week making most Delays. Find its Ranking.
SELECT day_of_week, airline, num_delays, rank_val
FROM (
    SELECT day_of_week, airline, num_delays, rank_val
    FROM (
        SELECT DAY_OF_WEEK, AIRLINE, COUNT(*) AS num_delays,
            RANK() OVER (PARTITION BY DAY_OF_WEEK ORDER BY COUNT(*) DESC) AS rank_val
        FROM flights
        WHERE DEPARTURE_DELAY > 0
        GROUP BY DAY_OF_WEEK, AIRLINE
    ) t
) t2
WHERE rank_val <= 10
ORDER BY day_of_week, rank_val 
limit 10;


-- r)	Create a view for client to show Top 10 airlines with highest Delay.
CREATE VIEW top_10_airlines_delay AS
	SELECT airline, AVG(arrival_delay) AS avg_delay
	FROM flights
	WHERE arrival_delay > 0
	GROUP BY airline
	ORDER BY avg_delay DESC
	LIMIT 10;
select * from top_10_airlines_delay;

-- s)	Create a new column named ‘Delay_Comaprison’ 
-- showing if flights making higher or lower than average flight delay.
ALTER TABLE flights ADD Delay_Comparison VARCHAR(10);
set sql_safe_updates=0;

SET @avg_delay := (SELECT AVG(Departure_Delay + Arrival_Delay) FROM flights);
UPDATE flights
SET Delay_Comparison = IF((Departure_Delay + Arrival_Delay) > @avg_delay, 'Higher', 'Lower');
select * from flights;

-- t)	Finding AIRLINES with its total flight count, total number of flights 
-- arrival delayed by more than 30 Minutes, % of such flights delayed by more than
-- 30 minutes when it is not Weekends with minimum count of flights from Airlines by 
-- more than 10. Also Exclude some of Airlines 'AK', 'HI', 'PR', 'VI' and arrange output 
-- in descending order by % of such count of flights. 
SELECT 
    AIRLINE, COUNT(*) AS total_flights, 
    SUM(CASE WHEN ARRIVAL_DELAY > 30 THEN 1 ELSE 0 END) AS delayed_flights, 
    ROUND(100 * SUM(CASE WHEN ARRIVAL_DELAY > 30 THEN 1 ELSE 0 END) / NULLIF(COUNT(CASE WHEN DAY_OF_WEEK NOT IN (1, 7) THEN 1 ELSE NULL END), 0), 2) AS pct_delayed_not_weekends
FROM flights
WHERE AIRLINE NOT IN ('AK', 'HI', 'PR', 'VI')
GROUP BY AIRLINE
HAVING COUNT(*) > 10
ORDER BY pct_delayed_not_weekends DESC;

-- u)	Finding AIRLINES with its total flight count with total number of flights 
-- departure delayed by less than 30 Minutes, % of such flights delayed by less than 
-- 30 minutes when it is Weekends with minimum count of flights from Airlines by more than 10. 
-- Also Exclude some of Airlines 'AK', 'HI', 'PR', 'VI' and arrange output in 
-- descending order by % of such count of flights. 
SELECT 
    airline, 
    COUNT(*) AS total_flights, 
    SUM(CASE WHEN DEPARTURE_DELAY < 30 THEN 1 ELSE 0 END) AS on_time_flights, 
    ROUND(SUM(CASE WHEN DAY_OF_WEEK NOT IN (1,7) AND DEPARTURE_DELAY < 30 THEN 1 ELSE 0 END) / 
          COUNT(*) * 100, 2) AS on_time_weekday_percentage
FROM flights 
WHERE airline NOT IN ('AK', 'HI', 'PR', 'VI') 
GROUP BY airline 
HAVING total_flights > 10 
ORDER BY on_time_weekday_percentage DESC;

-- v)	When is the best time of day/day of week/time of a year to fly with minimum delays?
SELECT 
    day_of_week, month, AVG(departure_delay) AS avg_delay 
FROM flights 
WHERE departure_delay > 0 
GROUP BY day_of_week, month
ORDER BY avg_delay ASC 
LIMIT 1;

-- w)	Suggest reasons of airlines delays and suggest, build solutions for it.
-- The suggestion is: if the airlines decreases the taxing time the delays can be reduced for the flights
-- which might effect the reputation of the airlines on the long run.
SELECT 
    origin_airport, destination_airport, airline, 
    AVG(departure_delay) AS avg_dep_delay, 
    AVG(arrival_delay) AS avg_arr_delay, 
    COUNT(*) AS num_delays 
FROM flights 
WHERE departure_delay > 0 AND arrival_delay > 0 
GROUP BY origin_airport, destination_airport, airline 
HAVING num_delays > 2
ORDER BY num_delays desc;

-- x)	Create a stored procedure to find weeks with maximum flights delays count
DELIMITER //
CREATE PROCEDURE find_max_delay_weeks()
BEGIN
    SELECT day, day_of_week, COUNT(*) AS num_delays
    FROM flights
    WHERE DEPARTURE_DELAY > 0
    GROUP BY day, day_of_week
    HAVING num_delays = (SELECT MAX(delay_count) FROM (
                            SELECT COUNT(*) AS delay_count
                            FROM flights
                            WHERE DEPARTURE_DELAY > 0
                            GROUP BY WEEK(day)
                        ) t)
    ORDER BY day_of_week;
END //
DELIMITER ;
call find_max_delay_weeks();