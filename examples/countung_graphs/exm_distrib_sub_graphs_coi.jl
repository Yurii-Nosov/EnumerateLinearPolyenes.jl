using EnumerateLinearPolyenes


#  Example of calculating the distribution of the number of molecular graphs of 
#   conformer subtypes of other isomers distinguished by the presence 
#   (or absence) of cisoid chains.
#------------------------------------------------------------------------------
# This program calculates the distribution of the number of molecular graphs of subtypes
# of conformers of other isomers, distinguished by the presence (or absence) of cisoid 
#--------------------------------------------------------------------------------------- 
# paths. Recall that a cisoid path is a path with 3 or 4 consecutive edges with a 
# cis-configuration. The number of consecutive edges with a cis-configuration is called
#  the length of the cisoid chain.
# There are 4 such subtypes:
# - the first subtype - graphs without cisoid chains of length 3 (without_cis3);
# - the second subtype - graphs with cisoid chains of length 3 (with_cis3);
#- the third subtype: graphs without cisoid paths of length 4 (without_cis4);
#-------------------------------------------------------------------------
#- the fourth subtype: graphs with cisoid paths of length 4 (with_cis4).
#-------------------------------------------------------------------------
# The calculation results are output as a table in the VS Code terminal and in the text
# file DistribNumbSubGraphsCOI.txt.
#-------------------------------------------------------------------------
# The table consists of five columns with the following headings: "n" (the order of 
# the graphs), "without_cis3", "with_cis3", "without_cis4"#", "with_cis4", and "Total_coi".


n_start = 6   #  initial value of the range for changing the graph order
n_end = 30    #  end value of the range for changing the graph order
dirpath = "C:\\Julia_results\\Distribution_of_molecular_graphs\\"  # path to the file folder                                                                    
fname = "DistribNumbSubGraphsCOI"  #  file name without extension

if !isdir(dirpath)
    mkpath(dirpath)
end

save_count_other_conformers_range(n_start, n_end,dirpath,fname)
