#!/bin/bash
##Desc: A short script to run and test `get_TreeHeight.R` and `get_TreeHeight.py`


echo "Testing `get_TreeHeight.R` using `../data/trees.csv`..."
Rscript get_TreeHeight.R ../data/trees.csv
echo "DONE!!! =D"

# echo "Testing `get_TreeHeight.py` using `../data/trees.csv`..."
# python get_TreeHeight.py ../data/trees.csv
# echo "Fishished This TOOOOOOOOOOOOO!!! =D"