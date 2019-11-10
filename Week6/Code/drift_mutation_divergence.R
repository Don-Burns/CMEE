## Desc: A script which takes three data sets from `../data`; `western_banded_gecko.csv`, `bent-toed_gecko.csv` and `leopard_gecko.csv`.  The data sets can be change by changing the directories under the `READ IN DATA` section.

######HOUSE KEEPING#######
rm(list = ls())


######READ IN DATA########
west_gecko <- read.csv("../data/western_banded_gecko.csv", stringsAsFactors = F, colClasses = "character", header = F)
bent_toed_gecko <- read.csv("../data/bent-toed_gecko.csv", stringsAsFactors = F, colClasses = "character", header = F)
leopard_gecko <- read.csv("../data/leopard_gecko.csv", stringsAsFactors = F, colClasses = "character", header = F)

DivergeTime <- 30*10^6 ## time since divergence



#####FUNCTIONS######
Find_Fixed <- function(d){ #finds columns with more than 1 unique value and retruns them. 
    #VARS: d = data
    loci <- NULL
    for(i in 1:ncol(d)){
        if(length(unique(d[,i])) == 1){ # find column with more than 1 unique value and record it
            loci <- c(loci, i) 
        }
        
    }
    return(loci)
}



Find_Diverged <- function(seq1, seq2){ # takes sequence data and outputs the diverged sites.
    Fixed1 <- Find_Fixed(seq1)
    Fixed2 <- Find_Fixed(seq2)
    CommonSites <- intersect(Fixed1, Fixed2)
    DivergedSites <- NULL
    for(i in CommonSites){
        if(seq1[1,i] != seq2[1,i]){
            DivergedSites <- c(DivergedSites, i)
            
        }
           
    }
    return(DivergedSites)
}


 Find_Common_Sites <- function(seq1, seq2){ # Find fixed sites which are comon
     Fixed1 <- Find_Fixed(seq1)
     Fixed2 <- Find_Fixed(seq2)
     CommonSites <- intersect(Fixed1, Fixed2)
     return(CommonSites)
}

Calc_dAB <- function(NumDivergedSites, NumCommonSites){# find expected divergence input: Number of diverged sites and umber of comon sites between the two species
    dAB <- NumDivergedSites/NumCommonSites
    return(dAB)
}
 
Calc_mu <- function(d_AB, t_AB){ # find mutation rate input: dAB = expected divergence, tAB = time since divergence
    
    
    mu <- d_AB/(2*t_AB)
    
    return(mu)
}

Calc_tAB <- function(d_AB, mu){ # to estimate time since divergene. input dAB is expected divergence, mu is mutation rate to outgroup
    t_AB <- d_AB/(2*mu)
    return(t_AB)
}
######MAIN#######

# Find diverged sites
DivergedBentLeop <- Find_Diverged(bent_toed_gecko, leopard_gecko)
DivergedWestBent <- Find_Diverged(west_gecko, bent_toed_gecko)
DivergedLeopWest <- Find_Diverged(leopard_gecko, west_gecko)

#Find common sites
CommonWestBent <- Find_Common_Sites(west_gecko, bent_toed_gecko)
CommonBentLeop <- Find_Common_Sites(bent_toed_gecko, leopard_gecko)
CommonLeopWest <- Find_Common_Sites(leopard_gecko, west_gecko)

# Find expected Divergence
ExpDivWestBent <- Calc_dAB(length(DivergedWestBent), length(CommonWestBent))
ExpDivBentLeop <-Calc_dAB(length(DivergedBentLeop), length(CommonBentLeop))
ExpDivLeopWest <- Calc_dAB(length(DivergedLeopWest), length(CommonLeopWest))

# Find mu 

muWestBent <- Calc_mu(ExpDivWestBent, DivergeTime)
muBentLeop <- Calc_mu(ExpDivBentLeop, DivergeTime)
muLeopWest <- Calc_mu(ExpDivLeopWest, DivergeTime)

# Find Time Diverence

timeDiffWestBent <- Calc_tAB(ExpDivWestBent, muLeopWest)  ## this is time to ancestral state
timeDiffLeopWest <- Calc_tAB(ExpDivLeopWest, muLeopWest)
timeDiffBentLeop <- Calc_tAB(ExpDivBentLeop, muLeopWest)

# Find divergence between ancestor and leopard

timeDiffLeopAncestor <- DivergeTime - timeDiffWestBent
        #note can also attempt to reconstruct ancestral sequence and estimate from there

#DivergedALL <- Find_Diverged3(bent_toed_gecko, leopard_gecko, west_gecko)

######DEBUG######
#seq1 <- west_gecko
#seq2 <- leopard_gecko
#bentFixed <- Find_Fixed(bent_toed_gecko)
#leopardFixed <- Find_Fixed(leopard_gecko)    
#westFixed <- Find_Fixed(west_gecko)


#########TEST############
#Fixed1 <- c(1,2,3,4,5)
#Fixed2 <- c(1,3,2,3,4)

########steps to take#######
# Find sites that are fixed in a species
# Find which sites are different between species, but the same within a species
#



### to be fixed

Find_Diverged3 <- function(seq1, seq2,seq3){ # takes sequence data and outputs the diverged sites. does so for 3 sequences
    return("needs to be debugged")
    Fixed1 <- Find_Fixed(seq1)
    Fixed2 <- Find_Fixed(seq2)
    Fixed3 <- Find_Fixed(seq3)
    CommonSites <- intersect(Fixed1, intersect(Fixed2, Fixed3))
    DivergedSites <- NULL
    for(i in CommonSites){
        if(seq1[1,i] != seq2[1,i]){
            if(seq1[1,i] != seq3[1,i]){
                if(seq1[1,i] != seq3[1,i]){
                    DivergedSites <- c(DivergedSites, i)
                }
            }
            
        }
        
    }
    return(DivergedSites)
}