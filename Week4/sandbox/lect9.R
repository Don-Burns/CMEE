## exercise from stats week lecture 9 - day 4

x <- c(1, 2, 3, 4, 8)
y <- c(4, 3, 5, 7, 9)
model1 <- lm(y~x)
model1
summary(model1)
anova(model1)
resid(model1)
cov(x,y)
var(x)
plot(y~x)
