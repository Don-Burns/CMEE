"""
Desc: A script for reading the results of 'fitting.py' from the csv files generated and to plot and save the results as a pdf
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
poly4 = {}




# with open("../Results/CModResults.csv") as file:
data = pd.read_csv("../Results/CModResults.csv")
IDList = data.ID.unique()

for ID in IDList:
    row = data[data["ID"] == ID]
    Cmod[ID] = {"a":float(row["a"]), "h":float(row["h"]), "AIC":float(row["AIC"]), "BIC":float(row["BIC"])}
    # for var in row.columns[1:]: # start from element 1 so as to skip ID
    #     # Cmod[ID] = {}
    #     Cmod[ID][var] = float(row[var])

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

data = pd.read_csv("../Results/poly4ModResults.csv")
IDList = data.ID.unique()
for ID in IDList:
    row = data[data["ID"] == ID]
    poly4[ID] = {"coefs" : {"c0":float(row["x^4"]),"c1":float(row["x^3"]),"c2":float(row["x^2"]), "c3":float(row["x"]), "c4":float(row["c"])}, "AIC":float(row["AIC"]), "BIC":float(row["BIC"])}

with PdfPages('../Results/FittedPlots.pdf') as pdf:
    data = pd.read_csv("../data/CRat.csv")

    for ID in IDList:
    ## Import data for original data points
        subset = data[data["ID"] == ID]
        ResDens = sc.array(subset["ResDensity"])
        NTrait = sc.array(subset["N_TraitValue"])
    ## organise spread data to plot smooth live
        RDensities = sc.random.uniform(min(ResDens), max(ResDens), 200)
        RDensities.sort()

    # Start Plotting
        plt.figure()
        plt.plot(ResDens, NTrait, "bo")
        try:
            plt.plot(RDensities, calc_C(RDensities, a=Cmod[ID]["a"], h=Cmod[ID]["h"]), '-g', label = "Hollings 1959")
        except KeyError:
            pass

        try:
            plt.plot(RDensities, calc_CQ(RDensities, a=CQmod[ID]["a"], h=CQmod[ID]["h"], q=CQmod[ID]["q"]), '-r', label = "Generalised Hollings")

        except KeyError:
            pass

        try:
            RevCoefList = list(poly2[ID]["coefs"].values())
            RevCoefList.reverse()
            plt.plot(RDensities, sc.polyval(RevCoefList, RDensities), '-b', label = "2nd Degree")

        except KeyError:
            pass

        try:
            RevCoefList = list(poly3[ID]["coefs"].values())
            RevCoefList.reverse()
            plt.plot(RDensities, sc.polyval(RevCoefList, RDensities), '-y', label = "3rd Degree")

        except KeyError:
            pass

        try:
            RevCoefList = list(poly4[ID]["coefs"].values())
            RevCoefList.reverse()
            plt.plot(RDensities, sc.polyval(RevCoefList, RDensities), '-m', label = "4th Degree")

        except KeyError:
            pass



        plt.legend()
        plt.xlabel('ResourceDensity')
        plt.ylabel('N_TraitValue')
        plt.title(ID)
        pdf.savefig()  # saves the current figure into a pdf page
        plt.close()


a = 0


