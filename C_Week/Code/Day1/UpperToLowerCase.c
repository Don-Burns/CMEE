// Desc: takes an uppercase letter `uppercase` and converts it to lowercase. i.e. add 32 to the uppercase letter


#include <stdio.h>

int main(void){
    
    
    char Uppercase = 'A'; // the uppercase letter in question
    int Lowercase = Uppercase + 32;


    printf("The character as uppercase is: %c\n", Uppercase);
    printf("The character as lowercase is: %c\n", Lowercase);


    return 0;
}