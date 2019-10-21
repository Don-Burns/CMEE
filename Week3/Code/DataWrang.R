## Desc: A script looking at methods to take filed data and convert it to a form that is more suitable for analysis.

## import data
MyData <- as.matrix(read.csv("../data/PoundHillData.csv", header = F, stringsAsFactors = F))
##import meta data
MyMetaData <- read.csv("../data/PoundHillMetaData.csv", header = T, sep = ";", stringsAsFactors = F)

##look at the data
class(MyData)

head(MyData)

MyMetaData

## modifying the dataset to replace "" with 0s
MyData[MyData == ""] = 0


###### change from short to long format########
## Transpose data as preparation for change
MyData <- t(MyData)
head(MyData)

colnames(MyData)

TempData <- as.data.frame(MyData[-1,], stringsAsFactors = F)
head(TempData)
##add column names
colnames(TempData) <- MyData[1,] # assign column names from original data
head(TempData)


## remove row names

rownames(TempData) <- NULL
head(TempData)

## install reshape2

require(reshape2) # load the reshape2 package

MyWrangledData <- melt(TempData, id = c("Cultivation", "Block", "Plot", "Quadrat"), variable.name = "Species", value.name = "Count")
head(MyWrangledData); tail(MyWrangledData)

MyWrangledData[, "Cultivaton"] <- as.factor(MyWrangledData[, "Cultivation"])
MyWrangledData[, "Block"] <- as.factor(MyWrangledData[, "Block"])
MyWrangledData[, "Plot"] <- as.factor(MyWrangledData[, "Plot"])
MyWrangledData[, "Count"] <- as.integer(MyWrangledData[, "Count"])
str(MyWrangledData)




