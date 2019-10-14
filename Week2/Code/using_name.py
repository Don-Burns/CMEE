#!/usr/bin/env python3
"""A script looking at how __main__ is handled in python."""

__author__ = 'Donal Burns (db319@ic.ac.uk)'
__version__ = '0.0.1'
# Author: Donal Burns (db319@ic.ac.uk)
# Date: Oct 2019
# Desc: A script looking at how __main__ is handled in python.
#Filename: using_name.py

if __name__ == '__main__':
    print('This program is being run by itself')

else:
    print("I am being imported from another module")
    