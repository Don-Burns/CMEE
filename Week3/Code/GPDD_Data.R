## Desc: A script which takes Global Population Dynamics Database (GPDD) data and maps it.
##House keeping ##
rm(list = ls())

## load data ##
load("../data/GPDDFiltered.RData")

## Packeages ## 
require(maps)
require(ggplot2)
## vars ##
lat <- gpdd$lat
long <- gpdd$long
world <- map_data("world")
## Main ## 


map <- ggplot() + # construct map
    geom_polygon(data = world, aes(x = long, y = lat, group = group), fill = "grey", color = "black") +
    coord_fixed(1.3)
pdf("../Results/GPDD_Data.pdf")
print(
    map + geom_point(data = gpdd, aes(x = long, y = lat), color ="red", size = .5, alpha = 0.7)  #add points
)
dev.off()


### observation - looking at this map the data is heavily biased toward westen USA and europe (particularly the UK).
#This shows that when you use "global" data you need to be aware of any "bias" the sampling will have.

