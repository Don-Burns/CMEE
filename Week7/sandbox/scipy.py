#!bin/usr/env python3

## Desc: start of python II week
import scipy as sc
a = sc.array(range(5)) # a one-dimensional array
a
print(type(a))

print(type(a[0]))

a = sc.array(range(5), float)

a.dtype # check type

x = sc.arange(5.) # directly specify float using decimal 
x
x.shape

b = sc.array([i for i in range(10) if i % 2 == 1])
b

c = b.tolist() # convert back to list
c

mat = sc.array([[0, 1], [2, 3]])
mat

mat.shape

mat[1]

mat[:,1]

mat[0,0]
mat[1,0]
mat[0, 1]
mat[0, -1]
mat[1, -1]
mat[0, -2]
mat[0,0] = -1 # replace a single element
mat[:,0] = [12, 12]
mat

sc.append(mat, [[12, 12]], axis = 0)# append row, note axis specification
sc.append(mat, [[12],[12]], axis = 1) # append column

newRow = [[12, 12]] # create new row
mat = sc.append(mat, newRow, axis = 0) # append that existing row
mat
sc.delete(mat, 2, 0)

mat = sc.array([[0, 1], [2, 3]])
mat0 = sc.array([[0, 10], [-1, 3]])
sc.concatenate((mat, mat0), axis = 0)

mat.ravel() # NOTE: ravel is row priority - happens row by row
mat.reshape((4, 1))
# mat.reshape((3, 1))
sc.ones((4, 2)) # are the (row, col) array dimensions
sc.zeros((4, 2)) # or zero
m = sc.identity(4) # create an identity matrix
m

m.fill(16)
m


mm = sc.arange(16)
mm = mm.reshape(4, 4) # convert to matrix
mm

mm.transpose()
mm + mm.transpose()
mm - mm.transpose()
mm * mm.transpose()
mm // mm.transpose()
mm // (mm + 1).transpose()
mm * sc.pi
mm.dot(mm) # MATRIX MULTIPLICATION, OR DOT PRODUCT
mm = sc.matrix(mm)
mm
print(type(mm))
mm * mm


import scipy.stats
scipy.stats.norm.rvs(size = 10) # 10 samples from N(0, 1)
scipy.stats.randint.rvs(0, 10, size = 7) # Random intergers betweeen 0 and 10






import scipy.integrate as integrate

def dCR_dt(pops, t = 0):
    R = pops[0]
    C = pops[1]
    dRdt = r * R - a * R * c
    dCdt = -z * C + e * a * R * C 

    return sc.array([dRdt, dCdt])

type(dCR_dt)

r = 1. 
a = 0.1
z = 1.5
e = 0.75

t = sc.linspace(0, 15, 1000)


R0 = 10
C0 = 5
RC0 = sc.array([R0, C0])

pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output = T)

pops

type(infodict)

infodict["message"]


####plotting in python###


import matplotlib.pylab as p 
f1 = p.figure

p.plot(t, pops[:, 0], "g-", label = "Resource density") #plot
p.plot(t, pops[:, 1], "b-", label = "Consumer density")
p.grid()
p.legend(loc = "best")
p.xlabel('Time')
p.ylabel("Population density")
p.title("Consumer-Resource population dynamics")
p.show()
f1.savefig("../Results/LV_model.pdf")





