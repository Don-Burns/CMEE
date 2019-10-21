## Desc: A script looking at methods to take filed data and convert it to a form that is more suitable for analysis.  All done using dplyr and tidyr
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

## install tidyr

require(tidyr) # load the tidyr package



MyWrangledData <- gather(TempData, key = "Species",  value = "Count", c(Cultivation -Block -Plot -Quadra)
head(MyWrangledData); tail(MyWrangledData)

MyWrangledData[, "Cultivaton"] <- as.factor(MyWrangledData[, "Cultivation"])
MyWrangledData[, "Block"] <- as.factor(MyWrangledData[, "Block"])
MyWrangledData[, "Plot"] <- as.factor(MyWrangledData[, "Plot"])
MyWrangledData[, "Count"] <- as.integer(MyWrangledData[, "Count"])
str(MyWrangledData)




