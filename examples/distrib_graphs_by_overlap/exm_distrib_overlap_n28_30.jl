using EnumerateLinearPolyenes

#    An example of calculating the distribution of Yeh's molecular graphs by the number
# of pairs of vertex overlaps. Uses more powerful tools from the DistribGraohsOverlapping module.


#   This program calculates and outputs the Yeh's graph distribution of order
#  28 in the VS Code terminal. The results were copied from the terminal and 
#  saved in the text file ResultDistribYehGraphsOverlapN28.txt.

println("*****  n = 28  *********")    
lstBcd = collect(gen_codes_yeh_graphs(28))
level = 1;  npr = 500000
distr_vector, sum_distr, prc_nia_nul, prc_nia_ss = 
distribution_graphs_overlap(lstBcd,level,npr)
output_distr_all_graphs_overlap(distr_vector)


#   This program calculates and outputs the Yeh's graph distribution of order
#  30 in the VS Code terminal. The results were copied from the terminal and 
#  saved in the text file ResultDistribYehGraphsOverlapN30.txt. 

println("*****  n = 30  *********")
lstBcd = collect(gen_codes_yeh_graphs(30))
level = 1;  npr = 500000
distr_vector, sum_distr, prc_nia_nul, prc_nia_ss = 
distribution_graphs_overlap(lstBcd,level,npr)
output_distr_all_graphs_overlap(distr_vector)