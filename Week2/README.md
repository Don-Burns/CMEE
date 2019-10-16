# Week 2 CMEE Course Repository   

## Structure  
Contains [`Code`](https://github.com/Don-Burns/CMEECourseWork/tree/master/Week2/Code) with the code produced during this week's class', [`Data`](https://github.com/Don-Burns/CMEECourseWork/tree/master/Week2/Data) with the data required for the code to run and [`Results`](https://github.com/Don-Burns/CMEECourseWork/tree/master/Week2/Results) which is where the code will output the resulting file of code if any is produced. This week also contains [`SandBox`](https://github.com/Don-Burns/CMEECourseWork/tree/master/Week2/SandBox) which is where simpler concepts are tested. 

## **Table of Contents**
### [**Code**](https://github.com/Don-Burns/CMEECourseWork/tree/master/Week2/Code) - List of codes with brief descriptions.
```
basic_csv.py
```
takes a file `../data/testcsv.csv` and writes a file to `../Results` called bodymass.csv  which contains only the species name and body mass

```
basic_io3.py
```
Creates a binary file `../testp.p` containing a dictionary with 2 keys.

```
control_flow.py
```
Some functions exemplicfying the use of control statements.

```
oaks.py
```
  Finds just those taxa that are oak trees from a list of species

```
align_seqs_fasta.py
```
A programme which takes two genetic sequences and aligns them to provide the best direct match possible.
It will run even if no inputs are given using short examples sequences, by using files `407228326.fasta` and `407228412.fasta` found within `../data/fasta` 

```
lc1.py
```
  A script taking birds latin names, common names and body mass and outputting them alone.

```
basic_io2.py
```
Takes# `../sandbox/testout.txt` and adds new lines at the end of each line.

```
boilerplate.py
```
Description of this program or application.  You can use several lines.

```
scope.py
```
A script looking at how global and local funtions are handled inside and outside functions.

```
loops.py
```
  A script practicing use of FOR loops in Python

```
sysargv.py
```
  A script examining how sys.argv is handeled in Python.

```
lc2.py
```
  A script examining how sys.argv is handeled in Python.

```
tuple.py
```
  A script taking a tuple containing tuples with the latin name, common name and body mass of various bird species.  

```
oaks_debugme.py
```
A program which parses a list and takes all members of the 'Quercuss' genus and saves them to a sperate file in `../data`.

```
using_name.py
```
  A script looking at how __main__ is handled in python.

```
align_seqs_better.py
```
A programme which takes two genetic sequences and aligns them to provide the best direct match possible.
It will run even if no inputs are given using short examples sequences, by using files `407228326.fasta` and `407228412.fasta` found within `../data/fasta`.  Uses `pickle` to speed up the allignment for very large files.

```
cfexercises2.py
```
A series of tests looking at how python does some simple calculations and printing a result if they meet various criterea.

```
dictionary.py
```
  A script taking a list with species stored with their order as a tuple in a list. It creates a dictionary mapping orders as keys and species as values to their respective orders.

```
basic_io1.py
```
Takes a file prints it then removes blank lines and outputs to the terminal.

```
cfexercises1.py
```
A test of writting simple function to execute simple operation on a number, or list of numbers.

```
align_seqs.py
```
A programme which takes two genetic sequences and aligns them to provide the best direct match possible.
It will run even if no inputs are given using short examples sequences, by using align_seqs.csv found within `../data`.

```
debugm.py
```
A script for experimenting with debugging in python.

```
test_control_flow.py
```
A script to test how to write and use doctests using some functions exemplicfying the use of control statements.

### [**Data**](https://github.com/Don-Burns/CMEECourseWork/tree/master/Week2/Data)  
Where inputs for the code are stored.

### [**SandBox**](https://github.com/Don-Burns/CMEECourseWork/tree/master/Week1/SandBox)  
For any testing of code or files.