birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

#(1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively. 

#latin names
latin = [bird[0] for bird in birds]
print(latin)

#Common Names
common = [bird[1] for bird in birds]
print(common)

#Body mass
mass = [bird[2] for bird in birds]
print(mass)
  
# (2) Now do the same using conventional loops (you can choose to do this 
# before 1 !). 

#pulls latin names
latin = []

for bird in birds:
    latin.append(bird[0])
print(latin)

#pulls common names
common = []

for bird in birds:
    common.append(bird[1])
print(common)

#pulls body mass
mass = []

for bird in birds:
    mass.append(bird[2])
print(mass)