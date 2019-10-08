# Week 1 CMEE Course Repositoty
## **Description**
This week covered using the Unix Terminal, shell scripting using bash and how to use Latex to typeset and create a document.  All Code is written to be run from the Code folder.

## Structure
Contains Code with the code produced during this week's class', Data with the data required for the code to run and Results which is where the code will output the resulting file of code if it produces any. This week also contains SandBox which is where

## **Table of Contents**
[**Code**](https://github.com/Don-Burns/CMEECourseWork/tree/master/Week1/Code) - Title of codes with brief description.

```
boilerplate.sh
```
A simple boilerplate for shell scripts.  Prints "This is a shell script!".
```
ConcatonateTwoFiles.sh
```  
Takes two files a merges them. Target of code should be the files to be merged.
```
csvtospace.sh  
```
Takes a comma seperated files and outputs a space seperated file.
```
MyExampleScript.sh  
```
Greets the user twice and starts a new line.
```
tabtocsv.sh
```
Takes a tab seperated file and outputs a comma seperated file.
```
CompileLatex.sh  
```
Used to compile a pdf using a .tex input.  Call the input file without any file extension.  Any bibliography needs to be in .bib format and should be name the same as the input .tex file.
```
CountLines.sh           
```
Determines how many lines are in a file.
```
tiff2png.sh    
```
Takes a .tiff image and converts it to a .png.  
```
variables.sh
```
A script which takes an imput from the user to put in a string and separately takes two numbers adds them together.

[**Data**](https://github.com/Don-Burns/CMEECourseWork/tree/master/Week1/Data)
Where inputs for the code are stored.
Directories:
    fasta           - contains genomic data used as an input for UnixPrac1.txt
    Temperatures    - contains .csv files to be used with csvtospace.sh

[**Results**](https://github.com/Don-Burns/CMEECourseWork/tree/master/Week1/Results)
For any outputs of the code to be placed.

[**SandBox**](https://github.com/Don-Burns/CMEECourseWork/tree/master/Week1/SandBox)
For any testing of code or files.