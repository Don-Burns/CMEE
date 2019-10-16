## Desc: A function looking at the speed difference between preallocating memory and not doing so.  Variable "size" can be changed to vary size of the allocation.

size = 10

NoAllocation <- function(){
    a <- NA
    for (i in 1:size) {
        a <- c(a, i)
        # print(a)
        # print(object.size(a))
    }
}








WithAllocation <- function(){
    a <- rep(NA, size)
    for (i in 1:10){
        a[i] <- i
        # print(a)
        # print(object.size(a))
    }
}


print("Time without allocation:")
print(system.time(NoAllocation()))
print("Time with allocation:")
print(system.time(WithAllocation()))