SELECT count(id), EXTRACT(YEAR from start_date) as year , EXTRACT(MONTH from start_date) as month
from data_officerallegation
group by year, month
Order by year, month;