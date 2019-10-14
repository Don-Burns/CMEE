#!/bin/bash
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