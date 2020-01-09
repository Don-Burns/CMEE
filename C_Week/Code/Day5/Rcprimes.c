#include <R.h>
#include <Rdefines.h>
#include "count_primes.h"

SEXP count_primes_C_wrap(SEXP limit){
    SEXP result;

    PROTECT(result = NEW_INTEGER(1)); // stops the garbage collector in R from clearing the memory of this int


    int limit_c = 0;
    limit_c = *(INTEGER(limit)); // tells compuler to read the limit arg as a c-type integer

    int c_result = count_primes_C(limit_c);
    *(INTEGER(result)) = c_result;

    UNPROTECT(1); //otherwise you get stackunbalance
    return result;
}