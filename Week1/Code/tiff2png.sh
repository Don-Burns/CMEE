#!/bin/bash
# Author: Donal Burns db319@ic.ac.uk 
# Script tiff2png.sh
# Desc: Takes a .tiff image and converts it to a .png
# Arguments: none
# Date: Oct 2019


for f in ../Data/*.tiff;
    do
        echo "$f"
        echo "Converting $f";
        convert "$f" "$(basename "$f" .tiff).png"; 
    done

mv *.png ../Results;