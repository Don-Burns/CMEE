#!/bin/usr/env python3

# Desc:


def LV2(argv):
    ####Packages#####
    import scipy as sc
    import scipy.integrate as integrate
    import matplotlib.pylab as p 
    import sys

    #####Functions######
    def dCR_dt(pops, t = 0):
        """
        function find the change in consumers and resources at time, t.

        """
        R = pops[0]
        C = pops[1]
        dRdt = r * R * (1 - (R / K)) - a * R * C 
        dCdt = -z * C + e * a * R * C 

        return sc.array([dRdt, dCdt])



    ######Main#######


    if len(sys.argv) == 1:
        r = 1. 
        a = 0.1
        z = 1.5
        e = 0.75
        print("Using default arguments for r, a, z, e")
    
    elif len(sys.argv):
        print("Not enought arguments given.  Please give r, a, z and e")

    else:
        args = sys.argv
        r = float(args[1]) 
        a = float(args[2])
        z = float(args[3])
        e = float(args[4])
        print("Using args from user in order: r, a, z, e")







    K = 50 ## K arbitrarily defined
    t = sc.linspace(0, 15, 1000)


    R0 = 10
    C0 = 5
    RC0 = sc.array([R0, C0])

    pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output = True)


    ######plotting######
    p.ioff()
    f1 = p.figure()

    p.plot(t, pops[:, 0], "g-", label = "Resource density") #plot
    p.plot(t, pops[:, 1], "b-", label = "Consumer density")
    p.grid()
    p.legend(loc = "best")
    p.xlabel('Time')
    p.ylabel("Population density")
    p.suptitle("Consumer-Resource population dynamics")
    p.title("r={}, a={}, z={}, e={}, K={}".format(r,a,z,e,K))
    # p.show()
    f1.savefig('../Results/LV_model_LV2.pdf') #Save figure
                ##### Practical #####
    f2 = p.figure()
    p.plot(pops[:, 0], pops[:, 1], "r-")
    p.grid()
    p.xlabel("Resource density")
    p.ylabel("Consumer density")
    p.suptitle("Consumer-Resource population dynamics")
    p.title("r={}, a={}, z={}, e={}, K={}".format(r,a,z,e,K))
    # p.show()
    f2.savefig("../Results/LV_model2_LV2.pdf")
    print("r={}, a={}, z={}, e={}, K={}".format(r,a,z,e,K))
    return 0

if __name__ == "__main__": 
    """Makes sure the "main" function is called from command line"""  
    import sys 
    LV2(sys.argv)