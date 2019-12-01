#!/bin/bash
# Author: Donal Burns db319@imperial.ac.uk
# Script: CompileLatex.sh
# Desc: Used to compile a pdf using a .tex input.  Call the input file without any file extension.  Any bibliography needs to be in .bib format and should be name the same as the input .tex file.
# Arguments: .tex file name, name before extension should match. E.g. FirstExample, will compile document using FirstExample.tex


# Date: Oct 2019

# give a default file to work with if no file is given.

if [ -z "$1"]
    then
        echo "No file given.  Default will be used."
        set -- "FirstExample"
fi 



pdflatex $1.tex
pdflatex $1.tex
bibtex $1
pdflatex $1.tex
pdflatex $1.tex
mv $1.pdf ../Results ## move file to results folder in week 1
filename=$(basename $1)
echo ../Results/$filename
evince ../Results/$filename.pdf &   ## opens file from ../Results

## Cleanup
rm *~
rm *.aux
rm *.dvi
rm *.log
rm .log
rm *.nav
rm *.out
rm *.snm
rm *.toc
rm *.bbl
rm *.blg
rm *.fdb* ##produced a _latex file
rm *.fls
rm *.synctex.gz



echo "Done! Saved in: ../Results"


exit 