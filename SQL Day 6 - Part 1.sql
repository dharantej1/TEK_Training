-- 1. Views
-- -- materialized views
-- 2. partitioning
-- -- ranks
-- -- -- window functions
-- 3. transaction
-- 4. normalization
-- 5. CTE 
-- 6. procedure

-- use accountsdb;
-- select * from employee;
-- select * from expense;

-- TRANSACTION

-- mysql  transaction allows you to execute a set of mysql operations to ensure that the 
-- database never contains the result of partial operations 
-- in a set of operations, if one of them fails the rollback occurs to restore the database to its original state  
-- if no error occurs the entire set of statements is committed to the database
-- -- -- steps to be followed 
-- 1. use the start transaction statement. the begin or begin work are the aliases of the start transaction
-- 2. insert new data into the table
-- 3. to commit the new transactionand make the changes premanent, you can use commit statement
-- 4.  to roll back the current transaction and cancel its changes, you can use roll back statement
-- 5. to enable/ disable the auto-commit mode for the current transactio, you can use "set autocommit"
-- mySQL automatically commits the changes permanently to your database
-- you can disable it by setting "set autocommit=0;"

create database if not exists transactiondb;
use transactiondb;
drop table if exists orders;
create table if not exists orders(
	order_num int not null,
    order_date date not null,
    required_date date not null,
    shipped_date date not null,
    status varchar(50) not null,
    comments text,
    customer_num int(20) not null,
    primary key(order_num)
)engine = InnoDB default charset=latin1; -- this engine and charset is optional to declare
describe orders;
insert into orders values 
	(10100,'2003-01-06','2003-01-13','2003-01-10','Shipped',NULL,363),
	(10101,'2003-01-09','2003-01-18','2003-01-11','Shipped','Check on availability.',128),
	(10102,'2003-01-10','2003-01-18','2003-01-14','Shipped',NULL,181),
	(10103,'2003-01-29','2003-02-07','2003-02-02','Shipped',NULL,121),
	(10104,'2003-01-31','2003-02-09','2003-02-01','Shipped',NULL,141),
	(10105,'2003-02-11','2003-02-21','2003-02-12','Shipped',NULL,145),
	(10106,'2003-02-17','2003-02-24','2003-02-21','Shipped',NULL,278),
	(10107,'2003-02-24','2003-03-03','2003-02-26','Shipped','Customer requested to deliver in office address between 9:30 to 18:30 for this shipping',131),
	(10108,'2003-03-03','2003-03-12','2003-03-08','Shipped',NULL,385),
	(10109,'2003-03-10','2003-03-19','2003-03-11','Shipped','Customer requested for early delivery using Amazon Prime',486);
select * from orders;

drop table if exists order_details;
create table if not exists order_details(
	order_num int(11) not null,
    product_code varchar(15) not null,
    quantity_ordered int(11) not null,
    price_each decimal(10,2) not null,
    order_line_number smallint(6) not null,    -- bigint, smallint can also be used for space optimization
    primary key (order_num, product_code),
    key product_code (product_code),
    constraint `order_details_1`
    foreign key (order_num) references orders(order_num)
)engine=InnoDB default charset=latin1;
describe order_details;
insert into order_details values
	(10100,'S18_1749',30,'136.00',3),
	(10100,'S18_2248',50,'55.09',2),
	(10100,'S18_4409',22,'75.46',4),
	(10101,'S18_2325',25,'108.06',4),
	(10101,'S18_2795',26,'167.06',1),
	(10101,'S24_1937',45,'32.53',3),
	(10102,'S18_1342',39,'95.55',2),
	(10102,'S18_1367',41,'43.13',1),
	(10104,'S12_3148',34,'131.44',1),
	(10104,'S12_4473',41,'111.39',9),
	(10105,'S10_4757',50,'127.84',2),
	(10105,'S12_1108',41,'205.72',15),
	(10106,'S18_1662',36,'134.04',12),
	(10106,'S18_2581',34,'81.10',2);
select * from order_details;

select column_name, constraint_name, referenced_column_name, referenced_table_name
from information_schema.KEY_COLUMN_USAGE
where table_name="order_details";

set autocommit=0;

-- step 1: start a new transaction
start transaction;

-- step 2: get the latest order_number
select @order_num:=max(order_num)+1 from orders;

-- step 3: insert a new order for customer
insert into orders values (@order_num,"2023-03-01","2023-03-05","2023-03-08","In Process",null,1234);

-- step 4: insert order line items
insert into order_details values 
	(@order_num, "S18_1749", 30, "136", 1),
	(@order_num, "S18_2248", 50, "55.09", 2);

select count(*) from orders;

-- step 5: commit changes
commit;

select count(*) from orders;