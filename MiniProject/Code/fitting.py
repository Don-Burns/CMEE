"""
Desc: Script for fitting models to functional response data.
Date: 21/11/2019
"""

######Import Packages#######
import sys
import os
import scipy as sc
import pandas as pd
import matplotlib.pyplot as plt
import lmfit
import csv
from scipy.optimize import curve_fit
from scipy import stats as stats
from math import log as log
from math import pi as pi
from numpy.polynomial import polynomial as polynomial
from matplotlib.backends.backend_pdf import PdfPages as PdfPages


######## Script options #########
## number if time to repeat the holling model fit
reps = 100

# Category of interest for comparing fits later
interest  = "Habitat"

# file to run fitting on
#default option for running
if len(sys.argv) == 1: 
    file = "../data/CRat.csv"

if len(sys.argv) != 1: # to take file argument from the terminal
    file = sys.argv[1]

if len(sys.argv) > 2: # error message if more than one argument given
    sys.exit("too many arguments given")
# model plots - deternmines whether or no certain models are plotted
plot1959Hollings = False
plotGeneralHollings = False
plotpolys = False

plotAll = False # will plot all models regardless of other options

#######FUNCTIONS############
def calc_C(Xr, a, h):
    """  The equation for the type II functional response from Holling, 1959

    
    Arguments:
        Xr {float} -- [description]
        a {float} -- [description]
        h {float} -- [description]
    
    Returns:
        {float} -- [description]
    """
    
    top = a * Xr
    bot = 1 + (h * a * Xr)
    C = top / bot
    return C


def calc_Clmfit(params, Xr, data = 0):  ## arbitrarily defined right now as 0.05
    """
    The equation for the more general Type II functional response curve.
    Need an argument params which is a dictionary containing the parameter values.
    This dictionary is made using lmfit.parameters().
    used for minimize.

    Arguments:
        Xr {float} -- [description]
        a {float} -- [description]
        h {float} -- [description]
        data {float} -- [description]

    Returns:
        {float} -- [description]
    """
    vals = params.valuesdict()
    a = vals['a']
    h = vals['h']

    top = a * Xr
    bot = 1 + (h * a * Xr)
    C = top / bot
    return C - data


def calc_CQ(Xr, a, h, q=0):  ## arbitrarily defined right now as 0.8
    """
    The equation for the more general Type II functional response curve.  
    Includes a dimensionless parameter `q` which is used to account for a small lag phase at the start of the curve
    """
    top = a * (Xr ** (q + 1))
    bot = 1 + (h * a * (Xr ** (q + 1)))
    C = top / bot
    return C


def calc_CQlmfit(params, Xr, data = 0):  ## arbitrarily defined right now as 0.05
    """
    The equation for the more general Type II functional response curve.
    Need an argument params which is a dictionary containing the parameter values.
    This dictionary is made using lmfit.parameters().
    Includes a dimensionless parameter `q` which is used to account for a small lag phase at the start of the curve.

    Arguments:
        params {dict} -- a dictionary containing the parameter values for the model
            Parameters:
                a {float} -- [description]
                h {float} -- [description]
        Xr {float} -- [description]
        data {float} -- [description]
    
    Returns:
        {float} -- 

    """
    vals = params.valuesdict()
    a = vals['a']
    h = vals['h']
    q = vals['q']

    top = a * Xr ** (q + 1)
    bot = 1 + (h * a * Xr ** (q + 1))
    C = top / bot
    return C - data

def calc_RSS(residuals):  ## model var is to specify which equation should be used. Model fit is popt under sc.optimize
    """
    Calculates the Residual Sum of Squares for an array of model residuals.
    """

    RSS = sum(residuals**2)

    return RSS


def est_a(ResDens, NTrait):
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
        mod = lmfit.models.LinearModel()
        params = mod.guess(NTrait[0:i], x = ResDens[0:i])
        tmpRegress = mod.fit(NTrait[0:i], params, x = ResDens[0:i])
        
        residuals = tmpRegress.residual
        
        if smallest_RSS == None:  # i.e. first loop

            smallest_RSS = calc_RSS(residuals)
            smallest_a = tmpRegress.params["slope"].value

        # if RSS is smaller record
        elif calc_RSS(residuals) < smallest_RSS:

            if sc.isnan(tmpRegress.params["slope"].value):  # skip if a becomes nan
                break

            else:
                smallest_RSS = calc_RSS(residuals)
                smallest_a = tmpRegress.params["slope"].value

            #     elif: #if equal what to do?

        else:  # if not smaller skip
            None


    return smallest_a


def poly2_eq(params, x, data=0):
    """A function to calculate a quadratic equation given the x value and coefficients in the form - c2x + c1x + c0
    
    Arguments:
        params {dict} -- a dictionary containing the parameter values for the model
            Parameters:
                c2 {float} -- a coefficient for the equation
                c1 {float} -- a coefficient for the equation
                c0 {float} -- a coefficient for the equation  
        x {float} -- x value to be used in the equation
        data {float} -- If using for lmfit.minimizer() then this is the data the result is to be compared against  

    Returns:
        {float} -- solution to the quadratic at given x value
    """
    vals = params.valuesdict()
    c0 = vals["c0"]
    c1 = vals["c1"]
    c2 = vals["c2"]

    return ((c2*(x**2)) + (c1*x) + c0) - data


def poly3_eq(x, c3, c2, c1, c0, data=0):
    """A function to calculate a cubic polynomial equation given the x value and coefficients in the form - c3x + c2x + c1x + c0
    
    Arguments:
        c3 {float} -- a coefficient for the equation
        c2 {float} -- a coefficient for the equation
        c1 {float} -- a coefficient for the equation
        c0 {float} -- a coefficient for the equation
        x {float} -- x value to be used in the equation
        data {float} -- If using for lmfit.minimizer() then this is the data the result is to be compared against  

    Returns:
        {float} -- solution to the polynomial at given x value
    """
    return ((c3*(x**3)) + (c2*(x**2)) + (c1*x) + c0
) - data


def poly4_eq(x, c4, c3, c2, c1, c0, data=0):
    """A function to calculate a 4th degree polynomial equation given the x value and coefficients in the form - c3x + c2x + c1x + c0
    
    Arguments:
        x {float} -- x value to be used in the equation
        c4 {float} -- a coefficient for the equation
        c3 {float} -- a coefficient for the equation
        c2 {float} -- a coefficient for the equation
        c1 {float} -- a coefficient for the equation
        c0 {float} -- a coefficient for the equation
        data {float} -- If using for lmfit.minimizer() then this is the data the result is to be compared against  

    Returns:
        {float} -- solution to the polynomial at given x value
    """
    return ((c4*(x**4)) + (c3*(x**3)) + (c2*(x**2)) + (c1*x) + c0) - data



######Import Data##########
data = pd.read_csv(file)

######Define some dictionaries for data to be saved ########

# category of interest for comparing the models after fitting
cat = {}

## `a` best value lists
aCmodList = {}  ###########Look into making these dictionaries for speed
aCQmodList = {}

##`h` best value lists
hCmodList = {}
hCQmodList = {}

## best q values list
qCQmodList = {}

## polynomial coefficients
poly2coefList = {}
poly3coefList = {}


# Reversed list for use with polyval
poly3coefListRev = {}

#for plots
poly2Fits = {}
poly3Fits = {}


# AIC Lists
AICCmodList = {}
AICCQmodList = {}
AICpoly2List ={}
AICpoly3List ={}


# BIC List
BICCmodList = {}
BICCQmodList = {}
BICpoly2List ={}
BICpoly3List ={}


# Initial values for models
initCmod = {}
initCQmod = {}


##Passed ID list - list of ID which pass
CmodPass = []
CQmodPass = []
poly2Pass = []
poly3Pass = []


## List of ID which error out in each model
CmodError = ["Files which gave errors in Hollings 1959"]  # list of IDs which error in Hollings 1959
CQmodError = ["Files which gave errors in generalised Hollings"]  # list of IDs which error in generalised Hollings
poly2Error = ["Files which gave errors in 2nd degree polynomial"]  
poly3Error = ["Files which gave errors in 3rd degree polynomial"]  

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
IDList = data.ID.unique()
for ID in IDList:
    ## Code Progress##

    counter += 1
    if counter % 30 == 0:
        print(round((counter / IDlen) * 100), "% finished fitting!!!")



    ### Subset data###
    subset = data[data["ID"] == ID]
    ResDens = sc.array(subset["ResDensity"])
    NTrait = sc.array(subset["N_TraitValue"])

    #record the category of interest for this ID
    cat[ID] = subset[interest].unique()
    cat[ID] = str(cat[ID]).strip("[']")
    ###Organise data###
    RDensities = sc.random.uniform(min(ResDens), max(ResDens), 200)
    RDensities.sort()

    ### Estimate starting values ###
    ##Estimate `h` as highest observed value of `N_TraitValue`for the give `ID`####
    hEst = 1/max(NTrait)

    
    ##Estimate `a` as the slope of the line which give the lowest RSS which is above a threshold number of points that the model is still acceptable. 
    aEst = est_a(ResDens, NTrait)
    q = 0



    ### Troubleshooting ###
    hEstList.append(hEst)
    aEstList.append(aEst)

    ### Fit Models### Using lmfit.Model()###
    bestAIC = 1e20 # assign an arbitrarily large number that should always be lower than an actual AIC result
    ####### Use Hollings 1959 model#####
    for i in range(reps):
        if i != 1: # try once with estimated values
            a = sc.random.uniform(size = 1, low = aEst*0.5, high = aEst*1.5)
            h = sc.random.uniform(size = 1, low = hEst*0.5, high = hEst*1.5)
        else:
            a = aEst
            h = hEst
        try:

            # add with tuples: (NAME VALUE VARY MIN  MAX  EXPR  BRUTE_STEP)
            params = lmfit.Parameters()
            params.add_many(("a", a, True, 0, None),
            ("h", h, True, 0, None))
            Cmod = lmfit.Minimizer(calc_Clmfit, params, fcn_args=(ResDens, NTrait))
            resultsCmod = Cmod.minimize()
            thisAIC = resultsCmod.aic # the current iterations AIC
            if thisAIC < bestAIC: # only assign new values if the current iterations AIC is greater than the previous best

            # record results of model
                CparamVals = resultsCmod.params.valuesdict()
                aCmod = CparamVals["a"]
                hCmod = CparamVals["h"]
                aCmodList[ID] = CparamVals["a"]
                hCmodList[ID] = CparamVals["h"]
                AICCmodList[ID] = resultsCmod.aic
                BICCmodList[ID] = resultsCmod.bic

            # record passing ID

            if ID in CmodPass: #  to make sure the same ID is not appended more than once
                None
            else:
                CmodPass.append(ID)

            ### Troubleshooting
            CModResultsDict[ID] = resultsCmod

        except ValueError:

            aCQmod = "NA"
            hCmod = "NA"
            aCmodList[ID] = "NA"
            hCmodList[ID] = "NA"
            qCmodList[ID] = "NA"
            AICCmodList[ID] = "NA"
            BICCmodList[ID] = "NA"
    if ID not in CmodPass:
        CmodError.append(ID)



    ####### Fit Generalised Hollings #####
    bestAIC = 1e20 # assign an arbitrarily large number that should always be lower than an actual AIC result
    for i in range(reps):
        if i != 1: # try once with estimated values
            q = sc.random.uniform(size = 1, low = 0.0, high = 1.0)
            a = sc.random.uniform(size = 1, low = aEst*0.5, high = aEst*1.5)
            h = sc.random.uniform(size = 1, low = hEst*0.5, high = hEst*1.5)

    
        try:
            # # add with tuples: (NAME VALUE VARY MIN  MAX  EXPR  BRUTE_STEP)
            params = lmfit.Parameters()
            params.add_many(("a", aEst, True, 0, None),
            ("h", hEst, True, 0, None), 
            ("q", q, True, 0, None))
            
            CQmod = lmfit.Minimizer(calc_CQlmfit, params, fcn_args=(ResDens, NTrait))
            resultsCQmod = CQmod.minimize()
            thisAIC = resultsCQmod.aic # the current iterations AIC
            if thisAIC < bestAIC: # only assign new values if the current iterations AIC is greater than the previous best
                CQparamVals = resultsCQmod.params.valuesdict()
                aCQmod = CQparamVals["a"]
                hCQmod = CQparamVals["h"]
                aCQmodList[ID] = CQparamVals["a"]
                hCQmodList[ID] = CQparamVals["h"]
                qCQmodList[ID] = CQparamVals["q"]
                AICCQmodList[ID] = resultsCQmod.aic
                BICCQmodList[ID] = resultsCQmod.bic

                initCQmod[ID] = resultsCQmod.init_vals

            if ID in CQmodPass: #  to make sure the same ID is not appended more than once
                None
            else:
                CQmodPass.append(ID)
            ### Troubleshooting
            # CQModResultsDict[ID] = resultsCQmod.fit_report()
            CQModResultsDict[ID] = resultsCQmod


        except ValueError:

            aCQmod = "NA"
            hCQmod = "NA"
            aCQmodList[ID] = "NA"
            hCQmodList[ID] = "NA"
            qCQmodList[ID] = "NA"
            AICCQmodList[ID] = "NA"
            BICCQmodList[ID] = "NA"

            initCQmod[ID] = resultsCQmod.init_vals

    if ID not in CQmodPass:
        CQmodError.append(ID)



    ####### Fit 2nd degree polynomial #####
    try:
        
        mod = lmfit.models.PolynomialModel(degree=2)
        params = mod.guess(NTrait, x = ResDens)
        poly2 = mod.fit(NTrait, params, x = ResDens)

        poly2coefList[ID] = poly2.best_values 
        poly2Fits[ID] = poly2.best_fit 
        AICpoly2List[ID] = poly2.aic
        BICpoly2List[ID] = poly2.bic
        poly2Pass.append(ID)


    except ValueError:

        poly2coefList[ID] = {"c0":"NA", "c1":"NA", "c2":"NA", "c3":"NA", "c4":"NA"} 
        poly2Fits[ID] = "NA"
        poly2coefList[ID] = "NA"
        AICpoly2List[ID] = "NA"
        BICpoly2List[ID] = "NA"

        poly2Error.append(ID)

    ####### Fit 3rd degree polynomial #####
    try:

        scmod = sc.polyfit(ResDens, NTrait, deg = 3)
        # poly2sc[ID] = polynomial.polyfit(x = ResDens, y = NTrait, deg = 2) # gives coefs in order x^2, x, c
        mod = lmfit.models.PolynomialModel(degree=3)
        params = mod.guess(NTrait, x = ResDens)
        poly3 = mod.fit(NTrait, params, x = ResDens)


        poly3coefList[ID] = poly3.best_values
        poly3Fits[ID] = poly3.best_fit 
        AICpoly3List[ID] = poly3.aic
        BICpoly3List[ID] = poly3.bic
        poly3Pass.append(ID)


    except ValueError:

        poly3coefList[ID] = {"c0":"NA", "c1":"NA", "c2":"NA", "c3":"NA", "c4":"NA"} 
        poly3Fits[ID] = "NA"
        AICpoly3List[ID] = "NA"
        BICpoly3List[ID] = "NA"
        poly3Error.append(ID)




# print(resultsCQmod.params)


###save data output###

print("Saving Results")
# Save results for Hollings 1959
w = csv.writer(open("../Results/CModResults.csv", "w"))
w.writerow(["ID", "a", "h", "AIC", "BIC", "CatOfInterest"])  ## write headers
for ID in IDList:
    w.writerow([ID, aCmodList[ID], hCmodList[ID], AICCmodList[ID], BICCmodList[ID], cat[ID]])
# Save results for Generalised Hollings
w = csv.writer(open("../Results/CQModResults.csv", "w"))
w.writerow(["ID", "a", "h", "q", "AIC", "BIC", "CatOfInterest"])  ## write headers
for ID in IDList:
    w.writerow([ID, aCQmodList[ID], hCQmodList[ID], qCQmodList[ID], AICCQmodList[ID], BICCQmodList[ID], cat[ID]])

# Save results for 2nd degree polynomial
w = csv.writer(open("../Results/poly2ModResults.csv", "w"))
w.writerow(["ID", "x^2", "x", "c", "AIC", "BIC", "CatOfInterest"])  ## write headers
for ID in IDList:
    w.writerow([ID, poly2coefList[ID]["c0"], poly2coefList[ID]["c1"], poly2coefList[ID]["c2"], AICpoly2List[ID], BICpoly2List[ID], cat[ID]])


# Save results for 3rd degree polynomial
w = csv.writer(open("../Results/poly3ModResults.csv", "w"))
w.writerow(["ID", "x^3","x^2", "x", "c", "AIC", "BIC", "CatOfInterest"])  ## write headers
for ID in IDList:
    w.writerow([ID, poly3coefList[ID]["c0"], poly3coefList[ID]["c1"], poly3coefList[ID]["c2"], poly3coefList[ID]["c3"], AICpoly3List[ID], BICpoly3List[ID], cat[ID]])

    

print("finished data \nFiles which gave errors:\n", CmodError, "\n", CQmodError, "\n", poly2Error, "\n", poly3Error, "\n")
