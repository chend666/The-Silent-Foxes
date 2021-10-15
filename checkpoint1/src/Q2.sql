--Question 2
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
