## Desc: A script for analysing the output of fitting.py

## Script goals
# - combine the output scripts from fitting   
# - find best model for each ID -DONE
# - find overall best model - DONE
# - compile the results into a separate summary csv
# - create new csv with IDs and which models fit best 

######## House Keeping ########
rm(list = ls())


######## script options ########
numMods <- 5


######## Packages #############
library(dplyr)

######## Data Import ##########
IDList = unique(read.csv("../data/CRat.csv", header = T)$ID) # read in all Ids from original `CRat.csv`
CMod = read.csv("../Results/CModResults.csv", header = T, stringsAsFactors = F)
CQMod = read.csv("../Results/CQModResults.csv", header = T, stringsAsFactors = F)
poly2 = read.csv("../Results/poly2ModResults.csv", header = T, stringsAsFactors = F)
poly3 = read.csv("../Results/poly3ModResults.csv", header = T, stringsAsFactors = F)
poly4 = read.csv("../Results/poly4ModResults.csv", header = T, stringsAsFactors = F)

######## Functions ############
commandArgs(trailingOnly = T) # to pass argunments here later


######## Main #########
bestMod <- matrix(0, nrow = length(IDList), ncol = numMods+1) # matrix to store which model fit best in boolean form
bestMod[,1] <- IDList
colnames(bestMod) <- c("ID", "CMod", "CQMod", "poly2", "poly3", "poly4")

AIC <- data.frame(matrix(NA, ncol = numMods+1, nrow = length(IDList))) # matrix to store model AIC values for comparison
colnames(AIC) <- c("ID", "CMod", "CQMod", "poly2", "poly3", "poly4")
AIC$ID = IDList
i = 0
for(ID in IDList){
    i = i + 1

    AIC$CMod[i] <- CMod$AIC[CMod$ID == ID]
    AIC$CQMod[i] <- CQMod$AIC[CQMod$ID == ID]
    AIC$poly2[i] <- poly2$AIC[poly2$ID == ID]
    AIC$poly3[i] <- poly3$AIC[poly3$ID == ID]
    AIC$poly4[i] <- poly4$AIC[poly4$ID == ID]
    if(sum(is.na(AIC[i,])) == 0){
        index <- which(AIC[i,-1] %in% max(AIC[i,-1])) + 1 # index which contains the best model +1 to account for ID column
        bestMod[i, index] <- 1
    }
    else {# to account for NA values
        NAindex <- which(is.na(AIC[i, ]) %in% T) # determine the index of the NA value
        AIC[i, NAindex] <- -9e12 # replace NAs with a very negative number so it is not chosen as best value
        index <- which(AIC[i,-1] %in% max(AIC[i,-1])) + 1 # index which contains the best model +1 to account for ID column
        bestMod[i, index] <- 1
    }
}

# sum each column in bestMod to find number of IDs each model fit best for
bestModTot <- rep(NA, numMods)
names(bestModTot) <- c("CMod", "CQMod", "poly2", "poly3", "poly4")
percentBestMod <- rep(NA, numMods)
names(percentBestMod) <- c("CMod", "CQMod", "poly2", "poly3", "poly4")

for(i in 1:length(bestModTot)) {
    bestModTot[i] <- sum(bestMod[,i+1]) # +1 to acccount for ID column
    percentBestMod[i] <- bestModTot[i] / length(IDList) *100
}









