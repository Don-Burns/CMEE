#!/bin/usr/env python3

"""
Finds all directories which start with uppercase 'C', file and directories which start with either upper or lowercase 'C' and finally all directories which start with  either upper or lowercase 'C'. The results are printed to the terminal as the number of files found in each case.
"""

__appname__ = 'using_os.py'
__author__ = 'Donal Burns (db319@ic.ac.uk)'
__version__ = '0.0.1'
__liscense__ = "Apache 2"


# Use the subprocess.os module to get a list of files and  directories 
# in your ubuntu home directory 

# Hint: look in subprocess.os and/or subprocess.os.path and/or 
# subprocess.os.walk for helpful functions

import subprocess
import re

#################################
#~Get a list of files and 
#~directories in your home/ that start with an uppercase 'C'

# Type your code here:

# Get the user's home directory.
home = subprocess.os.path.expanduser("~")

# Create a list to store the results.
FilesDirsStartingWithC = []
FilesDirsStartingWithCc = []
FilesStartingWithCc = []

# Use a for loop to walk through the home directory.

pattern = ".*C\w*.*\/"
for (dir, subdir, files) in subprocess.os.walk(home):
    tmp = re.findall(re.compile(pattern), dir)
    if len(tmp) >0:
        FilesDirsStartingWithC.append(tmp)
print("Dirs which start with C " + str(len(FilesDirsStartingWithC)))
  
#################################
# Get files and directories in your home/ that start with either an 
# upper or lower case 'C'

# Type your code here:

pattern = ".*[Cc]\w*.*"
for (dir, subdir, files) in subprocess.os.walk(home):
    tmp = re.findall(re.compile(pattern), str(dir))
    if len(tmp) >0:
        FilesDirsStartingWithCc.append(tmp)

print("Dirs and files which start with C or c " + str(len(FilesDirsStartingWithCc)))

#################################
# Get only directories in your home/ that start with either an upper or 
#~lower case 'C' 
# Type your code here:
pattern = "\/[Cc].*\/"
for (dir, subdir, files) in subprocess.os.walk(home):
    tmp = re.findall(re.compile(pattern), str(dir))
    if len(tmp) >0:
        FilesStartingWithCc.append(tmp)
print("Dirs which start with C or c " + str(len(FilesStartingWithCc)))


