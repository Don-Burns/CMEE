
#include <stdio.h>

int main(void){
    int a  = 7, b = 2; // var declaration can be done on the same line as here or different as below
    float c = 0;
    int d = 0;

    c = (float)7/2;
    d = a/b;

    printf("Result of literal expression: %f\n", c);
    printf("Results of variable expression: %i\n", d);

    return 0;
}