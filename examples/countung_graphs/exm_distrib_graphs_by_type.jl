using EnumerateLinearPolyenes

#   Example of calculating the distribution of the number of molecular 
#   graphs by graph type
#-----------------------------------------------------------------
# This program calculates the distribution of the number of molecular 
# graphs by graph type. The results are output as a table to the 
# terminal and to a text file.
#-------------------------------------------------------------------
# The table consists of five columns with the following headings: n (graph order),
# isomers, con _trans _iso, con _other_iso, Total.
#----------------------------------------------------------------------------
n_start = 6   #   initial value of the range for changing the graph order
n_end = 30   #   end value of the range for changing the graph order

dirpath = "C:\\Julia_results\\Distribution_of_molecular_graphs\\"  # # path to the file folder
fname = "DistribNumberMolGraphs"   # file name without extension

if !isdir(dirpath)
    mkpath(dirpath)
end

save_count_codes_range_edge(n_start, n_end, dirpath, fname)