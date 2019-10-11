#!/usr/bin/env python3
# Author: Donal Burns (db319@ic.ac.uk)
# Date: Oct 2019
# Desc: A script examining how sys.argv is handeled in Python.

# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )

# (1) Use a list comprehension to create a list of month,rainfall tuples where
# the amount of rain was greater than 100 mm.

Over100 = [entry for entry in rainfall if entry[1] > 100]
print(Over100)
 
# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm. 

under50 = [entry for entry in rainfall if entry[1] < 50]
print(under50)

# (3) Now do (1) and (2) using conventional loops (you can choose to do 
# this before 1 and 2 !). 

Over100 = []
for entry in rainfall:
    if entry[1] > 100: 
        Over100.append(entry)

print(Over100)

under50 = []
for entry in rainfall:
    if entry[1] < 50:
        under50.append(entry)

print(under50)