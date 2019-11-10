## Desc:  A script to make a regression, create a graph to match a pre-made example as closely as possible and save the key data generated to a `csv`


##House keeping##
rm(list = ls())




### packages ###
require(ggplot2)

### import data and assign variables ###
d <- read.csv("../data/EcolArchives-E089-51-D1.csv", stringsAsFactors = F)


for( i in 1:length(d[,1])){
    if (d$Prey.mass.unit[i] == "mg"){
        d$Prey.mass[i] = d$Prey.mass[i] / 1000
        d$Prey.mass.unit[i] = "g"
    }
}

#### get data for and write csv###

csvData = matrix(nrow = 1, ncol = 8)
csvHeaders = c("Type of Feeding Interaction", "Predator Lifestage", "Location", "Regression Slope", "Regression Intercept", "R^2", "F-statistic Value", "p-value")
i <- 1 ##counter for martrix row when storing values in loop
for(feed in unique(d$Type.of.feeding.interaction)){
    feedInt <- subset(d, d$Type.of.feeding.interaction == feed) # make subset of only desired feeding interaction
    for(lifestage in unique(d$Predator.lifestage)){
        
        lifesub <- subset(feedInt, feedInt$Predator.lifestage == lifestage) # make a subset of the feeding interaction with only desired lifestage
        for(location in unique(lifesub)){
            tmp <- subset(lifesub, lifesub$Location == location)

        

            if(dim(tmp)[1] != 0){ # checks if tmp has elements to use for lm
                lm_sum <- summary(lm(Predator.mass ~ Prey.mass, data = tmp)) # sets summary of lm
                if(nrow(lm_sum$coefficients) > 1) {# makes sure there is some data to take from lm_sum$coefficients
                    lm_coef <- lm_sum$coefficients
                    regSlope <- lm_coef[2,1]
                    regInt <- lm_coef[1,1]
                    lmR2 <- lm_sum$r.squared
                    lm_Fstat <- unname(lm_sum$fstatistic[1])
                    pVal <- lm_coef[2,4]
                    loc <- location[1]
                    curItMat <- matrix(NA, nrow = 1, ncol = 8)          # make a matrix to store the values in, then assign them.
                    curItMat[1] <- feed                               # feeding type
                    curItMat[2] <- lifestage                          # lifestage
                    curItMat[3] <- loc                                # location
                    curItMat[4] <- regSlope                           # slope of lm
                    curItMat[5] <- regInt                             # Intercept of lm
                    curItMat[6] <- lmR2                               # R2 of lm
                    curItMat[7] <- lm_Fstat                           # fstat of lm
                    curItMat[8] <- pVal                              # p value
                    csvData <- rbind(csvData, curItMat)
                    #if(is.nan(curItMat[6])) stop("found NaN") # for debug
                    i <- i + 1                                          # tick up for next row
                }
            }
        }
    }
}







csvData <- csvData[-1,] # remove first row of Na that is left from first defining the matrix
output <- as.data.frame(csvData) ## save as a data frame ready for saving
colnames(output) <- csvHeaders # add row names
write.csv(output, "../Results/PP_Regress_loc.csv", row.names = F)







