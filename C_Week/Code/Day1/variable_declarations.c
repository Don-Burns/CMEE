/*
3- Variable declarations

Rewrite the the example program below trying different type of basic variables (int, char, float, double - you can express each of them using printf and respectively %i, %c, %f and %e)
*/


#include <stdio.h>

int main (void)
{

  int x = 20;
  char a = 'c';
  float f = 2.5;
  double dub = 2.555;
  int chara = 'a';

  printf("The value of x: %i\n", x);
  printf("The value of a: %c\n", a);
  printf("The value of f: %f\n", f);
  printf("The value of dub: %e\n", dub);
  printf("The value of chara: %i\n", chara); //Will return the value of a in the acii table i.e. 97


  return x;

}
