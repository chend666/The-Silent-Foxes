--Question 4

--2005 and 2006 year
drop table new_2005;
drop table award_2005;
drop table complaint_2006;
drop table new_2006;
drop table award_2006;
drop table both_2006;
drop table both_2005_2006;
drop table output_2005_2;
drop table output_2006;

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

--2006 and 2007
drop table new_2006;
drop table award_2007;
drop table complaint_2007;
drop table new_2007;
drop table both_2007;
drop table both_2006_2007;
drop table output_2006_2;
drop table output_2007;

create table newC_2006 as
select officer_id from complaint_2006
where officer_id not in
(select award_2006.officer_id from award_2006);

create table award_2007 as
select officer_id from data_award
where EXTRACT(year FROM start_date) = 2007;

create table complaint_2007 as
select officer_id,incident_date from data_allegation
join data_officerallegation d on data_allegation.crid = d.allegation_id
where EXTRACT(year FROM incident_date) = 2007;

create table new_2007 as
select c.officer_id from newC_2006
join complaint_2007 c on newC_2006.officer_id = c.officer_id;

create table both_2007 as
select new_2007.officer_id from new_2007
join award_2007 a on new_2007.officer_id = a.officer_id;

create table both_2006_2007 as
select distinct b.officer_id from new_2007
join both_2007 b on new_2007.officer_id = b.officer_id;

create table output_2006_2 as
select b.officer_id,count(b.officer_id) from both_2006_2007
join newC_2006 b on both_2006_2007.officer_id = b.officer_id
group by b.officer_id
order by count(b.officer_id) DESC;

create table output_2007 as
select b.officer_id,count(b.officer_id) from both_2006_2007
join new_2007 b on both_2006_2007.officer_id = b.officer_id
group by b.officer_id
order by count(b.officer_id) DESC;

select a.officer_id,output_2006_2.count as count_2006, a.count as count_2007
from output_2006_2
join output_2007 a on output_2006_2.officer_id = a.officer_id;

select
(select sum(output_2006_2.count) as total_2006 from output_2006_2),
(select sum(output_2007.count) as total_2007 from output_2007);

--2007 and 2008
drop table newC_2007;
drop table award_2008;
drop table complaint_2008;
drop table new_2008;
drop table both_2008;
drop table both_2007_2008;
drop table output_2007_2;
drop table output_2008;

create table newC_2007 as
select officer_id from complaint_2007
where officer_id not in
(select award_2007.officer_id from award_2007);

create table award_2008 as
select officer_id from data_award
where EXTRACT(year FROM start_date) = 2008;

create table complaint_2008 as
select officer_id,incident_date from data_allegation
join data_officerallegation d on data_allegation.crid = d.allegation_id
where EXTRACT(year FROM incident_date) = 2008;

create table new_2008 as
select c.officer_id from newC_2007
join complaint_2008 c on newC_2007.officer_id = c.officer_id;

create table both_2008 as
select new_2008.officer_id from new_2008
join award_2008 a on new_2008.officer_id = a.officer_id;

create table both_2007_2008 as
select distinct b.officer_id from new_2008
join both_2008 b on new_2008.officer_id = b.officer_id;

create table output_2007_2 as
select b.officer_id,count(b.officer_id) from both_2007_2008
join newC_2007 b on both_2007_2008.officer_id = b.officer_id
group by b.officer_id
order by count(b.officer_id) DESC;

create table output_2008 as
select b.officer_id,count(b.officer_id) from both_2007_2008
join new_2008 b on both_2007_2008.officer_id = b.officer_id
group by b.officer_id
order by count(b.officer_id) DESC;

select a.officer_id,output_2007_2.count as count_2007, a.count as count_2008
from output_2007_2
join output_2008 a on output_2007_2.officer_id = a.officer_id;

select
(select sum(output_2007_2.count) as total_2007 from output_2007_2),
(select sum(output_2008.count) as total_2008 from output_2008);
