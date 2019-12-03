#include <stdio.h>

int main (void){
    int i = 0;
    int intarray[] = {4, 8, 5 ,44};
    char hello[] = "Hello!";

    //while loop

    while(i < 4){// while the condition in brackets is true execute the loop
    printf("%i ", intarray[i]);
    i++;
    }
    printf("\n");


    i = 0;
    do {
        printf("%i ", intarray[i]);
        i++;
    }while (i <4);
   
    printf("\n");

    printf("Using a for-loop;\n");
    for( i = 0; i < 4 ; ++i){
        printf("%i ", intarray[i]);
    }
    printf("\n");

    printf("reading backwards;\n");

    //read array backwards
    for(i = 3; i >= 0; --i){
        printf("%i ", intarray[i]);
    }

    printf("\n");


    // three ways to print a string:
    //  char hello[] = "Hello!";
    for (i = 0; i < 6; ++i){
        putchar(hello[i]);
    }
    printf("\n");

    for (i = 0; hello[i]; ++i){
        putchar(hello[i]);
    }
    printf("\n");

    printf("%s\n", hello);
    printf(hello); // will give warnings
    printf("\n");


}