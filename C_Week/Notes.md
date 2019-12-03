# C Week
# Day 1 


## C Data Types

* char - ACII character set
    typically 1 byte
* int - interger, can store a set number of digits
    storage of a large number
    typically 4 bytes, each bit is 9 bits, 1st is for the sign -/+
* float - floating point, real numbers
* double - double precision float, more decimal points
* _Bool - 0/1 aka T/F

broadly speaking there are 2 types of data; integral(char, _bool and int) and floating point (float and double)

integral

* char - typically 1 byte 
* int - typically 4 bytes, each bit is 9 bits, 1st is for the sign -/+
    can store 0 -> 2.1 bil
* -Bool

floating point broadly
    broadly speaking it can store more details,  but eventually will round off, floating point error
    floating point will always be slower, due to the need to conver the bytes into some actually number

    stored as 64 bytes 1 signed, 11 up and 53 down of decimal


Safest practice is to avoid changing between types with variables whereever possible.  Can lead to compatability issues


# Day 2

## Binary operators
* a&&b - logical AND
* a||b - logical OR
* a==b - test for equality
* a!=b - test for inequality


## unary logical operators
* !a - logical NOT
    I.e.
    if(a == 0)
        return true;
    else
        return false;



## x++ vs ++x

x++ postfix - verifies x then increments
++x prefix - increments then verifies x

**example**
x = 0;
y = 0;
y = ++x;
* here y will equal 1 as will x
y = x++;
* here y will equal 0 while x will equal 1









