## Checkpoint 4 Graph Analytics

### Q1 Is there a relationship between the clusters of officers with most complaints and their salary( and awards received)?

```
How to run:
1. In src/Q1, 
  open the terminal, and run the command 'python3 cp4-1.py'
You will see the network graph we have for our Question 1.

Note: Make sure you have all following modules installed:

networkx
matplotlib
psycopg2
numpy
seaborn

Running the current 'cp4-1.py' will give you result of first part of Question 1 we have in 'findings.pdf'
The second part of Question 1 is to add more edges based on working area, which is last_unit_id in data_officer from CPDB
As mentioned in comments of code, adding more edges by using last_unit_id will take a long time to run, since there are too many nodes and we are going to check and find relationship for each of them. 
You can choose whether to test it or not just by uncommenting the related lines of code.
```
### Q2 Can we identify clusters of officers who are likely to be co-accused by factors related to their career, like working environment, salary, rank? 

```
In src/Q2:
How to run:
1. Network showing connection of officers who are in the same last unit
Open and run 'getCombination.ipynb' in Jupter Notebook as Python language

2. Network showing clusters of officers with their current salary, also regarding officers who are in the same last unit have connections
Open and run 'officer_salary_network.ipynb' in Jupter Notebook as Python language

3. Network of officers with factor rank and award
Open and run 

The 'Result_2.csv' is salary and last_unit_id of officers we use in following steps to create network
The 'Result_6.csv' is rank and last_unit_id of officers
```

