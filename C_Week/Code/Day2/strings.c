

#include <stdio.h>

int main (void){
    char chararray[] = {'a', ' ', 'a', 't', 'r', 'i','n', 'g', '!', '\0'}; // in reality the string data type has the null character on  the end
    char string1[] = "A string!";

    printf("The 9th element of chararray: %i\n", chararray[9]);
    printf("The 9th element of string: %i\n", string1[9]);
}