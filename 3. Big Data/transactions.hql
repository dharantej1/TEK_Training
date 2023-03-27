-- -- -- -- -- -- CONTAINS NOTES BELOW -- -- -- -- -- -- 

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


-- 5. Create ORC File
drop table if exists transactions_orc;
create external table if not exists transactions_orc(
txno int, txdate varchar(50), custno varchar(50), amount float, category string, product varchar(50), city varchar(50), state varchar(50), mode_payment varchar(50))
row format delimited
fields terminated by ","
lines terminated by "\n"
stored as orcfile;

-- Insert data from transactions to parquet transactions_parquet
insert overwrite table transactions_orc
select * from transactions;

describe formatted transactions_orc;

-- raw datasize = sum of each data size columns * number of rows in the dataset 

-- AVRO file formats: 
-- -- no compression of data
-- -- this is a row based storage format for hadoop, data is inserted row wise
-- -- this format stores the schema of the table in json format, making it easy to read and interpret
-- -- data is stored in binary format making it compact and efficient
-- -- so the data is stored in a binary format, so the data is not human readable format
-- -- -- structure: {header + block1 + block2 + .....}


-- Parquet file format: (Only this is Column wise data)
-- -- its columns wise insertion of data
-- -- parquet is more efficient in terms of storages and performance
-- -- this file format is good for executing queries
-- -- this file format also compresses the actual file size


-- ORC file format:(Optimised Row Column)
-- -- insertion of data is row wise
-- -- creates the block of 256MB instead of 128MB block in the HDFS by default
-- -- its highly efficient form of storing the data as it overcomes the limitations of other file formats
-- -- default block sixe is 256MB
-- -- stores the data in compact format and enables skipping over the irrelevent data parts 
-- -- HEADER contains: Index data (Schema)
-- -- the STIRP FOOTER contains: count, min, max, size and also contains the block details (overall data)
-- -- as the strip footer contains the index data, the skipping of irrelevent data can be done




