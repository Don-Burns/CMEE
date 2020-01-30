# Desc: Handout 4 from Julia. day 2, 14/01/20

rm(list = ls())

gala <- read.delim("../data/gala.txt")
str(gala)
gala$propEnd <- gala$Endemics/gala$Species
gala$lgArea <- log(gala$Area)
plot(propEnd ~ lgArea, data = gala, cex = log(Species/2))
resp <- with(gala, cbind(Endemics, Species - Endemics))
galaMod <- glm(resp ~ lgArea, data = gala, family = binomial(link = logit))
galaMod <- glm(propEnd ~ lgArea, weights = Species, data = gala, family = binomial(link = logit))
anova(galaMod, test = "Chisq")
1-pchisq(44.053, 1)
summary(galaMod)
par(mfrow = c(1, 2))
plot(galaMod, which = c(1, 2))

pred <- expand.grid((lgArea = seq(-5, 9, by = 0.1)))
pred$fit <- predict(galaMod, newdata = pred, type = "response")

plot(propEnd ~ lgArea, data = gala)
lines(fit ~ lgArea, data = pred, col = "red")

predMod <- predict(galaMod, newdata = pred, se.fit = T)

pred$fit <- predMod$fit
pred$se.fit <- predMod$se.fit
pred$confint <- predMod$se.fit * qt(0.975, df = galaMod$df.residual)


plot(qlogis(propEnd) ~ log(Area), data = gala) # doing the y axis as logistic scale is for illustration purposes and would never do this in the real world
lines(fit ~ lgArea, data = pred, col = "red")
lines(fit + confint ~ lgArea, data = pred, col = "red", lty = 2)
lines(fit - confint ~ lgArea, data = pred, col = "red", lty = 2)

plot(propEnd ~ lgArea, data = gala, cex = log(Species/2))
lines(plogis(fit) ~ lgArea, data = pred, col = "red")
lines(plogis(fit + confint) ~ lgArea, data = pred, col = "red", lty = 2)
lines(plogis(fit - confint) ~ lgArea, data = pred, col = "red", lty = 2)



#### Predicting threat in Galliformes ####
rm(list = ls())

galliformes <- read.table("../data/galliformesData.txt", header = T)
str(galliformes)
galliformes <- na.omit(galliformes)
galliformes$ThreatBinary <- ifelse(galliformes$Status04 %in% c("1_(LC)", "2_(NT)"), 0, 1)

pairs(ThreatBinary ~ Range + Mass + Clutch + ElevRange, data = galliformes)

galliformes$lgMass <- log(galliformes$Mass)
galliformes$lgRange <- log(galliformes$Range)
galliformes$lgClutch <- log(galliformes$Clutch)
galliformes$lgElevRange <- log(galliformes$ElevRange)
pairs(ThreatBinary ~ lgRange + lgMass + lgClutch + lgElevRange, data = galliformes)

par(mfrow=c(2,2))
plot(ThreatBinary ~ lgRange, data=galliformes)
plot(ThreatBinary ~ lgMass, data=galliformes)
plot(ThreatBinary ~ lgClutch, data=galliformes)
plot(ThreatBinary ~ lgElevRange, data=galliformes)

galliMod <- glm(ThreatBinary ~ (lgRange +lgMass + lgClutch + lgElevRange)^2, data=galliformes, family=binomial(link=logit))
                
          

