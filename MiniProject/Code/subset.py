"""
Desc: A script used to subset data in preparation for fitting using `fitting.py`
Author: Donal Burns
Date: 19/02/2020
"""
###### Import Packages #######

import pandas as pd
import csv

###### Script Options #######
directory = "../data/" # the directory where the files are to be saved

####### Main #######

def subset(column = "Habitat", file = "../data/CRat.csv", directory = "../data/"):
    data = pd.read_csv(file)

    datacolumn = column # the column of interest for subsetting
    catList = data[datacolumn].unique() # vector of the categories of interest to subset by

    for i in catList:
        datasubset = data[data[datacolumn] == i]
        filepath = directory + i + ".csv"
        datasubset.to_csv(filepath, header = True, index = None)