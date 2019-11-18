
##House keeping##
graphics.off()
rm(list = ls())

##Load Packages
require(minpack.lm)
require(ggplot2)



#########Functions########
powMod <- function(x, a, b){
    return(a * x^b)
}

####Main####
MyData <- read.csv("../data/GenomeSize.csv")

head(MyData)


Data2Fit <- subset(MyData, Suborder == "Anisoptera")

Data2Fit <- Data2Fit[!is.na(Data2Fit$TotalLength),] #remove NA's



plot(Data2Fit$TotalLength, Data2Fit$BodyWeight) # plot data

##same plot but with ggplot
ggplot(Data2Fit, aes(x = TotalLength, y = BodyWeight)) +
    geom_point(size = I(3), colour ="red")+
    theme_bw()+
    labs(y = "Body mass (mg)", x = "Wing length (mm)")


PowFit <- nlsLM(BodyWeight ~ powMod(TotalLength, a, b), data = Data2Fit, start = list(a = .01, b = .01))



Lengths <- seq(min(Data2Fit$TotalLength), max(Data2Fit$TotalLength), len = 200)


Predic2PlotPow <- powMod(Lengths, coef(PowFit)["a"], coef(PowFit)["b"])

plot(Data2Fit$TotalLength, Data2Fit$BodyWeight)
lines(Lengths, Predic2PlotPow, col = "blue", lwd = 2.5)

confint(PowFit) ## find confidence intervals

## make same plot in ggplot

line <- data.frame(cbind(Lengths, Predic2PlotPow)) ## df with data for predicted line
    ##equation of line
a <- 3.94
b <- 10^-06
len <- "Length^2.59"
eq <- as.character(as.expression("weight = 3.94 * 10^-06 * Length^2.59"))   


ggplot(data = Data2Fit, aes(x = TotalLength, y = BodyWeight)) + # set data
    theme_bw() + 
    geom_point(shape = 21) +# set points
    geom_line(data = line, aes( x = Lengths, y = Predic2PlotPow), colour = "blue") 

#########Redo with zygoptera############

MyData <- read.csv("../data/GenomeSize.csv")

head(MyData)


Data2Fit <- subset(MyData, Suborder == "Zygoptera")

Data2Fit <- Data2Fit[!is.na(Data2Fit$TotalLength),] #remove NA's



plot(Data2Fit$TotalLength, Data2Fit$BodyWeight) # plot data

##same plot but with ggplot
ggplot(Data2Fit, aes(x = TotalLength, y = BodyWeight)) +
    geom_point(size = I(3), colour ="red")+
    theme_bw()+
    labs(y = "Body mass (mg)", x = "Wing length (mm)")


PowFit <- nlsLM(BodyWeight ~ powMod(TotalLength, a, b) , data = Data2Fit, start = list(a = .001, b = .001))

Lengths <- seq(min(Data2Fit$TotalLength), max(Data2Fit$TotalLength), len = 200)


Predic2PlotPow <- powMod(Lengths, coef(PowFit)["a"], coef(PowFit)["b"])

plot(Data2Fit$TotalLength, Data2Fit$BodyWeight)
lines(Lengths, Predic2PlotPow, col = "blue", lwd = 2.5)

confint(PowFit) ## find confidence intervals

## make same plot in ggplot

line <- data.frame(cbind(Lengths, Predic2PlotPow)) ## df with data for predicted line
##equation of line
a <- 3.94
b <- 10^-06
len <- "Length^2.59"
eq <- as.character(as.expression("weight = 3.94 * 10^-06 * Length^2.59"))   


ggplot(data = Data2Fit, aes(x = TotalLength, y = BodyWeight)) + # set data
    theme_bw() + 
    geom_point(shape = 21) +# set points
    geom_line(data = line, aes( x = Lengths, y = Predic2PlotPow), colour = "blue") 


####### OLS ###########

OLS <- lm(log(BodyWeight) ~ log(TotalLength), data = Data2Fit)
plot(log(Data2Fit$BodyWeight), log(Data2Fit$TotalLength))

exp(coef(OLS)[1]) ## intercept of line

coef(PowFit)[1]





