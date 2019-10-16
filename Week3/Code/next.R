## Desc: A script looking at how "next" is used.

for(i in 1:10){
    if((i %% 2) == 0){
    next # pass to next iteration of loo
    }
    print(i)
}