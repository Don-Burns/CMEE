## Desc: This Function calculates heights of tree given  distance of each from its bse and angle to its top, using trigonometric formula

# height = distance * tan(radians)

# Arguments
# degrees:   The angle of elevation of tree
# distance:  The distance from base of tree (e.g., meters)

# OUTPUT
# The heights of the tree, same units as "distance"



## TODO's? - speed it up with vectorisation

file <- read.table("../data/trees.csv", sep = ',', header = TRUE, as.is = 1) ## read in data from trees.csv

TreeHeight <- function(degrees, distance){
    radians <- degrees * pi / 180
    height <- distance * tan(radians)
    print(paste("Tree height is:", height))
    return(height)
}


WriteFile <- function(input,outputDir){
    fileSpecies <- rep(NA,nrow(input))
    fileDist <- rep(NA, nrow(input))
    fileDeg <- rep(NA, nrow(input))
    fileHeight  <- rep(NA, nrow(input))

    i = 0
    for (i in 1:nrow(input)){
        fileSpecies[i] <- input[i,1]
        fileDist[i] <-  input[i,2]
        fileDeg[i] <- input[i,3]
        fileHeight[i] <- TreeHeight(input[i,2], input[i,3])  
    }

finalTable <- data.frame(fileSpecies, fileDist, fileDeg, fileHeight)
write.table(finalTable, file = outputDir, sep = ',', row.names = FALSE, col.names = c("Species", "Distance.m", "angle.degrees", "Tree.Height.m") )
return("Done!!!")
}



WriteFile(file, "../data/TreeHts.csv")