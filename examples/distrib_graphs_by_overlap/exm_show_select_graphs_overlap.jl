using EnumerateLinearPolyenes

# An example of displaying images of Yeh's molecular graphs with a number of 
# overlap pairs of vertices no less than a specified npf value.

# Function used
#   show_select_graphs_overlap(list_vertex_code,npf, nglob,dirpath,fname)

# Displays molecular graphs with at least a specified number of vertex overlap pairs.    
# Arguments
#- `list_vertex_code::Vector{Vector{Int64}}`: List of graph vertex codes.
#- `npf::Int64`: Threshold for vertex overlap pairs (for graph filtering).
#- `nglob::Int64`: Number of previously displayed molecular graphs.
# - `dirpath::String`: Path to the folder containing the file.
# - `fname::String`: File name without extension
# Returns
# - Prints the count of selected graphs and the vertex overlap pair threshold.
#- For each graph displayed, a tuple of 4 elements is output to the terminal
#  and to a text file:
#  1. The number of the graph displayed on the screen, taking into account 
#     all previously displayed graphs (global).
#  2. Current index in the list.
#  3. The number of the graph displayed on the screen from the list of all
#     created graphs of the given type.
#  4. Vertex overlap pair count for the graph.  
#  5. Vertex code of the graph.

# ShowSelectOverlapN18

# Generation of vertex codes for Yeh's graphs

order  = 18  #  graphs order
list_vertex_code = collect(gen_codes_yeh_graphs(order))

# Displaying images of Yeh's molecular graphs with a number of pairs of overlapping
# vertices no less than the specified npf value

npf = 4
nglob = 1
dirpath = "C:\\Julia_results\\DistributionYehGraphsByOverlap\\ShowSelectOverlapN18\\"
fname = "ShowSelectOverlapN18"

show_select_graphs_overlap(list_vertex_code,npf, nglob,dirpath,fname)

#  **************************************************************

# ShowSelectOverlapN24

# Generation of vertex codes for Yeh's graphs

order  = 24
list_vertex_code = collect(gen_codes_yeh_graphs(order))

# Displaying images of Yeh's molecular graphs with a number of pairs of overlapping
# vertices no less than the specified npf value

npf = 8
nglob = 1
dirpath = "C:\\Julia_results\\DistributionYehGraphsByOverlap\\ShowSelectOverlapN24\\"
fname = "ShowSelectOverlapN24"

if !isdir(dirpath)
    mkpath(dirpath)
end

show_select_graphs_overlap(list_vertex_code,npf, nglob,dirpath,fname)