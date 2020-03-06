# Mini Project
## **Description**
This repository contains the mini project produced as part of the Computational Methods in Ecology and Evolution Msc at Imperial College London.  

The goal of the project was to take functional response data, fit a number of models and write a report describing the results obtained while tying it all into the biology of the consumers.  

The whole process and be started locally if this repository is clone and the `run_miniproject.sh` bash script run.  `run_miniproject.sh` can be found in the [`Code`](https://github.com/Don-Burns/CMEECourseWork/tree/master/MiniProject/Code) folder.  No other inputs will be need and the results, including the finished report, will be save to the results folder within the local version of the repository.

## **Structure**
* All data and code needed to create the report can be found in [`data`](https://github.com/Don-Burns/CMEECourseWork/tree/master/MiniProject/data) and [`Code`](https://github.com/Don-Burns/CMEECourseWork/tree/master/MiniProject/Code) rescpectively.
* All code outputs will be saved into [`Results`](https://github.com/Don-Burns/CMEECourseWork/tree/master/MiniProject/Results)

## **Table of Contents**
[**Code**](https://github.com/Don-Burns/CMEECourseWork/tree/master/MiniProject/Code)

Contains all the code necessary for the project.
* `analysis.R` - R script to perform the analysis of the fits. 
    
    Outputs:
    * `ResultsRaw.csv` - Results of all model fits in count form.
    * `ResultsPercent.csv` - Results of all model fits in percentage form.

* `fitting.py` - Takes data from `Crat.csv`, fits models to the data and outputs the fitted parameter estimates.
    
    Outputs:
    * `CModResults.csv` - results of type II functional response model fits.
    * `CQModResults.csv` - results of generalised functional response model fits.
    * `poly2ModResults.csv` - results of quadratic model fits.
    * `poly3ModResults.csv` - results of cubic model fits.

* `functions.py` - contains all functions needed to run `.py` script in [`Code`](https://github.com/Don-Burns/CMEECourseWork/tree/master/MiniProject/Code).

    

* `mechanisticAnalysis.R` - R script to perform the analysis of only the mechanistic model fits
    
    Outputs:
    * `MechanisticResultsRaw.csv` - Results of only mechanistic model fits in count form.
    * `MechanisticResultsPercent.csv` - Results of only mechanistic model fits in percentage form.

* `plotting.py` - Outputs plots of all the fits and plots needed for `Report.tex`

    Outputs:
    * `FittedPlots.pdf` - Results of all plots.
    * `dataSample.pdf` - A results sample from `fittedPlots.pdf` to use in `Report.tex`
    * `functionResponses.pdf` - Plot showing the three functional reponse types.
    * `misbehaving_cubic.pdf` - Used in `Report.tex`.

* `Report.tex` - Code for the `latex` report.
    
    Outputs:
    * `Report.pdf` in [`Results`](https://github.com/Don-Burns/CMEECourseWork/tree/master/MiniProject/Results)

* [`report`](https://github.com/Don-Burns/CMEECourseWork/tree/master/MiniProject/Code/report) - contains any file other than plots need to compile `Report.pdf`.

* `run_Miniproject.sh` - Will automatically run all scripts and clean up and junk files generated.


[**Data**](https://github.com/Don-Burns/CMEECourseWork/tree/master/MiniProject/data)
* `CRat.csv` - Contains the data used to perform the fitting
* `BiotraitsTemplateDescription.pdf` - Meta data for `CRat.csv`.


[**Results**](https://github.com/Don-Burns/CMEECourseWork/tree/master/MiniProject/Results)

An empty folder where the results of the fitting, graph produced for each ID in `data/CRat.csv` and graphs required to compile the `Report.pdf`.


[**Sandbox**](https://github.com/Don-Burns/CMEECourseWork/tree/master/MiniProject/sandbox)

Contains old or depreciated code or files that are no longer needed to run the project.  
Additonally, some jupyter notebooks explaining the thought process and how some of the code was constructed are stored here.