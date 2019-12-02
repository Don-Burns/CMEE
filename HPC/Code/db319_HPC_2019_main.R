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
  # Will use `neutral_step_speciation` to simulate the death and either reporduction or mutaiton of individuals over a generation where generation length = number of individuals / 2.
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
  
  barplot(averageOctaves, xlab = "Bins", ylab = "Species Abundance", names.arg = seq(1, length(averageOctaves))) # plot the mean as a barplot
  
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
      if(generation %% interval_rich == 0) richList[[length(richList)+1]] <-  c(species_richness(community)) #if the richness interval is reached append the richness to `richVect`
    }
    
    if(generation %% interval_oct == 0) octList[[length(octList)+1]] <- c(octaves(species_abundance(community))) #if the octaves interval is reached append the octave to `octVect`
    
    
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
  ## Plotting
  ylabel <- "Species Abundance"
  xlabel <- "Octave Bins"
  par(mfrow = c(2,2))
  barplot(mean500, main = "Mean Octaves, Size = 500", xlab = xlabel, ylab = ylabel, ylim =c(0, max(mean500)+1))
  barplot(mean1000, main = "Mean Octaves, Size = 1000", xlab = xlabel, ylab = ylabel, ylim =c(0, max(mean1000)+1))
  barplot(mean2500, main = "Mean Octaves, Size = 2500", xlab = xlabel, ylab = ylabel, ylim =c(0, max(mean2500)+1))
  barplot(mean5000, mean = "Mean Octaves, Size = 5000", xlab = xlabel, ylab = ylabel, ylim =c(0, max(mean5000)+5))


  
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
  plot(c(0,0), cex = 0.000001, pch = 8,xlim = c(0, max(Xstore)), ylim = c(0, max(Xstore))) # define the starting value of `X` manually as (0,0)
  points(Xstore, cex = 0.000001, pch = 8)
  
  return("What is returned is a series of points which draw one triangle with a triangle of black space enclosed inside, this reapeats producing increasingly smaller versions of the original pattern.  In other words a sierpinski gasket.")
}

# Question 24
turtle <- function(start_position, direction, length)  {# funtion to find the endpoint of a line `length` units away from a point `start_position` in a `direction`.  the `direction` needs to be between 0 and pi/2

  xDist <- length * cos(direction)# distance along x axis between start and endpoint
  yDist <- length * sin(direction)# distance along y axis between start and endpoint

  
  endpoint <- c(start_position[1] + xDist, start_position[2] + yDist) # define the endpoint as the start point plus the distances traveled to reach a point `length` units away from `startpoint`.
  segments(x0 = start_position[1],y0 = start_position[2] , x1 = endpoint[1], y1 = endpoint[2])
  
  return(endpoint) # you should return your endpoint here.
}

# Question 25
elbow <- function(start_position, direction, length)  {
  
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
spiral <- function(start_position, direction, length)  {
  
  if(length > 0.01){
  
  midpoint <- turtle(start_position = start_position, direction = direction, length = length)
  
  spiral(start_position = midpoint, direction = direction - pi/4, length = 0.95 * length)
  }  
  

  
  return("The code loops infinitly by calling itself over and over.  This results in a spiral made of many line segments where the direction shifts by pi/4 and each line segment is 95% the length of the previous.  In this code specifically this will continue as long as the length of a line segment is over 0.00001 units.")
}

# Question 27
draw_spiral <- function(start_position, direction, length)  {
  # clear any existing graphs and plot your graph within the R window
  if(is.null(dev.list()) == F) dev.off() # need if statement or else error will occur due to no device being present to close
  
  
  plot(start_position, cex = 0.000001, xlim = c(start_position[1]-2.3*length, start_position[1]+2.3*length), ylim = c(start_position[2]-2.3*length, start_position[2]+2.3*length))
  
  
  return(spiral(start_position = start_position, direction = direction, length = length))
  
}

# Question 28
tree <- function(start_position, direction, length)  {
 
   if(length > 0.01){
    
    midpoint <- turtle(start_position = start_position, direction = direction, length = length)
    
    tree(start_position = midpoint, direction = direction - pi/4, length = 0.65 * length)
    
    tree(start_position = midpoint, direction = direction + pi/4, length = 0.65 * length)
  }  
  
}
draw_tree <- function(start_position, direction, length)  {
  # clear any existing graphs and plot your graph within the R window
  if(is.null(dev.list()) == F) dev.off() # need if statement or else error will occur due to no device being present to close
  
  
  plot(start_position, cex = 0.000001, xlim = c(start_position[1]-2.3*length, start_position[1]+2.3*length), ylim = c(start_position[2]-2.3*length, start_position[2]+2.3*length))
  
  
  return(tree(start_position = start_position, direction = direction, length = length))
  }

# Question 29
fern <- function(start_position, direction, length)  {
  
  if(length > 0.01){
    
    midpoint <- turtle(start_position = start_position, direction = direction, length = length)
    
    fern(start_position = midpoint, direction = direction + pi/4, length = 0.38 * length)
    
    fern(start_position = midpoint, direction = direction, length = 0.87 * length)
  }  
  
  
}
draw_fern <- function(start_position, direction, length)  {
  # clear any existing graphs and plot your graph within the R window
  if(is.null(dev.list()) == F) dev.off() # need if statement or else error will occur due to no device being present to close
  
  plot(start_position, cex = 0.000001, xlim = c(0, 8), ylim = c(0, 8))
  
  return(fern(start_position = start_position, direction = direction, length = length))
}

# Question 30
fern2 <- function(start_position, direction, length, dir)  {
  if(length > 0.0001){
    
    midpoint <- turtle(start_position = start_position, direction = direction, length = length)
    
    fern2(start_position = midpoint, direction = (direction + pi/4), length = 0.38 * length, dir = -dir)
    
    fern2(start_position = midpoint, direction = direction, length = 0.87 * length, dir = -dir)
  }  
  
}
draw_fern2 <- function(start_position, direction, length)  {
  # clear any existing graphs and plot your graph within the R window
  if(is.null(dev.list()) == F) dev.off() # need if statement or else error will occur due to no device being present to close
  
  plot(start_position, cex = 0.000001, xlim = c(0, 8), ylim = c(0, 8))
  
  return(fern2(start_position = start_position, direction = direction, length = length, dir = 1))
}

# Challenge questions - these are optional, substantially harder, and a maximum of 16% is available for doing them.  

# Challenge question A
Challenge_A <- function() {
  # clear any existing graphs and plot your graph within the R window
}

# Challenge question B
Challenge_B <- function() {
  # clear any existing graphs and plot your graph within the R window
}

# Challenge question C
Challenge_C <- function() {
  # clear any existing graphs and plot your graph within the R window
}

# Challenge question D
Challenge_D <- function() {
  # clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Challenge question E
Challenge_E <- function() {
  # clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Challenge question F
Challenge_F <- function() {
  # clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Challenge question G should be written in a separate file that has no dependencies on any functions here.


