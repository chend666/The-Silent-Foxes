--select distinct rank from data_salary
--SELECT table_name FROM information_schema.tables;

--Question 2
--drop table if exists
drop table officer_complaint;
drop table number_complaint;
drop table officer_award;

--create table
create table officer_complaint as
select officer_id from data_allegation
join data_officerallegation daa on data_allegation.crid = daa.allegation_id
where is_officer_complaint = false;

create table number_complaint as
select officer_id,count(officer_id) as numofComplaints from officer_complaint
group by officer_id
order by count(officer_id) DESC;

create table officer_award as
    select distinct d.officer_id from data_award
join number_complaint d on d.officer_id = data_award.officer_id;

--Query to extract data
select * from officer_complaint; --total complaints
select count(*) as total_complaints from officer_complaint;
select * from number_complaint; --officer with complaint count
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

--Question 3
select
(select count(distinct officer_id) as disciplined_officer from data_officerallegation
where disciplined = true),
(select count(distinct d.officer_id) as disciplined_award_officer from data_officerallegation
join data_award d on d.officer_id = data_officerallegation.officer_id
where disciplined = true);

--Question 4
drop table complaint_2004;
drop table complaint_2005;
drop table award_2005;
drop table both_2005;
drop table both_2004_2005;


create table complaint_2004 as
select officer_id,incident_date from data_allegation
join data_officerallegation d on data_allegation.crid = d.allegation_id
where EXTRACT(year FROM incident_date) = 2004;

create table complaint_2005 as
select officer_id,incident_date from data_allegation
join data_officerallegation d on data_allegation.crid = d.allegation_id
where EXTRACT(year FROM incident_date) = 2005;

create table award_2005 as
select officer_id from data_award
where EXTRACT(year FROM start_date) = 2005;

create table both_2005 as
select complaint_2005.officer_id from complaint_2005
join award_2005 a on complaint_2005.officer_id = a.officer_id;

create table both_2004_2005 as
select distinct b.officer_id from complaint_2004
join both_2005 b on complaint_2004.officer_id = b.officer_id;

select * from both_2004_2005;

select b.officer_id,count(b.officer_id) from both_2004_2005
join both_2005 b on both_2004_2005.officer_id = b.officer_id
group by b.officer_id
order by count(b.officer_id) DESC;

select b.officer_id,count(b.officer_id) from both_2004_2005
join complaint_2004 b on both_2004_2005.officer_id = b.officer_id
group by b.officer_id
order by count(b.officer_id) DESC;
