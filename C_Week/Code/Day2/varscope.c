#include <stdio.h>

void double_int(int i){
    i = 2*i;
    return;
}

void add_one_to_all(int array[], int nelems){
    int i = 0;
    for (i = 0; i < nelems; ++i){
        array[i]++;
    }

    return;
}




int main (void){
    int i = 0;

    int array[] = {44, 77, 88, 101, 22};

    double_int(i);
    printf("Value f  after function call: %i\n", i);
    

    add_one_to_all(array, 5);
    for (i = 0; i < 5; ++i){
        printf("%i ", array[i]);
    }
    printf("\n");

    return 0;
}