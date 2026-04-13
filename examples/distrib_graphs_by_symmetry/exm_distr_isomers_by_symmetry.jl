using EnumerateLinearPolyenes

# Example of calculating the distribution of molecular graphs of isomers of 
# orders from 6 to 30 by symmetry groups


#   Calculation of the distribution of molecular graphs of isomers of orders 
# from 6 to 30 by symmetry groups

graphs_type = 1   #  Graph type: "isomers"
orders = 6:2:30   #  Range of variation in the order of molecular graphs

list_result = count_graphs_by_symmetry_range(graphs_type, orders)

# Output of the obtained results of graph distribution to the terminal 
# and to the text file DistribNumberIsomersBySymmetry.txt.

dirpath = "C:\\Julia_results\\Distrib_molecular_graphs_by_symmetry\\"
fname = " DistribNumberIsomersBySymmetry"

if !isdir(dirpath)
    mkpath(dirpath)
end

output_graphs_by_symmetry_range(list_result,graphs_type, dirpath, fname)