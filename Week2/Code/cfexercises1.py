# What does each of foo_x do?
def foo_1(x):
    return x ** 0.5  # x to power .5?

def foo_2(x, y):
    if x > y:
        return x # return x if greater than y
    return y
def foo_3(x, y, z):
    if x > y:           # swap x and y if x is greater
        tmp = y 
        y=x
        x = tmp
    if y > z:       #swap z and y if y is greater
        tmp = z 
        z = y
        y = tmp
    return [x, y, z]   # end result is if x is greater than y and z it swaps all positions to the left.

def foo_4(x):           #x! factorial
    result = 1
    for i in range(1, x+1):
        result = result * i
    return result

def foo_5(x):   # a recursive function that calculates the factoria
    if x == 1:
        return 1
    return x * foo_5(x -1)

def foo_6(x): # Calculate the factorial of x in a different way
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto
