rm(list=ls())
setwd("~/Documents/CMEECourseWork/Week4/stats/data/HandOutsandData'18/HandOutsandData'18")
d <- read.table("SparrowSize.txt", header =T)
str(d)
names(d)
head(d)
length((d$Tarsus))
hist(d$Tarsus)
mean(d$Tarsus)
mean(d$Tarsus, na.rm = T)
median(d$Tarsus, na.rm = T)
mode(d$Tarsus)
par(mfrow = c(2,2))
hist(d$Tarsus, breaks = 3, col="grey")
hist(d$Tarsus, breaks = 10, col="grey")
hist(d$Tarsus, breaks = 30, col="grey")
hist(d$Tarsus, breaks = 100, col="grey")

#install.packages("modeest") #package is discontinued
#require(modeest)
#mlv(d$Tarsus)
#d2 <- subset(d, d$Tarsus!="NA")
#length(d$Tarsus)
#lenght(d2$Tarsus)
#mlv(d2$Tarsus)

#range, var and sd
range(d$Tarsus, na.rm = T)
range(d2$Tarsus, na.rm = T)
var(d$Tarsus, na.rm = T)
var(d2$Tarsus, na.rm = T)




##excercise
mean(d$Bill, na.rm=T)
var(d$Bill, na.rm = T)
sd(d$Bill, na.rm =T)
mean(d$Mass, na.rm=T)
var(d$Mass, na.rm = T)
sd(d$Mass, na.rm =T)
mean(d$Wing, na.rm=T)
var(d$Wing, na.rm = T)
sd(d$Wing, na.rm =T)