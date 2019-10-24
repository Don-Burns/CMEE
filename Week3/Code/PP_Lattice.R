## Desc: A script to make three plots of `../data/EcolArchives-E089-51-D1.csv`, showing prey mass, predator mass and the size ratio between the two, all by feeding type.  It will also save the log of the mean of all three values by feeding type
### packages ###
rm(list = ls())
require(lattice)

### import data and assign variables ###
d <- read.csv("../data/EcolArchives-E089-51-D1.csv", stringsAsFactors = F)

#check for unique values in unit to look at what the units being used are, this can only be done with prey mass, just have to assume by looking at the data that predators are in g - prey is mg, g
unique(d$Prey.mass.unit)


preyG <- subset(d, d$Prey.mass.unit == "g")
preyMG <- subset(d, d$Prey.mass.unit == "mg")
d

for( i in 1:length(d[,1])){
    if (d$Prey.mass.unit[i] == "mg"){
        d$Prey.mass[i] = d$Prey.mass[i] / 1000
        d$Prey.mass.unit[i] = "g"
    }
    
    
}

# convert mg to g
preyMG$Prey.mass <- preyMG$Prey.mass / 1000






prey <- d$Prey.mass
predator <- d$Predator.mass
sizeRatio <- d$Prey.mass / d$Predator.mass

densityplot(~log(d$Prey.mass) | Type.of.feeding.interaction, data =d)
    

preyPlot <- densityplot(~log(prey) | Type.of.feeding.interaction, data =d)
predPlot <- densityplot(~log(predator) | Type.of.feeding.interaction, data =d)
sizePlot <- densityplot(~log(sizeRatio) | Type.of.feeding.interaction, data =d)

pdf("../Results/Prey_Lattice.pdf")
    print(preyPlot)
    graphics.off()
pdf("../Results/Predator_Lattice.pdf")
    print(predPlot)
    graphics.off()
pdf("../Results/SizeRatio_Lattice.pdf")
    print(sizePlot)
    graphics.off()
### means and saving them  by feeding type###
#write.csv()
preylog <-mean(log(prey))
predlog <- mean(log(predator))
sizeLog <- mean(log(sizeRatio))
csvHeaders <- c("Type of Feeding Interaction", "log Prey Mass", "log Predator Mass", "log Size")
unique(d$Prey.mass.unit)

csvData <- matrix(NA, nrow = 1, ncol = 4)
for(feed in unique(d$Type.of.feeding.interaction)){
    tmp <- subset(d, d$Type.of.feeding.interaction == feed)
    preylog <-mean(log(tmp$Prey.mass))
    predlog <- mean(log(tmp$Predator.mass))
    sizeLog <- mean(log(tmp$Prey.mass/tmp$Predator.mass))
    tmpData <- matrix(NA, nrow = 1, ncol = 4)
    tmpData[1] <- feed
    tmpData[2] <- preylog
    tmpData[3] <- predlog
    tmpData[4] <- sizeLog
    csvData <- rbind(csvData, tmpData)
}

outputData <- csvData[-1,]
output <- as.data.frame(outputData) ## save as a data frame ready for saving
colnames(output) <- csvHeaders # add row names
write.csv(output, "../Results/PP_Results.csv", row.names = F)














