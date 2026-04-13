module DetermClassSymmetry

using ..AllSmallParts


export  symmetry_class_from_vertex,symmetry_class_from_edge,
        count_graphs_by_symmetry_vertex, count_graphs_by_symmetry_edge,
        count_graphs_by_symmetry_range, output_graphs_by_symmetry_range

# Aliases for backward compatibility       
export symclassfromvertex, symclassfromedge,countgraphsbysymvertex,countgraphsbysymedge,
       countgraphsbysymrange, outputgraphsbysymrange


# Constants for symmetry types
const MIRROR_SYMMETRY = 1      # C_{2h} - mirror symmetry
const ROTATIONAL_SYMMETRY = 2  # C_{2v} - rotational symmetry
const NO_SYMMETRY = 3          # C_S - no symmetry

# Constants for graph types (consistent with AllSmallParts)
const ISOMER_TYPE = 1
const TRANS_CONFORMER_TYPE = 2
const OTHER_CONFORMER_TYPE = 3

"""
    symmetry_class_from_vertex(vertex_code::Vector{Int64}) -> Int64

Determines the symmetry class of a molecular graph from its vertex code.

# Arguments
- `vertex_code`: vector of length p = n-2 (internal vertices of the graph)

# Returns
- `1` (MIRROR_SYMMETRY): Graph has mirror symmetry (C_{2h});
- `2` (ROTATIONAL_SYMMETRY): Graph has rotational symmetry (C_{2v});
- `3` (NO_SYMMETRY): Graph has no symmetry (C_S).

# Algorithm
1. Checks the first and last bits of the code
2. If both are 0: compares the code with its reverse:
   - If equal: mirror symmetry (1);
   - Otherwise: no symmetry (3).
3. If first=0, last=1: compares the code with its inverted reverse:
   - If equal: rotational symmetry (2);
   - Otherwise: no symmetry (3).
"""
function symmetry_class_from_vertex(vertex_code::Vector{Int64})
    p = length(vertex_code)
    
    if p < 4
        error("Vertex code must have length at least 4 (n ≥ 6)")
    end
    
    first_bit = vertex_code[1]
    last_bit = vertex_code[end]
    
    if first_bit == 0 && last_bit == 0
        # Case: beginning and end of code = 0
        reversed_code = reverse(vertex_code)
        
        if vertex_code == reversed_code
            return MIRROR_SYMMETRY  # C_{2h} - mirror symmetry
        else
            return NO_SYMMETRY      # C_S - no symmetry
        end
        
    elseif first_bit == 0 && last_bit == 1
        # Case: beginning=0, end=1
        reversed_code = reverse(vertex_code)
        inverted_reversed_code = invert(reversed_code)
        
        if vertex_code == inverted_reversed_code
            return ROTATIONAL_SYMMETRY  # C_{2v} - rotational symmetry
        else
            return NO_SYMMETRY          # C_S - no symmetry
        end
        
    else
        # Other cases - no symmetry
        return NO_SYMMETRY
    end
end

"""
    symmetry_class_from_edge(edge_code::Vector{Int64}) -> Int64

Determines the symmetry class of a molecular graph from its edge code.

# Arguments
- `edge_code`: vector of length m = n-3 (internal edges of the graph)

# Returns
- `1` (MIRROR_SYMMETRY): Graph has mirror symmetry (C_{2h})
- `2` (ROTATIONAL_SYMMETRY): Graph has rotational symmetry (C_{2v})
- `3` (NO_SYMMETRY): Graph has no symmetry (C_S)

# Algorithm
1. Checks if the code equals its reverse (palindrome).
2. If not equal: no symmetry (3).
3. If equal: analyzes the central element of the code:
   - Central element = 1: mirror symmetry (1);
   - Central element = 0: rotational symmetry (2).
"""
function symmetry_class_from_edge(edge_code::Vector{Int64})
    m = length(edge_code)
    
    if m < 3
        error("Edge code must have length at least 3 (n ≥ 6)")
    end
    
    # Check if the code is a palindrome (equals its reverse)
    if edge_code != reverse(edge_code)
        return NO_SYMMETRY  # C_S - no symmetry
    else
        # Code is a palindrome, analyze the central element
        middle_index = div(m, 2) + 1  # index of the central element
        
        if edge_code[middle_index] == 1
            return MIRROR_SYMMETRY     # C_{2h} - mirror symmetry
        else
            return ROTATIONAL_SYMMETRY # C_{2v} - rotational symmetry
        end
    end
end


"""
    count_graphs_by_symmetry_edge(graphs_type::Int64,
    order::Int64) -> Tuple{Vector{Int64}}

Calculates the distribution of the number of molecular graphs of a given type by
 graph symmetry groups, using edge codes.

# Arguments
- `n`: total number of vertices in the polyene (n ≥ 6)

# Returns
`class_sym_count::Vector{Int64}`: vector contains 5 elements:
1. n (number of vertices);
2. Number of graphs with mirror symmetry (C_{2h});
3. Number of graphs with rotational symmetry (C_{2v});
4. Number of graphs with no symmetry (C_S);
5. Total number of graphs of this type.
"""
function count_graphs_by_symmetry_edge(graphs_type::Int64,
    order::Int64)
    if order < 6
        error("order must be at least 6 (got order = $order)")
    end

    if graphs_type < 1 || graphs_type > 3
        error("graphs_type must be 1, 2, or 3 (got $graphs_type)")
    end 
    
    m = order - 3
    total_combinations = 2^m
    length_code = m        
           
    # Vectors for counting: [n, C_{2h}, C_{2v}, C_S, total]
    class_sym_count = [order, 0, 0, 0, 0]
        
    for k in 1:total_combinations
        # Generate vertex code for number (k-1)
        code = intg_digits(k-1, length_code)
        
        # Check if the code is canonical
        canonical_code = min_edge_code(code)
        
        if code == canonical_code            
            # Determine graph type
            current_type = graph_type_from_edge(code)
            
            if current_type == graphs_type
                # Determine symmetry class
                symmetry_class = symmetry_class_from_edge(code)                
                class_sym_count[symmetry_class + 1] += 1  # +1 because indices start at 1
                class_sym_count[5] += 1  # total count             
            end
        end
    end    
    return class_sym_count
end


"""
    count_graphs_by_symmetry_vertex(graphs_type::Int64,
    order::Int64) -> Tuple{Vector{Int64}}

Calculates the distribution of the number of molecular graphs of a given type by
 graph symmetry groups, using edge codes.

# Arguments
- `n`: total number of vertices in the polyene (n ≥ 6)

# Returns
`class_sym_count::Vector{Int64}`: vector contains 5 elements:
1. n (number of vertices);
2. Number of graphs with mirror symmetry (C_{2h});
3. Number of graphs with rotational symmetry (C_{2v});
4. Number of graphs with no symmetry (C_S);
5. Total number of graphs of this type.
"""
function count_graphs_by_symmetry_vertex(graphs_type::Int64,
    order::Int64)
    if order < 6
        error("order must be at least 6 (got order = $order)")
    end

    if graphs_type < 1 || graphs_type > 3
        error("graphs_type must be 1, 2, or 3 (got $graphs_type)")

    end 
    
    p = order -2
    total_combinations = 2^(p-1)
    length_code = p
           
    # Vectors for counting: [n, C_{2h}, C_{2v}, C_S, total]
    class_sym_count = [order, 0, 0, 0, 0]
        
    for k in 1:total_combinations
        # Generate vertex code for number (k-1)
        code = intg_digits(k-1, length_code)
        
        # Check if the code is canonical
        canonical_code = min_vertex_code(code)
        
        if code == canonical_code            
            # Determine graph type
            current_type = graph_type_from_vertex(code)
            
            if current_type == graphs_type
                # Determine symmetry class
                symmetry_class = symmetry_class_from_vertex(code)                
                class_sym_count[symmetry_class + 1] += 1  # +1 because indices start at 1
                class_sym_count[5] += 1  # total count             
            end
        end
    end    
    return class_sym_count
end



"""
    count_graphs_by_symmetry_range(graphs_type::Int64,
    orders::StepRange{Int, Int})

Calculates the distribution of molecular graphs of a given type by graph symmetry groups
 for a range of graph orders. Uses edge codes for analysis.
 For each order in the specified range, returns:
 - number of vertices,
 - count of graphs with mirror symmetry (C₂ₕ),
 - count of graphs with rotational symmetry (C₂ᵥ),
 - count of asymmetric graphs (Cₛ),
 - total number of graphs of this type.
# Arguments:
- `graphs_type::Int64` — graph type (must be 1, 2, or 3);
- `orders::StepRange{Int, Int}` — range of graph orders to analyze
   (e.g., 6:2:12 — even numbers from 6 to 12).

# Returns:
- `Vector{Vector{Int64}}` — vector of results for each order in the range.
 Each element is a 5-element vector:
 1. n — number of vertices;
 2. Count of graphs with mirror symmetry (C₂ₕ);
 3. Count of graphs with rotational symmetry (C₂ᵥ);
 4. Count of asymmetric graphs (Cₛ);
 5. Total count of graphs of this type.
# Results are sorted by increasing graph order.
# Exceptions:
 - error if graphs_type is not in range 1–3;
 - error if code_type is not 1 or 2;
 - error from count_graphs_by_symmetry_class for invalid order.
"""
function count_graphs_by_symmetry_range(graphs_type::Int64,
    orders::StepRange{Int, Int})
    if graphs_type < 1 || graphs_type > 3
        error("graphs_type must be 1, 2, or 3 (got $graphs_type)")
    end
    set_distrib_graphs_by_symclass = Set{Vector{Int64}}()
    list_distrib_graphs_by_symclass = Vector{Vector{Int64}}()
    for n in orders  # только четные n
        n_val, mirror, rotat, asym, total = 
        count_graphs_by_symmetry_edge(graphs_type,n)
        push!(set_distrib_graphs_by_symclass,[n_val, mirror, rotat, asym, total])        
    end
    list_distrib_graphs_by_symclass = sort(collect(set_distrib_graphs_by_symclass))
    return list_distrib_graphs_by_symclass
end



"""
    output_graphs_by_symmetry_range(list_result,graphs_type::Int64,
    dirpath::String, fname::String)

Outputs the distribution of molecular graphs by symmetry classes to a text file.
 Generates a formatted table with headers and aligned data,
 including graph type information (isomers, conformers, etc.).
#Arguments:
 - `list_result::Any`— list of results (each item is a 5-element vector):
   1. n — number of vertices,
   2. mirror — count of C₂ₕ (mirror-symmetric) graphs,
   3. rotat — count of C₂ᵥ (rotationally-symmetric) graphs,
   4. asymmetry — count of C_S (asymmetric) graphs,
   5. Total — total graph count.
 - `graphs_type::Int64` — graph type (determines header text):
     1 — isomers,
     2 — conformers of trans-isomers,
     3 — conformers of other isomers.
 - `dirpath::String` — directory path to save the file.
 - `fname::String` — base filename (without extension; ".txt" will be added).
# Returns:
  Nothing (performs side effects: file creation and console output).
# Side effects:
 - Creates a text file at `dirpath/fname.txt`.
 - Writes a formatted table with headers and data to the file.
 - Prints progress messages to the console.
# Exceptions (eng):
 - I/O error (e.g., directory not accessible).
 - Unexpected type or structure of `list_result` (may cause error in the loop).
"""
function output_graphs_by_symmetry_range(list_result,graphs_type::Int64,
    dirpath::String, fname::String)
    filename = fname*".txt"    
    fpath = joinpath(dirpath, filename)
    # we define the signature for the header depending on the type of graphs

    if graphs_type == 1
        hd2 = " isomers "
    elseif graphs_type == 2
        hd2 = " conformer of trans-isomers "        
    elseif graphs_type == 3
        hd2 = " conformer of other isomers "
    else
        error("Unsupported graphs_type: $graphs_type (must be 1, 2, or 3)")    
    end    
            
    hd1 = " Distribution of the number of molecular graphs of " 
    hd3 = "  by graph symmetry group. "
    head23 = string(hd2,hd3)

    # Format column headers
    zag1 = lpdstr("n",2)
    zag2 = lpdstr("mirror",10)
    zag3 = lpdstr("rotat",10)
    zag4 = lpdstr("asymmetry",12)
    zag5 = lpdstr("Total",14)
    allzag = string("|", zag1,"|", zag2, "|", zag3, "|", zag4,"|",zag5,"|") 
    line = repeat("-", 54)

    # Open the file for writing
    file = open(fpath, "w")
    
    # Output headers and separators to the console and to the file
    println(hd1)
    println(head23)
    write(file, hd1*"\n")
    write(file, head23*"\n")    
    println(line)
    write(file,line*"\n")
    println(allzag)
    write(file,allzag*"\n")
    println(line)
    write(file,line*"\n")

    # Output each row of data
    for res in list_result          
        txt = string("|", lpdval(res[1],2), "|", lpdval(res[2],10),"|", 
        lpdval(res[3],10), "|", lpdval(res[4],12),"|", lpdval(res[5],14),"|")
        println(txt)
        write(file,txt*"\n")
    end

    # Complete the table
    println(line)    
    write(file,line*"\n")
    # Close the file
    close(file)
    println("File creation completed successfully") 
end


# ============================================================
# Aliases for backward compatibility
# ============================================================

const  symclassfromvertex = symmetry_class_from_vertex
const  symclassfromedge = symmetry_class_from_edge
const  countgraphsbysymvertex = count_graphs_by_symmetry_vertex
const  countgraphsbysymedge = count_graphs_by_symmetry_edge
const  countgraphsbysymrange = count_graphs_by_symmetry_range
const  outputgraphsbysymrange = output_graphs_by_symmetry_range


end