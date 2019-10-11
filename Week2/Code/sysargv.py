#!/usr/bin/env python3
# Author: Donal Burns (db319@ic.ac.uk)
# Date: Oct 2019
# Desc: A script examining how sys.argv is handeled in Python.

import sys
print("This is the name of the script: ", sys.argv[0])
print("Number of arguments: ", len(sys.argv))
print("The arguments are: ", str(sys.argv))

