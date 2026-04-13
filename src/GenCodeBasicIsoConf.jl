module GenCodeBasicIsoConf

using ..AllSmallParts

export generate_all_codes, generate_isomer_vertex, generate_isomer_edge,
       generate_trans_conformer_vertex, generate_trans_conformer_edge,
       generate_other_conformer_vertex,generate_other_conformer_edge
# Aliases for backward compatibility
export genallcode, genisovertex, genisoedge, gentransconfvertex,gentransconfedge,
       genotherconfvertex,genotherconfedge


# Constants for graph types (consistent with AllSmallParts)
const ISOMER_TYPE = 1
const TRANS_CONFORMER_TYPE = 2
const OTHER_CONFORMER_TYPE = 3



"""
    generate_all_codes(n::Int64) -> Tuple{Vector{Vector{Int64}}, Vector{Vector{Int64}}, Vector{Vector{Int64}}}

Generates all non-isomorphic molecular graphs of all three classes using edge codes.

# Arguments
- `n`: total number of vertices in the polyene (n ≥ 6)

# Returns
A tuple of three vertex code lists:
1. List of vertex codes for isomers
2. List of vertex codes for conformers of trans-isomers
3. List of vertex codes for conformers of other isomers

# Algorithm
1. Generates all possible edge codes of length m = n-3
2. Selects only canonical (non-isomorphic) codes
3. Converts edge codes to vertex codes
4. Separates by graph type (isomers, trans-conformers, other conformers)
"""
function generate_all_codes(order::Int64)
    if order < 6
        error("n must be at least 6 (got order=$order)")
    end

    m = order - 3  # number of internal edges
    total_combinations = 2^m
    length_code = m        
         
    # Use Set for automatic duplicate removal
    isomers_set = Set{Vector{Int64}}()
    trans_conformers_set = Set{Vector{Int64}}()
    other_conformers_set = Set{Vector{Int64}}()
    
    for k in 1:total_combinations
        # Generate edge code for number (k-1)
        edge_code = intg_digits(k-1, length_code)
        
        # Check if the code is canonical
        if check_min_edge(edge_code)
            # Convert to vertex code            
            vertex_code = edge_to_vertex(edge_code)           
            # Determine graph type
            graph_type = graph_type_from_edge(edge_code)
            
            if graph_type == ISOMER_TYPE
                push!(isomers_set, vertex_code)
            elseif graph_type == TRANS_CONFORMER_TYPE
                push!(trans_conformers_set, vertex_code)
            elseif graph_type == OTHER_CONFORMER_TYPE
                push!(other_conformers_set, vertex_code)
            end
        end
    end
    
    # Convert Set to sorted lists
    isomers_list = sort(collect(isomers_set))
    trans_conformers_list = sort(collect(trans_conformers_set))
    other_conformers_list = sort(collect(other_conformers_set))
    
    return isomers_list, trans_conformers_list, other_conformers_list
end




"""
    generate_isomer_vertex(order::Int64) -> Vector{Vector{Int64}}

Generates vertex codes of molecular graphs of isomers using edge codes.

# Arguments
- `order`: Order of molecular graphs of isomers with depleted hydrogen atoms;   


# Returns
List of vertex codes for isomers
"""
function generate_isomer_vertex(order::Int64)
    if order < 6
        error("n must be at least 6 (got n=$order)")
    end

    p = order - 2  # number of internal edges
    total_combinations = 2^(p-1)
    length_code = p 
    
    isomers_set = Set{Vector{Int64}}()
    
    for k in 1:total_combinations
        vertex_code = intg_digits(k-1, length_code)
                
        if check_min_vertex(vertex_code)
            if graph_type_from_vertex(vertex_code) == ISOMER_TYPE
                push!(isomers_set, vertex_code)   
            end            
        end
    end    
    return sort(collect(isomers_set))
end


"""
    generate_isomer_edge(order::Int64) -> Vector{Vector{Int64}}

Generates vertex codes of molecular graphs of isomers using edge codes.

# Arguments
- `order`: Order of molecular graphs of isomers with depleted hydrogen atoms;   


# Returns
List of vertex codes for isomers
"""
function generate_isomer_edge(order::Int64)
    if order < 6
        error("n must be at least 6 (got n=$order)")
    end
    
    m = order - 3  # number of internal edges
    total_combinations = 2^m
    length_code = m
        
    isomers_set = Set{Vector{Int64}}()
    
    for k in 1:total_combinations
        edge_code = intg_digits(k-1, length_code)
                
        if check_min_edge(edge_code)
            if graph_type_from_edge(edge_code) == ISOMER_TYPE 
               vertex_code = edge_to_vertex(edge_code)
               push!(isomers_set, vertex_code)                
            end            
        end
    end    
    return sort(collect(isomers_set))
end


"""
    generate_trans_conformer_vertex(order::Int64) -> Vector{Vector{Int64}}

Generates vertex codes of molecular graphs of conformers of trans-isomers using vertex codes.

# Arguments
- `order`: Order of molecular graphs of conformers of trans-isomers with 
   depleted hydrogen atoms;   


# Returns
List of vertex codes for conformers of trans-isomers
"""
function generate_trans_conformer_vertex(order::Int64)
    if order < 6
        error("n must be at least 6 (got n=$order)")
    end

    p = order - 2  # number of internal edges
    total_combinations = 2^(p-1)
    length_code = p 
               
    trans_conformers_set = Set{Vector{Int64}}()
    
    for k in 1:total_combinations
        vertex_code = intg_digits(k-1, length_code)
                
        if check_min_vertex(vertex_code)
            if graph_type_from_vertex(vertex_code) == TRANS_CONFORMER_TYPE 
               push!(trans_conformers_set, vertex_code)
            end            
        end
    end    
    return sort(collect(trans_conformers_set))
end


"""
    generate_trans_conformer_edge(order::Int64) -> Vector{Vector{Int64}}

Generates vertex codes of molecular graphs of conformers of trans-isomers using edge codes.

# Arguments
- `order`: Order of molecular graphs of conformers of trans-isomers with 
   depleted hydrogen atoms;   


# Returns
List of vertex codes for conformers of trans-isomers
"""
function generate_trans_conformer_edge(order::Int64)
    if order < 6
        error("n must be at least 6 (got n=$order)")
    end

    m = order - 3  # number of internal edges
    total_combinations = 2^m
    length_code = m                
           
    trans_conformers_set = Set{Vector{Int64}}()
    
    for k in 1:total_combinations
        edge_code = intg_digits(k-1, length_code)
                
        if check_min_edge(edge_code)
            if graph_type_from_edge(edge_code) == TRANS_CONFORMER_TYPE 
                vertex_code = edge_to_vertex(edge_code)                                              
                push!(trans_conformers_set, vertex_code)
            end            
        end
    end    
    trans_conformers_list = sort(collect(trans_conformers_set))
    srt_list_ctri = map(min_vertex_code,trans_conformers_list)
    return sort(srt_list_ctri)
end


"""
    generate_other_conformer_vertex(order::Int64) -> Vector{Vector{Int64}}

Generates vertex codes of molecular graphs of conformers of trans-isomers using vertex codes.

# Arguments
- `order`: Order of molecular graphs of isomers with suppressed hydrogen atom.   

# Returns
List of vertex codes for conformers of trans-isomers
"""
function generate_other_conformer_vertex(order::Int64)
    if order < 6
        error("n must be at least 6 (got n=$order)")
    end

    p = order - 2  # number of internal edges
    total_combinations = 2^(p-1)
    length_code = p 
    
    other_conformers_set = Set{Vector{Int64}}()
    
    for k in 1:total_combinations
        vertex_code = intg_digits(k-1, length_code)
                
        if check_min_vertex(vertex_code)
            if graph_type_from_vertex(vertex_code) == OTHER_CONFORMER_TYPE
               push!(other_conformers_set, vertex_code)
            end            
        end
    end    
    return sort(collect(other_conformers_set))    
end


"""
    generate_other_conformer_edge(order::Int64) -> Vector{Vector{Int64}}

Generates vertex codes of molecular graphs of conformers of trans-isomers using edge codes.

# Arguments
- `order`: Order of molecular graphs of isomers with suppressed hydrogen atom.   

# Returns
List of vertex codes for conformers of trans-isomers
"""
function generate_other_conformer_edge(order::Int64)
    if order < 6
        error("n must be at least 6 (got n=$order)")
    end

    m = order - 3  # number of internal edges
    total_combinations = 2^m
    length_code = m
    
    other_conformers_set = Set{Vector{Int64}}()
    
    for k in 1:total_combinations
        edge_code = intg_digits(k-1, length_code)
                
        if check_min_edge(edge_code)
            if graph_type_from_edge(edge_code) == OTHER_CONFORMER_TYPE
                vertex_code = edge_to_vertex(edge_code)                               
                push!(other_conformers_set, vertex_code)
            end            
        end
    end
    other_conformers_list = collect(other_conformers_set)
    srt_list_coi = map(min_vertex_code,other_conformers_list)
    return sort(srt_list_coi)
end



# ============================================================
# Aliases for backward compatibility
# ============================================================


const genallcode = generate_all_codes
const genisovertex = generate_isomer_vertex
const genisoedge = generate_isomer_edge
const gentransconfvertex = generate_trans_conformer_vertex
const gentransconfedge = generate_trans_conformer_edge
const genotherconfvertex = generate_other_conformer_vertex
const genotherconfedge = generate_other_conformer_edge



end  # end of module