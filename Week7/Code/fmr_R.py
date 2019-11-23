### Desc: Plots log(field metabolic rate) against log(body mass) for the Nagy et al 1999 dataset to a file fmr.pdf. Based upon the script `fmr.R` and runs it usign python
#!/bin/usr/env python3

"""
Plots log(field metabolic rate) against log(body mass) for the Nagy et al 1999 dataset to a file fmr.pdf.  Is a python version of `fmr.R`.
"""

__appname__ = 'fmr_R.py'
__author__ = 'Donal Burns (db319@ic.ac.uk)'
__version__ = '0.0.1'
__liscense__ = "Apache 2"
###############################################################
import subprocess

subprocess.Popen("Rscript --verbose fmr.R", shell=True).wait()

