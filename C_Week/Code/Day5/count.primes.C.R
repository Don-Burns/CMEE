count.primes.C <- function(limit){
    .Call("count_primes_C_wrap", limit = as.integer(limit))
}