/*
1- Bugs and compiler feedback

Compile the following program. What happens? Examine the compiler feedback to fix the program.
*/

#include <stdio.h>

int main(void)
{
    /* Declare the variables: */
    int x = 10;
    int y = 5;
    float z = 1.1;
    char a = 'a';
    
    /* Print the variables to the console */
    printf("The value of x: %i\n", x);
    printf("The value of y: %i\n",  y);
    printf("The value of z: %f\n", z);
    printf("The value of x: %c\n", a);
    
    /* Return 0 to the OS*/
    return 0;
}