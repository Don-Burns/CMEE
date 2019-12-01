#!/bin/bash
# Author: Donal Burns db319@ic.ac.uk 
# Script ConcatonateTwoFiles.sh
# Desc: merges two files into one using concatonate function.
# Arguments: none
# Date: Oct 2019

if [ -z "$1"]
    then
        echo "No arguments given.  Default used" 
        file1=../Data/concatfile.txt
        file2=../Data/concatfile.txt
        file3=../Data/concatedfile.txt

    else
        file1=$1
        file2=$2
        file3=$3
        
fi 


cat $file1 > $file3
cat $file2 >> $file3

echo "Merged File is"

cat $file3

mv $file3 ../Results/ 

echo "Saved in ../Results."

# cat $1 > $3
# cat $2 >> $3

# echo "Merged File is"

# cat $3

# mv $3 ../Results/ 

# echo "Saved in ../Results."
