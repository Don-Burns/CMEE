#!/bin/bash
# Desc: a code to take a `C` script and set the `.out` file name and ensure it runs with -Wall to catch error and warnings

gcc -Wall -o"${1//.c}".out $1

error=$?

if [ $error != 0 ]
    then 
        echo " Fix erors to obtain output"
    else
        ./"${1//.c}".out
fi