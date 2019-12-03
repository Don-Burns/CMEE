

#include <stdio.h>

int main (void){
    int i = 0; // interpretation: reserve memory with a read/write size of an int
    int j = 0;
    char c = 'c'; // interpretation: reserve memory with a read/write size of a char
    double pi = 3.14; // interpretation: reserve memory with a read/write size of a double

    int intarray[4]; // explicitly size declaration
    int intarray2[] = {0, 0, 1, 4,};


    int matrix[2][4]; // Matrixes ca be specified 
    int nmatrix[2][4][3]; // they can also be n-dimensional

    // reading and writing from.to arrays:

    // Example: read from and uninitialised array.
    // indexing starts at 0 just like python in C
    j= intarray[0];
    printf("The value of an uninitailised array at pos 0: %i\n", j);
    printf("The value of an uninitailised array at pos 1: %i\n", intarray[1]);
    printf("The value of an uninitailised array at pos 2: %i\n", intarray[2]);
    printf("The value of an uninitailised array at pos 3: %i\n", intarray[3]);

    printf("Before assignment\n");
    printf("The value of an uninitailised array at pos 0: %i\n", intarray2[0]);
    printf("The value of an uninitailised array at pos 1: %i\n", intarray2[1]);
    printf("The value of an uninitailised array at pos 2: %i\n", intarray2[2]);
    printf("The value of an uninitailised array at pos 3: %i\n", intarray2[3]);

    intarray2[0] = 3;
    intarray2[1] = 2;

    printf("After assignment\n");
    printf("The value of an uninitailised array at pos 0: %i\n", intarray2[0]);
    printf("The value of an uninitailised array at pos 1: %i\n", intarray2[1]);
    printf("The value of an uninitailised array at pos 2: %i\n", intarray2[2]);
    printf("The value of an uninitailised array at pos 3: %i\n", intarray2[3]);


    printf("Reading out of narray bounds: %i\n", intarray[6]);

    return 0;

}