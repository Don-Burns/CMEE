# Desc: A script exploring how to make, manipulate and save maps made using coordinate specified directly in code


rm(list = ls())


require(raster)
require(sf)
require(viridis)
require(units)
pop_dens <- data.frame(n_km2 = c(260, 67, 151, 4500, 133), country = c('England', 'Scotland', 'Wales', 'London', 'Northern Ireland'))
print(pop_dens)

##############################################
##########MAKING VECTORS FROM COORDINATES#####
##############################################
# Create coordinate for each country
# - this is a list of sets of coordinates forming the edge of the polygon
# - note that they have to _close_ (have the same coordinate at either end)
scotland <- rbind(c(-5, 58.6), c(-3, 58.6), c(-4, 57.6), c(-1.5, 57.6), c(-2, 55.8), c(-3, 55), c(-5, 55), c(-6, 56), c(-5, 58.6))

england <- rbind(c(-2,55.8),c(0.5, 52.8), c(1.6, 52.8), c(0.7, 50.7), c(-5.7,50), c(-2.7, 51.5), c(-3, 53.4),c(-3, 55), c(-2,55.8))

wales <- rbind(c(-2.5, 51.3), c(-5.3,51.8), c(-4.5, 53.4), c(-2.8, 53.4),  c(-2.5, 51.3))
ireland <- rbind(c(-10,51.5), c(-10, 54.2), c(-7.5, 55.3), c(-5.9, 55.3), c(-5.9, 52.2), c(-10,51.5))


# Convert these coordinate into feature geometries
# - these are simple coordinates sets with no projection information.

scotland <- st_polygon(list(scotland))
england <- st_polygon(list(england))
wales <- st_polygon(list(wales))
ireland <- st_polygon(list(ireland))

# Combine geometries into a simple feature column
uk_eire <- st_sfc(wales, england, scotland, ireland, crs = 4326)
plot(uk_eire, asp = 1)

uk_eire_capitals <- data.frame(long = c(-.1, -3.2, -3.2, -6, -6.25), lat = c(51.5, 51.5, 55.8, 54.6, 53.3), name = c('London', 'Cardiff', 'Edinburgh', 'Belfast', 'Dublin'))

uk_eire_capitals <- st_as_sf(uk_eire_capitals, coords = c('long', 'lat'), crs = 4326)


########################################################
##########VECTRO GEOMETRY OPERATIONS####################
########################################################

st_pauls <- st_point(x = c(-0.098056, 51.513611))
london <- st_buffer(st_pauls, 0.25)

england_no_london <- st_difference(england, london)

# Count the points and show the number of rings within the polygon features
lengths(scotland)

lengths(england_no_london)

wales <- st_difference(wales, england)    


# A rough that includes Northern Ireland and surrounding sea. 
# - not the alternative way of providing the coordinates.

ni_area <- st_polygon(list(cbind(x=c(-8.1, -6, -5, -6, -8.1), y=c(54.4, 56, 55, 54, 54.4))))

northern_ireland <- st_intersection(ireland, ni_area)
eire <- st_difference(ireland, ni_area)

# Combine the final geometries
uk_eire <- st_sfc(wales, england_no_london, scotland, london, northern_ireland, eire, crs = 4326)


########################################################
##############FEATURES AND GEOMETRIES###################
########################################################

# make the UK into a single feature
uk_country <- st_union(uk_eire[-6])

# Compare six polygon features with one multipolygon feature
print(uk_eire)

print(uk_country)

# Plot them
par(mfrow = c(1, 2), mar = c(3, 3, 1, 1))
plot(uk_eire, asp = 1, col = rainbow(6))
plot(st_geometry(uk_eire_capitals), add = T)
plot(uk_country, asp = 1, col = 'lightblue')


########################################################
############VECTOR DATA AND ATTRIBUTES##################
########################################################

uk_eire <- st_sf(name = c('Wales', 'England', 'Scotland', 'London', 'Northern Ireland', 'Eire'), geometry = uk_eire)
plot(uk_eire, asp = 1)

uk_eire$capital <- c('London', 'Edinburgh', ' Cardiff', NA, 'Belfast', 'Dublin')

uk_eire <- merge(uk_eire, pop_dens, by.x = 'name', by.y = 'country', all.x = T)
print(uk_eire)


##prevents crash?
dev.off()
########################################################
#################SPATIAL ATTIBUTES######################
########################################################

uk_eire_centroids <- st_centroid(uk_eire)

uk_eire$area <- st_area(uk_eire)  ## causing crashes?!
# The length of a polygon is the perimeter length
# - nte that this includes the length of internal holes.

uk_eire$length <- st_length(uk_eire)

# look at the result
print(uk_eire)

# You can change units in a neat way
uk_eire$area <- set_units(uk_eire$area, 'km^2')
uk_eire$length <- set_units(uk_eire$length, 'km')

# And which won't let you make silly error like turning a length into weight
#uk_eire$area <- set_units(uk_eire$area, 'kg')

#Or you can simply convert the 'units' version to simple numbers
uk_eire$length <- as.numeric(uk_eire$length) # will be a string by default

print(uk_eire)

st_distance(uk_eire)

st_distance(uk_eire_centroids)

########################################################
#############PLOTTING sf OBJECTS########################
########################################################
plot(uk_eire['n_km2'], asp = 1, logz = T) #task: to log the scale, use logz or log data beforehand

########################################################
#############REPROJECTING VECTOR DATA###################
########################################################

# British National Grid (EPSG:27700)
uk_eire_BNG <- st_transform(uk_eire, 27700)

# The bounding box of the data shows the change in units
st_bbox(uk_eire)

st_bbox(uk_eire_BNG)

# UTM50N (EPSG:32650)
uk_eire_UTM50N <- st_transform(uk_eire, 32650)

# plot the results
par(mfrow = c(1, 3), mar = c(3, 3, 1, 1))
plot(st_geometry(uk_eire), asp = 1, axes = T, main = 'WGS 84')
plot(st_geometry(uk_eire), asp = 1, axes = T, main = 'OSGB 1936 / BNG')
plot(st_geometry(uk_eire_UTM50N), axes = T, main = 'UTM 50N')

########################################################
###############Proj4 STRINGS############################
########################################################
# Set up some points seperated by 1 degree latitude and longitude from St. Pauls
st_pauls <- st_sfc(st_pauls, crs = 4326) 
one_deg_west_pt <- st_sfc(st_pauls - c(1, 0), crs = 4326) # near Goring
one_deg_north_pt <- st_sfc(st_pauls + c(0, 1), crs = 4326) # near Peterborough
# Calculate the distance between St pauls and each point
st_distance(st_pauls, one_deg_west_pt)

st_distance(st_pauls, one_deg_north_pt)

st_distance(st_transform(st_pauls, 27700), st_transform(one_deg_west_pt, 27700))



####IMPROVE LONDON CIRCLE###

## task -make london buffer 25km

londonBNG <- st_buffer(st_transform(st_pauls,27700), 25000)

# In one line, transform england to BNG and cut out London
england_no_london_BNG <- st_difference(st_transform(st_sfc(england, crs = 4326), 27700), londonBNG)

# project the other features and combine everything together
others_BNG <- st_transform(st_sfc(eire, northern_ireland, scotland, wales, crs = 4326), 27700)

corrected <- c(others_BNG, londonBNG, england_no_london_BNG)

# plot that 
graphics.off()
par(mar = c(3, 3, 1, 1))
plot(corrected, main = "25km radius London", axes = T)

########################################################
#############RASTERS####################################
#######Creating a raster################################
########################################################

# create an empty raster object covering UK and Eire
uk_raster_WGS84 <- raster(xmn = -11, xmx = 2, ymn = 49.5, ymx = 59, res = .5, crs = "+init=EPSG:4326")
hasValues(uk_raster_WGS84)

## add data to raster

values(uk_raster_WGS84) <- seq(length(uk_raster_WGS84))

plot(uk_raster_WGS84)
plot(st_geometry(uk_eire), add = T, border = 'black', lwd = 2, col = "#FFFFFF44")

#############CHANGING RASTER RESOLUTION############

# define a simple 4x4 square raster
m <- matrix(c(1, 1, 3, 3,
            1, 2, 4, 3,
            5, 5, 7, 8,
            6, 6, 7, 7), ncol = 4, byrow = T)

square <- raster(m)


#########AGGREGATING RASTERS############

# average values
square_agg_mean <- aggregate(square, fact = 2, fun = mean)
values(square_agg_mean)

# Maximum values
square_agg_max <- aggregate(square, fact = 2, fun = max)
values(square_agg_max)

# modal values for categories
square_agg_modal <- aggregate(square, fact = 2, fun = modal)
values(square_agg_modal)

###############DISAGGREGATING RASTERS#################

# copy parents
square_disagg <- disaggregate(square, fact =2)

# Interpolate
square_disagg_interp <- disaggregate(square, fact = 2, method = 'bilinear')


################REPROJECTING A RASTER###################

# make two simple `sfc` objects containing points in the lower left and top right of the two grids
uk_pts_WGS84 <- st_sfc(st_point(c(-11, 49.5)), st_point(c(2, 59)), crs = 4326)
uk_pts_BNG <- st_sfc(st_point(c(-2e5, 0)), st_point(c(7e5, 1e6)), crs = 27700)

# use st_make_grid to quickly create a polygon grid with the right cellsize
uk_grid_WGS84 <- st_make_grid(uk_pts_WGS84, cellsize = 0.5)
uk_grid_BNG <- st_make_grid(uk_pts_BNG, cellsize = 1e5)

# Reproject BNG grid into WGS4
uk_grid_BNG_as_WGS84 <- st_transform(uk_grid_BNG, 4326)


# Plot the features 
plot(uk_grid_WGS84, asp = 1, border = 'grey', xlim = c(-13,4))
plot(st_geometry(uk_eire), add = T, border = 'darkgreen', lwd = 2)
plot(uk_grid_BNG_as_WGS84, border = 'red', add = T)

# Create the target raster
uk_raster_BNG <- raster(xmn=-200000, xmx=700000, ymn=0, ymx=1000000, res=100000, crs='+init=EPSG:27700')
#uk_raster_BNG_interp <- projectRaster(uk_raster_WGS84, uk_raster_BNG, method='bilinear')
#uk_raster_BNG_ngb <- projectRaster(uk_raster_WGS84, uk_raster_BNG, method='ngb')
#par(mfrow=c(1,3), mar=c(1,1,2,1))
#plot(uk_raster_BNG_interp, main='Interpolated', axes=FALSE, legend=FALSE)
#plot(uk_raster_BNG_ngb, main='Nearest Neighbour',axes=FALSE, legend=FALSE)


############VECTOR TO RASTER################

# Create the target raster
uk_20km <- raster(xmn=-200000, xmx=650000, ymn=0, ymx=1000000, res=20000, crs='+init=EPSG:27700')

# Rasterising polygons
uk_eire_poly_20km <- rasterize(as(uk_eire_BNG, 'Spatial'), uk_20km, field = 'name')

#Rasterising lines
uk_eire_BNG_line <- st_cast(uk_eire_BNG, 'LINESTRING')

st_agr(uk_eire_BNG) <- 'constant'

# Rasterising lines
uk_eire_BNG_line <- st_cast(uk_eire_BNG, 'LINESTRING')
uk_eire_line_20km <- rasterize(as(uk_eire_BNG_line, 'Spatial'), uk_20km, field = 'name')

# Rasterizing points 
# - This isn't quite as neat. You need to take two steps in the cast and need to convert 
#   the name factor to numeric.

uk_eire_BNG_point <- st_cast(st_cast(uk_eire_BNG, 'MULTIPOINT'), 'POINT')
uk_eire_BNG_point$name <- as.numeric(uk_eire_BNG_point$name)
uk_eire_point_20km <- rasterize(as(uk_eire_BNG_point, 'Spatial'), uk_20km, field = 'name')

# Plotting those different outcomes
par(mfrow = c(1, 3), mar = c(1, 1, 1, 1))
plot(uk_eire_poly_20km, col = viridis(6, alpha = .5), legend = F, axes =F)
plot(st_geometry(uk_eire_BNG), add=TRUE, border='grey')

plot(uk_eire_line_20km, col=viridis(6, alpha=0.5), legend=FALSE, axes=FALSE)
plot(st_geometry(uk_eire_BNG), add=TRUE, border='grey')

plot(uk_eire_point_20km, col=viridis(6, alpha=0.5), legend=FALSE, axes=FALSE)
plot(st_geometry(uk_eire_BNG), add=TRUE, border='grey')


#############Raster to vector#################
# rasterToPolygons returns a polygon for each cell and return a Spatial object
poly_from_rast <- rasterToPolygons(uk_eire_poly_20km)
poly_from_rast <- as(poly_from_rast, 'sf')

# but can be set to dissolve the boundaries between cells with identical values
poly_from_rast_dissolve <- rasterToPolygons(uk_eire_poly_20km, dissolve =T)
poly_from_rast_dissolve <- as(poly_from_rast_dissolve, 'sf')

# rasterToPoints returns a matrix of coordinates and values
points_from_rast <- rasterToPoints(uk_eire_poly_20km)
points_from_rast <- st_as_sf(data.frame(points_from_rast), coords = c('x','y'))


# Plot the outputs - using key.pos=NULL to suppress the key and
# reset=FALSE to avoid plot.sf altering the par() options
par(mfrow=c(1,3), mar=c(1,1,1,1))
plot(poly_from_rast['layer'], key.pos = NULL, reset = FALSE)
plot(poly_from_rast_dissolve, key.pos = NULL, reset = FALSE)
plot(points_from_rast, key.pos = NULL, reset = FALSE)

##################LOADING RASTER DATA##############
# Read in Southern Ocean example data
so_data <- read.csv('../data/Southern_Ocean.csv', header=TRUE)
head(so_data)

# Convert the data frame to an sf object
so_data <- st_as_sf(so_data, coords=c('long', 'lat'), crs=4326)
head(so_data)

##############SAVING VECTOR DATA####################

st_write(uk_eire, '../data/uk_eire_WGS84.shp')
## Writing layer `uk_eire_WGS84' to data source `data/uk_eire_WGS84.shp' using driver `ESRI Shapefile'
## Writing 6 features with 5 fields and geometry type Polygon.

st_write(uk_eire_BNG, '../data/uk_eire_BNG.shp')
## Writing layer `uk_eire_BNG' to data source `data/uk_eire_BNG.shp' using driver `ESRI Shapefile'
## Writing 6 features with 5 fields and geometry type Polygon.

st_write(uk_eire, '../data/uk_eire_WGS84.geojson')
## Writing layer `uk_eire_WGS84' to data source `data/uk_eire_WGS84.geojson' using driver `GeoJSON'
## Writing 6 features with 5 fields and geometry type Polygon.

st_write(uk_eire, '../data/uk_eire_WGS84.gpkg')
## Updating layer `uk_eire_WGS84' to data source `data/uk_eire_WGS84.gpkg' using driver `GPKG'
## Writing 6 features with 5 fields and geometry type Polygon.

st_write(uk_eire, '../data/uk_eire_WGS84.json', driver='GeoJSON')
## Writing layer `uk_eire_WGS84' to data source `data/uk_eire_WGS84.json' using driver `GeoJSON'
## Writing 6 features with 5 fields and geometry type Polygon.

