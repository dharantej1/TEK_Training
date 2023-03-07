create database if not exists stocksdb;
use stocksdb;
drop table if exists stocks;
create table if not exists stocks(
	trade_date datetime,
    SPY double,
    GLD double,
    AMZN double,
    GOOG double,
    KPTI double,
    GILD double,
    MPC double
);

-- load data into stocks
-- set global local_file=true;
-- load data local infile "C:/Users/pdharantej/Desktop/Intern Training/data_sets/data.csv"
-- into table stocks
-- fields terminated by ","
-- lines terminated by "\n"
-- ignore 1 lines;

-- Error Code: 3948. Loading local data is disabled; this must be enabled on both the client and server sides

alter table stocks modify trade_date date;
-- if you have read the date format as string/ varchar() then use
-- set global sql_safe_updates=0
-- update stocks set trade_date=str_to_date(trade_date,%y%m%d)
-- set global sql_safe_updates=1

describe stocks;

select * from stocks limit 10;

-- create a new column named as SPYTrends 
-- values as UP/DOWN if its NEGATIVE/ POSITIVE 
alter table stocks add column SPYTrends varchar(20);
set sql_safe_updates=0; -- setting the safe update to 0 (False)
update stocks 
set SPYTrends = if(SPY<0,"down",
				if(SPY>0,"up","zero")
);
set sql_safe_updates=1; -- resetting the safe update to 1 (True)
select * from stocks limit 10;

select avg(amzn), if(amzn>0,"uptrend","downtrend") as direction from stocks
group by direction;

-- 19. CASE WHEN THEN
select trade_date, weekday(trade_date) from stocks;
select trade_date,
	case
		when weekday(trade_date)=0 then "Monday"
        when weekday(trade_date)=1 then "Tuesday"
        when weekday(trade_date)=2 then "Wednesday"
        when weekday(trade_date)=3 then "Thursday"
        when weekday(trade_date)=4 then "Friday"
        when weekday(trade_date)=5 then "Saturday"
        when weekday(trade_date)=6 then "Sunday"
	end as weekday
from stocks limit 5;
alter table stocks add column Week_day varchar(20);
set sql_safe_updates=0;
update stocks
	set Week_day = 
		case
			when weekday(trade_date)=0 then "Monday"
			when weekday(trade_date)=1 then "Tuesday"
			when weekday(trade_date)=2 then "Wednesday"
			when weekday(trade_date)=3 then "Thursday"
			when weekday(trade_date)=4 then "Friday"
			when weekday(trade_date)=5 then "Saturday"
			when weekday(trade_date)=6 then "Sunday"
		end ;
select * from stocks limit 5;
set sql_safe_updates=1;

alter table stocks add column overall varchar(10);
set sql_safe_updates=0;
update stocks set overall = if(spy + gld + amzn + goog + kpti + gild + mpc > 0,"UP","DOWN");
select * from stocks limit 5;

select overall, count(*) from stocks 
group by overall; 

select 
	case
		when weekday(trade_date)=0 then "Monday"
		when weekday(trade_date)=1 then "Tuesday"
		when weekday(trade_date)=2 then "Wednesday"
		when weekday(trade_date)=3 then "Thursday"
		when weekday(trade_date)=4 then "Friday"
		when weekday(trade_date)=5 then "Saturday"
		when weekday(trade_date)=6 then "Sunday"
	end as weekdays, round(avg(spy),4),round(avg(gld),4),
    round(avg(amzn),4),round(avg(goog),4),round(avg(kpti),4),
    round(avg(gild),4),round(avg(mpc),4)
    from stocks
    group by weekdays
    order by weekdays;
		