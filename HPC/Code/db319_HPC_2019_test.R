# CMEE 2019 HPC excercises R code HPC run code proforma

rm(list=ls()) # good practice 
source("db319_HPC_2019_main.R")
# it should take a faction of a second to source your file
# if it takes longer you're using the main file to do actual simulations
# it should be used only for defining functions that will be useful for your cluster run and which will be marked automatically

# do what you like here to test your functions (this won't be marked)
# for example
species_richness(c(1,4,4,5,1,6,1))
# should return 4 when you've written the function correctly for question 1

# you may also like to use this file for playing around and debugging
# but please make sure it's all tidied up by the time it's made its way into the main.R file or other files.

# Q1
species_richness(c(1,4,4,5,1,6,1))

# Q2
init_community_max(7)

# Q3
init_community_min(4)

# Q4
choose_two(4)

# Q5
neutral_step(c(10, 5, 13))

# Q6
neutral_generation(c(10, 5, 13))

# Q7
neutral_time_series(community = init_community_max(7), duration = 20)

# Q8
question_8()

# Q9
neutral_step_speciation(c(1,2,3,4,56), 0.2)

# Q10
neutral_generation_speciation(c(1,2,3,4,5,66,77,44), 100)

# Q11
neutral_time_series_speciation(community = c(1,2,3,4,5,66,77,44), speciation_rate = 0.2, duration = 100)

# Q12
question_12()

# Q13
species_abundance(c(1,5,3,6,5,6,1,1))

# Q14
octaves(c(100, 64, 63, 5, 4, 3, 2, 2, 1, 1, 1, 1))

# Q15
sum_vect(x = c(1,2,23,4,5), y = c(1,2,3))

# Q16
question_16()

# Q17
cluster_run(speciation_rate = 0.005502, size = 500, wall_time = 1, interval_rich = 1, interval_oct = 10, burn_in_generations = 200, output_file_name = "my_test_file_1.rda")

# Q18


# Q19


# Q20
process_cluster_results()

# Q21
question_21()

# Q22
question_22()

# Q23
chaos_game()

# Q24
plot(x = 4 , y = 2, ylim = c(0, 10), xlim = c(0,10))
turtle(start_position = c(4,2), direction = pi/3, length = 5)

# Q25
plot(x = 4 , y = 2, ylim = c(0, 10), xlim = c(0,10))
elbow(start_position = c(4,2), direction = pi/10, length = 5)

# Q26
plot(x = 4 , y = 2, ylim = c(0, 10), xlim = c(0,10), cex = 0.0000000000000000000001)
spiral(start_position = c(4,2), direction = pi/4, length = 1)

# Q27
draw_spiral(start_position = c(4,2), direction = pi/4, length = 1)
 
# Q28
# tree(start_position = c(4,2), direction = pi/4, length = 1)
draw_tree(start_position = c(4,2), direction = pi/4, length = 1)

# Q29
draw_fern(start_position = c(4,0), direction = pi/2, length = 1)

# Q30
draw_fern2(start_position = c(4,0), direction = pi/2, length = 1)

# Challenge_A
Challenge_A()
# Challenge_B
Challenge_B()
# Challenge_C 
Challenge_C()
# Challenge_D
Challenge_D()
# Challenge_E
Challenge_E()
# Challenge_F
Challenge_F()





