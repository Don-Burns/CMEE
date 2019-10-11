#!/usr/bin/env python3
""" A programme which takes two genetic sequences and aligns them to provide the best direct match possible.

It will run even if no inputs are given using short examples sequences, by using align_seqs.csv found within ../data """


__appname__ = 'align_seqs.py'
__author__ = 'Donal Burns (db319@ic.ac.uk)'
__version__ = '0.0.1'

## possible improvements
# use tags in file



##Imports##

import sys 
import csv 



###for differentiating files

##if not user arguments are given run with test files
if len(sys.argv) == 1:

    with open("../data/align_seqs.csv") as file:
        csv_reader = csv.reader(file, delimiter = ",")
        for s in csv_reader:
            seq1, seq2 = s[0], s[1]
#run with user designated file otherwise
else:

    with open(sys.argv[1]) as file:
        csv_reader = csv.reader(file, delimiter = ",")
        for s in csv_reader:
            seq1, seq2 = s[0], s[1]




# Two example sequences to match, will run should no other files be specified.  found as align_seqs.csv in ../Results
# seq2 = "ATCGCCGGATTACGGG"
# seq1 = "CAATTCGGAT"

# Assign the longer sequence s1, and the shorter to s2
# l1 is length of the longest, l2 that of the shortest

l1 = len(seq1)
l2 = len(seq2)
if l1 >= l2:
    s1 = seq1
    s2 = seq2
else:
    s1 = seq2
    s2 = seq1
    l1, l2 = l2, l1 # swap the two lengths

# A function that computes a score by returning the number of matches starting
# from arbitrary startpoint (chosen by user)
def calculate_score(s1, s2, l1, l2, startpoint):
    """ A function that computes a score by returning the number of matches starting from arbitrary startpoint (chosen by user)"""
    matched = "" # to hold string displaying alignements
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]: # if the bases match
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"

    # some formatted output
    print("." * startpoint + matched)           
    print("." * startpoint + s2)
    print(s1)
    print(score) 
    print(" ")

    return score

# Test the function with some example starting points:
# calculate_score(s1, s2, l1, l2, 0)
# calculate_score(s1, s2, l1, l2, 1)
# calculate_score(s1, s2, l1, l2, 5)

# now try to find the best match (highest score) for the two sequences
my_best_align = None
my_best_score = -1

for i in range(l1): # Note that you just take the last alignment with the highest score
    z = calculate_score(s1, s2, l1, l2, i)
    if z > my_best_score:
        my_best_align = "." * i + s2 # think about what this is doing!
        my_best_score = z 

def main(argv):
    """prints all alignments with scores and saves the alignment with the best score to ../Results"""
    with open("../Results/seq_alignment.txt","w") as file:
        # fileWrite = csv.writer(file)
        print(my_best_align)
        print(s1)
        print("Best score:", my_best_score)
        ##writes the file with best score        
        file.write(my_best_align + "\n")
        file.write(s1 + "\n")
        file.write("Best score:" + str(my_best_score) + "\n")




if (__name__ =="__main__"):
    status = main(sys.argv)
    sys.exit(status)