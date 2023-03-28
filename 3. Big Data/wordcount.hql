-- 1. change database
use hivedb;

-- 2. create table for word count
drop table if exists wordfiles;
create external table if not exists wordfiles(line STRING)
location '/wordcount';

select * from wordfiles limit 5;

-- 3. run query to get o/p as word and its total count
drop table if exists word_counts;
create table if not exists word_counts AS
select word, count(1) as count FROM 
(select explode(split(line,' ')) AS word FROM wordfiles)w
group by word
order by word;

select * from word_counts limit 30;


-- 4. final query for the word count
select words, sum(count) as counts from
(select lower(word) as words, count from word_counts) as sub_query
group by words
order by counts desc
limit 30;
