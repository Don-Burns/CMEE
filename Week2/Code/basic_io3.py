
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