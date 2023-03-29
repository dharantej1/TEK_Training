
-- 1. change database
use hivedb;

-- 2. create users table
drop table if exists users;
create external table if not exists users(userid int, username varchar(60), contact varchar(60), date_of_birth date, gender varchar(60), user_city varchar(60), user_email varchar(60), modified_date date)
row format delimited 
fields terminated by ','
lines terminated by '\n'
stored as textfile
location '/user_details/';

-- 3. show all table details
select * from users;


-- 4. show only updated entries by the date
create view modified_date as
select u1.* from 
(select * from users) u1
join
(select userid, max(modified_date) as max_date from (select * from users) u2 group by userid) s1
on u1.userid=s1.userid and u1.modified_date=s1.max_date;

select * from modified_date;
