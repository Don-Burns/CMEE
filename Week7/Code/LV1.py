#!/bin/usr/env python3
# Desc: 
####Packages#####
def LV1():
    import scipy as sc
    import scipy.integrate as integrate
    import matplotlib.pylab as p 


    #####Functions######
    def dCR_dt(pops, t = 0):
        """
        function find the change in consumers and resources at time, t.
        """
        R = pops[0]
        C = pops[1]
        dRdt = r * R - a * R * C 
        dCdt = -z * C + e * a * R * C 

        return sc.array([dRdt, dCdt])



    ######Main#######

    type(dCR_dt)

    r = 1. 
    a = 0.1
    z = 1.5
    e = 0.75

    t = sc.linspace(0, 15, 1000)


    R0 = 10
    C0 = 5
    RC0 = sc.array([R0, C0])

    pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output = True)

    pops

    type(infodict)

    infodict["message"]

    ######plotting######
    p.ioff()

    f1 = p.figure()

    p.plot(t, pops[:, 0], "g-", label = "Resource density") #plot
    p.plot(t, pops[:, 1], "b-", label = "Consumer density")
    p.grid()
    p.legend(loc = "best")
    p.xlabel('Time')
    p.ylabel("Population density")
    p.title("Consumer-Resource population dynamics")
    # p.show()
    f1.savefig('../Results/LV_model.pdf') #Save figure
                ##### Practical #####
    f2 = p.figure()
    p.plot(pops[:, 0], pops[:, 1], "r-")
    p.grid()
    p.xlabel("Resource density")
    p.ylabel("Consumer density")
    p.title("Consumer-Resource population dynamics")
    # p.show()
    f2.savefig("../Results/LV_model2.pdf")
    return 0

if __name__ == "__main__": 
    """Makes sure the "main" function is called from command line"""  
    LV1()







