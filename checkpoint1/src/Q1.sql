
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

-- | avg\_allegation\_count | salary |
-- | :--- | :--- |
-- | 10.7 | 57426 |
-- | 10.7 | 58572 |
-- | 10.7 | 63396 |
-- | 10.7 | 58572 |
-- | 10 | 55764 |
-- | 10 | 49548 |
-- | 10 | 66924 |
-- | 10 | 64662 |
-- | 10 | 53136 |
-- | 8.64 | 58572 |

-- 0 ~ 10+ (2)
-- 145118 -- 52698 -- 2922 -- 202 -- 8 -- 9

-- avg 
-- 1.7081373627193877

-- calculate average of allegation_coun, average of salary
select avg(oas.avg_allegation_count), avg(oas.salary)
from officer_allegationCount_and_salary oas

-- | avg | avg |
-- | :--- | :--- |
-- | 1.7081373627193877 | 75642.315455545216 |


-- calculate average of allegation_coun, average of salary, range of salary
select count(oas.avg_allegation_count), avg(oas.salary), max(oas.salary), min(oas.salary)
from officer_allegationCount_and_salary oas
where oas.avg_allegation_count >= 6;

-- count, avg, max, min
-- 219, 74363.315068493151,111474,42258

-- calculate median of salary
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY oas.salary)
from officer_allegationCount_and_salary oas;

-- medain
-- 75372

-- compare individual salary with median salary
select * from officer_allegationCount_and_salary oas,
(SELECT PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY oas.salary)
from officer_allegationCount_and_salary oas) temp
order by oas.avg_allegation_count desc;


