#!/bin/usr/env python3
## Desc: A script containing different functions to be profiled in `profileme2.py`


"""
A script containing different functions to be profiled
"""

__appname__ = 'profileme.py'
__author__ = 'Donal Burns (db319@ic.ac.uk)'
__version__ = '0.0.1'
__liscense__ = "Apache 2"
##############################################################################

def my_squares(iters):
    """
    Takes a value and makes a list of the squares of that value in a range of that value.
    """
    out = []
    for i in range(iters):
        out.append(i ** 2)
    return out

def my_join(iters, string):
    """
    Takes an int and string.  Will create a string with the string repeated for a range of the int seperated by a comma.
    """
    out = ""
    for i in range(iters):
        out += string.join(", ")
    return out

def run_my_funcs(x, y):
    """
    Takes the functions `my_join` and `my_squares` and runs them.  inputs are x= "some int", y = "some string"
    """
    print(x, y)
    my_squares(x)
    my_join(x, y)
    return 0 
run_my_funcs(10000000, "My string")











