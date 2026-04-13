using EnumerateLinearPolyenes

#  An example of generating molecular graph codes using functions 
# from the GenCodeUniversal module

# Generating molecular graph codes for isomers of order n

n = 8   #   graph order
graph_type = 1  # Graph type: "isomers"

lstbcd = collect(gen_codes_graphs_type(n, graph_type))
println("  lstbcd    \n ",lstbcd)  # Outputting a list of codes to the terminal


# Generation of codes for molecular graphs of conformers of trans‑isomers of order n.

graph_type = 2  #  Graph type - "conformers of trans-isomers"
lstbcd = collect(gen_codes_graphs_type(n, graph_type))
println("  lstbcd    \n ",lstbcd)    # Outputting a list of codes to the terminal

# Generation of codes for molecular graphs of conformers of other isomers of order n.

graph_type = 3  # Graph type - "conformers of other isomers"
lstbcd = collect(gen_codes_graphs_type(n, graph_type))
println("  lstbcd    \n ",lstbcd)    # Outputting a list of codes to the terminal

# Generating molecular graph codes for conformers of other n-order isomers

lstbcd = collect(gen_codes_graphs_coiso(n))
println("  lstbcd    \n ",lstbcd)    # Outputting a list of codes to the terminal

# Generation of Yeh's molecular graph codes of order n

lstbcd = collect(gen_codes_yeh_graphs(n))
println("  lstbcd    \n ",lstbcd)      # Outputting a list of codes to the terminal