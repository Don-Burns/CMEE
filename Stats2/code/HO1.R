## Desc: working through Handout 1 of Stats 2 with Julia
## Date: 13/01/2020
rm(list=ls())
d <- read.table("../data/SparrowSize.txt", header = T)
str(d)
names(d)
head(d)

#### Centrality and Spread ####
hist(d$Tarsus, xlab = "Tarsus length(mm)")
mean(d$Tarsus, na.rm = T)
var(d$Tarsus, na.rm = T)
sd(d$Tarsus, na.rm = T)


## Covariance
d1 <- subset(d, d$Tarsus != "NA")
d1 <- subset(d1, d1$Wing != "NA")
## dont match because they are not independant
sumz <- var(d1$Tarsus) + var(d1$Wing)
test <- var(d1$Tarsus + d1$Wing)

# plot(jitter(d1$Wing), d1$Tarsus, pch = 19, cex = .4)
plot(d1$Wing, d1$Tarsus, pch = 19, cex = .4)

# when you take covariance into account they match
cov(d1$Tarsus, d1$Wing)
sumz <- sumz + 2*cov(d1$Tarsus, d1$Wing)


## 10^2 * var^2(A) =  var^2(A * 10)

var(d1$Tarsus*10)
var(d1$Tarsus)*10^2


uni <- read.table("../data/RUnicorns.txt", header = T)
str(uni)
head(uni)
mean(uni$Bodymass)
sd(uni$Bodymass)
var(uni$Bodymass)
hist(uni$Bodymass)
mean(uni$Hornlength)
sd(uni$Hornlength)
var(uni$Hornlength)
hist(uni$Hornlength)
plot(uni$Bodymass~uni$Hornlength, pch = 19, xlab = "Horn Length", ylab = "Body Mass")



## Unicorn LM

hist(uni$Bodymass)
hist(uni$Hornlength)
hist(uni$Height)
cor.test(uni$Hornlength, uni$Height)
boxplot(uni$Bodymass~uni$Gender)
boxplot((uni$Bodymass~uni$Pregnant))
plot(uni$Hornlength[uni$Gender=="Female"], uni$Bodymass[uni$Gender== "Female"], pch = 19, xlab = "horn len", ylab = "body mass", xlim = c(2,10), ylim = c(6,19))
points(uni$Hornlength[uni$Gender=="Male"], uni$Bodymass[uni$Gender== "Male"], pch = 19, col = "red")
points(uni$Hornlength[uni$Gender=="Undecided"], uni$Bodymass[uni$Gender== "Undecided"], pch = 19, col = "green")

boxplot(uni$Bodymass~uni$Glizz)
plot(uni$Hornlength[uni$Glizz==0], uni$Bodymass[uni$Glizz==0], pch = 19, xlab = "Horn len", ylab = "Body Mass", xlim = c(2, 10), ylim = c(6,19))
points(uni$Hornlength[uni$Glizz==1], uni$Bodymass[uni$Glizz==1])


FullModel <- lm(uni$Bodymass~uni$Hornlength + uni$Gender + uni$Pregnant + uni$Glizz)
summary(FullModel)

u1 <- subset(uni, uni$Pregnant==0)
FullModel <- lm(u1$Bodymass~u1$Hornlength + u1$Gender + u1$Glizz)
summary(FullModel)

ReducedModel <- lm(u1$Bodymass~u1$Hornlength+u1$Glizz)
summary(ReducedModel)
plot(u1$Hornlength[u1$Glizz==0], u1$Bodymass[u1$Glizz==0], pch = 19, xlab = "horn Len", ylab = "body mass", xlim = c(2,10), ylim = c(6,19))
points(u1$Hornlength[u1$Glizz==1], u1$Bodymass[u1$Glizz==1], pch = 19, col = "red")
abline(ReducedModel)


ModForPlot <- lm(u1$Bodymass~u1$Hornlength)
summary(ModForPlot)
plot(u1$Hornlength[u1$Glizz==0], u1$Bodymass[u1$Glizz==0], pch = 19 ,  xlab = "horn len", ylab = " body mass", xlim = c(2,10), ylim = c(6,19))
points(u1$Hornlength[u1$Glizz==1], u1$Bodymass[u1$Glizz==1], pch = 19, col = "red")
abline(ModForPlot)

##check for independance of len and glizz

boxplot(u1$Hornlength~u1$Glizz)
t.test(u1$Hornlength~u1$Glizz)
plot(ReducedModel)

plot(u1$Hornlength[u1$Glizz==0], u1$Bodymass[u1$Glizz==0], pch = 10, xlab = "horn len", ylab = "body mass", xlim = c(3,8), ylim = c(6,15))
points(u1$Hornlength[u1$Glizz==1], u1$Bodymass[u1$Glizz==1], pch = 10, col = "red")
abline(ReducedModel)

#### Linear models - interpretation of interactions - two-level fixed factor and continous variable ####

rm(list = ls())

dat <- read.table("../data/data.txt", header = T)
head(dat)
str(dat)

fullmodel <- lm(species_richness~fertilizer * method, data = dat)
summary(fullmodel)


plot(dat$species_richness[dat$method=="conventional"]~dat$fertilizer[dat$method=="conventional"], pch = 16, xlim = c(0,50), ylim = c(0,70), col = "grey", ylab =  "species richness", xlab = "fertilizer")
points(dat$species_richness[dat$method=="organic"]~dat$fertilizer[dat$method=="organic"])


plot(fullmodel)

# Linear models - interpretation of interactions - three-level fixed factor and continous variable

rm(list = ls())

d <- read.table("../data/Three-way-Unicorn.txt", header = T)

names(d)
head(d)
mean(d$Bodymass)
sd(d$Bodymass)
var(d$Bodymass)
par(mfrow = c(1,2))
hist(d$Bodymass)
mean(d$HornLength)
sd(d$HornLength)
var(d$HornLength)
hist(d$HornLength)
dev.off()

plot(d$HornLength[d$Gender=="male"]~d$Bodymass[d$Gender=="male"], xlim=c(70,100),ylim=c(0,18), pch=19, xlab="Bodymass (kg)", ylab="Hornlength (cm)")
points(d$Bodymass[d$Gender=="female"],d$HornLength[d$Gender=="female"], col="red", pch=19)
points(d$Bodymass[d$Gender=="not_sure"], d$HornLength[d$Gender=="not_sure"], col="green", pch=19)

mod <- lm(HornLength~Gender * Bodymass, data = d)
summary(mod)

