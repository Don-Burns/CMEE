"""
Desc: A script used to subset data in preparation for fitting using `fitting.py`
Author: Donal Burns
Date: 19/02/2020
"""
###### Import Packages #######

import pandas as pd
import csv
import sys

###### Script Options #######
directory = "../data/" # the directory where the files are to be saved

####### Functions #######

def subset(column = "Habitat", file = "../data/CRat.csv", directory = "../data/"):
    """
    A function for subsetting data before fitting. Will split the original dataset based on the unique entries in a specified column e.g. the column of interest for a biological question. Each unique entry will be saved as a separate file.
    
    Keyword Arguments:
        column {str} -- The to split based on unique entries (default: {"Habitat"})
        file {str} -- The file containing the target dataset in `.csv` format (default: {"../data/CRat.csv"})
        directory {str} -- the directory where the result will be output to (default: {"../data/"})
    """
    data = pd.read_csv(file)

    datacolumn = column # the column of interest for subsetting
    catList = data[datacolumn].unique() # vector of the categories of interest to subset by

    for i in catList:
        datasubset = data[data[datacolumn] == i]
        filepath = directory + i + ".csv"
        datasubset.to_csv(filepath, header = True, index = None)

####### Main #######

if (__name__ == '__main__'):
    status = subset()
    sys.exit(status)