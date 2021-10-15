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
where year = 2008)
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
where EXTRACT(year FROM incident_date) = 2008 and is_officer_complaint=FALSE)
