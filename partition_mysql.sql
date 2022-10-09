-- Partition
-- partition is nothing but creation of smaller chunks from a huge table. makes working easy with the table constraints.
create database partition_test;
use partition_test;

-- lets practice partition with some table.
create table course_1(
course_name varchar(50) ,
course_id int , 
course_title varchar(60),
corse_description varchar(60),
launch_date date,
course_fee int,
course_mentor varchar(60),
course_lauch_year int);

select * from course_1;
-- lets insert some datas to this table course_1

insert into course_1 values
('machine_learning' , 101 , 'ML', "this is ML course" ,'2019-07-07',3540,'sudhanshu',2019) ,
('aiops' , 101 , 'ML', "this is aiops course" ,'2019-07-07',3540,'sudhanshu',2019) ,
('dlcvnlp' , 101 , 'ML', "this is ML course" ,'2020-07-07',3540,'sudhanshu',2020) ,
('aws cloud' , 101 , 'ML', "this is ML course" ,'2020-07-07',3540,'sudhanshu',2020) ,
('blockchain' , 101 , 'ML', "this is ML course" ,'2021-07-07',3540,'sudhanshu',2021) ,
('RL' , 101 , 'ML', "this is ML course" ,'2022-07-07',3540,'sudhanshu',2022) ,
('Dl' , 101 , 'ML', "this is ML course" ,'2022-07-07',3540,'sudhanshu',2022) ,
('interview prep' , 101 , 'ML', "this is ML course" ,'2019-07-07',3540,'sudhanshu',2019) ,
('big data' , 101 , 'ML', "this is ML course" ,'2020-07-07',3540,'sudhanshu',2020) ,
('data analytics' , 101 , 'ML', "this is ML course" ,'2021-07-07',3540,'sudhanshu',2021) ,
('fsds' , 101 , 'ML', "this is ML course" ,'2022-07-07',3540,'sudhanshu',2022) ,
('fsda' , 101 , 'ML', "this is ML course" ,'2021-07-07',3540,'sudhanshu',2021) ,
('fabe' , 101 , 'ML', "this is ML course" ,'2022-07-07',3540,'sudhanshu',2022) ,
('java' , 101 , 'ML', "this is ML course" ,'2020-07-07',3540,'sudhanshu',2020) ,
('MERN' , 101 , 'ML', "this is ML course" ,'2019-07-07',3540,'sudhanshu',2019) ;

select * from course_1;
select * from course_1 where course_lauch_year = 2022;
-- in this above querry the comparison done b/w each and every row to find the year based on the condition. but when using the partitioning done in such a way
-- it will compare only with the year. a tablwe will be created internally and only compare with that table it self.
-- lets create another table and work with the partitioning.
create table course2(
course_name varchar(50),
course_id int(10),
course_title varchar(60),
course_desc varchar(80),
launch_date date,
course_fee int,
course_mentor varchar(60),
course_launch_year int)
partition by range (course_launch_year)(
partition p0 values less than (2019),
partition p1 values less than (2020),
partition p2 values less than (2021),
partition p3 values less than (2022),
partition p4 values less than (2023));
-- okey now lets insert some values to this table course2

insert into course2 values
('machine_learning' , 101 , 'ML', "this is ML course" ,'2019-07-07',3540,'sudhanshu',2019) ,
('aiops' , 101 , 'ML', "this is aiops course" ,'2019-07-07',3540,'sudhanshu',2019) ,
('dlcvnlp' , 101 , 'ML', "this is ML course" ,'2020-07-07',3540,'sudhanshu',2020) ,
('aws cloud' , 101 , 'ML', "this is ML course" ,'2020-07-07',3540,'sudhanshu',2020) ,
('blockchain' , 101 , 'ML', "this is ML course" ,'2021-07-07',3540,'sudhanshu',2021) ,
('RL' , 101 , 'ML', "this is ML course" ,'2022-07-07',3540,'sudhanshu',2022) ,
('Dl' , 101 , 'ML', "this is ML course" ,'2022-07-07',3540,'sudhanshu',2022) ,
('interview prep' , 101 , 'ML', "this is ML course" ,'2019-07-07',3540,'sudhanshu',2019) ,
('big data' , 101 , 'ML', "this is ML course" ,'2020-07-07',3540,'sudhanshu',2020) ,
('data analytics' , 101 , 'ML', "this is ML course" ,'2021-07-07',3540,'sudhanshu',2021) ,
('fsds' , 101 , 'ML', "this is ML course" ,'2022-07-07',3540,'sudhanshu',2022) ,
('fsda' , 101 , 'ML', "this is ML course" ,'2021-07-07',3540,'sudhanshu',2021) ,
('fabe' , 101 , 'ML', "this is ML course" ,'2022-07-07',3540,'sudhanshu',2022) ,
('java' , 101 , 'ML', "this is ML course" ,'2020-07-07',3540,'sudhanshu',2020) ,
('MERN' , 101 , 'ML', "this is ML course" ,'2019-07-07',3540,'sudhanshu',2019) ;
select * from course2;
select * from course2 where course_launch_year = 2020;
-- ther are some significant execution time when executing this above querry. row examined is 4, so when you are using partition with larger tables 
-- the execution time also the row examined is reducing significantly. internally the partition ll create sub table. pretty much important one 
-- working with larger tables for filteration purpose,.
select * from course_1 where course_lauch_year = 2022;
-- but here the execution time is more also the row examined in also more ex: row examined is 30
-- execute this above to filteration querries and look into the statistics. where you can find or get an idea about the execution time and row 
-- examined are reduced significantly where partition used in a querry.
select partition_name, table_name, table_rows from information_schema.partitions where table_name = 'course2';
select partition_name, table_name, table_rows from information_schema.partitions;
-- the main differences between flat table and partitioned table is, internally the partitioned table trying to create sub tables based on the partitions
-- the information_schema.partitions is an internally created table where the partitions ll be maintained inside by the system
-- why we have to maintain year wise partition? for example if you are going to maintain a data for 10 years, incase of the filtering operation 
-- it ll be optimised if u can search data by year wise thats y you have to maintain the partitioning while working with large dataset for optimization.
-- there are some types partitons are available. list, hash, range, key, columns, subpartitioning
-- partitioning ll only divide the dataset 