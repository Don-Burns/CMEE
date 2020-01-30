## Desc: Do this first random effects Handout

rm(list = ls())
d <- read.table("../data/ObserverRepeatability.txt", header = T, sep = ",")
str(d)
hist(d$Tarsus)
hist(d$BillWidth)
d <- subset(d, d$Tarsus <= 40)
d <- subset(d, d$Tarsus >= 10)
summary(d$Tarsus)
var(d$Tarsus)
summary(d$BillWidth)
var(d$BillWidth)
require(lme4)
require(lmtest)

mT1 <- lmer(Tarsus ~ 1 + (1|StudentID), data = d)
mT2 <- lmer(Tarsus ~ 1 + (1|StudentID) + (1|GroupN), data = d)
lrtest(mT1, mT2)
summary(mT1)

3.21 / (3.21 + 1.23) # between group variance % explained

summary(mT2)

(3.29 + 0.35) / (3.29 + 0.35 + 2.26) # # between group variance % explained /// can seperate them to do how much each factor explains

## bill length
mT1 <- lmer(BillWidth ~ 1 + (1|StudentID), data = d)
mT2 <- lmer(BillWidth ~ 1 + (1|StudentID) + (1|GroupN), data = d)
lrtest(mT1, mT2)
summary(mT1)
(0.63) / (0.63 + 0.23)
summary(mT2)
(0.60 + 0.03) / (0.6 + 0.03 + 0.23)
