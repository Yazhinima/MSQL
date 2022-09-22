-- Primary key foreign key
create database key_prim;
use key_prim;
create table learn_prim(
course_id int not null,
course_name varchar(60),
course_status varchar(40),
num_of_enroll int,
primary key (course_id));

insert into learn_prim values(01, 'FSDA', 'Active', 100);
insert into learn_prim values(02, 'FSDS', 'NotActive', 100);
select * from learn_prim;

create table students(
student_id int,
course_name varchar(60),
student_mail varchar(60),
student_status varchar(40),
course_id1 int,
foreign key (course_id1) references learn_prim(course_id));

insert into students values(101, 'FSDA', 'student1@gmail.com', 'active', 05);
-- the child table's course_id shold match to the parent table's course id.
insert into students values(101, 'FSDA', 'student1@gmail.com', 'active', 01);
select * from students;

create table payment(
course_name varchar(60),
course_id int,
course_live_status varchar(40),
course_launch_date varchar(40),
foreign key (course_id) references learn_prim(course_id));

insert into payment values('FSDA', 01, 'not-active', '7th aug');
insert into payment values('FSDA', 01, 'not-active', '7th aug');
insert into payment values('FSDA', 01, 'not-active', '7th aug');

create table class(
course_id int,
class_name varchar(40),
class_topic varchar(60),
class_duration int,
primary key (course_id),
foreign key (course_id) references learn_prim(course_id));

-- droping the primary key in a table
alter table learn_prim drop primary key;
-- 0	this is the error when you trying to drop primary key in a table--->
--  2	09:28:25	alter table learn_prim drop primary key	Error Code: 1553. Cannot drop index 'PRIMARY': needed in a foreign key constraint	0.031 sec

alter table learn_prim add constraint test_prim primary key(course_id, course_name);
-- error:---> 0	3	09:35:38	alter table learn_prim add constraint test_prim primary key(course_id, course_name)	Error Code: 1068. Multiple primary key defined	0.000 sec
-- can not define multiple primary key for a table.
drop table learn_prim;
-- error:---> 0	4	09:43:10	drop table learn_prim	Error Code: 3730. Cannot drop table 'learn_prim' referenced by a foreign key constraint 'students_ibfk_1' on table 'students'.	0.015 sec
-- can not able to drop the parent table unless dropping child table.
drop table class;
-- 3	5	09:44:37	drop table class	0 row(s) affected	0.468 sec
-- you can drop the child table. if u want to drop the parent table u should drop all the child table then try droping the parent table.


create table test_multipleprimarykey(
id int not null,
`name` varchar(60),
email_id varchar(60),
mobile_number varchar(10),
address varchar(60));

-- you can alter table and add primary key after creating the table
alter table test_multipleprimarykey add primary key(id);
-- okey lets create multiple primary key. first drop the existing primary key
alter table test_multipleprimarykey drop primary key;
alter table test_multipleprimarykey add constraint primary key(id, email_id);

create table parent(
id int not null,
primary key(id));

create table child(
id int,
parent_id int,
foreign key (parent_id) references parent(id));

insert into parent values(1);
insert into parent values(3), (2);
select * from parent;
insert into child values (1,2);
select * from child;
insert into child values (2,2);
insert into child values(0,1);
delete from parent where id=1;
-- error:--> 0	29	10:10:00	delete from parent where id=1	Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`key_prim`.`child`, CONSTRAINT `child_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `parent` (`id`))	0.062 sec
-- incaase u want to do the deletion on parent table though table connected with child then u need to use casecade when creating the table. lets see that.

drop table child;
create table child(
id int,
parent_id int,
foreign key (parent_id) references parent(id) on delete cascade);
insert into child values(1,2),(0,1),(2,3);
select * from child;
delete from parent where id = 1;
-- 3	34	10:19:52	delete from parent where id = 1	1 row(s) affected	0.157 sec
-- this time after adding constraint cascade in the table creation we can able to delete from the parent table with out droping the child.

update parent set id = 3 where id = 2;
-- 0	36	11:24:58	update parent set id = 3 where id = 2	Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`key_prim`.`child`, CONSTRAINT `child_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `parent` (`id`) ON DELETE CASCADE)	0.078 sec

drop table child;
create table child(
id int,
parent_id int,
foreign key (parent_id) references parent(id) on update cascade);
update parent set id = 4 where id = 2;
select * from parent;
select * from child;
-- you can also add on update cascade and on dete cascade together.

create table child1(
id int,
parent_id int,
foreign key (parent_id) references parent(id) on update cascade on delete cascade);
