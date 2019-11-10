## Desc: A script working on `04_Demograpy.md`: Practical on population subdivision and demographic inferences. \nInput: 2 `csv` files.  `turtles.csv` has the alleles.  `turtle.genotypes.csv` has the genotype data for the population.  Both data sets contain data for 4 populations, each has 10 individuals and is listed in the order shown in Matteo's repository.

###HOUSE KEEPING######
rm(list = ls())

###IMPORTING DATA#####
d_allele <- read.csv("../data/turtle.csv", header = F)
d_geno <- read.csv("../data/turtle.genotypes.csv", header = F)

#### Predefined vars #####
origin_dist <- c(5, 10, 12, 50)

####Functions######
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


only_loci <- function(data){##finds and make a matrix with only the SNP sites, given allele data
    SNPloci <- Find_SNPs(data)
    lociDF <- matrix(NA, nrow = nrow(data), ncol = length(SNPloci))
    ticker <- 1
    for(i in SNPloci){
        lociDF[,ticker] <- data[,i]
        ticker <- ticker + 1
    }
    
    return(lociDF)
    
}

calc_fA <- function(loci_data){## calculates fA of a site given only_loci matrix
    
    allele_freq <- rep(NA, ncol(loci_data))
    
    for(i in 1:ncol(loci_data)){
        allele_freq[i] <- sum(loci_data[,i])/nrow(loci_data)
    }
    
    
    return(allele_freq)
}


calc_HT <- function(loci_data1, loci_data2){# calculates HT given a matrix of SNP locations for 2 populations
    allele_freq1 <- calc_fA(loci_data1)
    allele_freq2 <- calc_fA(loci_data2)
    HT <- rep(NA, length(allele_freq1))
    
    for(i in 1:length(allele_freq1)){
        fA1 <- allele_freq1[i]      # i.e. 1s in pop1
        fA2 <- allele_freq2[i]  # i.e. 1s in pop2
        HT[i] <- ((2*(fA1 + fA2)/2)*(1 - ((fA1 + fA2)/2)))
    }
    
    
    return(HT)
}

calc_Hs <- function(loci_data1, loci_data2){# calculates Hs given a matrix of SNP locations for 2 population
    allele_freq1 <- calc_fA(loci_data1)
    allele_freq2 <- calc_fA(loci_data2)
    Hs <- rep(NA, length(allele_freq1))
    
    for(i in 1:length(allele_freq1)){
        fA1 <- allele_freq1[i]      # i.e. 1s in pop 1
        fA2 <- 1 - allele_freq2[i]  # i.e. 1s in pop 2
        Hs[i] <- (fA1 * (1-fA1)) + (fA2*(1-fA2))#((2 * fA1*(1-fA1)) + (2*fA2*(1-fA2))/2)
    }
    
    
    return(Hs)
}

calc_Fst <- function(Ht, Hs){
    Fst <- (Ht - Hs)/Ht
    
    return(mean(Fst, na.rm = T))
} 

####MAIN####
dAlleleSNPOnly <- only_loci(d_allele) ## get only the SNP sites since other sites dont contribute to the calculations
allelepop1 <- dAlleleSNPOnly[1:20,]#ind are diploid and there are 20 of them
allelepop2 <- dAlleleSNPOnly[21:40,]
allelepop3 <- dAlleleSNPOnly[41:60,]
allelepop4 <- dAlleleSNPOnly[61:80,]

#### pop 1 and 2 ####
HT12 <- calc_HT(allelepop1, allelepop2)
Hs12 <- calc_Hs(allelepop1, allelepop2) 
Fst12 <- calc_Fst(HT12, Hs12)
## pop 1 3###
HT13 <- calc_HT(allelepop1, allelepop3)
Hs13 <- calc_Hs(allelepop1, allelepop3) 
Fst13 <- calc_Fst(HT13, Hs13)
## pop 1 4###
HT14 <- calc_HT(allelepop1, allelepop4)
Hs14 <- calc_Hs(allelepop1, allelepop4)
Fst14<- calc_Fst(HT14, Hs14)

## pop 2 3###
HT23 <- calc_HT(allelepop2, allelepop3)
Hs23 <- calc_Hs(allelepop2, allelepop3)
Fst23 <- calc_Fst(HT23, Hs23)

## pop 2 4###
HT24 <- calc_HT(allelepop2, allelepop4)
Hs24 <- calc_Hs(allelepop2, allelepop4)
Fst24 <- calc_Fst(HT24, Hs24)

##pop 3 4 ###
HT34 <- calc_HT(allelepop3, allelepop4)
Hs34 <- calc_Hs(allelepop3, allelepop4)
Fst34 <- calc_Fst(HT34, Hs34)








#####TESTING######

