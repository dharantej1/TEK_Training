create database if not exists norm;
use norm;

drop table if exists emptable;
create table if not exists emptable(
	employee_id int , employee_name varchar(50), city varchar(50), department varchar(30) not null
);

insert into emptable values 
	(101, "John","New York","Sales"),
    (101, "John","New York","Purchase"),
    (102, "Parvez","Delhi","Finance"),
    (103, "Gwen","California","Logistics"),
    (103, "Gwen","California","Admin");
select * from emptable;
insert into emptable(employee_id, employee_name, city) values (104,"Priyanka","Mumbai");

-- 1NF - 1 Normal Form
drop table if exists emptable2;
create table if not exists emptable2(
	emp_id int, emp_name varchar(50), contact varchar(50),
    constraint `primary_constraint` primary key(emp_id)
);
insert into emptable2 values 
	(101, "John","123 , 456"),
    (102, "Mickey","101112"),
    (103, "Parvez","121314"),
    (104, "Gwen","151617"),
    (105, "Dharan","181920");
select * from emptable2;
    
DELIMITER $$
USE `norm`$$
CREATE DEFINER = `root`@`localhost` PROCEDURE `new_procedure` (out var int)
BEGIN
	select count(*) into var from emptable2 where contact like "% , %";
END$$
DELIMITER ;

set @var=0;
call norm.new_procedure(@var);
select @var;

