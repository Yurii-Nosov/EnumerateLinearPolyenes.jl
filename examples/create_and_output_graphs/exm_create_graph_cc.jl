using EnumerateLinearPolyenes

#  Example of generating a molecular graph without  hydrogen atoms


# Elements of a molecular graph without hydrogen atoms:
# cc_edges  -  edge list of the central chain of the graph (list of C-C edges) 
# c_x_coords - A list of the x-coordinates of the vertices of the central
#              chain (C X-coordinates)
# c_y_coords -  A list of the x-coordinates of the vertices of the central
#               chain (C Y-coordinates)
#---------------------------------------------------------------------
#   Generating a molecular graph without  hydrogen atoms  =================

vertex_code = [0,1,0,1,0,1,0,1]   #  Graph vertex code
cc_edges, c_x_coords, c_y_coords, = create_carbon_chain(vertex_code)

# Output of elements of a molecular graph without hydrogen atoms to the terminal

println("cc_edges  \n",cc_edges)
println("c_x_coords \n ",c_x_coords)
println("c_y_coords  \n",c_y_coords)
