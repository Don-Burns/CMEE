## DoThisSecondLMMs.pdf handout

# handouts and data: https://drive.google.com/file/d/1jTg1oA7GJxiRZwhCp0zMi-N5ySoyeYKz/view
## solutions: https://drive.google.com/file/d/1OjqNv1NVLkfpfjguQfmWiJyHhGJa6DGU/view

rm(list = ls())
d <- read.table("../data/DataForMMs.txt", header = T)
str(d)
max(d$Individual)
d$Individual <- as.factor(d$Individual)
names(d)
par(mfrow = c(2,3))
hist(d$LitterSize)
hist(d$Size)
hist(d$Hornlength)
hist(d$Bodymass)
hist(d$Glizz)
hist(d$SexualActivity)
dev.off()

## Hypothesis 1
par(mfrow = c(1,3))
boxplot(d$Bodymass ~ d$Sex)
boxplot(d$Size ~ d$Sex)
boxplot(d$Hornlength ~ d$Sex)

library(lme4)
h1m1 <- lmer(Bodymass ~ Sex + (1|Individual), data = d)
summary(h1m1)

h1m2 <- lmer(Bodymass ~ Sex + (1|Individual) + (1|Family), data = d)
summary(h1m2)

library(lmtest)
lrtest(h1m1, h1m2)

mR<-lmer(Bodymass~1+(1|Individual), data=d)
summary(mR)

repeatability<-(0.46/(0.46+0.72))
repeatability

# Hypothesis 2
graphics.off()

plot(Bodymass ~ Hornlength, data = d )

h2m1 <- lmer(Bodymass ~ Hornlength + Glizz + (1|Individual) + (1|Family), data = d)
summary(h2m1)
h2m2 <- lmer(Bodymass ~ Hornlength + (1|Individual) + (1|Family), data = d)
summary(h2m1)

plot(h2m2)


plot(Bodymass~Hornlength,data=d, pch=19, cex=0.5)
abline(0.16,0.054, col = "red")


# Hypothesis 4
# Unicorns with longer horns have a higher fitness


hornMod <- lmer(LitterSize ~ Hornlength + (1|Individual), data = d)
summary(hornMod)


