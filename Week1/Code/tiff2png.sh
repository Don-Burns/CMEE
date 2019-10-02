#!/bin/bash# Author: Donal Burns db319@ic.ac.uk 
# Author: Donal Burns db319@ic.ac.uk 
# Script tiff2png.sh
# Desc: Takes a .tiff image and converts it to a .jpeg
# Arguments: none
# Date: Oct 2019

##CHECK for jpg or png for output
for f in *.tif;
    do
        echo "Converting $f";
        convert "$f" "$(basename "$f" .tiff).jpg; 
    done
