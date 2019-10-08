#!/bin/bash
# Author: Donal Burns db319@ic.ac.uk 
# Script csvtospace.sh
# Desc: marges two files into one using concatonate function.
# Arguments: Name of Folder containing files to be coverted.
# Date: Oct 2019



echo "Creating a space separated version of $1"
cat $1 | tr -s "," " " >> ../Results/"$1_spaced".csv
echo "DONE!"

exit



# where does samrat what the output to be saved?