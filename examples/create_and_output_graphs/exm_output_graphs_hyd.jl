using EnumerateLinearPolyenes


#  Example of displaying images of molecular graphs with hydrogen atoms based 
#  on a list of vertex codes



#  Generating a list of vertex codes for molecular graphs of isomers

n = 8 #   #  Order of molecular graphs.
ctype = 1  #  Vertex code used
list_vertex_code = generate_isomer_vertex(n)

# Displaying images of molecular graphs of isomers

dirpath = "C:Julia_results\\Figures\\Isomers\\"

if !isdir(dirpath)
    mkpath(dirpath)
end

print_list_graphs_hyd(list_vertex_code,dirpath)
# ------------------------------------------------------------

# Generating a list of vertex codes for molecular graphs of trans-isomer conformers

list_vertex_code = generate_trans_conformer_vertex(n)

# Displaying images of molecular graphs of trans-isomer conformers

dirpath = "C:Julia_results\\Figures\\Conformers\\"

if !isdir(dirpath)
    mkpath(dirpath)
end

print_list_graphs_hyd(list_vertex_code,dirpath)
# ------------------------------------------------------------






