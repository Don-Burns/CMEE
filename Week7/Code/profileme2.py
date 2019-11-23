#!/bin/usr/env python3
## Desc: A script containing different functions profiled from`profileme.py`


"""
A script containing different functions optimised from `profileme.py`
"""

__appname__ = 'profileme2.py'
__author__ = 'Donal Burns (db319@ic.ac.uk)'
__version__ = '0.0.1'
__liscense__ = "Apache 2"
############################################################################

def my_squares(iters):
    """
    Takes a value and makes a list of the squares of that value in a range of that value.
    """
    out = [i ** 2 for i in range(iters)]
    return out

def my_join(iters, string):
    """
    Takes an int and string.  Will create a string with the string repeated for a range of the int seperated by a comma
    """
    out = ''
    for i in range(iters):
        out += ", " + string
    return out

def run_my_funcs(x, y):
    """
    Takes the functions `my_join` and `my_squares` and runs them.  inputs are x= "some int", y = "some string"
    """
    print
    my_squares(x)
    my_join(x, y)
    return 0 

run_my_funcs(10000000,"My string")