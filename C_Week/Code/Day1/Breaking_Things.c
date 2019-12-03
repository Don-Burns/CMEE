/*
1- Breaking things

A good way to understand a new programming language is to try to break a program and examine the results. 
Try re-writing our introductory program by removig the pre-processor directive (i.e. the include statement). What happens?  -- get warnings about needing the include - could be errors depending on compiler
What happens if you leave out the return statement or change the return value? -- compiler doesnt care?
*/

#include <stdio.h>

int main (void)
{
    int myint = 4;
    
    printf("Hello, world!\nI have initialised myint to %i.\n", myint); 

    // return 0;
}