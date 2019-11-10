#!/usr/bin/env python3
## Desc: A python version of the `get_TreeHeight.R` script. This script calculates heights of tree given  distance of each from its base and angle to its top, using trigonometric formula and writes a new file with the heights of the tree appended. \nInput: Realtive directory to .csv file containing species names, distance from tree in meters and angle to top of each tree in degress./nOutput: File named `InputFileName"_Treeheight.csv"`

#TODO for some reason the loop from line 42-46 is being skipped, when the row counter is use a few lines prior, have specified for now so as to bug fix but still needs fixing


import sys
import math
import csv
import os
import re

####### Read in file #############
title = "../data/trees.csv"
# if no file is given run with a test file.
File = "../data/trees.csv"

# else run with the file given
if len(sys.argv) > 1:
    File = sys.argv[1]
    title = sys.argv[1]


############# Functions ###############

def TreeHeight(degrees, distance):
    """function to calculate height of a tree given angle to top of tree from point of observation and distance to the base of the tree"""
    radians = float(degrees) * math.pi / 180
    height = float(distance) * math.tan(radians)
    print("Tree height is:" + str(height))
    return (height)


def WriteFile(input, outputDir):
    """a function to construct the table of data and write to a file"""
    with open(input, "r") as data:
        csvRead = csv.reader(data)
        # predefine column size
        rowCount = 121

        # rowCount = sum(1 for row in csvRead)
        # for rows in csvRead:
        #     rowCount = rowCount + 1
        print("number of rows counted = " + str(rowCount))
        FileSpecies = ["Blank"] * rowCount
        FileDist = ["Blank"] * rowCount
        FileDeg = ["Blank"] * rowCount
        FileHeight = ["Blank"] * rowCount
        tmp = 0

        for i in csvRead:
            # read in file ensuring to skip the headers
            if "Species" in i:
                None
            else:
                print(i)

                print("in")
                FileSpecies[tmp] = i[0]
                FileDist[tmp] = i[1]
                FileDeg[tmp] = i[2]
                FileHeight[tmp] = TreeHeight(FileDeg[tmp], FileDist[tmp])
                tmp = tmp + 1

    with open(outputDir, "w") as outputFile:

        writer = csv.writer(outputFile)

        for rows in range(rowCount):
            if rows == 0:
                # write in headers for final file
                writer.writerow(["Species", "Distance", "angle.degrees", "Tree.Height.m"])
            #     writer[rows, 1] = "Species"
            #     writer[rows, 2] = "Distance.m"
            #     writer[rows, 3] = "angle.degrees"
            #     writer[rows, 4] = "Tree.Height.m"
            else:
                # else write in the data to the final table
                thisRow = [FileSpecies[rows], FileDist[rows], FileDeg[rows], FileHeight[rows]]
                writer.writerow(thisRow)
                # writer[rows, 1] = FileSpecies[rows]
                # writer[rows, 2] = FileDist[rows]
                # writer[rows, 3] = FileDeg[rows]
                # writer[rows, 4] = FileHeight[rows]

    return ("Done!!!")


###### MAIN ######
# ## make the modified table, with heights
# File <- read.table(File, sep = ',', header = TRUE, as.is = 1) ## read in data from trees.csv

## make new file name for output
FileName = re.sub('\.csv$', '', os.path.basename(title))

## output file to results
outputDir = "../Results/" + FileName + "_TreeHtsPy.csv"

WriteFile(File, outputDir)
