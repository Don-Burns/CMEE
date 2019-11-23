#!/bin/usr/env python3
"""

"""

__appname__ = ''
__author__ = 'Donal Burns (db319@ic.ac.uk)'
__version__ = '0.0.1'
__liscense__ = "Apache 2"

##################################################################
# loops vs. list comprehensions: which is faster?
##################################################################



iters = 1000000
import timeit 
from profileme import my_squares as my_squares_loops
from profileme2 import my_squares as my_squares_lc


# %timeit my_squares_loops(iters)
# %timeit my_squares_lc(iters)



##############################################################################
# loops vs. the join method for strings: which is faster?
##############################################################################


mystring = "my string"
from profileme import my_join as my_join_join
from profileme2 import my_join as my_join

# %timeit my_join_join(iters, mystring)
# %timeit my_join(iters, mystring)



### alternative method
import time
start = time.time()
my_squares_loops(iters)
print("my_squares_loops takes %f s to run." % (time.time() - start))

start = time.time()
my_squares_lc(iters)
print("my_squares_lc takes %f s to run." % (time.time() - start))


