#!/bin/usr/env python3


"""
Generates a "synthetic" food web and save the plot to `../Results`
"""

__appname__ = 'DrawFW.py'
__author__ = 'Donal Burns (db319@ic.ac.uk)'
__version__ = '0.0.1'
__liscense__ = "Apache 2"
###############################################################
## Desc: 


###PACKAGES
import networkx as nx
import scipy as sc
import matplotlib.pyplot as p 

####FUNCTIONS####

def GenRdmAdjList(N = 2, C = 0.5):
    """
    Generates a radnom adjecency list for N number of species
    """
    Ids = range(N)
    ALst = []
    for i in Ids:
        if sc.random.uniform(0, 1, 1) < C:
            Lnk = sc.random.choice(Ids, 2).tolist()
            if Lnk[0] != Lnk[1]: # avoid self cannibalistic loops
                ALst.append(Lnk)
    return ALst

####MAIN#####

MaxN = 30
C = 0.75

AdjL = sc.array(GenRdmAdjList(MaxN, C)) ## make adjecency list
AdjL
Sps = sc.unique(AdjL) # get species ids

SizRan = ([-10, 10]) # use log10 scale
Sizs = sc.random.uniform(SizRan[0], SizRan[1], MaxN)
Sizs
###plotting###

p.hist(Sizs)
# p.show()
p.hist(10 ** Sizs) ### plot raw scale
# p.show()
p.close("all") # close all open plot objects

pos = nx.circular_layout(Sps)

G = nx.Graph()

G.add_nodes_from(Sps)
G.add_edges_from(tuple(AdjL))

NodSizs = 1000 * (Sizs - min(Sizs))/(max(Sizs) - min(Sizs))

f = p.figure() 
nx.draw_networkx(G, pos, node_size = NodSizs)
# p.show()
f.savefig("../Results/DrawFW.pdf")



































