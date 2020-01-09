#include <stdio.h>
#include "node.h"

void node_traverse(node_t* n){

    

    if (n->tip != 0){
        printf("%i", n->tip);
        return;
    }
    printf("(");
    node_traverse(n->left);
    printf(",");
    node_traverse(n->right);

    printf(")");

    return;

}