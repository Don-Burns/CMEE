## Desc: Script looking at using and interpreting Anova test.  Use data obtained from students measureing the same sparrow tarsus and bill.

rm(list = ls())
d <- read.table("../data/SparrowSize.txt", header = T)
d1 <- subset(d, d$Wing != "NA")
summary(d1$Wing)
hist(d1$Wing)
model1 <- lm(Wing ~ Sex.1, data = d1)
summary(model1)
boxplot(d1$Wing~d1$Sex.1, ylab = "Wing length (m)")
anova(model1)
t.test(d1$Wing ~ d1$Sex.1, var.equal = T)
boxplot(d1$Wing ~ d1$BirdID, ylab = "Wing length (mm)")
require("dplyr")
tbl_df(d1)
glimpse(d1)

d$Mass %>% cor.test(d$Tarsus, na.rm =T)
d1 %>%
    group_by(BirdID) %>% summarise(count = length(BirdID))

count(d1, BirdID)

d1 %>%
    group_by(BirdID) %>% summarise(count = length(BirdID)) %>%
    count(count)
model3 <- lm(Wing ~ as.factor(BirdID), data = d1)
anova(model3)
    
boxplot(d$Mass ~ d$Year)

m2 <- lm(d$Mass ~ as.factor(d$Year))
anova(m2)
summary(m2)
t(model.matrix(m2))
summary(m2)

## excercise
not2000 <- subset(d1, d1$Year != "2000")
mod2000 <- lm(not2000$Mass ~ as.factor(not2000$Year)) 
anova(mod2000)
summary(mod2000)

# compared to m2 the signiicance when excluding 2000 is gone.  this indicates that 200 was an odd year for one reason or another.  could possibly stil be included but is not suitable for a reference level in the model





