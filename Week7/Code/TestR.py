#!/bin/usr/env python3

"""
Script experimenting with running R scripts with python
"""

__appname__ = ''
__author__ = 'Donal Burns (db319@ic.ac.uk)'
__version__ = '0.0.1'
__liscense__ = "Apache 2"
##################################################

import subprocess
subprocess.Popen("Rscript --verbose TestR.R > ../Results/TestT.Rout 2> ../Results/Results.TestR_errFile.Rout", shell = True).wait()

subprocess.Popen("Rscript --verbose NonExistScript.R > ../Results/outputFile.Rout 2> ../Results/errorFile.Rout", shell=True).wait()


