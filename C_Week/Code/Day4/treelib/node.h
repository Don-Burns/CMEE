#ifndef _NODE_H
#define _NODE_H

// A typedef to save keystrokes
typedef struct  _node node_t;
typedef struct _node
{
    node_t *left; // point to branch left
    node_t *right;
    node_t *anc;// point to ancestor

    int tip;// a tip number 
    int mem_index; // memory index
    char *label;

} node_t;

void node_traverse(node_t* n);








#endif