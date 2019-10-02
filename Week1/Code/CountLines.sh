#!/bin/bash
# Author: Donal Burns db319@ic.ac.uk 
#Script CountLines.sh
# Desc: Determines how many lines are in a file.
# Arguments: none
# Date: Oct 2019

NumLines=`wc -l < $1`
echo "The File $1 has $NumLines lines"
echo


