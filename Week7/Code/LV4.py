#!/bin/usr/env python3

# Desc: Discrete-time version of `LV2.py`, with variation in Resources


def LV4(argv):
    ####Packages#####
    import scipy as sc
    import scipy.stats as stats
    import scipy.integrate as integrate
    import matplotlib.pylab as p 
    import sys

    #####Functions######
    def dCR_dt(pops, t = 0):
        """
        function find the change in consumers and resources at time, t, in discrete time.
        """
        R = pops[0]
        C = pops[1]
        Rt1 = sc.zeros(len(t))
        Ct1 = sc.zeros(len(t))

        for i in range(len(t)):
            if i == 0: # for first iteration
                Rt1[i] = R * (1 + r * (1 - (R/K) - a * C))
                Ct1[i] = C * (1 - z + (e * a * R)) 
            else: ## every subsequent iteration
                Rt1[i] = Rt1[i-1] * (1 + (r+E) * (1 - (Rt1[i-1]/K) - a * Ct1[i-1]))
                Ct1[i] = Ct1[i-1] * (1 - z + (e * a * Rt1[i-1])) 
                

                ### if values reach or exceed 0, stop
                if Rt1[i] <= 0:
                    break
                
                if Ct1[i] <= 0:
                    break


        # Rt1 = Rt1[~sc.isnan(Rt1)] # the ~ cause return True only on valid numbers (https://stackoverflow.com/questions/11620914/removing-nan-values-from-an-array)
        # Ct1 = Ct1[~sc.isnan(Ct1)]
        # return sc.array([Rt1.tolist(), Ct1.tolist()])        
        return sc.array([Rt1, Ct1])



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







    K = 30 ## K arbitrarily defined
    t = sc.linspace(0, 15, 1000)
    E = stats.norm.rvs(1, size = 1) #random gaussian fluctuation

    R0 = 10
    C0 = 5
    RC0 = sc.array([R0, C0])

    pops = dCR_dt(RC0, t)

    print(len(pops[1]))



    ######plotting######
    p.ioff()
    f1 = p.figure()

    p.plot(t, pops[0], "g-", label = "Resource density") #plot
    p.plot(t, pops[1], "b-", label = "Consumer density")
    # p.xlim(0, 1)
    p.grid()
    p.legend(loc = "best")
    p.xlabel('Time')
    p.ylabel("Population density")
    p.suptitle("Consumer-Resource population dynamics")
    p.title("r={}, a={}, z={}, e={}, K={}".format(r,a,z,e,K))
    # p.show()
    f1.savefig('../Results/LV_model_LV4.pdf') #Save figure
                ##### Practical #####
    f2 = p.figure()
    p.plot(pops[0], pops[1], "r-")
    p.grid()
    p.xlabel("Resource density")
    p.ylabel("Consumer density")
    p.suptitle("Consumer-Resource population dynamics")
    p.title("r={}, a={}, z={}, e={}, K={}".format(r,a,z,e,K))
    # p.show()
    f2.savefig("../Results/LV_model2_LV4.pdf")
    print("r={}, a={}, z={}, e={}, K={}".format(r,a,z,e,K))
    return 0

if __name__ == "__main__": 
    """Makes sure the "main" function is called from command line"""  
    import sys 
    LV4(sys.argv)