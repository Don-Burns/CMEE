#!/bin/bash
# Author: Donal Burns db319@ic.ac.uk 
# Script variables.sh
# Desc: a script which takes an input from the user to put in a string and separately takes two numbers adds them together.
# Arguments: none
# Date: Oct 2019



#Shows the use of variables

MyVar="some string"
echo "the current value of the variable is" $MyVar
echo "Please enter a new string"
read MyVar
echo " the current value of the varriable is"$MyVar

## Reading multiple values
echo " Enter two numbers separated by space(s)"
read a b 
echo "you entered" $a "and" $b ". Their sum is:"
mysum=`expr $a + $b`
echo $mysum






