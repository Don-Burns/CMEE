# Script following Handout 18 of noets: Linear Multivariable Models
rm(list = ls())


a <- read.table("../data/ObserverRepeatability.txt", header =T)

require(dplyr)
a %>%
    group_by(StudentID) %>%
    summarise(count = length(StudentID)) %>%
    summarise(length(StudentID))

length(a$StudentID)

a %>%
    group_by(StudentID) %>%
    summarise(count = length(StudentID)) %>%
    summarise(sum(count^2))

mod <- lm(Tarsus ~ StudentID, data = a)
anova(mod)


mod <- lm(Tarsus ~ Leg+Handedness+StudentID, data = a)
anova(mod)

require(lme4)
lmm <- lmer(Tarsus ~ Leg+Handedness+(1|StudentID), data =a)
summary(lmm)


