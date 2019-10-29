rm(list=ls())
setwd("~/Documents/CMEECourseWork/Week4/notes/HandOutsandData'18/")
d <- read.table("SparrowSize.txt", header = T)
d1 <- subset(d, d$Tarsus!="NA")
d2 <- subset(d, d$Mass != "NA")
d3 <- subset(d, d$Wing != "NA")
d4 <- subset(d, d$Bill != "NA")


seTarsus <- sqrt(var(d1$Tarsus) / length(d$Tarsus))
seTarsus

d12001 <- subset(d1, d1$Year == 2001)
seTarsus2001 <- sqrt(var(d12001$Tarsus) / length(d12001$Tarsus))
seTarsus2001

seFun <- function(variable){
    sqrt(var(variable) / length(variable))
}

seFun(d1$Tarsus)
seFun(d2$Mass)
seFun(d3$Wing)
seFun(d4$Bill)

## 2001 only
sub2001Fun <- function(data){ #makes a subset with just 2001
    subset(data, data$Year==2001)
}
d22001 <- sub2001Fun(d2)
d32001 <- sub2001Fun(d3)
d42001 <- sub2001Fun(d4)
seFun(d12001$Tarsus)
seFun(d22001$Mass)
seFun(d32001$Wing)
seFun(d42001$Bill)




## 95% CI


seFun(d1$Tarsus) 
seFun(d2$Mass)
seFun(d3$Wing)
seFun(d4$Bill)

seFun(d12001$Tarsus)
seFun(d22001$Mass)
seFun(d32001$Wing)
seFun(d42001$Bill)







