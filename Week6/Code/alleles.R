# Desc: A script to look at the alleles, genotype, heterozygosity and homozygosity of a data set.  Input: `../data/bears.csv`.

############HOUSEKEEPING#############
rm(list = ls())

############DATA#################
bears <- read.csv("../data/bears.csv", colClasses = "character", stringsAsFactors = F, header = F)

############### FUNCTIONS ##################
Find_SNPs <- function(d){ #finds columns with more than 1 unique value and retruns them. 
    #VARS: d = data
    loci <- NULL
    for(i in 1:ncol(d)){
        if(length(unique(d[,i])) >1){ # find column with more than 1 unique value and record it
            loci <- c(loci, i) 
        }
    
    }
    return(loci)
}

Allele_Freq <- function(d, positions){ #finds frequecy of alleles when given an integer vector of positions 
    #VARS: d = data, positions = positions of alleles
    
    
    #define vars for building the dataframe at end.
    freqs <- rep(0, length(positions)) # allele frequencies
    allele1 <- rep(NA, length(positions)) # base allele
    allele2 <- rep(NA, length(positions)) # 1st allele that differs from baseline
    ##include allele 3 and 4 for non-diallelic data
    allele3 <- rep(NA, length(positions))
    allele4 <- rep(NA, length(positions))
    
    
    for(i in 1:length(positions)){

        for(s in 1:nrow(d)){
            
            if(d[s,positions[i]] != d[1,positions[i]]){
                freqs[i] <- freqs[i] + 1 # tick up the frequency for that row
                
            }
            if (length(unique(d[,positions[i]])) >= 2){
                allele1[i] <- unique(d[,positions[i]])[1]
                allele2[i] <- unique(d[,positions[i]])[2]
            }
            if (length(unique(d[,positions[i]])) >= 3){ # accounting for non-di-allelic data
                allele3[i] <- unique(d[,positions[i]])[3]
            }
            if (length(unique(d[,positions[i]])) >= 4){ # accounting for non-di-allelic data
                allele4[i] <- unique(d[,positions[i]])[4]    
                
            }
            
            
            
        }
        
    }
    freqDF <- rbind(positions, allele1)
    freqDF <- rbind(freqDF, allele2)
    if(all(is.na(allele3)) == F){  ## check if there is any data in allele 3 and 4, if so bind them
        freqDF <- rbind(freqDF, allele3)
    }
    if(all(is.na(allele4)) == F){
        freqDF <- rbind(freqDF, allele4)
    }
    
    freqDF <- rbind(freqDF, freqs) # bind the frequencies
    return(freqDF)
    
}



Geno_Freq <- function(d, position){#finds frequecy of genotypes when given an integer vector of positions.
    #assumes data is di-allelic
    #VARS: d = data, positions = positions of alleles
    
    label <- c("AA", "TT", "CC", "GG", "HZ")
    GenoDF <- matrix(0, ncol = 5, nrow = nrow(d)/2)
    for(i in position){# look at allele locus in chromosome 1 of ind
        ind <- ind + 1 # tick for next ind
        for(s in (1:nrow(d))){
            if(s %% 2 != 0){ # have loop only occur with odd numbers ie first chromosome of ind
                tmp <- s+1 #the pair chromosome row
                if(d[s,i] == d[tmp,i]){
                    pos <- match(paste(d[s,i], d[tmp,i], sep = ""), label) #find which col to place the value
                    print(pos)

                    GenoDF[ind, pos] <- GenoDF[ind, pos] + 1

                   # match(1, 2)
                }
                else{
                    GenoDF[ind, 5] <- GenoDF[ind, 5] + 1
                #currently making more entries than there are ind
                }
                ind <- ind + 1 # tick for next ind
                
            }
            
        }
    }
    colnames(GenoDF) <- label # add colnames
    rownames(GenoDF) <- position
}
###############MAIN###############


##Q1
SNPpos <- Find_SNPs(bears)
##Q2
freqs <- Allele_Freq(bears, SNPpos)
print(freqs) ##silly but asked to print it
barplot(as.numeric(freqs[4,]), xlab = "Loci", ylab = "Frequency")
##Q3




####### debugging #####
position <- SNPpos
d <- bears

