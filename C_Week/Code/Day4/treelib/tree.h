#ifndef _TREE_H_ /*if undefined call otherwise dont, prevents loops*/
#define _TREE_H_

#include "node.h"

typedef struct _tree {
    int num_taxa;
    int num_nodes;
    node_t* nodes;
    node_t* root;
}tree_t;


tree_t* new_tree(int num_taxa);
void delete_tree(tree_t* tree);
void tree_read_anc_table(int *anctable, tree_t* t);

#endif