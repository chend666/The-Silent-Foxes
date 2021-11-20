import networkx as nx
import matplotlib.pyplot as plt
import psycopg2
import numpy as np
import random
import seaborn as sns

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

color = sns.color_palette("Spectral", 18)

cur.execute("""select id,ceil(current_salary/10000)*10000 as salary,complaint_percentile,last_unit_id from data_officer
where current_salary is not NULL and complaint_percentile is not NULL and last_unit_id is not NULL""")

result = cur.fetchall()

salary = []

for i in result:
  if i[1] not in salary:
    salary.append(i[1])

salary.sort(reverse=True)
print(salary)

G = nx.Graph()
fig = plt.figure(figsize=(80, 60), dpi=80)

isCenter = True
center = 0
temp = []
color_map = []
for i in result:
  if i[2] == 0:
    if isCenter:
      center = i[0]
      isCenter = False
      temp.append(center)
    else:
      G.add_edge(center,i[0])
      temp.append(i[0])
    color_map.append(color[salary.index(i[1])])

isCenter = True
center = 0
temp1 = []
color_map1 = []
for i in result:
  if i[2] >0 and i[2] < 20:
    if isCenter:
      center = i[0]
      isCenter = False
      temp1.append(center)
    else:
      G.add_edge(center,i[0])
      temp1.append(i[0])
    color_map1.append(color[salary.index(i[1])])

isCenter = True
center = 0
temp2 = []
color_map2 = []
for i in result:
  if i[2] >20 and i[2] < 40:
    if isCenter:
      center = i[0]
      isCenter = False
      temp2.append(center)
    else:
      G.add_edge(center,i[0])
      temp2.append(i[0])
    color_map2.append(color[salary.index(i[1])])

isCenter = True
center = 0
temp3 = []
color_map3 = []
for i in result:
  if i[2] >40 and i[2] < 60:
    if isCenter:
      center = i[0]
      isCenter = False
      temp3.append(center)
    else:
      G.add_edge(center,i[0])
      temp3.append(i[0])
    color_map3.append(color[salary.index(i[1])])

isCenter = True
center = 0
temp3 = []
color_map3 = []
for i in result:
  if i[2] > 40 and i[2] < 60:
    if isCenter:
      center = i[0]
      isCenter = False
      temp3.append(center)
    else:
      G.add_edge(center,i[0])
      temp3.append(i[0])
    color_map3.append(color[salary.index(i[1])])

isCenter = True
center = 0
temp4 = []
color_map4 = []
for i in result:
  if i[2] >60 and i[2] < 80:
    if isCenter:
      center = i[0]
      isCenter = False
      temp4.append(center)
    else:
      G.add_edge(center,i[0])
      temp4.append(i[0])
    color_map4.append(color[salary.index(i[1])])

isCenter = True
center = 0
temp5 = []
color_map5 = []
for i in result:
  if i[2] >80 and i[2] < 100:
    if isCenter:
      center = i[0]
      isCenter = False
      temp5.append(center)
    else:
      G.add_edge(center,i[0])
      temp5.append(i[0])
    color_map5.append(color[salary.index(i[1])])

pos = nx.spring_layout(G,iterations = 10)
nx.draw_networkx(G.subgraph(temp),pos = pos,node_color = color_map,with_labels = False,node_size = 30)
nx.draw_networkx(G.subgraph(temp1),pos = pos,node_color = color_map1,with_labels = False,node_size = 30)
nx.draw_networkx(G.subgraph(temp2),pos = pos,node_color = color_map2,with_labels = False,node_size = 30)
nx.draw_networkx(G.subgraph(temp3),pos = pos,node_color = color_map3,with_labels = False,node_size = 30)
nx.draw_networkx(G.subgraph(temp4),pos = pos,node_color = color_map4,with_labels = False,node_size = 30)
nx.draw_networkx(G.subgraph(temp5),pos = pos,node_color = color_map5,with_labels = False,node_size = 30)
plt.show()
    

print('OK')
