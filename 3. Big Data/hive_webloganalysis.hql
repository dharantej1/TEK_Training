-- 1. change database
use hivedb;

-- 2. create external table for weblogs using SERDEPROPERTIES regex
-- drop table if exists weblogs;
-- create external table if not exists weblogs(`Source IP` string,`timestamp` string,request varchar(50),endpoint varchar(100),protocol string,
--                                             response string,content_size int)
-- row format serde 'org.apache.hadoop.hive.serde2.RegexSerDe'
-- with serdeproperties (
-- 	"input.regex"="(^.*) - - \\[(.*)\\] \\\"([A-Z]*|[^\\\"]*) ([^HTTP]*) ([^\\\"]*)\\\" ([\\d]+) ([^-].*)",
-- 	"output.format.string"="%1$s %2$s %3$s %4$s %5$s %6$s %7$s");

-- 3. Loading the local file 
-- load data local inpath '/home/hadoop/Downloads/access_log_Jul95'
-- INTO table weblogs;

select * from weblogs limit 5;


-- -- -- Analysis
-- 1. display frequency of status count from all responses
-- select response, count(*) as counts from weblogs group by response order by counts desc;

-- 2. show distribution of page view accessories logs (or) freq of page views in july month
-- select endpoint, count(*) as counts from weblogs group by endpoint order by counts desc;

-- 3. analysis of web server logs
-- -- show top 15 paths showing error status
-- select endpoint, response, count(*) as count_response from weblogs where response<>200 group by endpoint, response order by count_response -- desc limit 15; 

-- 4. show distinct source ip address
-- select distinct(`Source IP`) from weblogs;

-- 5. display 15 most frequent visitors at NASA page
-- select `Source IP`, count(*) as count_visitors from weblogs where endpoint like '%NASA%' group by Source IP order by count_visitors desc -- -- limit 15;

-- 6. list top 20 paths(end points) with 404 response code 
-- select endpoint, count(*) as not_found from weblogs where response='404' group by endpoint order by not_found desc limit 20;

-- 7. show top 15 paths(end points) response with maximum content size
-- select endpoint, content_size from weblogs order by counts desc limit 15;

-- 8. show top 20 source ip (host) with 404 as response status code
-- select `Source IP`, count(*) as error_count from weblogs where response='404' group by `Source IP` order by error_count desc limit 20;






























