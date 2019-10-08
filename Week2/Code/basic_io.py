
###########################
# FILE INPUT
###########################
# Open a file for reading
f = open('../sandbox/test.txt', 'r')
#use "implicit" for loop:
#if the object is a file, python will cycle over lines
for line in f:
    print(line)

#  close the file 
f.close()

# Same example, skip the blank lines
f = open('../sandbox/test.txt', 'r')
for line in f:
    if len(line.strip()) > 0:
        print(line)

f.close()

#######################
# STORING OBJECTS
#######################
# To save an object (even complex) for alter use 
my_dictionary = {"a key": 10, "another key": 11}

import pickle
f = open('../sandbox/testp.p','wb') # note the b: accept binary
pickle.dump(my_dictionary, f)

## Laod the data again
f = open('../sandbox/testp.p', 'rb')
another_dictionary = pickle.load(f)
f.close

print(another_dictionary)