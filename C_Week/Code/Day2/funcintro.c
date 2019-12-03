#include <stdio.h>

int add_integers(int, int);
int add_four_integers(int, int, int, int);


int add_four_integers( int a, int b, int c, int d){
    return add_integers(a,b) + add_integers(c,d);
}

int add_integers(int x, int y){
    return x + y;
}





int main(void){

    int a =5;
    int b =6;
    int result = 0;

    result = add_integers(a,b);

    printf("The sum of `a` and `b` is: %i\n",result);

    printf("The sum of result and b is: %i\n", add_integers(b, result));

    return 0;
}