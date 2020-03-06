
## Desc: A script for analysing the output of only mechanistic models of fitting.py
# author: Donal Burns
# Date: 06/03/2020
######## House Keeping ########
rm(list = ls())


######## script options ########
numMods <- 2
# the column of the data that you wish to separate the fits by
column_names <- c("ID", "CMod", "CQMod")
mod_names <-c("CMod", "CQMod")
######## Packages #############
library(dplyr)

######## Data Import ##########
# read in orignial data  and take only what is needed
cRat <- read.csv("../data/CRat.csv", header = T, stringsAsFactors = F) 
OrigData <-  unique(cRat %>% select(ID, Habitat))# take only  IDs from original `CRat.csv` and the coresponding category
rm(cRat) # remove as its no longer needed
IDList <-  unique(OrigData$ID)
cats <- unique(OrigData$Habitat)

CMod <- read.csv("../Results/CModResults.csv", header = T, stringsAsFactors = F)
CQMod <- read.csv("../Results/CQModResults.csv", header = T, stringsAsFactors = F)


######## Refine IDlist ############
# remove ID for which a = 0 or h=0 is produced in holling models as its not biologically viable
invalid <- c(which(IDList %in% IDList[CMod[,"a"] <= 0]))
invalid <- c(invalid, c(which(IDList %in% IDList[CQMod[,"a"] <= 0])))
invalid <- c(invalid, c(which(IDList %in% IDList[CMod[,"h"] <= 0])))
invalid <- c(invalid, c(which(IDList %in% IDList[CQMod[,"h"] <= 0])))
invalid <- unique(invalid)
IDList <- IDList[-invalid]
OrigData <- OrigData[-invalid,]
CQMod <- CQMod[-invalid,]

NACMod <- sum(is.na(CMod$AIC))
NACQMod <- sum(is.na(CQMod$AIC))

# NAPoly4 <- sum(is.na(poly4$AIC))

## remove na values
CQMod$AIC[is.na(CQMod$AIC)] <- 9e12
######## Main #########
bestMod <- data.frame(matrix(0, nrow = length(IDList), ncol = numMods+1)) # matrix to store which model fit best in boolean form
bestMod[,1] <- IDList
colnames(bestMod) <- column_names

AIC <- data.frame(matrix(NA, ncol = numMods+1, nrow = length(IDList))) # matrix to store model AIC values for comparison
colnames(AIC) <- column_names
AIC$ID = IDList

i = 0




for(ID in IDList){
    i = i + 1
    
    AIC$CMod[i] <- CMod$AIC[CMod$ID == ID]
    AIC$CQMod[i] <- CQMod$AIC[CQMod$ID == ID]
    
    row <- AIC[i,-1]
    row <- row - min(row)
    if(sum(row <= 2) == 1) bestMod[i,] <- c(ID, row <= 2)
}


# sum each column in bestMod to find number of IDs each model fit best for overall
overallBestModTot <- rep(NA, numMods)
overalPercentBestMod <- rep(NA, numMods)


for(i in 1:length(overallBestModTot)) {
    overallBestModTot[i] <- sum(bestMod[,i+1]) # +1 to acccount for ID column
    overalPercentBestMod[i] <- overallBestModTot[i] / length(IDList) *100
}

# find best results for each category
bestModTot <- matrix(NA, ncol = numMods, nrow = length(cats))
colnames(bestModTot) <- mod_names
rownames(bestModTot) <- c(cats)

percentBestMod <- matrix(NA, ncol = numMods, nrow = length(cats))
colnames(percentBestMod) <- mod_names
rownames(percentBestMod) <- c(cats)

for(i in cats){
    IDs <- subset(OrigData, OrigData$Habitat == i)
    tmp <- subset(bestMod, bestMod$ID %in% IDs$ID ==T)# assign the from best mods for the category
    tmp <- tmp[,-1] #  remove Id col for summing
    for(j in colnames(tmp)){
        bestModTot[i,j] <- sum(tmp[,j])
        percentBestMod[i,j] <- bestModTot[i,j] / nrow(tmp) *100
    }
}

combinedBestMod <- rbind(overallBestModTot, bestModTot)
rownames(combinedBestMod) <- c("overall",cats)
combinedPercentBestMod <- rbind(overalPercentBestMod, percentBestMod)
rownames(combinedPercentBestMod) <- c("overall", cats)

TotalModelFit <- 0 # the total number of times the models converged
numMarineData <- sum(OrigData$Habitat == "Marine")
numTerrestrialData <- sum(OrigData$Habitat == "Terrestrial")
numFreshwaterData <- sum(OrigData$Habitat == "Freshwater")
write.csv(combinedBestMod, "../Results/MechanisticResultsRaw.csv")
write.csv(combinedPercentBestMod, "../Results/MechanisticResultsPercent.csv")


q <- rep(NA, 5)
names(q) <- c("mean", "min", "max", "variance", "Number of values")
q[1] <- mean(na.omit(CQMod$q))
q[2] <- min(na.omit(CQMod$q))
q[3] <- max(na.omit(CQMod$q))
q[4] <- var(na.omit(CQMod$q))
q[5] <- sum(na.omit(CQMod$q)<=3)#  number q values <=1


# output results
write.csv(combinedBestMod, "../Results/MechanisticResultsRaw.csv")
write.csv(combinedPercentBestMod, "../Results/MechanisticResultsPercent.csv")
write.csv(q, "../Results/qResults.csv")
pdf(file = "../Results/qHist.pdf")
hist(na.omit(CQMod$q), breaks = 1000, xlim = c(0,3),ylim = c(0,100), col = "gray", xlab = "q Values", main ="")
dev.off()




