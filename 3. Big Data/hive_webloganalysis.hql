-- 1. change database
use hivedb;

-- 2. create external table for weblogs using SERDEPROPERTIES regex
create external table if not exists weblogs(
	`Source IP` string, `TimeStamp` string, request varchar(50), endpoint varchar(100), protocol string, response string
	content_size string
	)
row format serde 'org.apache.hadoop.hive.serde2.RegexSerDe'
with serdeproperties ("input.regex" 		= "",
		      "output.format.string" 	= ""); 
