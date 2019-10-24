## Desc:  A script finding the correlation between Temperature change across years. \n Input: Data in a style such as that found in `../data/KeyWestAnnualMeanTemperature.RData` with the same headers\n Output: A graph showing the correlation of temperature changes over years vs if the same data were just chosen in a random order without time having any influence.

#### Clearing data ###
rm(list=ls())

############## File information - edit here to changematch input file layout ##############################
File <- "../data/KeyWestAnnualMeanTemperature.RData"  ## file to be read in
data = load(File)
Temp <- ats[,2]
Year <- ats[,1]
################################################################################

######### Load packages ##############
require(ggplot2)

####################################

#############Functions##################
trim <- function(trimSpot, vector){
    ##choose if it should be the front or back trimmed with top or bot.
    x <- vector

    if (trimSpot == "top"){
        trimmed <- x[-1]
    }

    if (trimSpot == "bot"){
        trimmed <- x[-length(x)]
    }

    return(trimmed)
}


 
CorYrs <- function(Temp){
    # uses trim function to make, shift and trim to size two lists for comparison of 
    YrCor <- cor(trim("bot", Temp), trim("top", Temp))
    return(YrCor)
}


sampleYrs <- function(Temp, NumSamples){
    # for randomly sampling the years 
    size = length(Temp)
    sampleTemp <- rep(NA, size)
    samples <- rep(NA, size)
    for (i in 1:NumSamples){
    sampleTemp <- sample(Temp, size, replace = FALSE)
    samples[i] <- CorYrs(sampleTemp)
    }
    return(samples)
    
}


p_val <- function(ObservedCor, random_samples){
    reps <- length(random_samples)
    over <- 0

    # over <- sapply(random_samples, 1, function(ObservedCor) {if(random_samples > ObservedCor)})  ## to come back to

    for(i in 1:reps){
        if(random_samples[i] > ObservedCor) over <- over + 1
    }
    p <- over / reps
}
##############BODY#####################
##Check that samples are indeed representing a random selection.  Should be as close to 0 as possible.
ObservedCor <- CorYrs(Temp)
Samples <- sampleYrs(Temp, 10000)
SampleMean <- mean(Samples)
print(SampleMean)
plot (Temp)





#### Calculate P-value
# sapply(1:)



p <- p_val(ObservedCor, Samples)
print(p)
qplot(Samples, geom = "histogram")
qplot(Samples)


################GRAVEYARD###################


# print(CorYrs())
# print(cor(trim("top", ats[,2]), trim("bot", ats[,2])))







# plot(ats)
# print(cor(ats["Year"], ats["Temp"]))


## NOTES;   include plot of original series in pdf
    #       are plotting t vs t+1