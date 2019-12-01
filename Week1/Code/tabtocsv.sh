#!/bin/bash
# Author: Donal Burns db319@ic.ac.uk 
# Script tabtocsv.sh
# Desc: Substitute the tabs in the files with commas
# Saves the output into a .csv file
# Arguments: 1 -> tab delimited file 
# Date: Oct 2019

if [ -z "$1"]
    then
        echo "No arguments given.  Default used" 
        set -- "../SandBox/test.txt"
fi 

echo "Creating a comma delimited version of $1 ..."
cat $1 | tr -s "\t" "," >> $1.csv

echo "Done!  Output saved in $1.csv"

exit