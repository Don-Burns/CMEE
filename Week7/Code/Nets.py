#!/bin/usr/env python3
# Desc: A script to build a network of the QMEE CDT collaboration network.  Based on Nets.R

#!/bin/usr/env python3

"""
A script to build a network of the QMEE CDT collaboration network.  Based on Nets.R.
"""

__appname__ = 'Nets.py'
__author__ = 'Donal Burns (db319@ic.ac.uk)'
__version__ = '0.0.1'
__liscense__ = "Apache 2"
###############################################################
import scipy as sc
import pandas as pans
import networkx as nx 
import matplotlib.pylab as p

### read in data
links = pans.read_csv('../data/QMEE_Net_Mat_edges.csv', header = 0)
nodes = pans.read_csv('../data/QMEE_Net_Mat_nodes.csv', header = 0) ## row names are col 0
nodeList = list(links.columns) # find header names for links
AdjList = [None] * ((len(links))*(len(links)-1)) #adjecency list for later, -1 for diagonals .  each Node has n-1 interactions, where n is number of nodes.  are listed in same order as found in links and in AdjListKey

AdjList = []
for r in range(len(links)):
    for c in range(len(links)):
        if r == c: # to skip the diagonal
            None

        else:   #assign the value with direction

            tmp = links.iloc[r,c]
            if tmp != 0:
                AdjList.append((links.columns[r],  links.columns[c], tmp))


p.ioff()


pos = nx.circular_layout(nodeList)

G = nx.DiGraph()
G.add_nodes_from(nodes["id"])
G.add_weighted_edges_from(tuple(AdjList))


## find and assign node colours based on type of institution
nodeCols = []

for i in nodes["Type"]:
    if i == "Hosting Partner":
        nodeCols.append("green")
    elif i == "Non-Hosting Partners":
        nodeCols.append("red")
    elif i == "University":
        nodeCols.append("blue")
    else:
        print("You done goofed with assigning colours buuuuuuuuudy =D")




f = p.figure() 


## for legend
ax = f.add_subplot(1,1,1)

ax.plot([0],[0], color = "green", label= "Hosting Partner")
ax.plot([0],[0], color = "red", label= "Non-Hosting Partners")
ax.plot([0],[0], color = "blue", label= "University")


# draw the network
nx.draw_networkx(G, node_size=2000, arrowstyle= ('Fancy, head_width = 0.5, head_length = 0.6, tail_width=0.2'), arrowsize=30, width=.3, arrows = True, node_color = nodeCols)
p.legend(loc = "best")


# nx.draw_networkx(G, node_size=1000, arrowstyle= ('Fancy, head_width = 0.6, head_length = 0.6, tail_width=0.3'), arrowsize=30, width=.5, arrows = True, node_color = "green")


# nx.draw_networkx_edges(G, pos, node_size=node_sizes, arrowstyle='->', arrowsize=10, edge_color=edge_colors, edge_cmap=plt.cm.Blues, width=2)  #example from documentation



# p.show()
f.savefig("../Results/QMEENet_py.svg", width = 7, height  = 7)





