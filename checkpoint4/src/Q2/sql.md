#### sql for officer with same last unit id
```
select last_unit_id, id from data_officer where last_unit_id is not null
```

#### sql for salary 
```
select data_salary.salary, data_officer.last_unit_id from data_salary
join data_officer on data_officer.id = data_salary.id
where data_officer.last_unit_id is not null

result_2.csv
```

#### sql for rank 
```
select data_award.rank, data_officer.last_unit_id from data_award
join data_officer on data_officer.id = data_award.id
where data_officer.last_unit_id is not null and data_award.id is not null

result_6.csv
```
