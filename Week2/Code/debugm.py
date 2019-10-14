#!/usr/bin/env python3
#!/usr/bin/env python3
"""Simple piece of code used to practice debugging in python"""
__author__ = 'Donal Burns (db319@ic.ac.uk)'
__version__ = '0.0.1'
## Desc: script for debugging.

def makeabug(x):
    y = x**4
    z = 0.
    y = y/z
    return y

makeabug(25)
