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

######## Script options #########
# model plots - deternmines whether or no certain models are plotted
plot1959Hollings = True
plotGeneralHollings = True
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
        Xr {float} -- [description]
        a {float} -- [description]
        h {float} -- [description]
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


def poly2_eq(x, c2, c1, c0, data=0):
    """A function to calculate a quadratic equation given the x value and coefficients in the form - c2x + c1x + c0
    
    Arguments:
        x {float} -- x value to be used in the equation
        c2 {float} -- a coefficient for the equation
        c1 {float} -- a coefficient for the equation
        c0 {float} -- a coefficient for the equation  
        data {float} -- If using for lmfit.minimizer() then this is the data the result is to be compared against  

    Returns:
        {float} -- solution to the quadratic at given x value
    """
    return ((c2*(x**2)) + (c1*x) + c0) - data


def poly3_eq(x, c3, c2, c1, c0, data=0):
    """A function to calculate a cubic polynomial equation given the x value and coefficients in the form - c3x + c2x + c1x + c0
    
    Arguments:
        x {float} -- x value to be used in the equation
        c3 {float} -- a coefficient for the equation
        c2 {float} -- a coefficient for the equation
        c1 {float} -- a coefficient for the equation
        c0 {float} -- a coefficient for the equation
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
data = pd.read_csv("../data/CRat.csv")

######Define some lists for data to be saved ########

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
poly4coefList = {}

#for plots
poly2Fits = {}
poly3Fits = {}
poly4Fits = {}

# AIC Lists
AICCmodList = {}
AICCQmodList = {}
AICpoly2List ={}
AICpoly3List ={}
AICpoly4List ={}

# BIC List
BICCmodList = {}
BICCQmodList = {}
BICpoly2List ={}
BICpoly3List ={}
BICpoly4List ={}

# Initial values for models
initCmod = {}
initCQmod = {}


##Passed ID list - list of ID which pass
CmodPass = []
CQmodPass = []
poly2Pass = []
poly3Pass = []
poly4Pass = []

## List of ID which error out in each model
CmodError = ["Files which gave errors in Hollings 1959"]  # list of IDs which error in Hollings 1959
CQmodError = ["Files which gave errors in generalised Hollings"]  # list of IDs which error in generalised Hollings
poly2Error = ["Files which gave errors in 2nd degree polynomial"]  
poly3Error = ["Files which gave errors in 3rd degree polynomial"]  
poly4Error = ["Files which gave errors in 4th degree polynomial"]
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
    q = 0.3



    ### Troubleshooting ###
    hEstList.append(hEst)
    aEstList.append(aEst)

    ### Fit Models### Using lmfit.Model()###

    ####### Use Hollings 1959 model#####

    try:

        # # add with tuples: (NAME VALUE VARY MIN  MAX  EXPR  BRUTE_STEP)
        params = lmfit.Parameters()
        params.add_many(("a", aEst, True, 0, None),
         ("h", hEst, True, 0, None))
        Cmod = lmfit.Minimizer(calc_Clmfit, params, fcn_args=(ResDens, NTrait))
        resultsCmod = Cmod.minimize()

        # record results of model
        CparamVals = resultsCmod.params.valuesdict()
        aCmod = CparamVals["a"]
        hCmod = CparamVals["h"]
        aCmodList[ID] = CparamVals["a"]
        hCmodList[ID] = CparamVals["h"]
        AICCmodList[ID] = resultsCmod.aic
        BICCmodList[ID] = resultsCmod.bic

        # record passing ID
        CmodPass.append(ID)

        ### Troubleshooting
        # CModResultsDict[ID] = resultsCmod.fit_report()
        CModResultsDict[ID] = 0
    except ValueError:
        CmodError.append(ID)



    ####### Fit Generalised Hollings #####

    try:
        # # add with tuples: (NAME VALUE VARY MIN  MAX  EXPR  BRUTE_STEP)
        params = lmfit.Parameters()
        params.add_many(("a", aEst, True, 0, None),
         ("h", hEst, True, 0, None), 
         ("q", q, True, 0, None))
        
        CQmod = lmfit.Minimizer(calc_CQlmfit, params, fcn_args=(ResDens, NTrait))
        resultsCQmod = CQmod.minimize()

        # if using minimise
        CQparamVals = resultsCQmod.params.valuesdict()
        aCQmod = CQparamVals["a"]
        hCQmod = CQparamVals["h"]
        aCQmodList[ID] = CQparamVals["a"]
        hCQmodList[ID] = CQparamVals["h"]
        qCQmodList[ID] = CQparamVals["q"]
        AICCQmodList[ID] = resultsCQmod.aic
        BICCQmodList[ID] = resultsCQmod.bic

        initCQmod[ID] = resultsCQmod.init_vals

        CQmodPass.append(ID)
        ### Troubleshooting
        # CQModResultsDict[ID] = resultsCQmod.fit_report()
        CQModResultsDict[ID] = 0


    except ValueError:
        CQmodError.append(ID)

    
    ####### Fit 2nd degree polynomial #####
    try:

        # poly2sc[ID] = polynomial.polyfit(x = ResDens, y = NTrait, deg = 2) # gives coefs in order x^2, x, c
        # print(polynomial.polyfit(x = ResDens, y = NTrait, deg = 2)) # gives coefs in order x^2, x, c

        mod = lmfit.models.PolynomialModel(degree=2)
        params = mod.guess(NTrait, x = ResDens)
        poly2 = mod.fit(NTrait, params, x = ResDens)

        # poly2mod = lmfit.Model(poly2_eq)

        # poly2 = poly2mod.fit(NTrait, x = ResDens)

        poly2coefList[ID] = list(poly2.best_values.values())
        poly2Fits[ID] = poly2.best_fit  
          
        # print(poly2Fits[ID])  
        # with PdfPages('../Results/test.pdf') as pdf:

        #     plt.figure()
        #     poly2.plot()
        #     pdf.savefig()
        #     plt.close()

        # print(poly2.fit_report()) 
        AICpoly2List[ID] = poly2.aic
        BICpoly2List[ID] = poly2.bic
        poly2Pass.append(ID)


    except ValueError:
        poly2Error.append(ID)

    ####### Fit 3rd degree polynomial #####
    try:

        # poly2sc[ID] = polynomial.polyfit(x = ResDens, y = NTrait, deg = 2) # gives coefs in order x^2, x, c
        mod = lmfit.models.PolynomialModel(degree=3)
        params = mod.guess(NTrait, x = ResDens)
        poly3 = mod.fit(NTrait, params, x = ResDens)

        # poly2mod = lmfit.Model(poly2_eq)

        # poly2 = poly2mod.fit(NTrait, x = ResDens)

        poly3coefList[ID] = poly3.best_values 
        poly3Fits[ID] = poly3.best_fit 
        # print(poly3Fits[ID])
        poly3coefList[ID] = list(poly3.best_values.values())

        AICpoly3List[ID] = poly3.aic
        BICpoly3List[ID] = poly3.bic
        poly3Pass.append(ID)


    except ValueError:
        poly3Error.append(ID)


    ####### Fit 4th degree polynomial #####
    try:

        mod = lmfit.models.PolynomialModel(degree=4)
        params = mod.guess(NTrait, x = ResDens)
        poly4 = mod.fit(NTrait, params, x = ResDens)

        # mod = lmfit.Model(poly2_eq)
        # # add with tuples: (NAME VALUE VARY MIN  MAX  EXPR  BRUTE_STEP)
        # mod.Parameters.add_many(())
        # params = mod.add

        poly4coefList[ID] = poly4.best_values 
        poly4Fits[ID] = poly4.best_fit 
        # print(poly4Fits[ID])
        poly4coefList[ID] = list(poly4.best_values.values())

        AICpoly4List[ID] = poly4.aic
        BICpoly4List[ID] = poly4.bic
        poly4Pass.append(ID)


    except ValueError:
        poly4Error.append(str(ID, ":Value"))

    except TypeError:
        poly4Error.append(str(ID))







print("finished data \nFiles which gave errors:\n", CmodError, "\n", CQmodError, "\n", poly2Error, "\n", poly3Error, "\n", poly4Error, "\n", "\nPlotting graphs")

###take data for output###
import csv

w = csv.writer(open("../Results/CModResultsDict.csv", "w"))
for key, val in CModResultsDict.items():
    w.writerow([key, val])


w = csv.writer(open("../Results/CQModResults.csv", "w"))
w.writerow(["ID", "a", "h", "q", "AIC", "BIC"])  ## write headers
for ID in aCQmodList.keys():
    w.writerow([ID, aCQmodList[ID], hCQmodList[ID], qCQmodList[ID], AICCQmodList[ID], BICCQmodList[ID]])

    # w.writerow(aCQmodList, hCQmodList, AICCQmodList, BICCQmodList)

#####Plotting and saving in pdf######

if plot1959Hollings == True or plotAll == True:

    print("Plotting Hollings 1959.")
    with PdfPages('../Results/FittedPlots_Hollings1959.pdf') as pdf:
        for i in range(len(CmodPass)):  # write for loop that goes through the data and plots it
            ID =CmodPass[i]
            ### Subset data###
            subset = data[data["ID"] == CmodPass[i]]
            ResDens = sc.array(subset["ResDensity"])
            NTrait = sc.array(subset["N_TraitValue"])
            ## organise spread data to plot smooth live
            RDensities = sc.random.uniform(min(ResDens), max(ResDens), 200)
            RDensities.sort()
            ##Plot##

            plt.figure()
            plt.plot(ResDens, NTrait, "bo")
            plt.plot(ResDens, calc_C(ResDens, a=aCmodList[ID], h=hCmodList[ID]), '-r')
            plt.plot(RDensities, calc_C(RDensities, a=aCmodList[ID], h=hCmodList[ID]), '-g')
            # plt.ylim(bottom = 0, top = max(NTrait)*1.5)
            plt.xlabel('ResourceDensity')
            plt.ylabel('N_TraitValue')
            plt.title(CmodPass[i])
            pdf.savefig()  # saves the current figure into a pdf page
            plt.close()

if plotGeneralHollings == True or plotAll == True:

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
            plt.plot(ResDens, NTrait,"bo")
            plt.plot(ResDens, calc_CQ(ResDens, a=aCQmodList[ID], h=hCQmodList[ID], q=qCQmodList[ID]), '-r', label = aCQmodList[ID])
            # plt.plot(ResDens, calc_CQ(ResDens, a = aCQmodList[i][1], h = hCQmodList[i][1]), '-r')  ## changed above and below line to acccomadate aCQmodList and hCQmodList being changed from a list to a dictionary
            plt.plot(RDensities, calc_CQ(RDensities, a=aCQmodList[ID], h=hCQmodList[ID], q=qCQmodList[ID]), '-g', label = hCQmodList[ID])
            # plt.ylim(bottom = 0, top = max(NTrait)*1.5)
            plt.legend()
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


if plotpolys == True or plotAll == True:

    print("Plotting Polynomials.")
    with PdfPages('../Results/FittedPlots_Polynomials.pdf') as pdf:
        for i in range(len(CQmodPass)):  # write for loop that goes through the data and plots it
            ######### Stopgap while using dictionaries for analysis of broken plots
            ID = poly2Pass[i]
            #########
            ### Subset data###
            subset = data[data["ID"] == poly2Pass[i]]
            ResDens = sc.array(subset["ResDensity"])
            NTrait = sc.array(subset["N_TraitValue"])
            ## organise spread data to plot smooth live
            RDensities = sc.random.uniform(min(ResDens), max(ResDens), len(NTrait))
            RDensities.sort()
            ##Plot##
            plt.figure()
            plt.plot(ResDens, NTrait, "bo")
            plt.plot(sc.polyval(poly2coefList[ID], RDensities), NTrait, "r-", label = "2nd Degree")
            try:
                plt.plot(sc.polyval(poly3coefList[ID], RDensities), NTrait, '-g', label = "3rd Degree")
            except ValueError:
                print("Error 3rd degree: ", ID)
            except KeyError:
                print("KeyError 3rd:", ID)
            # try:
            #     plt.plot(RDensities, poly3Fits, '-g', label = "3rd Degree")
            # except ValueError:
            #     print("Error 3rd degree: ", ID)


            try:
                plt.plot(sc.polyval(poly4coefList[ID], RDensities), NTrait, '-b', label = "4th Degree")
            except ValueError:
                print("Error 4th degree: ", ID)
            except KeyError:
                print("KeyError 4th:", ID)
            # try:
            #     plt.plot(RDensities, poly4Fits, '-b', label = "4th Degree")
            # except ValueError:
            #     print("Error 4th degree: ", ID)
            # plt.ylim(bottom = 0, top = max(NTrait)*1.5)
            plt.legend()
            plt.xlabel('ResourceDensity')
            plt.ylabel('N_TraitValue')
            plt.title(ID)

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

# save model so they can be accessed or do the plotting during the fitting across all degrees of polynomial
    # alternative is to just do separate plot files


# 1959 fitting well enough,but generalised is a mess, despite the fact that a starting value of q means they are the same equation to start
#   means that something is going wrong in the fit..., 
# could try to limit q to positive? 
# try non-zero value for q like .1?
# check that graphs are plotting with the right equations for that dataset



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


##### Questions
# consumer movement
# resource movement
# detection - sphere or circle i.e. 2d or 3d perception


# discussion with samraat
# checking fits are significant?
    # just use aic/bic for significance
    # no need to quantify just rank them instead
    # wide CIs in the parameters will have worse aic anyway
    # can look at whether q is different from 0 by seeing if it is significant from 0
        # determines if type 2 or 1 response
    # even if AICs are marginally different just choose the best and maybe there will be a pattern so you can mention that it is marginal but there is a pattern

    # can look at using overlapping CIs for comparing params, but should read up on what is wrong with doing so and how it might not be trust worthy

