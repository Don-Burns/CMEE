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
unique(d$Prey.mass.unit)

#qplot(log(Prey.mass), log(Predator.mass), data = MyDF, geom = c("point", "smooth"), colour = Type.of.feeding.interaction) + geom_smooth(method = "lm" ,fullrange = TRUE)

plot <- ggplot(d, aes(x = Prey.mass, y = Predator.mass, color = Predator.lifestage)) +
    geom_smooth(method = "lm", se = T, fullrange =T)+
    geom_point(shape = I(3))+
    #facet_wrap(~ Type.of.feeding.interaction, scales = "fixed")+
    facet_grid(Type.of.feeding.interaction~.)+
    scale_x_log10(breaks = c(1e-7, 1e-3, 1e1))+# scale axis and convert data to match
    scale_y_log10(breaks = c(1e-6, 1e-2, 1e2, 1e6))+
    theme_bw()+
    theme(plot.margin = unit(c(.5,4.5,.5,4.5),"cm")) +#set margins
    theme(legend.position = "bottom", legend.direction = "horizontal", legend.title = element_text(face = "bold"))+# fix legend typeset
    guides(color = guide_legend(nrow = 1))+  # force legend into one row
    xlab(element_text("Prey Mass in grams")) + # x label
    ylab(element_text("Predator mass in grams"))+  # y label
    theme(text = element_text(size = 12)) # text size
        
    
pdf("../Results/PP_Regress.pdf", 8, 10) ## save plot
    print(plot)
    graphics.off()

    
#### get data for and write csv###

csvData = matrix(nrow = 1, ncol = 7)
csvHeaders = c("Type of Feeding Interaction", "Predator Lifestage","Regression Slope", "Regression Intercept", "R^2", "F-statistic Value", "p-value")
i <- 1 ##counter for martrix row when storing values in loop
for(feed in unique(d$Type.of.feeding.interaction)){
    feedInt <- subset(d, d$Type.of.feeding.interaction == feed) # make subset of only desired feeding interaction
    for(lifestage in unique(d$Predator.lifestage)){
        tmp <- subset(feedInt, feedInt$Predator.lifestage == lifestage) # make a subset of the feeding interaction with only desired lifestage
        
        if(dim(tmp)[1] != 0){ # checks if tmp has elements to use for lm
            lm_sum <- summary(lm(Predator.mass ~ Prey.mass, data = tmp)) # sets summary of lm
            if(nrow(lm_sum$coefficients) > 1) {# makes sure there is some data to take from lm_sum$coefficients
                lm_coef <- lm_sum$coefficients
                regSlope <- lm_coef[2,1]
                regInt <- lm_coef[1,1]
                lmR2 <- lm_sum$r.squared
                lm_Fstat <- unname(lm_sum$fstatistic[1])
                pVal <- lm_coef[2,4]
                curItMat <- matrix(NA, nrow = 1, ncol = 6)          # make a matrix to store the values in, then assign them.
                curItMat[1] <- feed                               # feeding type
                curItMat[2] <- lifestage                          # lifestage
                curItMat[3] <- regSlope                           # slope of lm
                curItMat[4] <- regInt                             # Intercept of lm
                curItMat[5] <- lmR2                               # R2 of lm
                curItMat[6] <- lm_Fstat                           # fstat of lm
                curItMat[7] <- pVal                              # p value
                csvData <- rbind(csvData, curItMat)
                #if(is.nan(curItMat[6])) stop("found NaN") # for debug
                i <- i + 1                                          # tick up for next row
                
            }
        }
    }
}







csvData <- csvData[-1,] # remove first row of Na that is left from first defining the matrix
output <- as.data.frame(csvData) ## save as a data frame ready for saving
colnames(output) <- csvHeaders # add row names
write.csv(output, "../Results/PP_Regress.csv", row.names = F)







