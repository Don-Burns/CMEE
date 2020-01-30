# Desc: follows Handout 3 from Julia

#### Species richness on the galapagos islands ####
rm(list = ls())

gala <- read.table("../data/gala.txt")
str(gala)
plot(Species ~ Area, data = gala, pch = 19)
plot(Species ~ log(Area), data = gala)

gala$lgArea <- log(gala$Area)
galaMod <- glm(Species ~ lgArea, data = gala, family = poisson(link = log))

summary(galaMod)

par(mfrow = c(1,2))
plot(galaMod, which = c(1,2))

exp(0.3377) # increase of 1.4 fold

pred <- expand.grid(lgArea = seq(-5, 9, by = 0.1))
pred$fit <- predict(galaMod, newdata = pred, type =  "response")
head(pred)
tail(pred)

plot(Species ~ log(Area), data = gala)
lines(fit ~ lgArea, data = pred, col = "red")


#### Amphibian roadkills in Portugal ####
dev.off()
rm(list = ls())
roadkill <- read.table("../data/RoadKills.txt", header = T)

head(roadkill)
str(roadkill)
plot(TOT.N ~ D.PARK, data = roadkill)

## My Turn ##

roadMod <- glm(TOT.N ~ D.PARK, data = roadkill, family = poisson(link = log))
summary(roadMod)

pred <- data.frame(seq(0, 25000))
colnames(pred) <- "D.PARK"
pred$fit <- predict(roadMod, newdata = pred, type = "response")
lines(fit ~ D.PARK, data = pred, col = "red")

#### Species richness in grassland plot ####

species <- read.table("../data/species.txt", header = T)
head(species) 
str(species)

## Checkign for deviations from normality
# hist(Biomass)
# lmspec <- lm(Species ~ pH + Biomass, data = species)
# lmspec2 <-lm(Species ~ pH * Biomass, data = species)
mfull <- glm(Species ~ pH * Biomass, data = species, family = poisson)
m2 <- glm(Species ~ pH + Biomass, data = species, family = poisson)
# require(lmtest)
# lrtest(mfull,m2)
# AIC(mfull,m2)
