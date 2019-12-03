/*
1- Loop for counting prime numbers

Let's try to write a loop for enumerating each prime numbers between 1 and 100. Just as a reminder, a prime number can only be divided by 1 or itself. Note that of course there are way than one solution to this problem!

Tip1: to write loops in a language you don't know that well, I find it easier to first write it in english and then in computer language. It helps you keeping track of where you want to go.

Tip2: you can use a "logical" architecture (we will see proper logical later on) where you can try to divide all numbers between 2 (you can skip 1) and 100 and check if it can be perfectly divided by any number. You can use the modulo operator (%), if a % b == 0 and a == b, it will mean that a is a prime number.
*/

#include <stdio.h>

int main (void){
    int i = 0;
    int j = 0;
    for(i=2; i <= 100; i++){
        for(j = 2; j <= i; j++){
            if(i % j == 0 && i != j){
                break;
            }
            else if(i % j == 0 && i==j){
                printf("%i is prime\n", i);
            }
        }
    }




}