
##House keeping##
graphics.off()
rm(list = ls())

##Load Packages
require(minpack.lm)
require(ggplot2)



####Main####

powMod <- function(x, a, b){
    return(a * x^b)
}

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


PowFit <- nlsLM(BodyWeight ~ powMod(TotalLength, a, b) , data = Data2Fit, start = list(a = .1, b = .1))

Lengths <- seq(min(Data2Fit$TotalLength), max(Data2Fit$TotalLength), len = 200)


Predic2PlotPow <- powMod(Lengths
                         , coef(PowFit)["a"], coef(PowFit)["b"])

plot(Data2Fit$TotalLength, Data2Fit$BodyWeight)
lines(Lengths, Predic2PlotPow, col = "blue", lwd = 2.5)

confint(PowFit) ## find confidence intervals




