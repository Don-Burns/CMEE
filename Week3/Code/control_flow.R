## Desc: A script experimenting with how control flow tools are used in R.

## If statement 

a <- TRUE
if (a == TRUE){
    print("a is TRUE")
    }else{
    print("a is FALSE")
}

## If statement on a single line
z <- runif(1) ## uniformly distributed random number
if (z <= 0.5){print("less than a half")}

## FOR loop using a sequence
for(i in 1:10){
    j <- i * i
    print(paste(i, " squared is", j))
}

## FOR loop over vector of strings
for(species in c('Heliodoxa rubinoides', 'Boissoneaua jardini', 'Sula nebouxii')){
    print(paste('The species is', species))
}

## for loop using a vector
v1 <- c("a", "bc", "def")
for(i in v1){
    print(i)
}

## while loop 
i <- 0 
while (i<10){
    i <- i+1
    print(i^2)
}





