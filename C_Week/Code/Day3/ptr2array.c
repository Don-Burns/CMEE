#include <stdlib.h>
#include <stdio.h>

int main (void){
    int integers[] = {2, 33, 4, 10, 11};
    int (*aintptr)[] = NULL; //pointer to array of ints
    int *aintptr2 = NULL; // pointer to an int

    aintptr = &integers;

    printf("The value at index 1 in intarray via indirection: %i\n", (*aintptr)[1]); // need the brackets around aintptr because of priority when reading the var, prioritizes the [] over *
    aintptr2 = integers;
    printf("Dereferencing pointer to an array: %i\n", *aintptr2);

    printf("Get second value by pointer arrithmetic: %i\n", *(aintptr2+1));// essentially shift over by 1 ints of bits

    printf("Get second value by pointer arrithmetic: %i\n", *(aintptr2+2));
    printf("Get second value by pointer arrithmetic: %i\n", aintptr2[1]);// can alos use array subscript even though not entirely true

    int *endofarray = NULL; // Let's point to a specific value in the array
    endofarray = &integers[4];  // now points to last element of itnegers

    for(aintptr2 = integers; aintptr2 <= endofarray; ++aintptr2){
        printf("%i ", *aintptr2);
    }
    printf("\n");   
}