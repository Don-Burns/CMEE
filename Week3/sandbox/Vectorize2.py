#!/usr/bin/env python3
# Desc: A script looking at vectorisation in python. Spefically an python version of `Vectorize2.R`

import random
import math
import numpy

def stochrick(p0 = [random.uniform(.5, 1.5) for x in range(1000)], r = 1.2, K = 1, sigma = .2, numyears = 100):
    #initialize
    N = numpy.array([[None for x in range(numyears)] for x in range(len(p0))])
    N[:, 0] = p0
    for pop in range(numyears):
        for yr in range(1,numyears):
            N[yr][pop] = N[yr-1][pop] * math.exp(r * (1-N[yr-1][pop]/K) + numpy.random.normal(0, sigma, 1))
    return N


 

## Desc: A challenge to reduce the runtime of a script which applies the Ricker model to some data.

# Runs the stochastic (with gaussian fluctuations) Ricker Eqn .

# Now write another function called stochrickvect that vectorizes the above
# to the extent possible, with improved performance:

def stochrickvect(p0 = [random.uniform(.5, 1.5) for x in range(1000)], r = 1.2, K = 1, sigma = .2, numyears = 100):
    #initialize
    N = [[None for x in range(len(p0))] for x in range(numyears)]
    N[:0] = p0
    for yr in range(1,numyears):
        N[yr:] = N[yr-1:] * math.exp(r * (1-N[yr-1:]/K) + numpy.random.normal(1,0,sigma))
    return N






def elapsed_time(TestCode):
    start = timeit.default_timer()
    TestCode
    end  = timeit.default_timer()
    return end  - start # returns time in seconds


print("unvectorized Stichastic Ricker takes:")
print(elapsed_time(stochrick()))
print("Vectorized Stochastic Ricker takes:")
print(elapsed_time(stochrickvect()))
