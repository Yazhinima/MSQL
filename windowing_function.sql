-- two types of windowing function
-- aggregated windowing function, 
-- analytical windowing function

create database window_function;
use window_function;

create table students(
student_id int,
student_batch varchar(40),
student_name varchar(40),
student_stream varchar(40),
student_mark int,
student_mail varchar(60));

-- lets create some dataset
insert into students values(101, 'FSDA', 'john', 'EE', 80, 'john@abc.com');
insert into students values(102, 'FSDA', 'vivek', 'EE', 81, 'vivek@abc.com');
insert into students values(103, 'FSDS', 'deera', 'cs', 83, 'deera@abc.com');
insert into students values(104, 'FSDS', 'mithun', 'me', 60, 'mithun@abc.com');
insert into students values(105, 'FSEE', 'manish', 'ec', 70, 'manish@abc.com');
insert into students values(106, 'FSDA', 'jesan', 'me', 89, 'jesan@abc.com');
insert into students values(107, 'FSDS', 'jinesh', 'cs', 80, 'jinesh@abc.com');
insert into students values(108, 'FSDS', 'mike', 'cicil', 90, 'mike@abc.com');
insert into students values(109, 'FSDS', 'lore', 'ms', 76, 'lore@abc.com');
insert into students values(110, 'FSDA', 'kajal', 'EEE', 50, 'kajal@abc.com');
insert into students values(111, 'FSDA', 'sneha', 'EEE', 80, 'sneha@abc.com');
insert into students values(112, 'FSDA', 'kajur', 'EEE', 70, 'kajur@abc.com');
insert into students values(113, 'FSDA', 'eshav', 'EEE', 90, 'eshav@abc.com');
delete from students where student_name = 'john';

select * from students;

-- aggregation window function
-- eg:- sum, mean, max, avg, groupby
select student_batch, sum(student_mark) from students group by student_batch;
select student_batch, min(student_mark) from students group by student_batch;
select student_batch, max(student_mark) from students group by student_batch;
select student_batch, avg(student_mark) from students group by student_batch;
select count(student_batch) from students;
select count(distinct student_batch) from students;
select student_batch, count(student_id) from students group by student_batch;
--------------------------------------------------------------------------------------------------------------------------------------------------

-- analytical window function
-- rank, row_number,
-- give the rank nbased on the marks from students table.

-- some example of not using window function
select student_name, student_mark from students where student_mark in 
(select max(student_mark) from students where student_batch = 'fsda');

select student_name, student_mark from students where student_batch = 'FSDA' order by student_mark desc limit 4;
-- eshav	90
-- jesan	89
-- vivek	81
-- sneha	80
select student_name, student_mark from students where student_batch = 'FSDA' order by student_mark desc limit 1,1;
-- jesan	89
select student_name, student_mark from students where student_batch = 'FSDA' order by student_mark desc limit 2,1;
-- vivek	81
select student_name, student_mark from students where student_batch = 'FSDA' order by student_mark desc limit 1,2;
-- jesan	89
-- vivek	81
select * from students where student_batch = 'fsda' order by student_mark desc limit 2,3;
select * from students where student_batch = 'fsda' order by student_mark desc;
select * from students where student_mark in (
select min(student_mark) from (
select distinct(student_mark) from students where student_batch = 'fsda' order by student_mark desc limit 3) as top);
-- basically the limit 1,1 try to fetch the second record out of the entire output based on the filter.
-- limt 3,1 means it will reach to the 3rd index and pull out ine record
-- limit 1,3 means it will reach to the 1st index and pull out 3 records. indexing from0,1,2,3..
--------------------------------------------------------------------------------------------------------------------------------------------
-- using analytical window function
select student_id, student_name, student_batch, student_stream, student_mark, row_number() over(order by student_mark) as 'row_number' from students;
select student_id, student_name, student_batch, student_stream, student_mark, row_number() over(partition by student_batch order by student_mark) as 'row_number' from students;
select * from (select student_id, student_name, student_batch, student_stream, student_mark, 
row_number() over(partition by student_batch order by student_mark desc) as 'row_num' from students) as test where row_num = 1;
-- 113	eshav	FSDA	EEE	90	1
-- 108	mike	FSDS	cicil	90	1
-- 105	manish	FSEE	ec	70	1

-- but in this row_number also we have some issue in retreving the correct output. 
-- there are two records have the same highest value but it is only retreving one of the two but we need both. so to solve this we are using rank window function

select student_id, student_name, student_batch, student_mark, rank() over(order by student_mark) as row_rank from students;
-- 110	kajal	FSDA	50	1
-- 104	mithun	FSDS	60	2
-- 105	manish	FSEE	70	3
-- 112	kajur	FSDA	70	3
-- 109	lore	FSDS	76	5
-- 107	jinesh	FSDS	80	6
-- 111	sneha	FSDA	80	6
-- 101	john	FSDA	80	6
-- 102	vivek	FSDA	81	9
-- 103	deera	FSDS	83	10
-- 106	jesan	FSDA	89	11
-- 108	mike	FSDS	90	12
-- 113	eshav	FSDA	90	12
-- now the issue got solved lets try to pull the 1st rank from the record in each batch

select * from
(select student_id, student_name, student_batch, student_mark, rank() over(partition by student_batch order by student_mark desc)as row_rank from students) as test where row_rank = 1;
-- 113	eshav	FSDA	90	1
-- 108	mike	FSDS	90	1
-- 105	manish	FSEE	70	1
select student_id, student_name, student_batch, student_mark, rank() over(partition by student_batch order by student_mark desc) as row_rank from students;
-- 113	eshav	FSDA	90	1
-- 106	jesan	FSDA	89	2
-- 102	vivek	FSDA	81	3
-- 111	sneha	FSDA	80	4
-- 101	john	FSDA	80	4
-- 112	kajur	FSDA	70	6
-- 110	kajal	FSDA	50	7
-- 108	mike	FSDS	90	1
-- 103	deera	FSDS	83	2
-- 107	jinesh	FSDS	80	3
-- 109	lore	FSDS	76	4
-- 104	mithun	FSDS	60	5
-- 105	manish	FSEE	70	1
select * from (select student_id, student_name, student_batch, student_mark,row_number() over(partition by student_batch order by student_mark desc) as 'row_number',
 rank() over(partition by student_batch order by student_mark desc) as row_rank from students) as test where row_rank = 1;
select * from (select student_id, student_name, student_batch, student_mark,row_number() over(partition by student_batch order by student_mark desc) as 'row_number',
 rank() over(partition by student_batch order by student_mark desc) as row_rank from students) as test where row_rank = 2;
 select * from (select student_id, student_name, student_batch, student_mark,row_number() over(partition by student_batch order by student_mark desc) as 'row_number',
 rank() over(partition by student_batch order by student_mark desc) as row_rank from students) as test where row_rank = 3;
select * from (select student_id, student_name, student_batch, student_mark,row_number() over(partition by student_batch order by student_mark desc) as 'row_number',
 rank() over(partition by student_batch order by student_mark desc) as row_rank from students) as test where row_rank = 4;

-- in this rank() also there is some problem if u see the result we can notice two 3s after that rank moved to 5 
-- instead of 4 so to solve this we using dense_rank()

select * from (select student_id, student_name, student_batch, student_mark,row_number() over(partition by student_batch order by student_mark desc) as 'row_number',
 dense_rank() over(partition by student_batch order by student_mark desc) as row_denserank from students) as test where row_denserank = 3;
select student_id, student_name, student_batch, student_mark,row_number() over(partition by student_batch order by student_mark desc) as 'row_number',
 dense_rank() over(partition by student_batch order by student_mark desc) as row_denserank from students;
--  113	eshav	FSDA	90	1	1
-- 106	jesan	FSDA	89	2	2
-- 102	vivek	FSDA	81	3	3
-- 111	sneha	FSDA	80	4	4
-- 101	john	FSDA	80	5	4
-- 112	kajur	FSDA	70	6	5
-- 110	kajal	FSDA	50	7	6
-- 108	mike	FSDS	90	1	1
-- 103	deera	FSDS	83	2	2
-- 107	jinesh	FSDS	80	3	3
-- 109	lore	FSDS	76	4	4
-- 104	mithun	FSDS	60	5	5
-- 105	manish	FSEE	70	1	1

select * from (select student_id, student_name, student_batch, student_mark,row_number() over(partition by student_batch order by student_mark desc) as 'row_number',
 dense_rank() over(partition by student_batch order by student_mark desc) as row_denserank from students) as test where row_denserank in (1,2,3);
-- WRAP UP--------------------------------------------------------------------------------------------------------------------------------
 
