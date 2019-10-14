#!/usr/bin/env python3
"""A script taking a list with species stored with their order as a tuple in a list. It creates a dictionary mapping orders as keys and species as values to their respective orders."""

__author__ = 'Donal Burns (db319@ic.ac.uk)'
__version__ = '0.0.1'
# Author: Donal Burns (db319@ic.ac.uk)
# Date: Oct 2019
# Desc: A script taking a list with species stored with their order as a tuple in a list. It creates a dictionary mapping orders as keys and species as values to their respective orders.

taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]

# Write a short python script to populate a dictionary called taxa_dic 
# derived from  taxa so that it maps order names to sets of taxa. 
# E.g. 'Chiroptera' : set(['Myotis lucifugus']) etc. 
taxa = set(taxa)
taxa_dic = {}

for entry in taxa:
        ##if not on keys add new key and new species
        if entry[1] not in taxa_dic.keys():  
                taxa_dic[entry[1]] = [entry[0]]


        ##else find matching key and add the species
        elif entry[1] in taxa_dic.keys():    
                taxa_dic[entry[1]].append(entry[0])


for i in taxa_dic.keys():
        print(i + ":\t" + str(taxa_dic[i]))
        


