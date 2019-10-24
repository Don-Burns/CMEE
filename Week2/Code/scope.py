#!/usr/bin/env python3
""" A script looking at how global and local funtions are handled inside and outside functions."""

__author__ = 'Donal Burns (db319@ic.ac.uk)'
__version__ = '0.0.1'

#PART 1
_a_global = 10  # a global variable

if _a_global >= 5:
    _b_global = _a_global + 5 # alsoa global variable

def a_function():
    """ shows how locals variables work"""
    _a_global = 5  # a local variable
    
    if _a_global >= 5:
        _b_global = _a_global + 5 # also a local variable
    
    _a_local = 4
    
    print("Inside the function, the value is ", _a_global)
    print("Inside the function, the value is ", _b_global)
    print("Inside the function, the value is ", _a_local)

    return None

a_function()

print("Outside the function, the value is ", _a_global)
print("Outside the function, the value is ", _b_global)

# PART 2
_a_global = 10

print("Outside the function, the value is ", _a_global)

def a_function():
    """ shows local vs global variables"""
    global _a_global
    _a_global = 5 
    _a_local = 4
    print("Inside the function, the value is ", _a_global)
    print("Inside the function, the value is ", _a_local)
    return None

a_function()
print("Outside the function, the value is ", _a_global)

# PART 3
def a_function():
    """ shows how assigning global variables works"""
    _a_global = 10

    def _a_function2():
        """ demonstrates how the global variable is handled in a fucntion"""
        global _a_global
        _a_global = 5
        _a_local = 4 

        print("Inside the function, the value of _a_global ", _a_global)
        print("Inside the function, the value of _a_local", _a_local)

        return None

a_function()

print("Outside the function, the value of _a_global now is ", _a_global)

#PART 4

def a_function():
    """ more global testing"""
    _a_global = 10

    def _a_function2():
        global _a_global
        _a_global = 20

    print("Before calling a_function, value of _a_global is ", _a_global)

    return None

    _a_function2()

    print("After calling _a_function2, value of _a_global is ", _a_global)

a_function()

print("The value of a_global in main workspace / namespace is ", _a_global)

#PART 5

_a_global = 10
def a_function():
    """ mroe global vs local """
    def _a_function2():
        """ even more global vs local"""
        global _a_global
        _a_global = 20

    print("Before calling a_function, value of _a_global is ", _a_global)

    _a_function2()
    
    print("After calling _a_function2, value of _a_global is ", _a_global)

a_function()

print("The value of a_global in main workspace / namespace is ", _a_global)
