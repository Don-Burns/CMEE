#include <stdio.h>
#include <stdlib.h>

int *pos_first_odd(const int[], const unsigned long);// all that is needed for the prototype





int *pos_first_odd(const int integers[], const unsigned long size){
    
    
    
    unsigned long int c = 0;
    int *ret = NULL;

    ret = (int*)integers;

    while(*ret % 2 == 0 && c < size){
        ++ret;
        ++c;
    }

    if(c == size){
        --ret;
        if (*ret % 2 == 0){   
        return NULL;
        }
    }


    int (*x)(); // X  is a pointer to a function which takes nothing, which points to a function that takes a double, and returns an int

    printf("%i\n", x());


    return ret;
}


int main (void){
    int *res = NULL;
    int integers[] = {2, 4, 10, 21, 30};

    res = pos_first_odd(integers, 5);
    
    printf("res now points to: %i\n", *res);
    
    *res = *res -1;  

    res = pos_first_odd(integers, 5);
    if(res != NULL){
        printf("res now points to: %i\n", *res);
    }


    return 0;
}