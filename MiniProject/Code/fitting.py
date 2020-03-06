"""
Desc: Script for fitting models to functional response data.
Author: Donal Burns
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

######## import my functions ######
from functions import  calc_C as calc_C
from functions import  calc_Clmfit as calc_Clmfit
from functions import calc_CQ as calc_CQ
from functions import calc_CQ as calc_CQ
from functions import calc_CQlmfit as calc_CQlmfit
from functions import calc_RSS as calc_RSS
from functions import est_a as est_a



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

#######FUNCTIONS############


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
