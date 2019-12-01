#!/bin/bash
# Author: Donal Burns db319@ic.ac.uk 
# Script CountLines.sh
# Desc: Determines how many lines are in a file.
# Arguments: any file, otherwise deafult is used
# Date: Oct 2019

if [ -z "$1"]
    then
        echo "No arguments given.  Default used" 
        set -- "../SandBox/test.txt"
fi 

NumLines=`wc -l < $1`
echo "The File $1 has $NumLines lines"
echo


