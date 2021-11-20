import networkx as nx
import matplotlib.pyplot as plt
import psycopg2
import numpy as np
import random
# G = nx.petersen_graph()

# subax1 = plt.subplot(121)

# nx.draw(G, with_labels=True, font_weight='bold')

# subax2 = plt.subplot(122)

# nx.draw_shell(G, nlist=[range(5, 10), range(5)], with_labels=True, font_weight='bold')

# plt.show()  

#subax1 = plt.subplot(121)

#plt.show()  

conn = psycopg2.connect(host="codd01.research.northwestern.edu", port = 5432, database="postgres", user="cpdbstudent", password="DataSci4AI")
cur = conn.cursor()
cur.execute("""select id,last_unit_id
from data_officer
where last_unit_id is not NULL""")
officers = cur.fetchall()
cur.execute("""select distinct last_unit_id
from data_officer
where last_unit_id is not NULL""")
q2 = cur.fetchall()
unit_id = []
for i in q2: 
  unit_id.append(i[0])

color = ["#"+''.join([random.choice('0123456789ABCDEF') for j in range(6)])
             for i in range(len(unit_id))]

# officer_1 = []
# for i in officers:
#   if i[1] == unit_id[0]:
#     officer_1.append(i[0])

# officer_2 = []
# for i in officers:
#   if i[1] == unit_id[1]:
#     officer_2.append(i[0])

# G = nx.Graph()
# fig = plt.figure(figsize=(80, 40))

# for i in range(0,10):
#   isCenter = True
#   center = 0
#   for j in range(0,len(officers)):
#     if officers[j][1] == unit_id[i]:
#       if isCenter:
#         center = officers[j][0]
#         isCenter = False
#       else:
#         G.add_edge(center,officers[j][0])

# pos = nx.spring_layout(G,iterations = 20)
# for i in range(0,10):
#   temp = []
#   for j in range(0,len(officers)):
#     if officers[j][1] == unit_id[i]:
#       temp.append(officers[j][0])
#   nx.draw_networkx(G.subgraph(temp),pos = pos,with_labels = False,node_color = color[i],node_size = 60)

# plt.show()

cur.execute("""select id,ceil(current_salary/10000)*10000 as salary,complaint_percentile from data_officer
where current_salary is not NULL and complaint_percentile is not NULL""")

result = cur.fetchall()

salary = []

for i in result:
  if i[1] not in salary:
    salary.append(i[1])

print(salary)
