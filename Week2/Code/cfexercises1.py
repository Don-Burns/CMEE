#!/usr/bin/env python3
"""A test of writting simple function to execute simple operation on a number, or list of numbers."""

__author__ = 'Donal Burns (db319@ic.ac.uk)'
__version__ = '0.0.1'

## imports##
import sys

## constants##

##functions##

# What does each of foo_x do?
def foo_1(x):
    """ Takes a number x and finds the square root of it."""
    return x ** 0.5  # x to power .5?

def foo_2(x, y):
    """ Takes two numbers x and y and return the greater of the two. """
    if x > y:
        return x # return x if greater than y
    return y
def foo_3(x, y, z):
    """ Takes three numbers x, y, z.  
    First if x is greater than y, they are swapped.  
    Next if y is greater than z, they are swapped.
    The end result will be if x is greater than the 
    other two values then x is moved to the end of the list."""
    if x > y:           # swap x and y if x is greater
        tmp = y 
        y=x
        x = tmp
    if y > z:       #swap z and y if y is greater
        tmp = z 
        z = y
        y = tmp
    return [x, y, z]   # end result is if x is greater than y and z it swaps all positions to the left.

def foo_4(x):           
    """ Takes a number x and outputs x!. """
    result = 1      #x! factorial
    for i in range(1, x+1):
        result = result * i
    return result

def foo_5(x):   # a recursive function that calculates the factoria
    """ Takes a number x and outputs x!. """
    if x == 1:
        return 1
    return x * foo_5(x -1)

def foo_6(x): # Calculate the factorial of x in a different way
    """ Takes a number x and outputs x!. """
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto




def main (argv):
    print(foo_1(4))
    print(foo_2(2,4))
    print(foo_3(9,5,3))
    print(foo_4(5))
    print(foo_5(5))
    print(foo_6(5))
    
    


if (__name__ =="__main__"):
    status = main(sys.argv)
    sys.exit(status)

