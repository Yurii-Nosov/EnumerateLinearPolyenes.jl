using EnumerateLinearPolyenes

#  Example of generating a molecular graph with  hydrogen atoms


# Elements of a molecular graph with hydrogen atoms:
# cc_edges  -  edge list of the central chain of the graph (list of C-C edges)
# ch_edges -   C-H edges a list of edges extending from the vertices of the central
#               chain to the pendant vertices (list of C-H edges)
# c_x_coords - A list of the x-coordinates of the vertices of the 
#              central chain (C X-coordinates)
# c_y_coords -  A list of the x-coordinates of the vertices of the
#               central chain (C Y-coordinates)
# h_x_coords -  A list of the x-coordinates of the pendant vertices
# h_y_coords - A list of the y-coordinates of the pendant vertices
#-------------------------------------------------------------------
#   Generating a molecular graph with hydrogen atoms  =================

vertex_code = [0,1,0,1,0,1,0,1]   #  Graph vertex code

cc_edges, ch_edges, c_x_coords, c_y_coords, h_x_coords, h_y_coords = 
create_hydrogen_tree(vertex_code)

# Output of elements of a molecular graph without hydrogen atoms to the terminal

println("cc_edges  \n",cc_edges)
println("ch_edges   \n ",ch_edges) 
println("c_x_coords \n ",c_x_coords)
println("c_y_coords  \n",c_y_coords)
println("h_x_coords  \n ",h_x_coords)
println("h_y_coords   \n ",h_y_coords)