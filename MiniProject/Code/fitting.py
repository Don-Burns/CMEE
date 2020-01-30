## Desc: Script for fitting models to functional response data.
# Date: 21/11/2019

######Import Packages#######
import scipy as sc
import pandas as pd
import matplotlib.pyplot as plt
import lmfit
from scipy.optimize import curve_fit
from scipy import stats as stats
from math import log as log
from math import pi as pi
from numpy.polynomial import polynomial as polynomial
from matplotlib.backends.backend_pdf import PdfPages as PdfPages


#######FUNCTIONS############
def calc_C(Xr, a, h):
    """
    The equation for the type II functional response from Holling, 1959
    """
    top = a * Xr
    bot = 1 + (h * a * Xr)
    C = top / bot
    return C


def calc_Clmfit(params, Xr):  ## arbitrarily defined right now as 0.05
    """
    The equation for the more general Type II functional response curve.
    Need an argument params which is a dictionary containing the parameter values.
    This dictionary is made using lmfit.parameters().
    used for minimize.
    """
    vals = params.valuesdict()
    a = vals['a']
    h = vals['h']

    top = a * Xr
    bot = 1 + (h * a * Xr)
    C = top / bot
    return C


def calc_CQ(Xr, a, h, q=0.8):  ## arbitrarily defined right now as 0.8
    """
    The equation for the more general Type II functional response curve.  
    Includes a dimensionless parameter `q` which is used to account for a small lag phase at the start of the curve
    """
    top = a * (Xr ** (q + 1))
    bot = 1 + (h * a * (Xr ** (q + 1)))
    C = top / bot
    return C


def calc_CQlmfit(params, Xr):  ## arbitrarily defined right now as 0.05
    """
    The equation for the more general Type II functional response curve.
    Need an argument params which is a dictionary containing the parameter values.
    This dictionary is made using lmfit.parameters().
    Includes a dimensionless parameter `q` which is used to account for a small lag phase at the start of the curve.
    """
    vals = params.valuesdict()
    a = vals['a']
    h = vals['h']
    q = vals['q']

    top = a * Xr ** (q + 1)
    bot = 1 + (h * a * Xr ** (q + 1))
    C = top / bot
    return C


def calc_RSS(data2fitx, ModelFit, Model=calc_C, mode="NLS"):  ## model var is to specify which equation should be used. Model fit is popt under sc.optimize
    """
    Calculates the Residual Sum of Squares for a set of data given the model fit.  
    The equation used to fit the model can also be changed using the `Model` argument, default is the `calc_C` function.
    Can be used for both NLS and lm, specified with mode = "NLS" OR "lm".
    """
    diffList = []
    a = ModelFit[0]  # search rate
    h = ModelFit[1]  # handling time

    if mode == "NLS":
        for i in range(len(data2fitx)):
            # find diff between model and observed
            diffList.append(abs(Model(data2fitx[i], a, h) - data2fitx[i]) ** 2)
            # sum the values
            RSS = sum(diffList)

    if mode == "lm":
        for i in range(len(data2fitx)):
            # find diff between model and observed
            diffList.append(abs(Model(data2fitx[i], a, h) - data2fitx[i]) ** 2)
            # sum the values
            RSS = sum(diffList)

    return RSS


def pModel(coefficients):
    """Return number of parameters of a model when given a list of them."""
    return len(coefficients)


def calc_AIC(data2fit, n, Model_RSS, pModel):
    """
    Calculates the AIC value given the data (data2fit), number of samples (n), the RSS of the model (Model_RSS) and number of parameters in the model(pModel).
    """
    return n + 2 + n * log((2 * pi) / n) + n * log(Model_RSS) + 2 * pModel


def calc_BIC(data2fit, n, Model_RSS, pModel):
    """
    Calculates the BIC value given the data (data2fit), number of samples (n), the RSS of the model (Model_RSS) and number of parameters in the model(pModel).
    """
    return n + 2 + n * log(2 * pi / n) + n * log(RSS) + p * log(n)


def est_a(ResDens, NTrait, h):
    """
    Gets an estimate of `a` given the `ResDensity`, `N_TraitsValue` and `h` estimate.  Uses the arguments to progressively eliminate points to a minimum number of points to make a linear regression and takes the slope of the line as the estimate of `a`.  Minimum number of points is 3 or less than 30% of total data points.
    """
    best_a = None  # for recording the value of `a` which gave the lowest RSS value.
    smallest_RSS = None  # for recording the lowest RSS value.

    for i in range(len(ResDens), -1, -1):  ## loop backwards from len(ResDens)
        

        if len(ResDens[0:i]) < 3 or i < (0.3 * len(ResDens)):
            # print("less than 3 points")
            break
        # linear regression with ever shrinking data set from
        tmpRegress = stats.linregress(ResDens[0:i], NTrait[0:i])
        # parameters for this iteration, h is found beforehand. a is slope of the line
        paramEst = [tmpRegress[0], h]
        
        if smallest_RSS == None:  # i.e. first loop

            smallest_RSS = calc_RSS(ResDens[0:i], paramEst, Model=calc_CQ)
            smallest_a = tmpRegress[0]
            # import pdb; pdb.set_trace()

        # if RSS is smaller record
        elif calc_RSS(ResDens[0:i], paramEst, Model=calc_CQ) < smallest_RSS:

            if sc.isnan(tmpRegress[0]):  # skip if a becomes nan
                break

            else:
                smallest_RSS = calc_RSS(ResDens[0:i], paramEst, Model=calc_CQ)
                smallest_a = tmpRegress[0]

            #     elif: #if equal what to do?

        else:  # if not smaller skip
            None


    return smallest_a

def calc_poly(poly, x, deg = 0):
    """
    To calculate the output of a polynomial of n-degree. requires a minimum degree of 1.

    poly: the polynomial coefficients in order from highest degree to lowest, includes intercept

    x: the observed datat to be used for the x-axis in the form of a list.

    deg: degree of the polynomial

    Returns: values of y using the coefficients of poly as a list
    """
    if len(poly == 1) or deg == 0: # to catch missing arguments or 0 degree polynomials
        return "Please give a polynomial of degree of 1 or greater, or specify the degree of your polynomial"

    ylist = []

    x_coefs = np.array(poly[0 : deg-1])
    c = poly[deg]
    exponents = list(range(1,deg))
    x_valexp = np.array([]) # list with values adjusted for their exponent

    ## put x values to right exponent
    for x_val in x:
        for i in range(deg):
            x_valexp.append(x_val ** exponents[i])
        y_val = sum(x_valexp*x_coefs) + c
        ylist.append(y_val)
    return ylist


######Import Data##########
data = pd.read_csv("../data/CRat.csv")

######Define some lists for data to be saved ########


## `a` best value lists
# aCmodList = []  ###########Look into making these dictionaries for speed
# aCQmodList = []


# ##`h` best value lists
# hCmodList = []
# hCQmodList = []

# # AIC Lists
# AICCmodList = []
# AICCQmodList = []

# # BIC List
# BICCmodList = []
# BICCQmodList = []

# ##Passed ID list - list of ID which pass
# CmodPass = []
# CQmodPass = []

## `a` best value lists
aCmodList = []  ###########Look into making these dictionaries for speed
aCQmodList = {}

##`h` best value lists
hCmodList = []
hCQmodList = {}

## best q values list
qCQmodList = {}

# AIC Lists
AICCmodList = []
AICCQmodList = {}

# BIC List
BICCmodList = []
BICCQmodList = {}

##Passed ID list - list of ID which pass
CmodPass = []
CQmodPass = []

## List of ID which error out in each model
CmodError = ["Files which gave errors in Hollings 1959"]  # list of IDs which error in Hollings 1959
CQmodError = ["Files which gave errors in generalised Hollings"]  # list of IDs which error in generalised Hollings

##for progress counter
counter = 0
IDlen = len(data.ID.unique())
print("fitting data")

### Troubleshooting
hEstList = []  # for hEstimates
aEstList = []  # for a Estimates

CModResultsDict = {}
CQModResultsDict = {}
######Main########


for ID in data.ID.unique():
    ## Code Progress##

    counter += 1
    if counter % 30 == 0:
        print(round((counter / IDlen) * 100), "% finished fitting!!!")



    ### Subset data###
    subset = data[data["ID"] == ID]
    ResDens = sc.array(subset["ResDensity"])
    NTrait = sc.array(subset["N_TraitValue"])

    ###Organise data###
    RDensities = sc.random.uniform(min(ResDens), max(ResDens), 200)
    RDensities.sort()

    ### Estimate starting values ###
    ##Estimate `h` as highest observed value of `N_TraitValue`for the give `ID`####
    hEst = max(NTrait)

    
    ##Estimate `a` as the slope of the line which give the lowest RSS which is above a threshold number of points that the model is still acceptable. 
    aEst = est_a(ResDens, NTrait, hEst)
    q = 0.2



    ### Troubleshooting ###
    hEstList.append(hEst)
    aEstList.append(aEst)

    ### Fit Models### Using lmfit.Model()###
    ####### Use Hollings 1959 model#####


    

    try:
        Cmod = lmfit.Model(calc_C)  # set the model and equations we want to use
        paramsCmod = Cmod.make_params(a=aEst, h=hEst)
        resultsCmod = Cmod.fit(NTrait, Xr=ResDens, a=aEst, h=hEst)
        aCmod = resultsCmod.best_values["a"]
        hCmod = resultsCmod.best_values["h"]
        aCmodList.append((ID, resultsCmod.best_values["a"]))
        hCmodList.append((ID, resultsCmod.best_values["h"]))
        AICCmodList.append((ID, resultsCmod.aic))
        BICCmodList.append((ID, resultsCmod.bic))

        CmodPass.append(ID)

        ### Troubleshooting
        CModResultsDict[ID] = resultsCmod.fit_report()

    except ValueError:
        CmodError.append(ID)
    ####### Fit Generalised Hollings #####

    try:
        CQmod = lmfit.Model(calc_CQ)  # set the model and equations we want to use
        paramsCQmod = CQmod.make_params(a=aEst, h=hEst, q=q)
        

        resultsCQmod = CQmod.fit(NTrait, Xr=ResDens, a=aEst, h=hEst, q=q)
        aCQmod = resultsCQmod.best_values["a"]
        hCQmod = resultsCQmod.best_values["h"]
        aCQmodList[ID] = resultsCQmod.best_values["a"]
        hCQmodList[ID] = resultsCQmod.best_values["h"]
        qCQmodList[ID] = resultsCQmod.best_values["q"]
        AICCQmodList[ID] = resultsCQmod.aic
        BICCQmodList[ID] = resultsCQmod.bic

        # aCQmodList.append((ID, resultsCQmod.best_values["a"]))
        # hCQmodList.append((ID, resultsCQmod.best_values["h"]))
        # AICCQmodList.append((ID,resultsCQmod.aic))
        # BICCQmodList.append((ID,resultsCQmod.bic))

        CQmodPass.append(ID)
        # print(resultsCQmod.best_values["q"])
        ### Troubleshooting
        CQModResultsDict[ID] = resultsCQmod.fit_report()

    except ValueError:
        CQmodError.append(ID)

    
    ####### Fit 2nd degree polynomial #####
    try:

        poly2 = polynomial.polyfit(x = ResDens, y = NTrait, deg = 2) # gives coefs in order x^2, x, c

        # import pdb; pdb.set_trace()


    except ValueError:
        None

    ####### Fit 3rd degree polynomial #####

    ####### Fit 4th degree polynomial #####









print("finished data \nFiles which gave errors:\n", CmodError, "\n", CQmodError, "\nPlotting graphs")

###take data for output###
import csv

w = csv.writer(open("../Results/CModResultsDict.csv", "w"))
for key, val in CModResultsDict.items():
    w.writerow([key, val])

w = csv.writer(open("../Results/CQModResultsDict.csv", "w"))
for key, val in CQModResultsDict.items():
    w.writerow([key, val])

w = csv.writer(open("../Results/CQModResults.csv", "w"))
w.writerow(["ID", "a", "h", "q", "AIC", "BIC"])  ## write headers
for ID in aCQmodList.keys():
    w.writerow([ID, aCQmodList[ID], hCQmodList[ID], qCQmodList[ID], AICCQmodList[ID], BICCQmodList[ID]])

    # w.writerow(aCQmodList, hCQmodList, AICCQmodList, BICCQmodList)

#####Plotting and saving in pdf######
print("Plotting Hollings 1959.")
with PdfPages('../Results/FittedPlots_Hollings1959.pdf') as pdf:
    for i in range(len(CmodPass)):  # write for loop that goes through the data and plots it
        ### Subset data###
        subset = data[data["ID"] == CmodPass[i]]
        ResDens = sc.array(subset["ResDensity"])
        NTrait = sc.array(subset["N_TraitValue"])
        ## organise spread data to plot smooth live
        RDensities = sc.random.uniform(min(ResDens), max(ResDens), 200)
        RDensities.sort()
        ##Plot##

        plt.figure()
        plt.scatter(ResDens, NTrait)
        plt.plot(ResDens, calc_C(ResDens, a=aCmodList[i][1], h=hCmodList[i][1]), '-r')
        plt.plot(RDensities, calc_C(RDensities, a=aCmodList[i][1], h=hCmodList[i][1]), '-g')
        # plt.ylim(bottom = 0, top = max(NTrait)*1.5)
        plt.xlabel('ResourceDensity')
        plt.ylabel('N_TraitValue')
        plt.title(CmodPass[i])
        pdf.savefig()  # saves the current figure into a pdf page
        plt.close()

print("Plotting Generalied Hollings.")
with PdfPages('../Results/FittedPlots_HollingsGeneral.pdf') as pdf:
    for i in range(len(CQmodPass)):  # write for loop that goes through the data and plots it
        ######### Stopgap while using dictionaries for analysis of broken plots
        ID = CQmodPass[i]
        #########
        ### Subset data###
        subset = data[data["ID"] == CQmodPass[i]]
        ResDens = sc.array(subset["ResDensity"])
        NTrait = sc.array(subset["N_TraitValue"])
        ## organise spread data to plot smooth live
        RDensities = sc.random.uniform(min(ResDens), max(ResDens), 200)
        RDensities.sort()
        ##Plot##
        plt.figure()
        plt.scatter(ResDens, NTrait)
        plt.plot(ResDens, calc_CQ(ResDens, a=aCQmodList[ID], h=hCQmodList[ID]), '-r')
        # plt.plot(ResDens, calc_CQ(ResDens, a = aCQmodList[i][1], h = hCQmodList[i][1]), '-r')  ## changed above and below line to acccomadate aCQmodList and hCQmodList being changed from a list to a dictionary
        plt.plot(RDensities, calc_CQ(RDensities, a=aCQmodList[ID], h=hCQmodList[ID]), '-g')
        # plt.ylim(bottom = 0, top = max(NTrait)*1.5)
        plt.xlabel('ResourceDensity')
        plt.ylabel('N_TraitValue')
        plt.title(CQmodPass[i])

        ## for "legend"
        # f = plt.figure()
        # ax = f.add_subplot(1,1,1)

        # # plt.text(right, top, aCQmodList[ID])
        # ax.plot([0],[0], color = "green", label= aCQmodList[ID])

        pdf.savefig()  # saves the current figure into a pdf page
        plt.close()

######Notes######

# import data
# subset data
# starting values 
# feed to model calcs 
# record final values of a, h, q(if present) i.e.parameter vals
# get AIC and BIC
# plot and save to pdf


####questions 
# with fluct for starting values, can we fluctuate all params at once or should we go one by one to try get fits.


print("100% finished =)")

### things to pick up on for next time:
# 1959 fitting well enough,but generalised is a mess, despite the fact that a starting value of q means they are the same equation to start
#   means that something is going wrong in the fit..., 
# could try to limit q to positive? 
# try non-zero value for q like .1?
# check that graphs are plotting with the right equations for that dataset

# finish implementing calc_poly for the graphs
# look at est_a for RSS since using a model in calcRSS makes no sense since i am getting the starting values for the model



# look into the errors that are shown when the script is run in scipy - seem to be from when i get NAN values but seems to be accounted for in the loop



# least squares solution ?
# # Load the data
# x_data, y_data = load_data()

# # Model the data with specified values for parameters a0, a1
# y_model = model(x_data, a0=150, a1=25)

# # Compute the RSS value for this parameterization of the model
# rss = np.sum(np.square(y_data - y_model))
# print("RSS = {}".format(rss))


# pandas==0.22.0