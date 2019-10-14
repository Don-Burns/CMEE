#!/usr/bin/env python3
""" A script practicing use of FOR loops in Python"""

__author__ = 'Donal Burns (db319@ic.ac.uk)'
__version__ = '0.0.1'
# Author: Donal Burns (db319@ic.ac.uk)
# Date: Oct 2019
# Desc: A script practicing use of FOR loops in Python
for i in range(5):  #prints number from 1-5
    print(i)

my_list = [0, 2, "geronimo!", 3.0, True, False]  
# prints all elements in my_list
for k in my_list:
    print(k)

total = 0                          
 # takes each element in summands adds it to the sum of all previous elements and prints it each time.
summands = [0, 1, 11, 111, 1111]
for s in summands:
    total = total + s 
    print(total)

# WHILE loops in Python
z = 0           # counts from 1-100, while printing each time
while z < 100:
    z = z + 1
    print(z)

# creates an infinite loop printing "GERONIMO! infinite loop! ctrl+c to stop" the whole time.
b = True  
while b:
    print("GERONIMO! infinite loop! ctrl+c to stop")
# ctrl + c to stop