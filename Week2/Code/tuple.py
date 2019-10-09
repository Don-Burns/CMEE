birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
        )

# Birds is a tuple of tuples of length three: latin name, common name, mass.
# write a (short) script to print these on a separate line or output block by species 
# Hints: use the "print" command! You can use list comprehensions!
n = 1
tags = ["Species:", "Common Name:", "Mass:"]

for species in birds:
    print("---Species " + str(n) + "---")
    for entry in species:
        for tags in entry:
            print(tags + entry)

    print("\n")
    n = n + 1
