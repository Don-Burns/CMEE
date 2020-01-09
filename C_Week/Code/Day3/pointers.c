#include <stdlib.h>
#include <stdio.h>

int main (void){
    int i  = 0;
    int *p = NULL;

    p = &i;

    printf("Value of i before indirection: %i\n", i);
    printf("Value of i via indirection: %i\n", *p);

    i = 4;
    *p = 5;

    printf("Value of i after indirection: %i\n", i);





    return 0;



}