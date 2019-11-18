#!/bin/usr/env python3
# Desc: A script to build a network of the QMEE CDT collaboration network.  Based on Nets.R
import scipy as sc
import pandas as pans
import networkx as nx 
import matplotlib.pylab as p

### read in data
links = pans.read_csv('../data/QMEE_Net_Mat_edges.csv', header = 0)
nodes = pans.read_csv('../data/QMEE_Net_Mat_nodes.csv', header = 0) ## row names are col 0
nodeList = list(links.columns) # find header names for links
AdjList = [None] * ((len(links))*(len(links)-1)) #adjecency list for later, -1 for diagonals .  each Node has n-1 interactions, where n is number of nodes.  are listed in same order as found in links and in AdjListKey
# posInAdjList = 0 # to track where in the adj list we are placing entries
# AdjListKey = [None] * (len(links) * (len(links)-1))
AdjList = []
for r in range(len(links)):
    for c in range(len(links)):
        if r == c: # to skip the diagonal
            None
        else:   #assign the value with direction
            # AdjList[posInAdjList] = links.iloc[r,c] 
            # AdjListKey[posInAdjList] = links.columns[r] + '-->' + links.columns[c]
            tmp = links.iloc[r,c]
            if tmp != 0:
                AdjList.append((links.columns[r],  links.columns[c], tmp))
            # AdjList[posInAdjList] = (links.columns[r],  links.columns[c], tmp)
            # posInAdjList = posInAdjList + 1

# SizRan = ([-10, 10]) # use log10 scale
# Sizs = sc.random.uniform(SizRan[0], SizRan[1], 30)


# pos = nx.circular_layout(nodeList)

G = nx.Graph()

G.add_nodes_from(nodeList)
G.add_weighted_edges_from(tuple(AdjList))


# NodSizs = 1000 * (Sizs - min(Sizs))/(max(Sizs) - min(Sizs))

f = p.figure() 
# nx.draw_networkx(G, pos, node_size = NodSizs)
nx.draw_networkx(G, node_size=500, arrowstyle='->', arrowsize=10, width=2, arrows = True)
# nx.draw_networkx_edges(G, node_size=100, arrowstyle='->', arrowsize=10, width=2)

# nx.draw_networkx_edges(G, pos, node_size=node_sizes, arrowstyle='->', arrowsize=10, edge_color=edge_colors, edge_cmap=plt.cm.Blues, width=2)  #example from documentation


# nx.drawing.nx_pylab.draw_networkx_edges(G, arrows = True, arrowstyle = "Fancy")
p.show()






