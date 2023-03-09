-- views / materialized views
-- views are database objects
-- views are created over a database
-- views are like virtual table and doesnot store any data

create database if not exists viewsdb;
use viewsdb;

drop table if exists customer_data;
create table if not exists customer_data(
	customer_id varchar(20),
    customer_name varchar(60),
    phone bigint,
    email varchar(50),
    city_name varchar(50)
);

drop table if exists product;
create table if not exists product(
	product_id varchar(20),
    product_name varchar(50),
    `brand_company` varchar(60),
    price int
);

drop table if exists order_details;
create table if not exists order_details(
	order_id int,
    product_id varchar(20),
    quantity int,
    customer_id varchar(20),
    discount float,
    date_of_order date
);

insert into customer_data values
	('C1', 'Divya Parasher', 123456789321, 'parasherdivya@example.com', 'Mathura'),
	('C2', 'Mahad Ulah', 456544831568, 'ullahmahad@example.com', 'Bhopal'),
	('C3', 'Arya Pratap Singh', 93543168435, 'aryasingh@example.com', 'lucknow'),
	('C3', 'Atreya Bag', 78965168321, 'bagatreya@example.com', 'Vizag'),
	('C4', 'Mukund Sahu', 673218987351, 'mukund@example.com', 'Mumbai'),
	('C5', 'Parth Tyagi', 8989989899, 'parth@example.com', 'Kota');

insert into product values
    ('DF12321', 'Mouse', 'Dell', 19.37),
    ('AM12322', 'Laptop', 'Apple Inc.', 999.41),
	('MP12333', 'Books', 'Pustak Mahal', 5.19),
    ('12335M', 'Bottle', 'Milton', 29.35),
    ('SB12387I', 'Backpack', 'Sky Bags', 89.75),
    ('PT12389TS', 'Tshirt', 'Polo', 3.53);

insert into order_details values
	(1111, 'DF12321', 3, 'C2', 0.05, '2022-02-01'),
	(2122, 'AM12322', 2, 'C1', 0.25, '2022-02-02'),
	(3323, 'MP12333', 5, 'C1', 0.15, '2022-02-03'),
	(4447, '12335M', 2, 'C3', 0.10, '2022-02-04'),
	(5655, 'SB12387I', 3, 'C2', 0.10, '2022-02-05'),
	(6686, 'PT12389TS', 1, 'C4', 0.15, '2022-02-06');

-- write a query to show the order summary to be delivered to the client

select o.order_id, o.date_of_order, p.product_name, c.customer_name,
	   round((p.price*o.quantity)-((p.price*o.quantity)* discount),3) as cost
       from customer_data c inner join order_details o on o.customer_id=c.customer_id
							inner join product p on p.product_id=o.product_id;
                            
-- creating the view for the above query!^
-- in this we are not revealing the customer id by creating the view as another independent table. 
create view product_order_summary as
select o.order_id, o.date_of_order, p.product_name, c.customer_name,
	   round((p.price*o.quantity)-((p.price*o.quantity)* discount),3) as cost
       from customer_data c inner join order_details o on o.customer_id=c.customer_id
							inner join product p on p.product_id=o.product_id;
                            
-- display output for the created view
select * from product_order_summary;

-- show view summary
show create view product_order_summary;

-- security in view
-- create role username login access and password "login password"
-- -- Syntax: grant select on <view name> to <user name> 
grant select on product_order_summary to root;

-- security in view
-- hiding entire query / table name / used to generate view


-- CREATE OR REPLACE VIEW
-- cant change the column name or 
-- 				   column sequense or
-- 				   order of the displaying
-- but can add a new columns at the end

create or replace view product_order_summary as 
select o.order_id,o.date_of_order,c.customer_name,p.product_id,p.product_name,o.quantity,
	   round((p.price * o.quantity)-((p.price*o.quantity)*o.discount),3) as cost 
       from customer_data c join order_details o on (o.customer_id=c.customer_id) 
						    join product p on (p.product_id = o.product_id);


-- alter view
-- rename existing view columns with new columns
alter algorithm = merge
view product_order_summary as
select o.order_id,c.customer_name,o.date_of_order,p.product_id,p.product_name,o.quantity,
round((p.price * o.quantity)-((p.price*o.quantity)*o.discount),3) as cost
	from customer_data c join order_details o on (o.customer_id=c.customer_id) 
						 join product p on (p.product_id = o.product_id);
                     
select * from product_order_summary;

drop view product_order_summary;


-- update
create or replace view expensive_products as
	select * from product where price> 80;
    
select * from expensive_products;

set sql_safe_updates=0;

update expensive_products
set product_name = 'airpods pro', brand_company = 'apple',
price = 1000 where product_id='AM12322';

select * from expensive_products;