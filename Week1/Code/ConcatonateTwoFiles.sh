#!/bin/bash
# Author: Donal Burns db319@ic.ac.uk 
# Script ConcatonateTwoFiles.sh
# Desc: merges two files into one using concatonate function.
# Arguments: none
# Date: Oct 2019

cat $1 > $3
cat $2 >> $3

echo "merged File is"

cat $3

