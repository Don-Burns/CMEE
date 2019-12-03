

#include <stdio.h>

int main (void){
    int x = 6;
    int y = 0;

    // postfix incrementation
    y = x++;
    printf("Y after postfix:%i\n",y);
    printf("X after postfix: %i\n",x);

    // prefix increment
    y = ++x;
    printf("y after prefix: %i\n",y);
    printf("x prefix: %i\n", x);

    // Deincrement
    
    printf("x with decrement: %i\n", x--); // undefined behavior, should assign beforehand to avoid issues




    return 0;

}