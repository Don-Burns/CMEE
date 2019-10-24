## Desc: TO BE IGNORED FOR README.  A script to look at using ggplot following the notes from samraats repo

require(ggplot2) ## Load the package
graphics.off()
MyDF <- read.csv("../data/EcolArchives-E089-51-D1.csv")

print(qplot(Prey.mass, Predator.mass, data = MyDF))#

print(qplot(log(Prey.mass), log(Predator.mass), data = MyDF))

print(qplot(log(Prey.mass), log(Predator.mass), data = MyDF, colour = Type.of.feeding.interaction))

print(qplot(log(Prey.mass), log(Predator.mass), data = MyDF, shape = Type.of.feeding.interaction))

qplot(log(Prey.mass), log(Predator.mass), data = MyDF, colour = "red")

qplot(log(Prey.mass), log(Predator.mass), data = MyDF, colour = I("red"))

qplot(log(Prey.mass), log(Predator.mass), data = MyDF, size = 3) # with ggplot size mapping


qplot(log(Prey.mass), log(Predator.mass), data = MyDF, size = I(3)) ## makes size not care about other factors.

qplot(log(Prey.mass), log(Predator.mass), data = MyDF, shape = I(3)) ## shape can be changed to even give letters for points

qplot(log(Prey.mass), log(Predator.mass), data = MyDF, colour = Type.of.feeding.interaction, alpha = 0.5)

qplot(log(Prey.mass), log(Predator.mass), data = MyDF, geom = c("point", "smooth"))


qplot(log(Prey.mass), log(Predator.mass), data = MyDF, geom = c("point", "smooth")) + geom_smooth(method = "lm")

qplot(log(Prey.mass), log(Predator.mass), data = MyDF, geom = c("point", "smooth"),colour = Type.of.feeding.interaction) + geom_smooth(method = "lm")

qplot(log(Prey.mass), log(Predator.mass), data = MyDF, geom = c("point", "smooth"), colour = Type.of.feeding.interaction) + geom_smooth(method = "")

qplot(Type.of.feeding.interaction, log(Prey.mass/Predator.mass), data = MyDF)

qplot(Type.of.feeding.interaction, log(Prey.mass/Predator.mass), data = MyDF, geom = "jitter")


qplot(Type.of.feeding.interaction, log(Prey.mass/Predator.mass), data = MyDF, geom = "boxplot")

qplot(log(Prey.mass/Predator.mass), data = MyDF, geom = "histogram")

qplot(log(Prey.mass/Predator.mass),  data = MyDF, geom = "histogram", fill = Type.of.feeding.interaction)

qplot(log(Prey.mass/Predator.mass), data = MyDF, geom = "histogram", fill = Type.of.feeding.interaction, binwidth = 1)


qplot(log(Prey.mass/Predator.mass), data = MyDF, geom = "density", fill = Type.of.feeding.interaction)

qplot(log(Prey.mass/Predator.mass), data = MyDF, geom = "density", fill = Type.of.feeding.interaction, alpha = I(0.5))

qplot(log(Prey.mass/Predator.mass), data = MyDF, geom = "density", colour = Type.of.feeding.interaction)

qplot(log(Prey.mass/Predator.mass), facets = Type.of.feeding.interaction ~., data = MyDF, geom = "density")

qplot(log(Prey.mass/Predator.mass), facets = .~ Type.of.feeding.interaction, data = MyDF, geom = "density")


## The function doesn't like the plus in the original script so modified to make it one then feed to the function
MyDF$feedlocat <- paste(MyDF$Type.of.feeding.interaction , MyDF$Location)

qplot(log(Prey.mass/Predator.mass), facets = .~ feedlocat, data = MyDF, geom = "density")

qplot(Prey.mass, Predator.mass, data = MyDF, log = 'xy')

qplot(Prey.mass, Predator.mass, data = MyDF, log = 'xy',
main = "Relation between predator and prey mass",
xlab = "log(Prey mass) (g)",
ylab = "log(Predator mass) (g)")

qplot(Prey.mass, Predator.mass, data = MyDF, log = 'xy',
main = "Relation between predator and prey mass",
xlab = "log(Prey mass) (g)",
ylab = "log(Predator mass) (g)") + theme_bw()

pdf("../Results/MyFirst-ggplot2-Figure.pdf")
print(qplot(Prey.mass, Predator.mass, data = MyDF, log = "xy",
    main = "Relation between predator and prey mass",
    xlab = "log(Prey mass (g)",
    ylab = "log(Predator mass) (g)") + theme_bw())
dev.off()


###Various GEOM section
MyDF <- as.data.frame(read.csv("../data/EcolArchives-E089-51-D1.csv"))

#barplot
qplot(Predator.lifestage, data = MyDF, geom = "bar")
# boxplot
qplot(Predator.lifestage, log(Prey.mass), data = MyDF, geom = "boxplot")
#violin plot 
qplot(Predator.lifestage, log(Prey.mass), data = MyDF, geom = "violin")
#density
qplot(log(Predator.mass), data = MyDF, geom = "density")
#histogram
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, geom = "point")
#smooth
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, geom = "smooth")
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, geom = "smooth", method = "lm")


## advanced plotting - ggplot
p <- ggplot(MyDF, aes(x = log(Predator.mass), y = log(Prey.mass), colour = Type.of.feeding.interaction))
p + geom_point()

q <- p + geom_point(size = I(2), shape = I(10)) +
    theme_bw() + # makle the background white
    theme(aspect.ratio = 1)
q

q + theme(legend.position = "none") + theme(aspect.ratio = 1)


require(reshape2)












