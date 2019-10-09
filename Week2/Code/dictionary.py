taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]

# Write a short python script to populate a dictionary called taxa_dic 
# derived from  taxa so that it maps order names to sets of taxa. 
# E.g. 'Chiroptera' : set(['Myotis lucifugus']) etc. 

taxa_dic = {}

for entry in taxa:
        if entry[1] not in taxa_dic.keys():  ##if not on keys add new key and new species
                taxa_dic[entry[1]] = [entry[0]]



        elif entry[1] in taxa_dic.keys():     ##else find matching key and add the species
                taxa_dic[entry[1]].append(entry[0])

# print(taxa_dic)

for i in taxa_dic.keys():
        print(i + ":\t" + str(taxa_dic[i]))
        # print(taxa_dic[i])


