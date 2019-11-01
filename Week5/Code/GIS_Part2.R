## Desc: Due to constant crashing of the uk data handling. the code was split where that data was no longer being used to pregress

require(raster)
require(sf)
require(viridis)
require(units)

############LOADING VECTOR DATA#################
# Load a vector shapefile
ne_110 <- st_read('../data/ne_110m_admin_0_countries/ne_110m_admin_0_countries.shp')
##################LOADING RASTER DATA##############

# Read in Southern Ocean example data
so_data <- read.csv('../data/Southern_Ocean.csv', header=TRUE)
head(so_data)

# Convert the data frame to an sf object
so_data <- st_as_sf(so_data, coords=c('long', 'lat'), crs=4326)
head(so_data)

##########LOADING RASTER DATA##################
etopo_25 <- raster('../data/etopo_25.tif')
# Look at the data content
print(etopo_25)

plot(etopo_25)

### task tbd


##solution
bks <- seq(-10000, 6000, by=250)
land_cols  <- terrain.colors(24)
sea_pal <- colorRampPalette(c('darkslateblue', 'steelblue', 'paleturquoise'))
sea_cols <- sea_pal(40)
plot(etopo_25, axes=FALSE, breaks=bks, col=c(sea_cols, land_cols), 
     axis.args=list(at=seq(-10000, 6000, by=2000), lab=seq(-10,6,by=2)))


# Download bioclim data: global maximum temperature at 10 arc minute resolution
tmax <- getData('worldclim', download=TRUE, path='../data', var='tmax', res=10)

# ... and the data for those layers has been saved in our data folder.
dir('../data/wc10')

# scale the data
tmax <- tmax / 10
# Extract  January and July data and the annual maximum by location.
tmax_jan <- tmax[[1]]
tmax_jul <- tmax[[7]]
tmax_max <- max(tmax)
# Plot those maps
par(mfrow=c(3,1), mar=c(2,2,1,1))
bks <- seq(-500, 500, length=101)
pal <- colorRampPalette(c('lightblue','grey', 'firebrick'))
cols <- pal(100)
ax.args <- list(at= seq(-500, 500, by=100))
plot(tmax_jan, col=cols, breaks=bks, axis.args=ax.args, main='January maximum temperature')
plot(tmax_jul, col=cols, breaks=bks, axis.args=ax.args, main='July maximum temperature')
plot(tmax_max, col=cols, breaks=bks, axis.args=ax.args, main='Annual maximum temperature')



####################Cropping Data###################
so_extent <- extent(-60, -20, -65, -45)
# The crop function for raster data...
so_topo <- crop(etopo_25, so_extent)
# ... and the st_crop function to reduce some higher resolution coastline data
ne_10 <- st_read('../data/ne_10m_admin_0_countries/ne_10m_admin_0_countries.shp')


st_agr(ne_10) <- 'constant'
so_ne_10 <- st_crop(ne_10, so_extent)
## although coordinates are longitude/latitude, st_intersection assumes that they are planar


## task and solution
sea_pal <- colorRampPalette(c('grey30', 'grey50', 'grey70'))
plot(so_topo, col=sea_pal(100), asp=1, legend=FALSE)
contour(so_topo, levels=c(-2000, -4000, -6000), add=TRUE, col='grey80')
plot(st_geometry(so_ne_10), add=TRUE, col='grey90', border='grey40')
plot(so_data['chlorophyll'], add=TRUE, logz=TRUE, pch=20, cex=2, pal=viridis, border='white', reset=FALSE)
.image_scale(log10(so_data$chlorophyll), col=viridis(18), key.length=0.8, key.pos=4, logz=TRUE)


############# spatial joining###################

# extract Africa from the ne_110
 africa <- subset(ne_110, CONTINENT == 'Africa', select = c('ADMIN', 'POP_EST'))

# transform to the Robinson Projection
africa <- st_transform(africa, crs = 54030)























