## Checkpoint 1

### Q1 ###

What is the statistics(mean, median, range..) of salary for the officers with the most complaints?

-- create a table including officer_id, avg_allegation_count to check out officers with most complaints;
```
DROP TABLE IF EXISTS officer_and_allegationCount;
select t.officer_id, round(avg(allegation_per_year), 2) as avg_allegation_count
into officer_and_allegationCount
from (select officer_id, EXTRACT(YEAR FROM start_date) as file_year, count(distinct allegation_id) as allegation_per_year from data_officerallegation
group by officer_id, file_year) as t group by t.officer_id order by avg_allegation_count desc;
```

-- create a table including officer_id, avg_allegation_count, salary_per_year, year 
```
DROP TABLE IF EXISTS officer_allegationCount_and_salary;
create table officer_allegationCount_and_salary as
select oa.avg_allegation_count, ds.salary
from officer_and_allegationCount oa
join data_salary ds on oa.officer_id = ds.officer_id
order by oa.avg_allegation_count desc;

select * from officer_allegationCount_and_salary limit 10;

DROP TABLE IF EXISTS officer_id_allegationCount_and_salary;
create table officer_id_allegationCount_and_salary as
select oa.officer_id, oa.avg_allegation_count, ds.salary, ds.year
from officer_and_allegationCount oa
join data_salary ds on oa.officer_id = ds.officer_id
order by oa.avg_allegation_count desc;

select * from officer_id_allegationCount_and_salary;
```
-- to checkout average salary, median salary, max salary, min salary and variacne salary in each year and compare these results among officers with most complaints, whole officers and officers with less complaints;

-- to checkout the officers whose salary over 100000 and their number of complaints;

-- to checkout and compare the officer whose salary over 100000 and has most complaints with the officers with less complaints 

### Q2 ###

What percentage of total complaints are these officers who have received an honor mention or award responsible for?
```
--drop table if exists
drop table officer_complaint;
drop table number_complaint;
drop table officer_award;

--officers who receive complaints
create table officer_complaint as
select officer_id from data_allegation
join data_officerallegation daa on data_allegation.crid = daa.allegation_id
where is_officer_complaint = false;

--count total number of complaints for each officer
create table number_complaint as
select officer_id,count(officer_id) as numofComplaints from officer_complaint
group by officer_id
order by count(officer_id) DESC;

--officers,who receive complaints, get awards
create table officer_award as
    select distinct d.officer_id from data_award
join number_complaint d on d.officer_id = data_award.officer_id;

--Query to extract data
select * from officer_complaint;
select count(*) as total_complaints from officer_complaint;
select * from number_complaint;
select count(*) as officer_with_complaints from number_complaint;
select count(distinct d.officer_id) as award_officer_with_complaints from data_award
join number_complaint d on d.officer_id = data_award.officer_id;

--Query for Question 2 output:
select (select count(*) as total_complaints from officer_complaint),
       (select sum(numofComplaints) as total_complaints_officer_with_awards from officer_award
join number_complaint oc on officer_award.officer_id = oc.officer_id),
       (select count(*) as officer_with_complaints from number_complaint),
       (select count(distinct d.officer_id) as award_officer_with_complaints from data_award
join number_complaint d on d.officer_id = data_award.officer_id);
```

### Q3 ###

What is the percentage of officers who were disciplined in an allegation get an honor mention or awards?

select query for:

--officers who were disciplined in a complaint

--officers who were disciplined in a complaint,get awards
```
select
(select count(distinct officer_id) as disciplined_officer from data_officerallegation
where disciplined = true),
(select count(distinct d.officer_id) as disciplined_award_officer from data_officerallegation
join data_award d on d.officer_id = data_officerallegation.officer_id
where disciplined = true);
```

### Q4 ###

Can the total number or frequency of complaints received by the officer be reflected by his/her career advancement(whether an officer holding an award in a year receives less or no complaint)?

--use following query to view answers for year 2005 and 2006

--if you want to view other years shown in our findings, please find in sql file
```
--officers who receive complaints in 2005
create table complaint_2005 as
select officer_id,incident_date from data_allegation
join data_officerallegation d on data_allegation.crid = d.allegation_id
where EXTRACT(year FROM incident_date) = 2005;

--officers who receive awards in 2005
create table award_2005 as
select officer_id from data_award
where EXTRACT(year FROM start_date) = 2005;

--officers who receive complaints but no awards in 2005
create table new_2005 as
select officer_id from complaint_2005
where officer_id not in
(select award_2005.officer_id from award_2005);

--officers who receive complaints in 2006
create table complaint_2006 as
select officer_id,incident_date from data_allegation
join data_officerallegation d on data_allegation.crid = d.allegation_id
where EXTRACT(year FROM incident_date) = 2006;

--officers, who receive complaints but no awards in 2005, receive complaints in 2006
create table new_2006 as
select c.officer_id from new_2005
join complaint_2006 c on new_2005.officer_id = c.officer_id;

--officers who get awards in 2006
create table award_2006 as
select officer_id from data_award
where EXTRACT(year FROM start_date) = 2006;

--officers, who receive complaints but no awards in 2005, receive both complaints and awards in 2006
create table both_2006 as
select new_2006.officer_id from new_2006
join award_2006 a on new_2006.officer_id = a.officer_id;

--officers, who receive complaints, get awards in 2006 but not in 2005
create table both_2005_2006 as
select distinct b.officer_id from new_2005
join both_2006 b on new_2005.officer_id = b.officer_id;

--count number of complaints received by each officer
create table output_2005_2 as
select b.officer_id,count(b.officer_id) from both_2005_2006
join new_2005 b on both_2005_2006.officer_id = b.officer_id
group by b.officer_id
order by count(b.officer_id) DESC;

create table output_2006 as
select b.officer_id,count(b.officer_id) from both_2005_2006
join new_2006 b on both_2005_2006.officer_id = b.officer_id
group by b.officer_id
order by count(b.officer_id) DESC;

--use this query to see the comparison of number of complaints for each complaint in each year
select a.officer_id,output_2005_2.count as count_2005, a.count as count_2006
from output_2005_2
join output_2006 a on output_2005_2.officer_id = a.officer_id;

--get total number of complaints in 2005 and 2006 for officers described above
select
(select sum(output_2005_2.count) as total_2005 from output_2005_2),
(select sum(output_2006.count) as total_2006 from output_2006);
```

### Q5 ###

Is there a relationship between the change of frequency of an officer who gets allegations and the change of his/her salary(if any)?
```
-- pull out table
SELECT table_name FROM information_schema.tables;
-- Pull out AVG salary for 2005
SELECT
(SELECT avg(salary) as AVG_2005 from data_salary
where year = 2005),
-- Pull out AVG salary for 2006
(SELECT avg(salary) as AVG_2006 from data_salary
where year = 2006),
-- Pull out AVG salary for 2007
(SELECT avg(salary) as AVG_2007 from data_salary
where year = 2007),
-- Pull out AVG salary for 2008
(SELECT avg(salary) as AVG_2008 from data_salary
where year = 2008);
---------------------------------------------------
---------------------------------------------------
SELECT
-- Pull out SUM allegation for 2005 by civilian
(SELECT count(incident_date) as sum_2005 from data_allegation
where EXTRACT(year FROM incident_date) = 2005 and is_officer_complaint=FALSE),
-- Pull out SUM allegation for 2006 by civilian
(SELECT count(incident_date) as sum_2006 from data_allegation
where EXTRACT(year FROM incident_date) = 2006 and is_officer_complaint=FALSE),
-- Pull out SUM allegation for 2007 by civilian
(SELECT count(incident_date) as sum_2007 from data_allegation
where EXTRACT(year FROM incident_date) = 2007 and is_officer_complaint=FALSE),
-- Pull out SUM allegation for 2008 by civilian
(SELECT count(incident_date) as sum_2008 from data_allegation
where EXTRACT(year FROM incident_date) = 2008 and is_officer_complaint=FALSE);
```
