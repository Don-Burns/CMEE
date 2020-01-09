#include <stdio.h>
#include <stdlib.h>




struct listobj{
    int data;
    struct listobj* next;
        
    
};

void traverse_list(struct listobj* lobj){
    /* this function traverses a list recursively and calls oout the integer stored inside*/
    if (lobj!= NULL){
        printf("int data: %i\n", (*lobj).data); // pre-order
        traverse_list((*lobj).next);
        printf("int data: %i\n", (*lobj).data); // post order

    }
}


int main (void){


    
    struct listobj l1;
    struct listobj l2;
    struct listobj l3;
    struct listobj l4;
    
    int intarray[3] = {10, 21, 33};
    
    l1.data = 10;
    l2.data = 21;
    l3.data = 33;
    l4.data = 41;


    l1.next = &l2;
    l2.next = &l3;
    l3.next = NULL;

    // loop through linked list

    struct listobj* p = NULL;
    p = &l1;

    // first lets look at memeber selection via a pointer
    int data = 0;
    data = (*p).data; // struct refference operator has higher precedence so brackets are needed.

    data = p->data; // exact same meaning as the line above, is merely a shorthand

    // So let's leverage to do some looping
    while (p != NULL)
    {
        printf("data in p: %i\n", p->data);
        p = p->next;

    }
    



    // insert a new elemenet
    p = &l1;
    l1.next = &l4;
    l4.next = &l2;

    printf("Inserting new element.\n");

    while (p != NULL)
    {
        printf("data in p: %i\n", p->data);
        p = p->next;

    }
    // let's traverse the list recursively using a function
    printf("Traversing recusively.\n");
    traverse_list(&l1);
    printf("\n");


    return 0;
}