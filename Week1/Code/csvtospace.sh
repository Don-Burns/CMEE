#!/bin/bash
# Author: Donal Burns db319@ic.ac.uk 
# Script csvtospace.sh
# Desc: marges two files into one using concatonate function.
# Arguments: Name of Folder containing files to be coverted.
# Date: Oct 2019

cd /home/$USER/Documents/TheMulQuaBio/data/Temperatures

$2 = _spaced

echo "Creating a space separated version of $1"
cat $1 | tr -s "," " " >> $1$2.csv
echo "DONE!"

exit







# echo " creating a comma delimited version of $1 ..."
# cat $1 | tr -s "\t" "," >> $1.csv

# echo "Done!"

# exit
