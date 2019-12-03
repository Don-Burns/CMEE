
#include <stdio.h>

int main (void){
    char cap = '\0';
    char offset = 'A' - 'a';

    printf("Input a capital cahracter: ");
    cap = getchar(); // take input from the user

    if (cap >= 'A' && cap <= 'Z'){
            printf("The lowercase of %c is: %c\n", cap,cap-offset);
    }
    else
    {
        printf("The input is out of range.  Enter a capital letter\n");
    
    }
/*
   if (cap >= 'A'){
        if (cap <= 'Z'){
            printf("The lowercase of %c is: %c\n", cap,cap-offset);
        }
        else
        {
            printf("The input is out of range.  Enter a capital letter\n");
        }
    }
    else
    {
        printf("The input is out of range.  Enter a capital letter\n");
    
    }*/
    
    return 0;
}