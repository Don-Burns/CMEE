# Week 3 CMEE Course Repository   

## Structure  
Contains [`Code`](https://github.com/Don-Burns/CMEECourseWork/tree/master/Week3/Code) with the code produced during this week's class', [`Data`](https://github.com/Don-Burns/CMEECourseWork/tree/master/Week3/Data) with the data required for the code to run and [`Results`](https://github.com/Don-Burns/CMEECourseWork/tree/master/Week3/Results) which is where the code will output the resulting file of code if any is produced. This week also contains [`SandBox`](https://github.com/Don-Burns/CMEECourseWork/tree/master/Week3/SandBox) which is where simpler concepts are tested. 

## **Table of Contents**
### [**Code**](https://github.com/Don-Burns/CMEECourseWork/tree/master/Week3/Code) - List of codes with brief descriptions.
```
GPDD_Data.R
```
  A script which takes Global Population Dynamics Database (GPDD) data and maps it.


```
DataWrang.R
```
  A script looking at methods to take filed data and convert it to a form that is more suitable for analysis.

```
TAutoCorr.tex
```
 A first of typesetting a dcoument using latex.

```
MyBars.R
```
  A script to experiment with layering bar charts using gg plot

```
preallocate.R
```
  A function looking at the speed difference between preallocating memory and not doing so.  Variable "size" can be changed to vary size of the allocation.


```
TreeHeight.R
```
  This Function calculates heights of tree given  distance of each from its base and angle to its top, using trigonometric formula

```
boilerplate.R
```
  A boilerplate R script.


```
next.R
```
  A script looking at how "next" is used.

```
break.R
```
 A script looking at how to break out of a loop using the "break" funtion.

```
plotLin.R
```
  A script to make the data for and plot a linear regression using ggplot



```
control_flow.R
```
  A script experimenting with how control flow tools are used in R.

```
apply1.R
```
  script looking at how to use "*apply" functions.

```
Vectorize2.R
```
  A challenge to reduce the runtime of a script which applies the Ricker model to some data.

```
Vectorize1.R
```
  A script looking at vectorisation in R

```
Girko.R
```
  a script to plot two dataframes by using Girko's circular Law as an example. /nSaves the output to `../Results/Girko.pdf`

```
sample.R
```
  A script looking at how to use sampling and the speed of various methods using *apply or not.

```
PP_Lattice.R
```
  A script to make three plots of `../data/EcolArchives-E089-51-D1.csv`, showing prey mass, predator mass and the size ratio between the two, all by feeding type.  It will also save the log of the mean of all three values by feeding type

```
try.R
```
  A script to look at the use of debugging options in R.

```
Ricker.R
```
   A script which runs a non-stochastic version of the Ricker model 

```
TAutoCorr.R
```
   A script finding the correlation between Temperature change across years. \n Input Data in a style such as that found in `../data/KeyWestAnnualMeanTemperature.RData` with the same headers\n Output A graph showing the correlation of temperature changes over years vs if the same data were just chosen in a random order without time having any influence.


```
apply2.R
```
  A script experimenting with *apply functions in R

```
PP_Regress.R
```
 A script to make a regression, create a graph to match a pre-made example as closely as possible and save the key data generated to a `csv`

```
run_get_TreeHeight.sh
```
 A short script to run and test `get_TreeHeight.R` and `get_TreeHeight.py`

```
DataWrangTidy.R
```
  A script looking at methods to take filed data and convert it to a form that is more suitable for analysis.  All done using dplyr and tidyr

```
get_TreeHeight.R
```
  This script calculates heights of tree given  distance of each from its base and angle to its top, using trigonometric formula and writes a new file with the heights of the tree appended. \nInput Realtive directory to .csv file containing species names, distance from tree in meters and angle to top of each tree in degress./nOutput File named InputFileName"_Treeheight.csv"

### [**Data**](https://github.com/Don-Burns/CMEECourseWork/tree/master/Week3/Data)  
Where inputs for the code are stored.

### [**SandBox**](https://github.com/Don-Burns/CMEECourseWork/tree/master/Week1/SandBox)  
For any testing of code or files.