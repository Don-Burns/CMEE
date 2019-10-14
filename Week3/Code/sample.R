x <- rnorm(50) # Generate your population

doit <- function() {
    x <- sample(x, replace = TRUE)
    if(length(unique(x)) > 30) {#only take mean if sample was sufficient
    print(paste("Mean of this sample was:", as.character(mean(x))))
    }
}

## Run 100 interations using vectorization:
result <- lapply(1:100, function(i)doit(x))

## Or using a for loop:
result <- vector("list", 100) # Preallocate/Initialise
for(i in 1:100){
    result[[i]] <- doit(x)
}



