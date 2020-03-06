"""
Script containing functions needed for the mini project
Author: Donal Burns
Date: 10/02/2020
"""

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
#######FUNCTIONS############

def calc_C(Xr, a, h):
    """  The equation for the type II functional response from Holling, 1959

    
    Arguments:
        Xr {float} -- Resource Density
        a {float} -- attack rate
        h {float} -- handling time
    
    Returns:
        {float} -- consumption rate
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
        Xr {float} -- Resource Density
        params {dict} -- a dictionary containing the parameter values for the model
            Parameters:
                a {float} -- Attack rate
                h {float} -- handling time
        data {float} -- the data that Xr is compared against if minimising the difference using lmfit.minimize()

    Returns:
        {float} -- difference in consumption rate between estimate and the data
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
    

    Returns:
        [type] -- Consumption rate
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
                a {float} -- Attack rate
                h {float} -- handling time
                q {float} -- dimensionless exponent
        Xr {float} -- Resource Density
        data {float} -- the data that Xr is compared against if minimising the difference using lmfit.minimize()
    
    Returns:
        {float} -- difference in consumption rate between estimate and the data

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
    """    Calculates the Residual Sum of Squares for an array of model residuals.

    
    Returns:
        {float} -- Residual sum of squares
    """

    RSS = sum(residuals**2)

    return RSS


def est_a(ResDens, NTrait):
    """    Gets an estimate of `a` given the `ResDensity`, `N_TraitsValue` and `h` estimate.  Uses the arguments to progressively eliminate points to a minimum number of points to make a linear regression and takes the slope of the line as the estimate of `a`.  Minimum number of points is 3 or less than 30% of total data points.

    
    Arguments:
        ResDens {float} -- Resource density
        NTrait {float} -- Consumption rate
    
    Returns:
        {float} -- attack rate estimate for data
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



