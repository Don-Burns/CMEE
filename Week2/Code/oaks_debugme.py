#!/usr/bin/env python3

"""A program which parses a list and takes all members of the 'Quercuss' genus and saves them to a sperate file in `../data`
"""




__appname__ = 'align_seqs_fasta.py'
__author__ = 'Donal Burns (db319@ic.ac.uk)'
__version__ = '0.0.1'



import csv
import sys
import re ##regular expression module for quercus typos
#Define function
def is_an_oak(name):
    """ Returns True if name is starts with 'quercus', has some ability to allow typos to be correctly interpreted e.g. Qaecuss.  Will not accept if the user makes 3 typos in a row or has one typo and too many letters.  Have judged this to be an acceptable level of redundancy while maintaining strictness of passing.

    doctest
    >>> is_an_oak('Fagus syvatica')
    False
    >>> is_an_oak('Quercus maximus')
    True
    >>> is_an_oak('Qaercuss maximus')
    True
    >>> is_an_oak('Qaurcuss maximus')
    False
     """

    oak = name.lower()
    

    if oak.startswith('quercus'):
        return True
        ##checks for user typos begin
    if re.match(re.compile('q.e.c.s'), oak):
        return True 
    if re.match(re.compile('.u.r.c.s'), oak):
        return True

    return False

def main(argv): 
    """ Prints every row in the list in the order [Genus species].  Also specifies Genus.  If the row is an oak an additional row "FOUND AN OAK!" will be printed.  All oaks are then saved to ../data/JustOaksData.csv """
    f = open('../data/TestOaksData.csv','r')
    g = open('../data/JustOaksData.csv','w')
    taxa = csv.reader(f)
    csvwrite = csv.writer(g)
    oaks = set() ###############< should take the input and makes sure there is no doubles
    csvwrite.writerow(['Genus','species']) # print header for JustOaksData.csv
    for row in taxa:
        if row[0] == 'Genus': ## don't print 'Genus, species' in terminal
            None
        else:
            print(row)
            print ("The genus is: ") 
            print(row[0] + '\n')
            if is_an_oak(row[0]):
                print('FOUND AN OAK!\n')
                csvwrite.writerow([row[0], row[1]])    

    return 0
    
if (__name__ == "__main__"):
    status = main(sys.argv)