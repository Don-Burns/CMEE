rm(list=ls())
setwd("~/Documents/CMEECourseWork/Week4/notes/HandOutsandData'18/")
d <- read.table("SparrowSize.txt", header = T)
boxplot(d$Mass~d$Sex.1, col = c("red", "blue"), ylab = "Body mass (g)")
T.test1 <- t.test(d$Mass~d$Sex.1)
T.test1

d1 <- as.data.frame(head(d,50))
length(d1$Mass)
t.test2 <- t.test(d1$Mass~d1$Sex)
t.test2


pop2001 <- subset(d, d$Year == 2001)
t.test.wing01 <- t.test(pop2001$Wing~pop2001$Sex.1)
t.test.wing01
t.test.wing <- t.test(d$Wing~d$Sex.1)
t.test.wing
t.test.tarsus <- t.test(d$Tarsus~d$Sex)
t.test.tarsus
