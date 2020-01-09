#include <stdlib.h>
#include <stdio.h>


int main (void){

    int numsites = 30;
    int *sppcounts = NULL;
    // int *sppcounts2 = NULL;

    sppcounts = (int*)malloc(numsites * sizeof(int)); // sizeof number of bits in int
    if(sppcounts = NULL){
        printf("Insufficient memeory for operation\n!");
        return 1;
    }
    sppcounts[20] = 44;

    int i = 0;
    for(i=0;i<numsites;++i){
        printf("data in site %i is: %i\n", i, *(sppcounts +i));
    }

 //     Free memory, return to the system before overwritting the pointer to that memory to prevent memory leaks
    free(sppcounts);
    sppcounts = NULL;


    sppcounts = (int*)calloc(numsites, sizeof(int)); // sizeof number of bits in int
    if(sppcounts = NULL){
        printf("Insufficient memeory for operation\n!");
        return 1;   
    }
    sppcounts[20] = 44;

    
    for(i=0;i<numsites;++i){
        printf("data in site %i is: %i\n", i, *(sppcounts +i));
    }

    free(sppcounts);

    return 0;

}



