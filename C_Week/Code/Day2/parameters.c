#include <stdio.h>

void print_int_array(const int array[], const int nelems){
    int i = 0;
    
    for (i = 0; i < nelems; ++i){
        printf("%i", array[i]);
        if(i < (nelems -1)){
            printf(", ");
        }
    }
    printf("\n");


    return; // for a void functio return is good practice but trying to return a value will cause errors.  Can be used to cut off functions under given conditions
}

int main (void){
    int intarray[] = {8 , 6, 4, 2, 101, 27};

    print_int_array(intarray,6);
}