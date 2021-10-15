
-- build table
DROP TABLE IF EXISTS officer_and_allegationCount;
select t.officer_id, round(avg(allegation_per_year), 2) as avg_allegation_count
into officer_and_allegationCount
from (select officer_id, EXTRACT(YEAR FROM start_date) as file_year, count(distinct allegation_id) as allegation_per_year from data_officerallegation
group by officer_id, file_year) as t group by t.officer_id order by avg_allegation_count desc;


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

-- calculate and compare average salary
select avg(oias.salary), oias.year from officer_id_allegationCount_and_salary oias where oias.avg_allegation_count >= 6 group by oias.year;
select avg(oias.salary), oias.year from officer_id_allegationCount_and_salary oias group by oias.year;
-- compare average salary of officers with most complaints
select avg(oias.salary), oias.year from officer_id_allegationCount_and_salary oias where oias.avg_allegation_count between 6 and 8 group by oias.year;
select avg(oias.salary), oias.year from officer_id_allegationCount_and_salary oias where oias.avg_allegation_count between 8 and 10 group by oias.year;
select avg(oias.salary), oias.year from officer_id_allegationCount_and_salary oias where oias.avg_allegation_count>10 group by oias.year;
-- compare maximum salary of officers with most complaints
select max(oias.salary), oias.year from officer_id_allegationCount_and_salary oias where oias.avg_allegation_count >= 6 group by oias.year;
select max(oias.salary), oias.year from officer_id_allegationCount_and_salary oias where oias.avg_allegation_count < 6 group by oias.year;
-- compare minimum salary of officers with most complaints
select min(oias.salary), oias.year from officer_id_allegationCount_and_salary oias where oias.avg_allegation_count >= 6 group by oias.year;
select min(oias.salary), oias.year from officer_id_allegationCount_and_salary oias where oias.avg_allegation_count < 6 group by oias.year;
-- compare median salary of officers with most complaints
select PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY oias.salary), oias.year from officer_id_allegationCount_and_salary oias where oias.avg_allegation_count >= 6 group by oias.year;
select PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY oias.salary), oias.year from officer_id_allegationCount_and_salary oias where oias.avg_allegation_count < 6 group by oias.year;
-- compare variance salary of officers with most complaints
select variance(oias.salary), oias.year from officer_id_allegationCount_and_salary oias where oias.avg_allegation_count >= 6 group by oias.year;
select variance(oias.salary), oias.year from officer_id_allegationCount_and_salary oias where oias.avg_allegation_count < 6 group by oias.year;

-- find officers whose complaints is over 10
select officer_id from officer_and_allegationCount where  avg_allegation_count >= 10;
-- 13788,

-- create a table including officer_id, avg_allegation_count, allegation_per_year, salary_per_year, year
DROP TABLE IF EXISTS officer_id_and_allegationCount_year;
create table officer_id_and_allegationCount_year as
select officer_id, EXTRACT(YEAR FROM start_date) as file_year, count(distinct allegation_id) as allegation_per_year from data_officerallegation
group by officer_id, file_year order by allegation_per_year desc;

DROP TABLE IF EXISTS officer_id_allegationCount_and_salary_year;
create table officer_id_allegationCount_and_salary_year as
select oay.officer_id, oa.avg_allegation_count, oay.allegation_per_year, ds.salary as salary_per_year, ds.year
from officer_id_and_allegationCount_year oay
join data_salary ds on oay.officer_id = ds.officer_id and ds.year = oay.file_year
join officer_and_allegationCount oa on oa.officer_id = oay.officer_id
order by oa.avg_allegation_count desc;

-- checkout table
select * from officer_id_allegationCount_and_salary_year;

-- for officers with most complaints, their change of allegation # and average salary in each year:
select  avg(allegation_per_year) as avg_allegation_each_year, avg(salary_per_year) as avg_salary_each_year, year from officer_id_allegationCount_and_salary_year
where avg_allegation_count >= 6 group by year order by year;
select  avg(allegation_per_year) as avg_allegation_each_year, avg(salary_per_year) as avg_salary_each_year, year from officer_id_allegationCount_and_salary_year
where avg_allegation_count < 6 group by year order by year;
-- Compare the change of minimum salary of officers with most complaints or not in each year:
select min(salary_per_year) as avg_salary_each_year, year from officer_id_allegationCount_and_salary_year
where avg_allegation_count >= 6 group by year order by year;
select min(salary_per_year) as avg_salary_each_year, year from officer_id_allegationCount_and_salary_year
where avg_allegation_count < 6 group by year order by year;

-- checkout the officer whose salary over 100000 and their complaints.
select officer_id, avg_allegation_count, avg(salary_per_year)   from officer_id_allegationCount_and_salary_year
where salary_per_year > 100000 group by officer_id, avg_allegation_count, year order by avg_allegation_count desc;
-- result: 32166 as top

--checkout and compare the officer whose salary over 100000 and has most complaints with all officers with complaints below 6
select * from officer_id_allegationCount_and_salary_year where officer_id = 32166 order by year;

