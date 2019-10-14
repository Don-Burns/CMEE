""" takes a file '../data/testcsv.csv' and writes a file to ../Results called bodymass.csv  which contains only the species name and body mass"""


import csv

# Read a file containing:
# 'Species, 'Infraorder', 'Family, ' Distribution', 'Body mass male'
f = open('../data/testcsv.csv', 'r')

csvread = csv.reader(f)
temp = []
for row in csvread:
    temp.append(tuple(row))
    if row[0] == "Species":
        print("Data layout:")
        print(str(row) + "\n")
        
    else:    
        print("The species is", row[0])
        print(str(row) + "\n")
    
f.close()

# write a file containing only species name and Body mass
f = open('../data/testcsv.csv', 'r')
g = open('../data/bodymass.csv', 'w')

csvread = csv.reader(f)
csvwrite = csv.writer(g)
for row in csvread:
    print(row)
    csvwrite.writerow([[row[0]], row[4]])
print("\n\nFile has been saved as 'bodymass.csv' within /data \n")
f.close()
g.close()