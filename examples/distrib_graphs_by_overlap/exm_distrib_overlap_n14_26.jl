using EnumerateLinearPolyenes

#  An example of calculating the distribution of Yeh's molecular graphs by the number
# of pairs of vertex overlaps
#---------------------------------------------------------------
#  This program calculates and outputs Yeh's graph distributions of orders 14 
#   through 26 inclusive in the VS Code terminal. The results were copied from the 
#  terminal and saved in the text file ResultDistribYehGraphsOverlapN12-26txt.

println("*****  n = 14  *********")
lstBcd = collect(gen_codes_yeh_graphs(14)) 
# println(" lstBcd   \n ",lstBcd) 
graph_order,distr_overlap14 = calc_distr_all_graphs_overlap(lstBcd)
# println(" distr_overlap14 \n",  distr_overlap14 )
output_distr_all_graphs_overlap(graph_order,distr_overlap14)
#---------------------------------------------------------------
println("*****  n = 16  *********")
lstBcd = collect(gen_codes_yeh_graphs(16)) 
# println(" lstBcd   \n ",lstBcd) 
graph_order,distr_overlap16 = calc_distr_all_graphs_overlap(lstBcd)
#println(" distr_overlap16 \n",  distr_overlap16 )
output_distr_all_graphs_overlap(graph_order,distr_overlap16)
#---------------------------------------------------------------
println("*****  n = 18  *********")
lstBcd = collect(gen_codes_yeh_graphs(18)) 
# println(" lstBcd   \n ",lstBcd) 
graph_order,distr_overlap18 = calc_distr_all_graphs_overlap(lstBcd)
# println(" distr_overlap18 \n",  distr_overlap18 )
output_distr_all_graphs_overlap(graph_order,distr_overlap18)
#---------------------------------------------------------------
println("*****  n = 20  *********")
lstBcd = collect(gen_codes_yeh_graphs(20)) 
# println(" lstBcd   \n ",lstBcd) 
graph_order,distr_overlap20 = calc_distr_all_graphs_overlap(lstBcd)
#println(" distr_overlap20 \n",  distr_overlap20 )
output_distr_all_graphs_overlap(graph_order,distr_overlap20)
#---------------------------------------------------------------
println("*****  n = 22  *********")
lstBcd = collect(gen_codes_yeh_graphs(22)) 
# println(" lstBcd   \n ",lstBcd) 
graph_order,distr_overlap22 = calc_distr_all_graphs_overlap(lstBcd)
# println(" distr_overlap22 \n",  distr_overlap22 )
output_distr_all_graphs_overlap(graph_order,distr_overlap22)
#---------------------------------------------------------------
println("*****  n = 24  *********")
lstBcd = collect(gen_codes_yeh_graphs(24)) 
# println(" lstBcd   \n ",lstBcd) 
graph_order,distr_overlap24 = calc_distr_all_graphs_overlap(lstBcd)
# println(" distr_overlap24 \n",  distr_overlap24 )
output_distr_all_graphs_overlap(graph_order,distr_overlap24)
#---------------------------------------------------------------
println("*****  n = 26  *********")
lstBcd = collect(gen_codes_yeh_graphs(26)) 
# println(" lstBcd   \n ",lstBcd) 
graph_order,distr_overlap26 = calc_distr_all_graphs_overlap(lstBcd)
# println(" distr_overlap26 \n",  distr_overlap26 )
output_distr_all_graphs_overlap(graph_order,distr_overlap26)
