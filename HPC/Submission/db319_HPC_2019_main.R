# CMEE 2019 HPC excercises R code main proforma
# you don't HAVE to use this but it will be very helpful.  If you opt to write everything yourself from scratch please ensure you use EXACTLY the same function and parameter names and beware that you may loose marks if it doesn't work properly because of not using the proforma.

name <- "Donal Burns"
preferred_name <- "Donal"
email <- "donal.burns319@imperial.ac.uk"
username <- "db319"
personal_speciation_rate <- 0.005502 # will be assigned to each person individually in class and should be between 0.002 and 0.007

# Question 1
species_richness <- function(community){ 
  # Returns the species richness of a community when given a list of the species in that community, `community`.
  return (length(unique(community)))
}

# Question 2
init_community_max <- function(size){
  # Returns a vector containing the maximun number of species that can be present in a community of X individuals. 
  # E.g. for `size = 4` returns the vector (1, 2, 3, 4)
  return(seq(1:size))
}

# Question 3
init_community_min <- function(size){
  # Returns a vector containing the minimum number of species that can be present in a community of X individuals. 
  # E.g. for `size = 2` returns the vector (1, 1).
  return(rep(1, size))
}

# Question 4
choose_two <- function(max_value){
  # returns a vector with two different values randomly chosen between 1 and `max_value`
  distribution <- seq(1:max_value)
  return(sample(distribution, 2, replace = F))
}

# Question 5
neutral_step <- function(community){
  # Chooses one individual in `commuity` to reproduce and one to die.  Then outputs the new community with the new individual in the place of the one which died.
  tmp = choose_two(length(community)) #chooses the index of two individuals from `community`
  reproduce <- tmp[1] # index of individual which reproduces
  die <- tmp[2] # index of individual which dies
  
  community[die] <- community[reproduce] # replace the individual which dies with the offspring of the individual which reproduced
  return(community)
}

# Question 6
neutral_generation <- function(community){
  # Will use `neutral_step` to simulate the reproduction and death of individuals over a generation where generation length = number of individuals / 2.
  roundUpDown <- sample(c(T,F), 1) # choose to round up or down randomly
  
  if(roundUpDown){ # if `round_updown` is True then round up
    rounding <- ceiling
  }
  else{ # else round down
    rounding <- floor
  }
  
  genLength <- rounding(length(community) / 2) # length of a generation
  
  for(i in 1:genLength){ # go through one generation and apply `neutral_step` to community and save the output each time.
    community <- neutral_step(community)
  }
  return(community)
}

# Question 7
neutral_time_series <- function(community,duration)  {
  # returns a vector with the results of `community` undergoing a neutral theory simulation over `duration` generations.  The first entry in the output is the initial community's species richness.
  
  output <- rep(NA, duration + 1) # predefine the length of the output, will contain the richness of the community after each generation.  One extra slot is defined for the initial community's species richness to be stored
  output[1] <- species_richness(community) # assign the first point as the initial community's richness
  
  for(i in 1:duration){ # loop over `duration` generations and store the output
    community <- neutral_generation(community)
    output[i+1] <- species_richness(community) # save the result of the generation.  (index is offset because of initial value in output)
  }
    
  return(output)
}

# Question 8
question_8 <- function() {
  # Simulates a neutral theory simulation on a community of 100 individuals with maximum richness over 200 generations.  Plots the result and returns an explaination of what occurs.
  
  # clear any existing graphs and plot your graph within the R window
  if(is.null(dev.list()) == F) dev.off() # need if statement or else error will occur due to no device being present to close
  
  generations <- 200 # number of genrations
  community <- init_community_max(100) # define the community as having maximum richness for a community of 100 individuals
  
  # simulate the community over number of generations
  SimOutput <- neutral_time_series(community, duration = generations) # output of the simulation
  
  ##Plotting##
  plot(SimOutput, type = "l", xlab = "Generations", ylab = "Species Richness")
  title("Question 8")
  
  return("The system will always converge on a species richness of one.  This is because this simulation is always choosing onw individual to reproduce and one to die.  There is also no mutation or migration in the system.  Meaning that one species will slowly take over the system.")
}

# Question 9
neutral_step_speciation <- function(community,speciation_rate)  {
  # Chooses one individual in `commuity` to reproduce and one to die.  Then outputs the new community with the new individual in the place of the one which died.
  mutation <- runif(n = 1, min = 0, max = 1) # pick a number between 0 and 1 to be used to determine whether mutation occurs or not

  if(mutation < speciation_rate){ # if there is a mutation take the dead individual and replace it with an individual of a new species
    tmp = choose_two(length(community)) #chooses the index of two individuals from `community`
    die <- tmp[1] # index of individual which dies
    mutation <- max(community)+1 # value of the new species, choose an ID which is no present in the community already
    
    community[die] <- mutation # replace the individual which dies with the offspring of the individual which reproduced
    return(community)
  }
  else{ # if no mutation just carry out normal neutral_step
    return(neutral_step(community))
  }

}

# Question 10
neutral_generation_speciation <- function(community,speciation_rate)  {
  # Will use `neutral_step_speciation` to simulate the death and either reporduction or mutation of individuals over a generation where generation length = number of individuals / 2.
  roundUpDown <- sample(c(T,F), 1) # choose to round up or down randomly
  
  if(roundUpDown){ # if `round_updown` is True then round up
    rounding <- ceiling
  }
  else{ # else round down
    rounding <- floor
  }
  
  genLength <- rounding(length(community) / 2) # length of a generation
  
  for(i in 1:genLength){ # go through one generation and apply `neutral_step_speciation` to community and save the output each time.
    community <- neutral_step_speciation(community, speciation_rate)
  }
  return(community)
}


# Question 11
neutral_time_series_speciation <- function(community,speciation_rate,duration)  {
  # returns a vector with the results of `community` species richness after undergoing a neutral theory simulation, including speciation, over `duration` generations.  The first entry in the output is the initial community's species richness.
  
  output <- rep(NA, duration + 1) # predefine the length of the output, will contain the richness of the community after each generation.  One extra slot is defined for the initial community's species richness to be stored
  output[1] <- species_richness(community) # assign the first point as the initial community's richness
  
  for(i in 1:duration){ # loop over `duration` generations and store the output
    community <- neutral_generation_speciation(community, speciation_rate)
    output[i+1] <- species_richness(community) # save the result of the generation.  (index is offset because of initial value in output) 
  }
  
  return(output)
}

# Question 12
question_12 <- function()  {
  # Simulates a neutral theory simulation with mutation on a community of 100 individuals with maximum richness over 200 generations.  Plots the result and returns an explaination of what occurs.
  
  # clear any existing graphs and plot your graph within the R window
  if(is.null(dev.list()) == F) dev.off() # need if statement or else error will occur due to no device being present to close
  
  generations <- 200 # number of genrations
  communityMax <- init_community_max(100) # define the community as having maximum richness for a community of 100 individuals
  communityMin <- init_community_min(100)
  # simulate the community over number of generations
  SimOutputMaxRich <- neutral_time_series_speciation(communityMax, speciation_rate = 0.1, duration = generations) # output of the simulation with max richness to start
  SimOutputMinRich <- neutral_time_series_speciation(communityMin, speciation_rate = 0.1, duration = generations) # output of the simulation with min richness to start
  
  ##plotting##
  plot(SimOutputMaxRich, type = "l", xlab = "Generations", ylab = "Species Richness", col = "red") # plot max richness from simulation
  lines(SimOutputMinRich, col = "blue") # plot min richness 
  legend("topright", legend = c("Max Richness", "Min Richness"), col = c("red", "blue"), lty = 1) # add a legend for the lines
  title("Question 12")
  
  return("From the plot it can be seen that given enough time species richness will reach a sort of equilibrium and fluctuate around it given mutation is occuring.  This occurs irrespective of starting species richness.  This is the result of richness decreasing, and given no mutation it would fixate at one, as seen in `quesiton 8`.  Given only mutation as a factor diversity would increase to the maximum possible value.  Here after enough time mutation add richness while wihtout it would decrease, resulting in the 'equilibrium'.")
}

# Question 13
species_abundance <- function(community)  { 
  # returns a vector of the abundances of a species in a community in decreasing order.
  return(as.vector(sort(table(community), decreasing = T))) # sort in decreasing order and then make a table of the data.
}

# Question 14
octaves <- function(abundance_vector) { # takes a species abundance vector and returns them bined in "octave classes" where each bin ranges from 2^n-1 to 2^n where n is the bin number.
  return(tabulate(floor(log2(abundance_vector)+1))) # use log2 to find what bin each value should go in i.e. n, add 1 to adjust for the fact that log2(1) = 0, likewise if not done all other values are off by 1.
  
}

# Question 15
sum_vect <- function(x, y) { 
  # takes two vectors of different lengths and add them together.
  lenx <- length(x) 
  leny<- length(y)
  
  
  if(lenx == leny){ # if they are equal length there is no need to manipulate so return x + y
    return(x + y)
  }
  
  
  else if(lenx > leny){ # if x longer add 0s to the end of y until lenght its the same.
    tmpy <- c(y, rep(0, lenx - leny)) # add the difference in length as 0s
    output <- x + tmpy
  }
  else{ # if y is longer add 0s to x until they are the same length
    tmpx <- c(x, rep(0, leny- lenx)) # add the difference in length as 0s
    output <- y + tmpx
  }
  
  return(output)
  
}

# Question 16 
question_16 <- function()  {
  # Runs a neutral model with mutation on a community of 100 individuals for a burn in time of 200 generations and the octave vector of the community recorded.  After this burn in time the simulation is continued for 2000 generations and the average of the octaves taken every 20 generations is plotted as a barplot.
  
  
  # clear any existing graphs and plot your graph within the R window
  if(is.null(dev.list()) == F) dev.off() # need if statement or else error will occur due to no device being present to close
  
  burnin <- 200 # number of genrations for burn in
  speciation_rate <- 0.1 # speciation rate
  community <- init_community_max(100) # define the community as having maximum richness for a community of 100 individuals

  
  # simulate the community over number of generations
  
  for(i in 1:burnin){ # loop over `duration` generations and store the output
    community <- neutral_generation_speciation(community, speciation_rate)
  }
  
  postBurnOctave <- octaves(species_abundance(community)) # octave of commuity after burn in period
 
  
  ##### simulation after burn in#####
  
  generations <- 2000 # number of generation after burn in
  
  # predefine the matrix to store the octaves every 20 generations.  
  octaves20gen <- postBurnOctave # start the Octaves of every 20th generation as equalling the postBurnOctave.  The value of the community octave will be added to this every 20 generations in the loop below
  
  for(i in  1:generations){
    # simulate the community change with mutation from 1 to n generations and save the octave of every 20th generation
    
    community <- neutral_generation_speciation(community, speciation_rate)
    
    # store the octave of every 20th generation, use sum_vect to account for different ized vectors possibly caused by increase in abundace and therefore numbe of bins
   
    if(i%%20 == 0) octaves20gen <- sum_vect(octaves(species_abundance(community)), octaves20gen)
  }
  

  averageOctaves <- octaves20gen / floor(generations/20) + 1 # find the mean by dividing the vector by the number of samples.  i.e. generations / 20 rounded down to the nearest whole number.  1 is added to the denominator to account for the initial `postBurninOctave` being included
  
  barplot(averageOctaves, xlab = "Bins", ylab = "Species Abundance", names.arg = seq(1, length(averageOctaves)), main = "Question 16") # plot the mean as a barplot
  
  return("So long as the number of individuals in the community remains the same, the starting condition of the system does not matter.  This is because the system will reach an equilibrium by the time the burn in period has finished.  This equilibrium will occur around the same species abundances regardless of starting state.")
}

# Question 17
cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name)  {
  # run a neutral theoty simulation with speciation for `wall_time` seconds
  
  community <- init_community_min(size) # define the community as `size` individuals with minimum species richness
  generation <- 0 # a counter for keeping track of what geenration the simulaiton is on
  richList <- list() # an empty list to record species richness to at generation intervals of interval_rich
  octList <- list() # an empty list to record abundance octaves to at generation intervals of interval_oct
  
  start <- proc.time()[3] # start the timer
  while ((proc.time()[3] - start)/60 < wall_time) { # while the timer is less than the wall time continue the simulation. 3rd element is the elapsed time in seconds
    generation <- generation + 1 #iterate the generation
    community <- neutral_generation_speciation(community, speciation_rate) # update the generation with speciation 
    
    if(generation <= burn_in_generations){# only record species richness during the burn in period
      if(generation %% interval_rich == 0) richList[[length(richList)+1]] <-  c(species_richness(community)) #if the richness interval is reached append the richness to `richList`
    }
    
    if(generation %% interval_oct == 0) octList[[length(octList)+1]] <- c(octaves(species_abundance(community))) #if the octaves interval is reached append the octave to `octList`
    
    
  }
  TotalTime <- (proc.time()[3] - start)/60 # divided by 60 to convert to minutes
  
  save(file = output_file_name, burn_in_generations, richList, octList, community, TotalTime, size, speciation_rate, interval_rich, interval_oct, wall_time)
}

# Questions 18 and 19 involve writing code elsewhere to run your simulations on the cluster

# Question 20 
process_cluster_results <- function(filePrefix = "Cluster_Run_output", numFiles = length(list.files(pattern = paste(filePrefix, "*", sep = ''))))  {# Takes the data from HPC, gathers it and returns the average octave for 500, 1000, 2500 and 5000 size populations as a list in this order.  Also plots the results.
  
  # clear any existing graphs and plot your graph within the R window
  if(is.null(dev.list()) == F) dev.off() # need if statement or else error will occur due to no device being present to close

  #### assign list to sum to ###
  sum500 <- c()
  sum1000 <- c()
  sum2500 <- c()
  sum5000 <- c()
  
  ## counter for finding the average later
  counter500 <- 0
  counter1000 <- 0
  counter2500 <- 0
  counter5000 <- 0
  
  

  for(i in 1:numFiles){ # loop through files and remove the burn in generations before stroing the average octave of each `size` of population.

    
    
    load(paste(filePrefix, i, ".rda", sep = '')) # load file
    
    octList <- octList[-c(seq(1, burn_in_generations/interval_oct))] # remove the burn in gernerations 
    
    
    
    ## Depending on `size` used when running the file save it to a corresponding list
    if(size == 500){
      # list500[[length(list500)+1]] <- c(octList)
      for(j in 1:length(octList)){
        sum500 <- sum_vect(sum500, octList[[j]])
        counter500 <- counter500 +1
        }
      }
    if(size == 1000){
      # list1000[[length(list1000)+1]] <- c(octList)
      for(j in 1:length(octList)){
        sum1000 <- sum_vect(sum1000, octList[[j]])
        counter1000 <- counter1000 + 1
       }
      }
  
    if(size == 2500){
      # list2500[[length(list2500)+1]] <- c(octList)
      for(j in 1:length(octList)){
        sum2500 <- sum_vect(sum2500, octList[[j]])
        counter2500 <- counter2500 + 1
      }
    }

    if(size == 5000){
      # list5000[[length(list5000)+1]] <- c(octList)
      for(j in 1:length(octList)){
        sum5000 <- sum_vect(sum5000, octList[[j]])
        counter5000 <- counter5000 + 1
      }
    }
    
    
  }
  
  # average each size
  mean500 <- sum500 / counter500
  mean1000 <- sum1000 / counter1000
  mean2500 <- sum2500 / counter2500
  mean5000 <- sum5000 / counter5000
  
  
  
  
  
  combined_results <- list(mean500, mean1000, mean2500, mean5000) #create your list output here to return
  ####Plotting####
  ylabel <- "Species Abundance"
  xlabel <- "Octave Bins"
  par(mfrow = c(2,2))
  barplot(mean500, main = "Mean Octaves, Size = 500", xlab = xlabel, ylab = ylabel, ylim =c(0, max(mean500)+1), names.arg = seq(1, length(mean500)))
  barplot(mean1000, main = "Mean Octaves, Size = 1000", xlab = xlabel, ylab = ylabel, ylim =c(0, max(mean1000)+1), names.arg = seq(1, length(mean1000)))
  barplot(mean2500, main = "Mean Octaves, Size = 2500", xlab = xlabel, ylab = ylabel, ylim =c(0, max(mean2500)+1), names.arg = seq(1, length(mean2500)))
  barplot(mean5000, main = "Mean Octaves, Size = 5000", xlab = xlabel, ylab = ylabel, ylim =c(0, max(mean5000)+5), names.arg = seq(1, length(mean5000)))

  names(combined_results) <- c("mean500", "mean1000", "mean2500", "mean5000")
  
  return(combined_results)
}

# Question 21
question_21 <- function()  {
  # calculates the dimension of the fractal found in q21 of the handout
  
  # to make a fractal 3x the width of the original how many copies of the original are needed? 
      # answer is 8 because of the hole in the middle.
  # from James' notes `lecture 4 fractals` page 4 of pdf: 
  # 8(the number of copies needed) = 3^x (3 times bigger to x, where x is the dimension)
  # by extension log(8) = x(log(3))
  
  dimension <- log(8)/log(3)
  
  return(list(dimension,"The number needed to make a fractal which is three times the width of the original fractal, eight copies are needed.  one ommited in comparison to a plain cube due to the 'whole' in the middle.  Can then find the dimension according to `x = log(8) / log(3)`, where x is the dimension, 8 because of the number of copies needed to replicate the orgininal at 3 times the size and 3 because that is the amount being scaling by"))
}

# Question 22
question_22 <- function()  {
  # applies the same logic as `question_23`, but for a 3D version of the fractal  
  
  dimension <- log(20) / log(3)
  
  
  return(list(dimension, "Following the logic outlines in `question_21`, this time in three dimensions the larger fractal can be broken into three layers.  the top and bottom layer are identical and much like the 2D version need eight copies and the middle layer has four copies which make the 'pillars' joining the top and bottom layers."))
}

# Question 23
chaos_game <- function(repeats = 100000)  {
  # Takes a points `X` and jumps halfway towards a point `A`, `B` or `C` randomly and plots the resulting fractal
  # clear any existing graphs and plot your graph within the R window
  if(is.null(dev.list()) == F) dev.off() # need if statement or else error will occur due to no device being present to close
  
  #points to jump towards when plotting fractal
  A <- c(0,0)
  B <- c(3,4)
  C <- c(4,1)
  
  
  # list of points ABC for sampling from when deciding which to direction to jump
  ABClist <- list(A, B, C)
  
  X <- c(0,0) # point to initially jump from
  
  Xstore <- matrix(NA, nrow = repeats, ncol = 2) # list to store where X jumps during the simulation
  
  
  
  for(i in 1:repeats){
    choice <- unlist(sample(c(ABClist),1)) # randomly choose to jump towards A, B or C
    X <- (X + choice)/2    # X <- X + (choice/2)
    Xstore[i,] <- X # store the value of X
  }
  
  # plot the results of the loop above
  plot(c(0,0), cex = 0.000001, pch = 8,xlim = c(0, max(Xstore)), ylim = c(0, max(Xstore)), axes = F, xlab = "", ylab = "") # define the starting value of `X` manually as (0,0)
  points(Xstore, cex = 0.000001, pch = 8)
  
  return("What is returned is a series of points which draw one triangle with a triangle of black space enclosed inside, this reapeats producing increasingly smaller versions of the original pattern.  In other words a shape that closely ressembles a Sierpinski Gasket.")
}

# Question 24
turtle <- function(start_position = c(4,2), direction = pi/3, length = 5)  {# funtion to find the endpoint of a line `length` units away from a point `start_position` in a `direction`.  the `direction` needs to be between 0 and pi/2

  xDist <- length * cos(direction)# distance along x axis between start and endpoint
  yDist <- length * sin(direction)# distance along y axis between start and endpoint

  
  endpoint <- c(start_position[1] + xDist, start_position[2] + yDist) # define the endpoint as the start point plus the distances traveled to reach a point `length` units away from `startpoint`.
  segments(x0 = start_position[1],y0 = start_position[2] , x1 = endpoint[1], y1 = endpoint[2])
  
  return(endpoint) # you should return your endpoint here.
}

# Question 25
elbow <- function(start_position = c(4,2), direction = pi/10, length = 5)  {
  
  midpoint <- turtle(start_position = start_position, direction = direction, length = length) # store the midpoint for the elbow

  endpoint <- turtle(start_position = midpoint, direction = direction + pi/4, length = 0.95 * length) # store endpoint of elbow, which is a line pi/4 and `length` away from `midpoint`
  
  segments(x0 = start_position[1],y0 = start_position[2] , x1 = midpoint[1], y1 = midpoint[2])
  segments(x0 = midpoint[1], y0 = midpoint[2], x1 = endpoint[1], y1 = endpoint[2])
  
  output <- matrix(NA, ncol = 2, nrow = 3)
  output[1,] <- start_position
  output[2,] <- midpoint
  output[3,] <- endpoint
  
  return(output) # return a vector containing the 3 points in order need to define the "elbow" line
}

# Question 26
spiral <- function(start_position = c(4,2), direction = pi/4, length = 1)  {
  
  if(length > 0.01){
  
  midpoint <- turtle(start_position = start_position, direction = direction, length = length)
  
  spiral(start_position = midpoint, direction = direction - pi/4, length = 0.95 * length)
  }  
  

  
  return("The code loops infinitly by calling itself over and over.  This results in a spiral made of many line segments where the direction shifts by pi/4 and each line segment is 95% the length of the previous.  In this code specifically this will continue as long as the length of a line segment is over 0.00001 units.")
}

# Question 27
draw_spiral <- function(start_position = c(4,2), direction = pi/4, length = 1)  {
  # clear any existing graphs and plot your graph within the R window
  if(is.null(dev.list()) == F) dev.off() # need if statement or else error will occur due to no device being present to close
  
  
  plot(start_position, cex = 0.000001, xlim = c(start_position[1]-2.3*length, start_position[1]+2.3*length), ylim = c(start_position[2]-2.3*length, start_position[2]+2.3*length), col = "white")
  
  
  return(spiral(start_position = start_position, direction = direction, length = length))
  
}

# Question 28
tree <- function(start_position = c(4,2), direction = pi/4, length = 1)  {
 
   if(length > 0.01){
    
    midpoint <- turtle(start_position = start_position, direction = direction, length = length)
    
    tree(start_position = midpoint, direction = direction - pi/4, length = 0.65 * length)
    
    tree(start_position = midpoint, direction = direction + pi/4, length = 0.65 * length)
  }  
  
}
draw_tree <- function(start_position = c(4,2), direction = pi/4, length = 1)  {
  # clear any existing graphs and plot your graph within the R window
  if(is.null(dev.list()) == F) dev.off() # need if statement or else error will occur due to no device being present to close
  
  
  plot(start_position, cex = 0.000001, xlim = c(start_position[1]-2.3*length, start_position[1]+2.3*length), ylim = c(start_position[2]-2.3*length, start_position[2]+2.3*length), col = "white")
  
  
  return(tree(start_position = start_position, direction = direction, length = length))
  }

# Question 29
fern <- function(start_position = c(4,0), direction = pi/2, length = 1)  {
  
  if(length > 0.01){
    
    midpoint <- turtle(start_position = start_position, direction = direction, length = length)
    
    fern(start_position = midpoint, direction = direction + pi/4, length = 0.38 * length)
    
    fern(start_position = midpoint, direction = direction, length = 0.87 * length)
  }  
  
  
}
draw_fern <- function(start_position = c(4,0), direction = pi/2, length = 1)  {
  # clear any existing graphs and plot your graph within the R window
  if(is.null(dev.list()) == F) dev.off() # need if statement or else error will occur due to no device being present to close
  
  plot(start_position, cex = 0.000001, xlim = c(0, 8), ylim = c(0, 8), col = "white")
  
  return(fern(start_position = start_position, direction = direction, length = length))
}

# Question 30
fern2 <- function(start_position = c(4,0), direction = pi/2, length = 1, dir = 1)  {
  if(length > 0.01){
    
    midpoint <- turtle(start_position = start_position, direction = direction, length = length)
    
    fern2(start_position = midpoint, direction = (direction + pi/4 *dir), length = 0.38 * length, dir = dir)
    
    fern2(start_position = midpoint, direction = direction, length = 0.87 * length, dir = -dir)
  }  
  
}

draw_fern2 <- function(start_position = c(4,0), direction = pi/2, length = 1)  {
  # clear any existing graphs and plot your graph within the R window
  if(is.null(dev.list()) == F) dev.off() # need if statement or else error will occur due to no device being present to close
  
  plot(start_position, cex = 0.000001, xlim = c(0, 8), ylim = c(0, 8), col = "white")
  
  return(fern2(start_position = start_position, direction = direction, length = length, dir = 1))
}

# Challenge questions - these are optional, substantially harder, and a maximum of 16% is available for doing them.  

# Challenge question A
multi_calc_rich <- function(sim_num = 30, burnin = 200, speciation_rate = 0.1, community = init_community_max(100), generations = 2000){
  ## function to calculate the richness of the community over multiple simulations and return a matrix of the results
  
  ## define matrix to store species richness values from which to calculate means later, defined as each row being a simulation and each column a generation
  rich_store <- matrix(NA, nrow = sim_num, ncol = burnin + generations)
  
  
  for(i in 1:sim_num){
    runCommunity <- community # community for the current simulation
    
    # simulate the community over number of generations
    
    for(j in 1:burnin){ # loop over `burnin` generations and store the output
      runCommunity <- neutral_generation_speciation(runCommunity, speciation_rate)
      rich_store[i,j] <- species_richness(runCommunity)
    }
    
    ##### simulation after burn in#####
    

    for(j in  1:generations){
      # simulate the community change with mutation from 1 to n generations and save the octave of every 20th generation
      runCommunity <- neutral_generation_speciation(runCommunity, speciation_rate)
      # store the mean at each generation
      rich_store[i, j+burnin] <- species_richness(runCommunity) # inlcude offset for burnin gens
      
    }

  }
  
  
  
  return(rich_store)
}

Challenge_A <- function() {
  # clear any existing graphs and plot your graph within the R window
  if(is.null(dev.list()) == F) dev.off() # need if statement or else error will occur due to no device being present to close

  ##### simulate with max intitial richness####
  burnin <- 100 # number of genrations for burn in
  generations <- 100 # number of generation after burn in
  
  speciation_rate <- 0.1 # speciation rate
  # community <- init_community_max(100) # define the community as having maximum richness for a community of 100 individuals
  # 
  generations <- 200 # number of generation after burn in
  
  MaxSims <- multi_calc_rich(sim_num = 30, burnin = burnin, speciation_rate = 0.1, community = init_community_max(100), generations= generations)
  MinSims <- multi_calc_rich(sim_num = 30, burnin = burnin, speciation_rate = 0.1, community = init_community_min(100), generations= generations)
  
  ## make vectors to store mean richness of simulation at each generation
  MaxMean <- rep(NA, ncol(MaxSims))
  MinMean <- rep(NA, ncol(MinSims))
  
  # loop and calculate means for max and min
  for(i in 1:length(MaxMean)) MaxMean[i] <- mean(MaxSims[,i])
  for(i in 1:length(MinMean)) MinMean[i] <- mean(MinSims[,i])
  
  ##### 97.5 CI #######
  
  # error <- qnorm(0.975)*s/sqrt(n)
  
  errorMax <- rep(NA, ncol(MaxSims))  # the deviation of MaxSims
  for(i in 1:ncol(MaxSims)) errorMax[i] <- qnorm(0.972)*(sd(MaxSims[,i])/sqrt(nrow(MaxSims)))
  errorMaxUpper <- MaxMean + errorMax
  errorMaxLower <- MaxMean - errorMax
  
  errorMin <- rep(NA, ncol(MinSims))  # the deviation of MinSims
  for(i in 1:ncol(MinSims)) errorMin[i] <- qnorm(0.972)*(sd(MinSims[,i])/sqrt(nrow(MinSims)))
  errorMinUpper <- MinMean + errorMin
  errorMinLower <- MinMean - errorMin
  
  
  ##### Estimate min burnin time #####
  # take the highest value within the last 200 gens then find where the value starts to stay within the range for 50 gens, take that point as burnin finished.
  # should not matter if the max or min is taken as by the end of the sim they are at dynamic EQ
  upperLim <- max(tail(errorMinUpper, 200))
  lowerLim <- min(tail(errorMinUpper, 200))
  burninGens <- NA # gens needed for burnin
  for(i in 1:length(MinMean)){
    if (MinMean[i] < upperLim && MinMean[i] > lowerLim){#
      for(j in 1:50){
        if (MinMean[i+j] < upperLim && MinMean[i+j] > lowerLim){
        }
        else break()
      }
      burninGens <- i
      break
    }
  }
  
  ###### Plotting ######
  # plot colours
  maxRed <- rgb(1,0,0,alpha = 0.5)
  minBlue <- rgb(0,0,1,alpha = 0.5)
  
  
  # plot graph
  xPoints <- seq(burnin + generations) # x axis values
  plot(MaxMean, type = "l", xlab = "Generations", ylab = "Mean Species Richness", col = "red") # plot mean max initial richness from simulation
  polygon(c(xPoints, rev(xPoints)),c(errorMaxLower,rev(errorMaxUpper)), col = maxRed, border = FALSE) #plot the 97.5% CI for MaxMean
  lines(MinMean, col = "blue") # plot min richness 
  abline(v = burninGens)
  polygon(c(xPoints, rev(xPoints)),c(errorMinLower,rev(errorMinUpper)), col = minBlue, border = FALSE) #plot the 97.5% CI for MinMean
  legend("topright", legend = c("Initial Max Richness", "Initial Min Richness", paste("Generations to burnin:", burninGens)), col = c("red", "blue", "black"), lty = 1) # add a legend for the lines
  title("Challenge_A")
  
}

# Challenge question B
init_community <- function(size = 100, richness = NULL){
  ## a function to intialize a communtiy of a given richness and size
  ##### warnings/errors ####
  if (is.null(richness)) return("Please give a richness value")
  else if (richness > size) return("Richness cannot be greater than size")
  else{
    #### body####
    community <- rep(NA, size)
    
    vectStart <- sample(x = seq(1, richness), size = richness, replace = F) # vector of the first n entries of community where n is richness. sample so as to randomise the placement.
    
    community[1:richness] <- vectStart # assign `richness` sized entries to be each entry in vectStart.  ensures there is at least one member of each species to achieve the desired richness.
    community[(richness+1):size] <- sample(x = vectStart, size - richness, replace = T) # fill in the remaining entries by sampling with replacement from vectStart

  }
  return(community)
}

Challenge_B <- function(richVect = c(10, 25, 50, 75, 90), size = 100) {
  # Takes a vector of desired richnesses and a community size, returns a plot of the average of the different communities simulated 30 times.
  # clear any existing graphs and plot your graph within the R window
  if(is.null(dev.list()) == F) dev.off() # need if statement or else error will occur due to no device being present to close
 
  burnin = 60
  generations = 100
  simNum = 10 # number of simulations per community richness
  # here we generate the desired richness and plot
  richMeans <- matrix(NA, nrow = length(richVect), ncol = burnin + generations)
  
  
  for (i in 1:length(richVect)){
    
    richness <- richVect[i]
    community <- init_community(size = size, richness = richVect[i])
    richSims <- multi_calc_rich(sim_num = simNum, community = community, burnin = burnin, generations = generations, speciation_rate = 0.005502)
    
    runMean <- rep(NA, ncol(richSims))  
    for(j in 1:length(runMean)) runMean[j] <- mean(richSims[,j])
    richMeans[i,] <- runMean
    
  }
  
  
  ####plotting####
  colourPallet <- c("#000000", "#E69F00", "#0072B2", "#CC79A7", "#009E73")## a few values from a colour blind colour pallete
  # colourPallet <- c("red", "black", "green", "aquamarine1", "blue")
  
  
  plot(x = rep(0, burnin+generations), y = rep(0, burnin+generations), ylim = c(0, max(richVect)*1.1), xlim = c(0, burnin+generations+10), type = "l", xlab = "Generations", ylab = "Richness")
  for(i in 1:length(richVect)){
    
    lines(x = richMeans[i,], col = colourPallet[i])
    
  }
  legend("topright", legend = richVect, col = colourPallet, lty = 1, title = "Initial Community Richness") # add a legend for the lines
  title("Challenge_B")
  
  
  
}

# Challenge question C
calc_burnin_gens <- function(meanVector, len = length(meanVector)){
  # takes a vector of means and retuns when burnin should have stoped
  # logic: take the highest value within the last 10% of gens then find where the value starts to stay within the range for 200 gens, take that point as burnin finished.
  end <- tail(meanVector, len * .1) # a tail to get range of values during dynamic equilibrium
  endMax <- max(end) # get min and max to have the range
  endMin <- min(end)
  
  burninGens <- NA # gens needed for burnin
  for(i in 1:length(meanVector)){
    if (meanVector[i] < endMax && meanVector[i] > endMin){#
      for(j in 1:200){
        if (meanVector[i+j] < endMax && meanVector[i+j] > endMin){
        }
        else break()
      }
      burninGens <- i
      break
    }
  }
  
  return(burninGens)
}

Challenge_C <- function(filePrefix = "Cluster_Run_output", numFiles = length(list.files(pattern = paste(filePrefix, "*", sep = '')))) {
  
  # clear any existing graphs and plot your graph within the R window
  if(is.null(dev.list()) == F) dev.off() # need if statement or else error will occur due to no device being present to close
  
  #### assign list to sum to ###
  sum500 <- c()
  sum1000 <- c()
  sum2500 <- c()
  sum5000 <- c()
  
  ## counter for finding the average later
  counter500 <- 0
  counter1000 <- 0
  counter2500 <- 0
  counter5000 <- 0
  
  
  
  
  for(i in 1:numFiles){ # loop through files and remove the burn in generations before stroing the average octave of each `size` of population.
    
    
    
    load(paste(filePrefix, i, ".rda", sep = '')) # load file
    
    ## Temporary to construct a vector of the richness over generations in
    richVect <- rep(0, burn_in_generations)
    
    
    ## Depending on `size` used when running the file save it to a corresponding list
    if(size == 500){
      # list500[[length(list500)+1]] <- c(richList)
      for(j in 1:length(richList)){
        richVect[j] <- richList[[j]]
      }
      sum500 <- sum_vect(sum500, richVect)
      counter500 <- counter500 + 1
    }
    if(size == 1000){
      # list1000[[length(list1000)+1]] <- c(richList)
      for(j in 1:length(richList)){
        richVect[j] <- richList[[j]]
      }
      sum1000 <- sum_vect(sum1000, richVect)
      counter1000 <- counter1000 + 1
    }
    
    if(size == 2500){
      # list2500[[length(list2500)+1]] <- c(richList)
      for(j in 1:length(richList)){
        richVect[j] <- richList[[j]]
      }

      sum2500 <- sum_vect(sum2500, richVect)
      counter2500 <- counter2500 + 1
    }
    
    if(size == 5000){
      # list5000[[length(list5000)+1]] <- c(richList)
      for(j in 1:length(richList)){
        richVect[j] <- richList[[j]]
      }
      sum5000 <- sum_vect(sum5000, richVect)
      counter5000 <- counter5000 + 1
    }
    
    
  }
  
  
  # average each size
  mean500 <- sum500 / counter500
  mean1000 <- sum1000 / counter1000
  mean2500 <- sum2500 / counter2500
  mean5000 <- sum5000 / counter5000
  
  
  ####Calc when how long burnin really needed to run####
  
  burninTime500 <- calc_burnin_gens(mean500)
  burninTime1000 <- calc_burnin_gens(mean1000)
  burninTime2500 <- calc_burnin_gens(mean2500)
  burninTime5000 <- calc_burnin_gens(mean5000)
  
  
  
  
  combined_results <- list(mean500, mean1000, mean2500, mean5000) #create your list output here to return
  ## Plotting
  ylabel <- "Mean Species Richness"
  xlabel <- "Generations, Burnin Gens:"
  par(mfrow = c(2,2))
  plot(mean500, main = "Mean Richness, Size = 500", xlab = paste(xlabel, burninTime500), ylab = ylabel, ylim =c(0, max(mean500)+1), type = "l")
  abline(v = burninTime500, col ="red") # include burnin gens line
  plot(mean1000, main = "Mean Richness, Size = 1000", xlab = paste(xlabel, burninTime1000), ylab = "", ylim =c(0, max(mean1000)+1), type = "l")
  abline(v = burninTime1000, col ="red") # include burnin gens line
  plot(mean2500, main = "Mean Richness, Size = 2500", xlab = paste(xlabel, burninTime2500), ylab = ylabel, ylim =c(0, max(mean2500)+1), type = "l")
  abline(v = burninTime2500, col ="red") # include burnin gens line
  plot(mean5000, main = "Mean Richness, Size = 5000", xlab = paste(xlabel, burninTime5000), ylab = "", ylim =c(0, max(mean5000)+5), type = "l")
  abline(v = burninTime5000, col ="red") # include burnin gens line
  
  
  avgRichList <- list(mean500, mean1000, mean2500, mean5000)
  names(avgRichList) <- c("rich500", "rich1000", "rich2500", "rich5000")
  return(avgRichList)
  
}



# Challenge question D

calc_avg_octave <- function(size = 1000, reps = 100){
  #calculate the average octave produced with a coalescence model of size n, repeasted `reps` times.
  
  v <- 0.005502 # speciation rate (personal one from the top)
  
  sumOctave <- c() # blank vecto to store sum of octaves
  
  counter <- 0 # counter for calculating mean later (records how many entries are summed in sumOctave)
  
  for (i in 1:reps){      # loop to produce many octave results
    
    lineages <- rep(1, size)
    
    abundances <- c()
    
    N <- size
    
    theta <- v * ((N-1) / (1-v))
    
    # choose runif from 1 - 0 multiplied by the len, i.e. pick a position a certain % along the vector,  then ceiling for index, use ceiling to account for less than one ans that rounds to 0
    while(N >1){
      index <- ceiling(N * (runif(n = 1, min = 0, max = 1)))  #part e
      
      randnum <- runif(n = 1, min = 0, max = 1)
      
      threshold <- theta / (theta + N -1) # threshold for following if statements to decide what to do
      
      if (randnum < threshold) abundances <- append(abundances, lineages[index])
      
      if (randnum >= threshold) {
        index2 <- ceiling(N * (runif(n = 1, min = 0, max = 1)))
        while (index2 == index) index2 <- ceiling(N * (runif(n = 1, min = 0, max = 1))) # to ensure index and index2 never match
        
        lineages[index2] <- lineages[index2] + lineages[index]
      }
      lineages <- lineages[-index] # remove the jth entry
      
      N <- N - 1 # decrease the size to reflect the new size#
    }
    
    abundances <- append(abundances, lineages) # add the only remaining result to abundances
    sumOctave <- sum_vect(sumOctave, octaves(abundances))
    counter <- counter + 1
    
  }
  return(sumOctave/counter)
}

Challenge_D <- function() {
  # clear any existing graphs and plot your graph within the R window
  if(is.null(dev.list()) == F) dev.off() # need if statement or else error will occur due to no device being present to close

  reps <- 500
  
  mean500 <- calc_avg_octave(size = 500, reps = reps)
  mean1000 <- calc_avg_octave(size = 1000, reps = reps)
  # mean2500 <- calc_avg_octave(size = 2500, reps = reps)
  # mean5000 <- calc_avg_octave(size = 5000, reps = reps)

  
  ######Comparison with cluster results######  used for answer below
  # cat("Time to calculate average octave for community size 500 with coalescence model ")
  # cat(system.time(calc_avg_octave(size = 500, reps = 25))[3])
  # print("")
  
  
  ##Plotting##
  clusterRes <- process_cluster_results()
  graphics.off()
  par(mfrow = c(2,2))
  ylabel <- "Species Abundance"
  xlabel <- "Octave Bins"
  barplot(mean500, main = "Coalescence, Size = 500", xlab = xlabel, ylab = ylabel, ylim =c(0, max(mean500)+1))
  barplot(mean1000, main = "Coalescence, Size = 1000", xlab = xlabel, ylab = "", ylim =c(0, max(mean1000)+1))
  
  barplot(clusterRes$mean500, main = "Cluster, Size = 500", xlab = xlabel, ylab = ylabel, ylim =c(0, max(clusterRes$mean500)+1))
  barplot(clusterRes$mean1000, main = "Cluster, Size = 1000", xlab = xlabel, ylab = "", ylim =c(0, max(clusterRes$mean1000)+1))
 
  

  
  return("25 runs of community size 500 takes ~0.137 seconds.  The cluster run took 11.5 hours to produce the results used for each run, i.e.287.5 CPU hours for 25 runs.  The coalescence simulations were quicker because as the simulation only need to run for as many 'generations' as there are members in the observed population.  Meanwhile the cluster simulations ran for as long as was decided by the user to get and maintain dynamic equilibrium for an amount of time that was deemed to generate enough samples, in this case 11.5 hours (excluding burnin time for the data we used when graphing the results")
}

# Challenge question E
new_startin_coords <- function(repeats = 100000){
  ####function to see what happens when the starting coordinates for `chaos_game` are changed
  
  A <- c(0,0)
  B <- c(3,4)
  C <- c(4,1)
  
  
  # list of points ABC for sampling from when deciding which to direction to jump
  ABClist <- list(A, B, C)
  
  X <- c(5,1) # point to initially jump from
  
  Xstore <- matrix(NA, nrow = repeats, ncol = 2) # list to store where X jumps during the simulation
  first100 <- matrix(NA, nrow = 100, ncol = 2) # matrix to store and look at first 100 results
  
  
  for(i in 1:repeats){
    choice <- unlist(sample(c(ABClist),1)) # randomly choose to jump towards A, B or C
    X <- (X + choice)/2    # X <- X + (choice/2)
    
    if ( i < 100) first100[i,] <- X
    Xstore[i,] <- X # store the value of X
  }
  
  # plot the results of the loop above
  plot(c(0,0), cex = 0.000001, pch = 8,xlim = c(0, max(Xstore)), ylim = c(0, max(Xstore)), main = "New Starting Point", axes = F, xlab = "", ylab = "") # define the starting value of `X` manually as (0,0)
  points(Xstore, cex = 0.000001, pch = 8)
  points(first100, cex = 1, pch = 2, col = "red")
}


sierpinski <- function(repeats = 100000){
  # a function to draw a sierpinski gasket
  
  A <- c(0,0)
  B <- c(1.5,3)
  C <- c(3,0)
  
  
  # list of points ABC for sampling from when deciding which to direction to jump
  ABClist <- list(A, B, C)
  
  X <- c(1.5, 1.5) # point to initially jump from
  
  Xstore <- matrix(NA, nrow = repeats, ncol = 2) # list to store where X jumps during the simulation

  
  for(i in 1:repeats){
    choice <- unlist(sample(c(ABClist),1)) # randomly choose to jump towards A, B or C
    X <- (X + choice)/2    # X <- X + (choice/2)
    
    Xstore[i,] <- X # store the value of X
  }
  
  # plot the results of the loop above
  plot(c(0,0), cex = 0.000001, pch = 8,xlim = c(0, max(Xstore)), ylim = c(0, max(Xstore)), main = "Sierpinski Gasket", axes = F, xlab = "", ylab = "") # define the starting value of `X` manually as (0,0)
  points(Xstore, cex = 0.000001, pch = 8)
  
}

five_points <- function(repeats = 100000){
  # a function to produce a shape in the same manner as `choas_game`, but with 5 points
  
  A <- c(550, 450)
  B <- c(455, 519)
  C <- c(491, 631)
  D <- c(609, 631)
  E <- c(645, 519)
  
  pointList <- list(A, B, C, D, E)
  
  X <- c(500, 500)
  
  Xstore <- matrix(NA, nrow = repeats, ncol = 2) # list to store where X jumps during the simulation
  
  
  for(i in 1:repeats){
    choice <- unlist(sample(c(pointList),1)) # randomly choose to jump towards A, B or C
    X <- (X + choice)/2    # X <- X + (choice/2)
    
    Xstore[i,] <- X # store the value of X
  }
  
  # plot the results of the loop above
  plot(c(0,0), cex = 0.00000000001, pch = 8,xlim = c(450, 650), ylim = c(440, 650), main = "5 point plot", axes = F, xlab = "", ylab = "") # define the starting value of `X` manually as (0,0)
  points(Xstore, cex = 0.000000001, pch = 8)
}


Challenge_E <- function() {
  # clear any existing graphs and plot your graph within the R window
  if(is.null(dev.list()) == F) dev.off() # need if statement or else error will occur due to no device being present to close
  par(mfrow = c(2,2))
  new_startin_coords()
  sierpinski()
  five_points()
  
  
  return("When the starting position is changed the points will initially shoot outside the 'bounds' of ABC, but eventially return inside and slowly return to the same patter as the initial starting point used in `chaos_game`.  This is because as the simulation runs and the distance of the 'jumps' is decreased more and more, the affects of the starting value decrease.  This results in the final pattern produced not being hugely different.")
}

# Challenge question F
green_red_turtle <- function(start_position, direction, length)  {# funtion to find the endpoint of a line `length` units away from a point `start_position` in a `direction`.  the `direction` needs to be between 0 and pi/2
  
  xDist <- length * cos(direction)# distance along x axis between start and endpoint
  yDist <- length * sin(direction)# distance along y axis between start and endpoint
  
  
  endpoint <- c(start_position[1] + xDist, start_position[2] + yDist) # define the endpoint as the start point plus the distances traveled to reach a point `length` units away from `startpoint`.
  
  ## to shift colours as the plot progresses
  
  if (length > 0.1) segColour <- "chocolate4" # set "branch to brown
  else segColour <- "chartreuse3" # set leaves to green
  if (length < .015) segColour <- "red2" # "flowers"
  segments(x0 = start_position[1],y0 = start_position[2] , x1 = endpoint[1], y1 = endpoint[2], col = segColour)
  
  return(endpoint) # you should return your endpoint here.
}
curly_fern <- function(start_position, direction, length, dir)  {
  # plots a curly fern
  if(length > 0.01){
    
    midpoint <- green_red_turtle(start_position = start_position, direction = direction, length = length)
    
    curly_fern(start_position = midpoint, direction = (direction + pi/4 *dir), length = 0.38 * length, dir = dir)
    
    curly_fern(start_position = midpoint, direction = direction + pi/8, length = 0.87 * length, dir = -dir)
  }  
  
}
curly_fern2 <- function(start_position, direction, length, dir, checkpoint = 1, initialLen = 1)  {
  # plots a curly fern bifurcating, currently not ideally what I wanted.
  if(length > 0.01){
    
    midpoint <- green_red_turtle(start_position = start_position, direction = direction, length = length)
    if (checkpoint == 1)
    curly_fern2(start_position = midpoint, direction = (direction + pi/4 *dir), length = 0.38 * length, dir = dir, initialLen)
    curly_fern2(start_position = midpoint, direction = direction + pi/8, length = 0.87 * length, dir = -dir, initialLen)
    if (length == initialLen) checkpoint <- 0
    if (checkpoint == 0){
      curly_fern2(start_position = midpoint, direction = (direction + pi/4 *dir), length = 0.38 * length, dir = dir, initialLen, checkpoint = 0)
      curly_fern2(start_position = midpoint, direction = direction - pi/8, length = 0.87 * length, dir = -dir, initialLen, checkpoint = 0)
    }
  }  
  
}

challenge_fern2 <- function(start_position, direction, length, dir)  {
  # plots the same as fern2 but uses colours
  if(length > 0.01){
    
    midpoint <- green_red_turtle(start_position = start_position, direction = direction, length = length)
    
    challenge_fern2(start_position = midpoint, direction = (direction + pi/4 *dir), length = 0.38 * length, dir = dir)
    
    challenge_fern2(start_position = midpoint, direction = direction, length = 0.87 * length, dir = -dir)
  }  
  
}

challenge_fern2 <- function(start_position, direction, length, dir)  {
  # plots the same as fern2 but uses colours
  if(length > 0.01){
    
    midpoint <- green_red_turtle(start_position = start_position, direction = direction, length = length)
    
    challenge_fern2(start_position = midpoint, direction = (direction + pi/4 *dir), length = 0.38 * length, dir = dir)
    
    challenge_fern2(start_position = midpoint, direction = direction, length = 0.87 * length, dir = -dir)
  }  
  
}

irish_turtle <- function(start_position, direction, length)  {# funtion to find the endpoint of a line `length` units away from a point `start_position` in a `direction`.  the `direction` needs to be between 0 and pi/2
  
  xDist <- length * cos(direction)# distance along x axis between start and endpoint
  yDist <- length * sin(direction)# distance along y axis between start and endpoint
  
  
  endpoint <- c(start_position[1] + xDist, start_position[2] + yDist) # define the endpoint as the start point plus the distances traveled to reach a point `length` units away from `startpoint`.
  
  ## to shift colours as the plot progresses
  
  if (start_position[1] < 3.5) segColour <- "chartreuse3" # left side
  else segColour <- "white" # middle
  if (start_position[1] > 4.5) segColour <- "orange" # right
  segments(x0 = start_position[1],y0 = start_position[2] , x1 = endpoint[1], y1 = endpoint[2], col = segColour)
  
  return(endpoint) # you should return your endpoint here.
}
irish_fern <- function(start_position, direction, length, dir)  {
  # plots the same as fern2 but uses colours
  if(length > 0.01){
    
    midpoint <- irish_turtle(start_position = start_position, direction = direction, length = length)
    
    irish_fern(start_position = midpoint, direction = (direction + pi/4 *dir), length = 0.38 * length, dir = dir)
    
    irish_fern(start_position = midpoint, direction = direction, length = 0.87 * length, dir = -dir)
  }  
  
}

Challenge_F <- function(start_position = c(4,0), direction = pi/2, length = 1) {
  # clear any existing graphs and plot your graph within the R window
  if(is.null(dev.list()) == F) dev.off() # need if statement or else error will occur due to no device being present to close
  par(mfrow = c(2,2))
  plot(start_position, cex = 0.000001, xlim = c(0, 8), ylim = c(0, 8), ylab = "", xlab = "", col = "white")
  challenge_fern2(start_position = start_position, direction = direction, length = length, dir = 1)
  plot(start_position, cex = 0.000001, xlim = c(0, 4), ylim = c(0, 4), ylab = "", xlab = "", col = "white")
  curly_fern(start_position = start_position, direction = direction, length = length, dir = 1)
  plot(start_position, cex = 0.000001, xlim = c(0, 8), ylim = c(0, 8), ylab = "", xlab = "", col = "white")
  rect(xleft = 0, xright = 8, ytop = 8, ybottom = 0, col = "black")
  irish_fern(start_position = start_position, direction = direction, length = length, dir = 1)
  plot(start_position, cex = 0.000001, xlim = c(0, 8), ylim = c(0, 8), ylab = "", xlab = "", col = "white")
  curly_fern2(start_position = start_position, direction = direction, length = length, dir = 1, initialLen = length)
  
  
  return("As the line  threshold shrinks the time to run the function increases.  Additionally, the image produced becomes 'bushier', i.e. there are much more 'leaves' produced due to the fractal being able to branch at much smaller intervals.")
}

# Challenge question G should be written in a separate file that has no dependencies on any functions here.


# To produce db319_cluster_results.rda
# load("Cluster_Run_output1.rda")
# richList <- Challenge_C()
# graphics.off()
# octList <- process_cluster_results()
# graphics.off()
# sizes <- c(500, 1000, 2500, 5000)
# save(file = "db319_cluster_results.rda", burn_in_generations, richList, octList, community, TotalTime, sizes, speciation_rate, interval_rich, interval_oct)








