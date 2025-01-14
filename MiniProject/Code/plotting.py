"""
Desc: A script for reading the results of 'fitting.py' from the csv files generated and to plot and save the results as a pdf

Author: Donal Burns
Date: 10/02/2020
"""

######Import Packages#######
import matplotlib.pyplot as plt 
from matplotlib.backends.backend_pdf import PdfPages as PdfPages
import scipy as sc 
import pandas as pd 
from ast import literal_eval
from functions import calc_C, calc_CQ as calc_C, calc_CQ



### Storage variables - variable where the data needed to plot will be held###

Cmod = {}
CQmod = {}
poly2 = {}
poly3 = {}


cat = {}#to add category of interest to the title of each graph



data = pd.read_csv("../Results/CModResults.csv")
IDList = data.ID.unique()
# get what category each ID is part of
for ID in IDList:
    row = data[data["ID"] == ID]
    cat[ID] = row["CatOfInterest"].unique()
    cat[ID] = str(cat[ID]).strip("[']")

for ID in IDList:
    row = data[data["ID"] == ID]
    Cmod[ID] = {"a":float(row["a"]), "h":float(row["h"]), "AIC":float(row["AIC"]), "BIC":float(row["BIC"])}


data = pd.read_csv("../Results/CQModResults.csv")
IDList = data.ID.unique()
for ID in IDList:
    row = data[data["ID"] == ID]
    CQmod[ID] = {"a":float(row["a"]), "h":float(row["h"]), "q":float(row["q"]), "AIC":float(row["AIC"]), "BIC":float(row["BIC"])}

data = pd.read_csv("../Results/poly2ModResults.csv")
IDList = data.ID.unique()
for ID in IDList:
    row = data[data["ID"] == ID]
    poly2[ID] = {"coefs" : {"c0":float(row["x^2"]), "c1":float(row["x"]), "c2":float(row["c"])}, "AIC":float(row["AIC"]), "BIC":float(row["BIC"])}
    # poly2[ID] = {"coefficients":row["coefficients (highest degree first)"].apply(literal_eval), "AIC":float(row["AIC"]), "BIC":float(row["BIC"])} # to try get dictionary values out

data = pd.read_csv("../Results/poly3ModResults.csv")
IDList = data.ID.unique()
for ID in IDList:
    row = data[data["ID"] == ID]
    poly3[ID] = {"coefs" : {"c0":float(row["x^3"]),"c1":float(row["x^2"]), "c2":float(row["x"]), "c3":float(row["c"])}, "AIC":float(row["AIC"]), "BIC":float(row["BIC"])}


###################################################################
################ All plots fitted #################################
###################################################################
with PdfPages('../Results/FittedPlots.pdf') as pdf:
    data = pd.read_csv("../data/CRat.csv")

    for ID in IDList:
    ## Import data for original data points
        subset = data[data["ID"] == ID]
        ResDens = sc.array(subset["ResDensity"])
        NTrait = sc.array(subset["N_TraitValue"])
    ## organise spread data to plot smooth live
        RDensities = sc.random.uniform(min(ResDens)*0.1, max(ResDens), 200)
        RDensities.sort()

    # Start Plotting
        plt.figure()
        plt.plot(ResDens, NTrait, "bo")
        try:
            plt.plot(RDensities, calc_C(RDensities, a=Cmod[ID]["a"], h=Cmod[ID]["h"]), '-g', label = "Type II")
        except KeyError:
            pass

        try:
            plt.plot(RDensities, calc_CQ(RDensities, a=CQmod[ID]["a"], h=CQmod[ID]["h"], q=CQmod[ID]["q"]), '-r', label = "Generalised Holling")

        except KeyError:
            pass

        try:
            RevCoefList = list(poly2[ID]["coefs"].values())
            RevCoefList.reverse()
            plt.plot(RDensities, sc.polyval(RevCoefList, RDensities), '-b', label = "Quadratic")

        except KeyError:
            pass

        try:
            RevCoefList = list(poly3[ID]["coefs"].values())
            RevCoefList.reverse()
            plt.plot(RDensities, sc.polyval(RevCoefList, RDensities), '-y', label = "Cubic")

        except KeyError:
            pass


        plt.legend()
        plt.xlabel('ResourceDensity')
        plt.ylabel('Consumption Rate')
        title = str(ID) + " " + cat[ID]
        plt.title(title)
        pdf.savefig()  # saves the current figure into a pdf page
        plt.close()


###################################################################
############ Sample plot showing all models once###################
###################################################################

with PdfPages('../Results/dataSample.pdf') as pdf:
    data = pd.read_csv("../data/CRat.csv")

    ID = 39956
## Import data for original data points
    subset = data[data["ID"] == ID]
    ResDens = sc.array(subset["ResDensity"])
    NTrait = sc.array(subset["N_TraitValue"])
## organise spread data to plot smooth live
    RDensities = sc.random.uniform(min(ResDens)*0.1, max(ResDens), 200)
    RDensities.sort()

# Start Plotting
    plt.figure()
    plt.plot(ResDens, NTrait, "bo")
    try:
        plt.plot(RDensities, calc_C(RDensities, a=Cmod[ID]["a"], h=Cmod[ID]["h"]), '-g', label = "Type II")
    except KeyError:
        pass

    try:
        plt.plot(RDensities, calc_CQ(RDensities, a=CQmod[ID]["a"], h=CQmod[ID]["h"], q=CQmod[ID]["q"]), '-r', label = "Generalised Holling")

    except KeyError:
        pass

    try:
        RevCoefList = list(poly2[ID]["coefs"].values())
        RevCoefList.reverse()
        plt.plot(RDensities, sc.polyval(RevCoefList, RDensities), '-b', label = "Quadratic")

    except KeyError:
        pass

    try:
        RevCoefList = list(poly3[ID]["coefs"].values())
        RevCoefList.reverse()
        plt.plot(RDensities, sc.polyval(RevCoefList, RDensities), '-y', label = "Cubic")

    except KeyError:
        pass


    plt.legend()
    plt.xlabel('ResourceDensity')
    plt.ylabel('Consumption Rate')

    pdf.savefig()  # saves the current figure into a pdf page
    plt.close()
###################################################################
################ graph of functional responses ####################
###################################################################

with PdfPages('../Results/functionResponses.pdf') as pdf:
    data = pd.read_csv("../data/CRat.csv")


## organise spread data to plot smooth live
    RDensities = sc.random.uniform(0,10, 200)
    RDensities.sort()

# Start Plotting
    plt.figure()
    peak = 5
    a = 2
    h = 1/peak
    q = 1
    type1 = calc_CQ(RDensities,a=a, h=0, q=0)
    for i in range(len(type1)):
        if type1[i] > peak:
            type1[i] = peak
    try:
        plt.plot(RDensities, type1, '-b', label = "Type I")

    except KeyError:
        pass
    try:
        plt.plot(RDensities, calc_CQ(RDensities, a=a, h=h, q=0), '-g', label = "Type II")

    except KeyError:
        pass
    try:
        plt.plot(RDensities, calc_CQ(RDensities, a=a, h=h, q=q), '-r', label = "Type III")

    except KeyError:
        pass


    plt.legend()
    plt.xlabel('Resource Density')
    plt.ylabel('Consumption Rate')

    pdf.savefig()  # saves the current figure into a pdf page
    plt.close()

###################################################################
################ bad cubic with good fit ##########################
###################################################################

with PdfPages('../Results/misbehaving_cubic.pdf') as pdf:
    data = pd.read_csv("../data/CRat.csv")

    ID = 39969
## Import data for original data points
    subset = data[data["ID"] == ID]
    ResDens = sc.array(subset["ResDensity"])
    NTrait = sc.array(subset["N_TraitValue"])
## organise spread data to plot smooth live
    RDensities = sc.random.uniform(min(ResDens)*0.1, max(ResDens), 200)
    RDensities.sort()

# Start Plotting
    plt.figure()
    plt.plot(ResDens, NTrait, "bo")
    try:
        plt.plot(RDensities, calc_C(RDensities, a=Cmod[ID]["a"], h=Cmod[ID]["h"]), '-g', label = "Type II")
    except KeyError:
        pass

    try:
        plt.plot(RDensities, calc_CQ(RDensities, a=CQmod[ID]["a"], h=CQmod[ID]["h"], q=CQmod[ID]["q"]), '-r', label = "Generalised Holling")

    except KeyError:
        pass

    try:
        RevCoefList = list(poly2[ID]["coefs"].values())
        RevCoefList.reverse()
        plt.plot(RDensities, sc.polyval(RevCoefList, RDensities), '-b', label = "Quadratic")

    except KeyError:
        pass

    try:
        RevCoefList = list(poly3[ID]["coefs"].values())
        RevCoefList.reverse()
        plt.plot(RDensities, sc.polyval(RevCoefList, RDensities), '-y', label = "Cubic")

    except KeyError:
        pass


    plt.legend()
    plt.xlabel('Resource Density')
    plt.ylabel('Consumption Rate')
    pdf.savefig()  # saves the current figure into a pdf page
    plt.close()
