#include <stdlib.h>

#include "tree.h"


tree_t* new_tree(int num_taxa){
    tree_t *newt = NULL;

    int i = 0;

    newt = (tree_t*)calloc(1, sizeof(tree_t));
    if(newt != NULL){
        newt->num_taxa = num_taxa;
        newt->num_nodes = 2 * num_taxa -1;
        newt->nodes = (node_t*)calloc(newt->num_nodes, sizeof(node_t));
        if (newt->nodes == NULL){
            // allocation failed; clean up and return NULL
            free(newt);
            return NULL;
        }
        for (i = 0; i < newt->num_nodes; ++i){
            // assign memory indices to the nodes
            newt->nodes[i].mem_index = i;
            // Label the tips with non-zero
            if (i < newt->num_taxa){
                newt->nodes[i].tip = i + 1;
            }
            else{
                // Label the internal nodes with 0 tip
                newt->nodes[i].tip = 0;
            }
        }
    }
    return newt;
}

void delete_tree(tree_t* tree){
    //implement
}


void tree_clear_conects(tree_t* t)
{

    int i = 0;

    for (i = 0; i < t->num_nodes; ++i){
        t->nodes[i].left = NULL;
        t->nodes[i].right = NULL;
        t->nodes[i].anc = NULL;
    }
}


void tree_read_anc_table(int *anctable, tree_t* t){
    int i = 0;
    int j = 0;

    //clear all connector pointers so that we can assume NULL values
    tree_clear_conects(t);




    // Loop over all elements of anctable
    // at each pos link that node to its ancestor 

    for (i = 0; i < t->num_nodes - 1; ++i){ // aer assuming the last entry that the root is the final entry and that it is -1
        j = anctable[i]; // The index of the ancestor at ith node
        t->nodes[i].anc = &t->nodes[j];
        if (t->nodes[j].left == NULL){ // check ancestor node for NULL
            t->nodes[j].left = &t->nodes[i];
        }
    
        else{
            t->nodes[j].right = &t->nodes[i];
        }
    }
    
    t->root = &t->nodes[t->num_nodes-1];

}

void tree_traverse(tree_t* t){
    node_traverse(t->root);
}




































