#!/bin/usr/env python3

"""

"""

__appname__ = ''
__author__ = 'Donal Burns (db319@ic.ac.uk)'
__version__ = '0.0.1'
__liscense__ = "Apache 2"
#####################################################
import re
my_string = "a given string"

match = re.search(r'\s', my_string)
print(match)

match.group()

match = re.search(r'\d', my_string)
print(match)

MyStr = 'an example'

match = re.search(r'\w*\s', MyStr) # match any number of alpha-numberic charactes up to a white space.

if match: 
    print('found a match', match.group())
else:
    print('did not find a match')

match = re.search(r'2', "it takes 2 to tango")
match.group()


match = re.search(r'\d', "it takes 2 to tango")# find a digit
match.group()

match = re.search(r"\d.*", "it takes 2 to tango") #find everything after a digit
match.group()

match = re.search(r'\s\w{1,3}\s', "once upon a time") # find words 1-3 characters long
match.group()

match = re.search(r'\s\w*$', "once upon a time") # find the last word in a string
match.group()

re.search(r'\w*\s\d.*\d', "take 2 grams of H2O").group() # find a word then digit, then any characters until the next digit then stop

re.search(r'^\w*.*\s', "once upon a time").group() # uses the last space when parsing to match

re.search(r'<.+>', "this is a <EM>first<EM/> test").group()

re.search(r"\d*\.?\d", "1432.75+60.22i").group()

re.search(r"[AGTC]+", "the sequence ATTCGT").group()

re.search(r"\s+[A-Z]\w+\s*\w", "The bird-shit frog's name is Theloderma asper").group()

MyStr = 'Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory'

match = re.search(r"[\w\s]+,\s[\w\.@]+,\s[\w\s]+", MyStr)
match.group()

MyStr = 'Samraat Pawar, s-pawar@imperial.ac.uk, Systems biology and ecological theory'

match = re.search(r"[\w\s]+,\s[\w\.@]+,\s[\w\s]+", MyStr)
# match.group() ## returns NoneType

match = re.search(r"[\w\s]+,\s[\w.-]+,\s[\w\s]+", MyStr)
# match.group()


##### excercises#######
MyStr = 'Samraat Pawar+?, s.pawar@imperial.ac.uk, Systems biology and ecological theory'

match = re.search(r"[\D\s]+,\s[\w\.@]+,\s[\w\s]+", MyStr) #why doesnt "." work
match.group()


# r'^abc[ab]+\s\t\d'            ### start of string, match abc followed by any combo of a and/or b the a space tab and digit
# r'^\d{1,2}\/\d{1,2}\/\d{4}$'  ### from start find 1 to 2 digits in a row , then /, same again then / then 4 in a row  ^ and $ means the whole string needs to match, i.e. only a date
# r'\s*[a-zA-Z,\s]+\s*'         ### any number of spaces, one or more of any letter or , or space, any number of spaces

r'[19]{2}\d{2}\/[01]\d\/[123]\d|[20]{2}\d{2}\/[01]\d\/[123]\d'
r'(19|20)\d\d(1[012])(0[1-9]|[12][0-9]|3[01])'
##Write a regex to match dates in format YYYYMMDD, making sure that:

    # Only seemingly valid dates match (i.e., year greater than 1900)
    # First digit in month is either 0 or 1
    # First digit in day ≤3

re.search(r"[19]{2}\d{2}\/[01]\d\/[123]\d|[20]{2}\d{2}\/[01]\d\/[123]\d","1989/12/31").group()

####GROUPING REGEX PATTERNS#######
MyStr = 'Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory'
match = re.search(r"[\w\s]+,\s[\w\.-]+@[\w\.-]+,\s[\w\s&]+",MyStr)
match.group()

match.group(0) ## <-- what does this do here? normally will show some of the combonations of what is found given they satisfy the regex?

match = re.search(r"([\w\s]+),\s([\w\.-]+@[\w\.-]+),\s([\w\s&]+)",MyStr)


if match:
    print(match.group(0))
    print(match.group(1))
    print(match.group(2))
    print(match.group(3))
    


#################### finding all matches##################################

MyStr = "Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory; Another academic, a-academic@imperial.ac.uk, Some other stuff thats equally boring; Yet another academic, y.a_academic@imperial.ac.uk, Some other stuff thats even more boring"

emails = re.findall(r'[\w\.-]+@[\w\.-]+', MyStr)

for email in emails:
    print(email)

f = open('../data/TestOaksData.csv', 'r')
found_oaks = re.findall(r"Q[\w\s].*\s", f.read())
found_oaks


############Groups within multiple matches###########

MyStr = "Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory; Another academic, a.academic@imperial.ac.uk, Some other stuff thats equally boring; Yet another academic, y.a.academic@imperial.ac.uk, Some other stuff thats even more boring"

found_matches = re.findall(r"([\w\s]+),\s([\w\.-]+@[\w\.-]+)", MyStr)
found_matches

for item in found_matches:
    print(item)

###extracting text from webpages

import urllib3  

conn = urllib3.PoolManager() # open a connection
r = conn.request('GET', 'https://www.imperial.ac.uk/silwood-park/academic-staff/') 

webpage_html = r.data # read in the webpage's contents


My_Data  = webpage_html.decode()
#print(My_Data)


type(webpage_html)

pattern = r"(Dr)\s+([\w'-]+\s+[\w'-]+)|(Prof)+\s+([\w'-]+\s+[\w'-]+)"
regex = re.compile(pattern) # example use of re.compile(): youn can also ignore case with re.IGNORECASE
import scipy as sc
i = 0
nameList = [["Title"], ["Name"]]


###TODO Finish this see notes for details, seperate name list not done 
for match in regex.finditer(My_Data):

    # nameList[0].append(match.group(1))
    
    # nameList[1].append(match.group(2))

    print(match.group(1))
    
    print(match.group(2))



nameList[1] = sc.unique(nameList[1])


#############replace text##############

New_Data = re.sub(r'\t'," ", My_Data) # replace all tabs with a space
# print(New_Data)

