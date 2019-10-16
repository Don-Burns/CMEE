##Desc: A script looking at how to break out of a loop using the "break" funtion.

i <- 0 #Initialise i 
    while(i < Inf){
        if (i == 10){
            break
        }# Break out of the while loop!
        else {
            cat("i equals ", i, "\n")
            i <- i + 1 # update i
        }
    }