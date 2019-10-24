## Desc: A script looking at how to use the base plotting funtions in R
graphics.off()
MyDF <- read.csv("../data/EcolArchives-E089-51-D1.csv")
dim(MyDF) #check the sizeof the sata frame you loaded

#plot data but it is a lottle clustered at the axis
plot(MyDF$Predator.mass, MyDF$Prey.mass)

## plot log to get a better look
plot(log(MyDF$Predator.mass), log(MyDF$Prey.mass))

plot(log(MyDF$Predator.mass), log(MyDF$Prey.mass), pch = 20) # change marker

plot(log(MyDF$Predator.mass), log(MyDF$Prey.mass), pch = 20, xlab = "Predator Mass (g)", ylab = "Prey Mass (g)") #add labels

hist(MyDF$Predator.mass) # make histogram of the predator mass

hist(log(MyDF$Predator.mass), xlab = "Predator Mass (g)", ylab = "Count") # include labels

hist(log(MyDF$Predator.mass), xlab = "Predator Mass (g)", ylab = "Count", col = "lightblue", border = "pink") # change bar and border colours
 ##################find how o adjust bin size

par(mfcol = c(2,1)) # initialize multi-paneled plot
par(mfg = c(1,1)) # specify whic sub-plot to use first
hist(log(MyDF$Predator.mass), xlab = "Predator Mass (g)", ylab = "Count", col = "lightblue", border = "pink", main = "Predator") # add title
par(mfg = c(2,1)) # second sub-plot
hist(log(MyDF$Prey.mass), xlab = "Prey Mass (g)", ylab = "Count", col = "lightgreen", border = "pink")

dev.off() # to shut off the slit graphing

# Predator histogram
hist(log(MyDF$Predator.mass), #Pred hsitogram
xlab = "Body Mass (g)", ylab = "Count", # set labels
col = rgb(1, 0, 0, 0.5), # Note "rgb", 4th value is transparency
main = "Predator-prey size Overlap") # Set title

hist(log(MyDF$Prey.mass), col = rgb(0, 0, 1, 0.5), add = T) ## Plot prey
legend('topleft', c('Predators', 'Prey'), # add legend
    fill = c(rgb(1, 0, 0, 0.5), rgb(0, 0, 1, 0.5)))



boxplot(log(MyDF$Predator.mass), xlab = "Location", ylab = "Predator Mass", main = "Predator mass")

boxplot(log(MyDF$Predator.mass) ~ MyDF$Location, # why the tilde
xlab = "Location", ylab = "Predator Mass", main = "Predator mass by location")

boxplot(log(MyDF$Predator.mass) ~ MyDF$Type.of.feeding.interaction,
    xlab = "Location", ylab = "Predator Mass",
    main = "Predator mass by feeding interaction type")

# mixing plot types

par(fig = c(0, 0.8, 0, 0.8)) #specify figure size as proportion
plot(log(MyDF$Predator.mass), log(MyDF$Prey.mass), xlab = "Predator Mass (g)", ylab = "Prey Mass (g)") # add labels

par(fig=c(0, 0.8, 0.4 ,1), new = T)
boxplot(log(MyDF$Predator.mass), horizontal = T, axes = F)
par(fig=c(0.55, 1, 0, 0.8), new = T)
boxplot(log(MyDF$Prey.mass), axes = F)
mtext("Fancy Predator-prey scatterplot", side = 3, outer = T, line = -3)


#############LATTICE PLOTS##################

library(lattice)
# densityplot(~log(Predator.mass) | Type.of.feeding.interaction, data = MyDF)
print(densityplot(~log(Predator.mass) | Type.of.feeding.interaction, data=MyDF))


pdf("../Results/Pred_Prey_Overlay.pdf", #Open blank pdf using a realtive path
11.7, 8.3) # These numbers are page dimensionsin inches
hist(log(MyDF$Predator.mass), #PLot predator histogram (note 'rgb')
    xlab = 'Body Mass(g)', ylab = "Count", col = rgb(1, 0, 0, 0.5), main = "Predator-Prey Size Overlap")
hist(log(MyDF$Prey.mass), # Plot prey weights
    col = rgb(0, 0, 1, 0.5),
    add = T) # Add to some plot = TRUE
legend('topleft', c('Predators', 'Prey'),
    fill = c(rgb(1, 0, 0, 0.5), rgb(0,0,1,0.5)))
graphics.off(); # you can also use dev.of()




