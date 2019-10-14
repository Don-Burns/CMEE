#!/usr/bin/env python3
"""A series of tests looking at how python does some simple calculations and printing a result if they meet various criterea."""

__author__ = 'Donal Burns (db319@ic.ac.uk)'
__version__ = '0.0.1'


for j in range(12):  # prints hello 4 times
    if j % 3 == 0:
        print('hello')

for j in range(15):  #prints hello 5 times
    if j % 5 == 3:  # prints on 3, 8, 13
        print('hello')
    elif j % 4 == 3: # prints on 7,15
        print('hello')

z = 0
while z != 15:  # prints "hello" 5 times
    print('hello')
    z = z + 3

z = 12      # prints "hello" 8 times
while z < 100:
    if z == 31:
        for k in range(7):
            print('hello')
    elif z == 18:
        print('hello')
    z = z + 1

