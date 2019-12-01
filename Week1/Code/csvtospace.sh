#!/bin/bash
# Author: Donal Burns db319@ic.ac.uk 
# Script csvtospace.sh
# Desc: marges two files into one using concatonate function.
# Arguments: Name of Folder containing files to be coverted.
# Date: Oct 2019
if [ -z "$1"]
    then
        echo "No arguments given.  Default used" 
        set -- "../Data/spawannxs.txt"
fi 


echo "Creating a space separated version of $1"
cat $1 | tr -s "," " " >> "$1_spaced".csv
newfile=$"$1_spaced".csv
mv $newfile ../Results
echo "DONE!"

exit


