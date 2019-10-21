## Desc: A script to looka t the use of debugging options in R.

doit <- function(x){
    temp_x <- sample(x, replace = TRUE)
    if(length(unique(temp_x)) > 30) {#only take mean sample if there are more than 30 unique entries
        print(paste("Mean of this sample was:", as.character(mean(temp_x))))
    }
    else{
        stop("Couldn't calulate mean: too few unique values!")
    }
}

popn <- rnorm(50)


# lapply(1:15, function(i) doit(popn))


result <- lapply(1:15, function(i) try(doit(popn), FALSE))

class(result)

result

result <- vector("list", 15) # Preallocate/initialise
for(i in 1:15){
    result[[i]] <- try(doit(popn), FALSE)
}

