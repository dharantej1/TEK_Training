
-- 1. change database
use hivedb;

-- 2. create users table
create external table if not exists users(userid int, username varchar(60), contact varchar(60), date_of_birth date, gender varchar(60), user_city varchar(60), user_email varchar(60), modified_date date)
row format delimited 
fields terminated by ','
lines terminated by '\n'
stored as textfile
location '/user_details/';

-- 3. show all table details
select * from users;
