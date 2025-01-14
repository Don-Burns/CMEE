#!/usr/bin/env python3
"""Finds just those taxa that are oak trees from a list of species."""

__author__ = 'Donal Burns (db319@ic.ac.uk)'
__version__ = '0.0.1'
# Author: Donal Burns (db319@ic.ac.uk)
# Date: Oct 2019
# Desc: Finds just those taxa that are oak trees from a list of species

taxa = ['Quercus robur', 
'Fraxinus exelsior', 
'Pinus sylvestris', 
'Quercus cerris', 
'Quercus patraea']

def is_an_oak(name):
    return name.lower().startswith('quercus ')

## Using for loops
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species)
print(oaks_loops)

## Using list comprehensions
oaks_lc = set([species for species in taxa if is_an_oak(species)])
print(oaks_lc)

## Get names in UPPER CASE using for loops
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species.upper())
print(oaks_loops)

## Get names in UPPER CASE using list comprehensions
oaks_lc = set([species.upper() for species in taxa if is_an_oak])
print(oaks_lc)

