#!/usr/bin/env python3
# Desc: A script looking at vectorisation in python. Spefically an python version of `Vectorize1.R`

import random
import timeit

M = [[random.uniform(0, 1) for x in range(1000)] for x in range(1000)]


def SumAllElements(M):
    Tot = 0
    Dimensions = [len(M), len(M[0])]  # dimensions in nrow, ncol
    for j in range(Dimensions[0]):
        for i in range(Dimensions[1]):
            Tot = Tot + M[j][i]

    return Tot


def elapsed_time(TestCode):
    start = timeit.default_timer()
    TestCode
    end  = timeit.default_timer()
    return end  - start # returns time in seconds


def test(number):
    for i in range(number):
        a = 5*4*3*45*28*4434
        return a



print("Using loops, the time taken is: ")
print(elapsed_time(SumAllElements(M)))
print("Using the in built vectorized function, the time taken is: ")
print(elapsed_time(sum(M)))
