# Desc: script looking at how to calculate and interprete coalescence data.
##HOUSEKEEPING####
rm(list = ls())


####read in data######
north <- read.csv("../data/killer_whale_North.csv", header = F)
south <- read.csv("../data/killer_whale_South.csv", header = F)

###Define known variables####
mu <- 1*10^-8

##Functions###

Find_SNPs <- function(d){ #finds columns with more than 1 unique value and retruns them. 
    #VARS: d = data
    loci <- NULL
    for(i in 1:ncol(d)){
        if(length(unique(d[,i])) > 1){ # find column with more than 1 unique value and record it
            loci <- c(loci, i) 
        }
        
    }
    return(loci)
}


only_loci <- function(data, SNPloci){
    lociDF <- matrix(NA, nrow = nrow(data), ncol = length(SNPloci))
    ticker <- 1
    for(i in SNPloci){
        lociDF[,ticker] <- data[,i]
        ticker <- ticker + 1
    }
    
    return(lociDF)
    
}

watterson <- function(data){
    SNPloci <- Find_SNPs(data)
    s <- length(SNPloci)#Find num of  SNPs
    n <- nrow(data)
    bot <- c()
    for(i in 1:(n-1)){
        bot <- c(bot, 1/i)
    }
    thetaW <- s/sum(bot)
    
    return(thetaW)
}


tajima <- function(data){
    
    SNPloci <- Find_SNPs(data)
    data <- only_loci(data, SNPloci)
    dij <- 0
    n <- nrow(data)
    for(i in 1:(nrow(data)-1)){
        for(s in (i+1):nrow(data)){
                dij <- dij + sum(data[i,] != data[s,])
        }
    }
    
    bot <- (n*(n-1))/2
    
    thetaT <- dij/bot
    return(thetaT)
}


sfs <- function(data){
    SNPloci <- Find_SNPs(data)
    sfs_array <- rep(NA, length(SNPloci))
    array_point <- 1
    for(i in 1:length(SNPloci)){
        tmp <- 0 # counter for number of 1s in a SNP locus
        dcol <- SNPloci[i]
        for(r in 1:nrow(data)){
            if(isTRUE(data[r, dcol] == 1)){
                tmp <- tmp + 1
            }
        } 
        sfs_array[array_point] <- tmp
        array_point <- array_point + 1
    }
    f <- c()
    for(i in sfs_array){
        f <- c(f, i/length(SNPloci))
    }
    
    return(f)
}


###Main####

wattNorth <- watterson(north)
wattSouth <- watterson(south)
tajNorth <- tajima(north)
tajSouth <- tajima(south)
thetaNorth <- 4*mu*(ncol(north))*(nrow(north))
sfsNorth <- sfs(north)
sfsSouth <- sfs(south)

#####plotting#####
par(mfrow = c(1,2))
barplot(sfsNorth)
barplot(sfsSouth)
#### Testing ####
SNPloci <- Find_SNPs(north)
data <- north
###planning####

# need:
    # differences pairwise
    # pi


    # S = num SNPs
    # 

