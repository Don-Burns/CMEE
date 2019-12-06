## Desc:  A script finding the correlation between Temperature change across years. \n Input: Data in a style such as that found in `../data/KeyWestAnnualMeanTemperature.RData` with the same headers\n Output: A graph showing the correlation of temperature changes over years vs if the same data were just chosen in a random order without time having any influence.

#### Clearing data ###
rm(list=ls())

############## File information - edit here to changematch input file layout ##############################
File <- "../data/KeyWestAnnualMeanTemperature.RData"  ## file to be read in
data = load(File)
Temp <- ats[,2] # observed temperature data
Year <- ats[,1] # year it was observed
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


 
corYrs <- function(Temp){
    # uses trim function to make, shift and trim to size two lists for comparison of 
    YrCor <- cor(trim("bot", Temp), trim("top", Temp)) #bot is for t, top is for t+1
    return(YrCor)
}


sampleYrs <- function(Temp, NumSamples){
    # for randomly sampling the years 
    size = length(Temp)
    sampleTemp <- rep(NA, size)
    samples <- matrix(NA, ncol = NumSamples, nrow =  size)
    for (i in 1:NumSamples){
    samples[,i] <- sample(Temp, size, replace = FALSE)
    }
    return(samples)
    
}


corSamples <- function(samples){
    cor <- rep(NA, ncol(samples))
    for(i in 1:ncol(samples)){
        cor[i] <- corYrs(samples[,i])
    }
    return(cor)
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
ObservedCor <- corYrs(Temp)
Samples <- sampleYrs(Temp, 10000)
CorSamples <- corSamples(Samples)
SampleMean <- mean(Samples)
print(SampleMean)
# plot (Temp)





##### Calculate P-value

p <- p_val(ObservedCor, CorSamples)
print(paste("The p-value of the observed data vs randomly generated data is", p))


#######plotting########
# d <- data.frame(NA, nrow = length(Temp) -1, ncol = 2)## combine timen shifted data for plotting
# d[,1] <- t(trim("bot", Temp)) # t
# d[,2] <- t(trim("top", Temp)) # t+1

# d <- as.data.frame(d)d <- matrix(NA, nrow = length(Temp) -1, ncol = 2)## combine timen shifted data for plotting
# d[,1] <- trim("bot", Temp) # t
# d[,2] <- trim("top", Temp) # t+1
# 
# d <- as.data.frame(d)



pdf("../Results/TAuto_SampleCor.pdf")
qplot(CorSamples, geom = "histogram", col = I("black"), fill =I("gray"), xlab = "Samples", ylab = "Count")
graphics.off()
# qplot(as.numeric(d1), as.numeric(d2))
pdf("../Results/TAuto_Temps.pdf")
qplot(trim("bot", Temp), trim("top", Temp), geom = c("point", "smooth"), method = "lm", xlab = "t", ylab = "t+1")
graphics.off()





################GRAVEYARD###################

# ### get data for the plot
# d1 <- matrix(NA, nrow = (nrow(Samples)-1), ncol = ncol(Samples)) # d1 1 is t d2 2 is t+1
# d2 <- d1 <- matrix(NA, nrow = (nrow(Samples)-1), ncol = ncol(Samples)) #d2 2 is t+1
# 
# for(i in 1:ncol(Samples)){
#     d1[, i] <- trim("bot", Samples[,i])
#     d2[, i] <- trim("top", Samples[,i])
# }


## NOTES;   include plot of original series in pdf
    #       are plotting t vs t+1