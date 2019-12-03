/*
2- Fixing bugs before the compiler

Examine the following program and identify all of the bugs within it.
*/
#include <stdio.h>

int main (void)
{
     int x = 1;
     char a = 'a';
     float _1point1 = 1.1;
     
     printf("An integer: %i\n", x);
     printf("A character: %c\n", a);
     printf("A floating point: %f\n", _1point1);
     
     return 0;
}