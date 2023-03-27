-- 1. use database

-- 2. create external table
-- column_names: txno, txdate, custno, amount, category, product, city, state, mode_payment


drop table if exists transactions;
create external table if not exists transactions(
txno int, txdate varchar(50), custno varchar(50), amount float, category string, product varchar(50), city varchar(50), state varchar(50), mode_payment varchar(50))
row format delimited
fields terminated by ","
lines terminated by "\n"
stored as textfile
location '/transactions';

-- 3. show first 5 rows
select * from transactions limit 5;


-- 4. create parquet table
drop table if exists transactions_parquet;
create external table if not exists transactions_parquet(
txno int, txdate varchar(50), custno varchar(50), amount float, category string, product varchar(50), city varchar(50), state varchar(50), mode_payment varchar(50))
row format delimited
fields terminated by ","
lines terminated by "\n"
stored as parquetfile;

-- Insert data from transactions to parquet transactions_parquet
insert overwrite table transactions_parquet
select * from transactions;

describe formatted transactions_parquet;

