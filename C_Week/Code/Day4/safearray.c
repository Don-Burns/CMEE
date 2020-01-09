#include <stdlib.h>
#include <stdio.h>

struct intvec{
    size_t nelems;
    int* data;
};

typedef struct intvec intvec_t; // makes an alias for the "strcut intvect" 

intvec_t *new_intvec(size_t nelems){
    intvec_t* newvec = NULL;
    newvec = (intvec_t*)calloc(1, sizeof(intvec_t));

    if (newvec != NULL){
        // set the array bounds
        newvec->nelems = nelems;

        // Allocate the memory for the 'array'
        newvec->data = (int*)calloc(nelems, sizeof(intvec_t));
        if (newvec->data ==NULL){
            // if it failed, clean up the resources and exit the function returning NULL
            free(newvec);
            return NULL;
        }
    }

    return newvec;
}


void delete_intvec(intvec_t* ints){
    if (ints != NULL){
        if (ints->data != NULL){
            free(ints->data);
            ints->data = NULL;
        }
        free(ints);  
    }
    
}




// This function sets dat in th int vec at a particular position; return 0 if success; and resturns -1 if dailed (i.e. out of bounds)
int set_data(int data, int index, intvec_t* ints){
    if (index >= ints->nelems){
        return -1;
    }

    ints->data[index] = data;
}

// This fucntion gets data from a particular index in the intvec; returns 0 if success; return -1 if failed (i.e. out of bounds)
int get_data(int* res, int index, intvec_t* ints){
    if (index < ints->nelems){
        *res = ints->data[index];
        return 0;
    }
    return -1;
}

int main (void){

    intvec_t*sppcounts = new_intvec(30);


    int i = 0;
    int val = 0;

    for (i =0; i < sppcounts->nelems; ++i){
        set_data(i + 3, i, sppcounts);
    }

    printf("All teh elements of sppcounts:\n");
    for (i = 0; i < sppcounts->nelems; ++i){
        get_data(&val, i, sppcounts);
        printf("%i ", val);
    }
    printf("\n");

    int error = 0;

    error = get_data(&val, 50, sppcounts);
    if (error != 0){
        printf("Error!, Tried to read out of bounds, you muppet!\n");
    }
    
    
    
    
    
    
    return 0;

}