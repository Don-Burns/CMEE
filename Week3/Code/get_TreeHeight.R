## Desc: This script calculates heights of tree given  distance of each from its base and angle to its top, using trigonometric formula and writes a new file with the heights of the tree appended. \nInput: Realtive directory to .csv file containing species names, distance from tree in meters and angle to top of each tree in degress./nOutput: File named InputFileName"_Treeheight.csv"

####### Read in file #############
title = "../data/trees.csv"
# if no file is given run with a test file.
File = "../data/trees.csv"

# else run with the file given
if(length(commandArgs(trailingOnly = T)) != 0) {
    File = commandArgs(trailingOnly = T)
    title = commandArgs(trailingOnly = T)
}
############# Functions ###############
TreeHeight <- function(degrees, distance){
    # function to calculate height of a tree given angle to top of tree from point of observationa and distance to the base of the tree
    radians <- degrees * pi / 180
    height <- distance * tan(radians)
    print(paste("Tree height is:", height))
    return(height)
}


WriteFile <- function(input,outputDir){
    ## a function to construct the table of data and write to a file
    FileSpecies <- rep(NA,nrow(input))
    FileDist <- rep(NA, nrow(input))
    FileDeg <- rep(NA, nrow(input))
    FileHeight  <- rep(NA, nrow(input))
    
    i = 0
    for (i in 1:nrow(input)){
        FileSpecies[i] <- input[i,1]
        FileDist[i] <-  input[i,2]
        FileDeg[i] <- input[i,3]
        FileHeight[i] <- TreeHeight(input[i,2], input[i,3])  
    }
    
    finalTable <- data.frame(FileSpecies, FileDist, FileDeg, FileHeight)
    write.table(finalTable, file = outputDir, sep = ',', row.names = FALSE, col.names = c("Species", "Distance.m", "angle.degrees", "Tree.Height.m") )
    return("Done!!!")
}


###### MAIN ######
## make the modified table, with heights
File <- read.table(File, sep = ',', header = TRUE, as.is = 1) ## read in data from trees.csv

## make new file name for output
title = basename(title)
FileName = gsub(".csv", "", title, ignore.case = F)


## output file to results
outputTitle = paste("../Results/",FileName,"_TreeHts.csv", sep = "")

WriteFile(File, outputTitle)