## Desc: A script looking at how to use sampling and the speed of various methods using *apply or not.

################ Functions #################
## A function to take a sample of size n from a population "popn" and return its mean
myexperiment <- function(popn,n){
    pop_sample <- sample(popn, n, replace = FALSE)
    return(mean(pop_sample))
}

## Calculate means using a for loop without preallocation:
loopy_sample1 <- function(popn, n, num){
    result1 <- vector() # Initialise the vector of size 1
    for(i in 1:num){
        result1 <- c(result1, myexperiment(popn, n))
    }
    return(result1)
}

## To run "num" iterations of the experiment using a for lop on a vector with preallocation:
loopy_sample2 <- function(popn, m, num){
    result2 <- vector(,num) # Preallocate exprected size
    for (i in 1:num){
        result2[i] <- myexperiment(popn, n)
        }
        return(result2)
}

## To run "num" interations of the experiment using a for loop on a list with preallocation:
loopy_sample3 <- function(popn, n, num){
    result3 <- vector("list", num) # preallocate exprected size
    for( i in 1:num){
        result3[[i]] <- myexperiment(popn, n)
    }
    return(result3)
}


## To run "num" iterations of the experiment using vectorisation with lapply:
lapply_sample <- function(popn, n, num){
    result4 <- lapply(1:num, function(i) myexperiment(popn, n))
    return(result4)
}


## To run "num" iterations of the experiment using vectorisation with lapply:
sapply_sample <- function(popn, n, num){
    result5 <- sapply(1:num, function(i) myexperiment(popn, n))
    return(result5)
}

popn <- rnorm(1000) #generate the population
hist(popn)


n <- 20     # sample size for each experiment
num <- 1000 # Number of time to rerun the experiment

print("The loopy, non-preallocation approach takes:")
print(system.time(loopy_sample1(popn, n, num)))

print("The looopy, but wiht preallocation appraoch takes:")
print(system.time(loopy_sample2(popn, n, num)))

print("The loopy, non-preallocation approach takes:")
print(system.time(loopy_sample3(popn, n, num)))

print("The vectorised sapply approach takes:")
print(system.time(sapply_sample(popn, n, num)))

print("The vectorised lapply approach takes:")
print(system.time(lapply_sample(popn, n, num)))




