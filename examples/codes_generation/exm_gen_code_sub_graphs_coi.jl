using EnumerateLinearPolyenes


# An example of generating vertex codes for molecular graphs subtype of conformers trans isomers

# Generation of vertex codes for graphs without cisoid paths of length 3 or more

n = 6
lstbcd = generate_coi_non_cis3p(n)
println("lstbcd  \n",lstbcd)

# Generation of vertex codes for graphs with cisoid paths of length 3

n = 8
lstbcd = generate_coi_cis3(n)
println("lstbcd  \n",lstbcd)

# Generation of vertex codes for graphs with cisoid paths of length 4 or more

n = 10
lstbcd = generate_coi_cis4p(n)
println("lstbcd  \n",lstbcd)


#  Generation of molecular graphs of a given subtype of conformers of other isomers


# Generation of vertex codes for graphs without cisoid paths of length 3 or more


n = 8
target_subtype= 1 #  Specified graph subtype
lstbcd = gen_coi_subtype_edge(n,target_subtype)
println("lstbcd  \n",lstbcd)

# Generation of vertex codes for graphs with cisoid paths of length 3

n = 8
target_subtype = 2  #  Specified graph subtype
lstbcd =gen_coi_subtype_edge(n,target_subtype)
println("lstbcd  \n",lstbcd)

# Generation of vertex codes for graphs with cisoid paths of length 4 or more

n = 8
target_subtype = 3  #  Specified graph subtype
lstbcd =gen_coi_subtype_edge(n,target_subtype)
println("lstbcd  \n",lstbcd)