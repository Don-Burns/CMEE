# Data Source: https://drive.google.com/file/d/13sCyMzBqcI_MHZx-ELTUcNAzYoON-TV0/view
rm(list = ls())

cham <- read.table("../data/chadatafinal_NoBlanks.csv", header = T, sep = ",", stringsAsFactors = F, na.strings = "na")
str(cham)

par(mfrow = c(2,2))
hist(cham$perch.height)
hist(cham$SVL)
hist(cham$branch.diam)
hist(log(cham$branch.diam))


### data cleaning ###
## remove NAs for hypothesis 1
Hyp1 <- subset(cham, cham$perch.height != "NA")
Hyp1 <- subset(Hyp1, Hyp1$Sp != "NA")
# different species occupy different heigth niches

mod1 <- lm(Hyp1$perch.height ~ Hyp1$Sp)
mod2 <- lm(Hyp1$perch.height ~ Hyp1$Sp + Hyp1$branch.diam + Hyp1$SVL)

mod3 <- lm(Hyp1$branch.diam ~ Hyp1$Sp)


# is perch height dependant on size(SVL - snout vent length i.e. snout to chlaoca)
