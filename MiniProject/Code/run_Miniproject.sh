#!/usr/bin/env bash

# author: Donal Burns
# Date: 06/03/2020
###############################################################################


# run the 3 fits in "parallel"
python3 fitting.py

# run plotting on the outputs
python3 plotting.py

# run analysis
Rscript analysis.R
Rscript mechanisticAnalysis.R
# compile the report
texcount -1 -sum Report.tex > ./report/Report.sum
pdflatex Report.tex
pdflatex Report.tex
bibtex Report
pdflatex Report.tex
pdflatex Report.tex
# remove junk files produced 
sleep 5s # force a pause to ensure the files are removed, without they are left behind for some reason
rm Report.aux
rm Report.bbl
rm Report.blg
rm Report.log
rm Report.out
rm Report.toc
rm Report.dvi
rm Report.gz
rm Report.fls
rm Report.fdb_latexmk
rm Report.synctex.gz

mv Report.pdf ../Results/