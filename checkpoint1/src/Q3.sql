--Question 3

--officers who were disciplined in a complaint
--officers,who were disciplined in a complaint,get awards
select
(select count(distinct officer_id) as disciplined_officer from data_officerallegation
where disciplined = true),
(select count(distinct d.officer_id) as disciplined_award_officer from data_officerallegation
join data_award d on d.officer_id = data_officerallegation.officer_id
where disciplined = true);
