module GenCodeSubGraphCOI

using ..AllSmallParts

export gen_coi_subtype_edge, gen_coi_subtype_vertex
export generate_coi_non_cis3p, generate_coi_cis3, generate_coi_cis4p

# Aliases for backward compatibility
 
export gencoisubtypeedge, gencoisubtypevertex,
       generatecoinoncis3p, generatecoicis3, generatecoicis4p


"""
    gen_coi_subtype_vertex(n::Int64,target_subtype::Int64) -> Vector{Vector{Int64}}

Generates vertex codes for molecular graphs of the specified subtype. 
Vertex codes are used for generation.
# Arguments
- `n`: total number of vertices in the polyene (n ≥ 6)
- `target_subtype::Int64`: Specified subtype of molecular graphs of conformers of other isomers.
   Can take one of three values:
   1 - graphs without cisoid chains of length 3 or longer;
   2 - graphs with cisoid chains of length 3;
   3 - graphs with cisoid chains of length 4 or longer.
# Returns
List of vertex codes of molecular graphs of the subtype defined in the target_subtype parameter.
"""
function gen_coi_subtype_vertex(n::Int64,target_subtype::Int64)
    p = n - 2   
    pmo = 2^(p-1)
    set_coi_subtype = Set{Vector{Int64}}() 
    lst_coi_subtype = []
    OTHER_CONFORMER_TYPE = 3          
    for k in 1:pmo  
        vertex_code = intg_digits(k-1,p)        
        if  check_min_vertex(vertex_code) == true           
            graph_type = graph_type_from_vertex(vertex_code)
            if graph_type == OTHER_CONFORMER_TYPE                                
                subtype = graph_subtype_vertex(vertex_code,1)
                if subtype == target_subtype                    
                    push!(set_coi_subtype, vertex_code)                                   
                end          
            end     
        end        
    end
    lst_coi_subtype = sort(collect(set_coi_subtype))    
end 



"""
    gen_coi_subtype_edge(n::Int64,target_subtype::Int64) -> Vector{Vector{Int64}}

Generates vertex codes for molecular graphs of the specified subtype. 
Edge codes are used for generation.
# Arguments
- `n`: total number of vertices in the polyene (n ≥ 6)
- `target_subtype::Int64`: Specified subtype of molecular graphs of conformers of other isomers.
   Can take one of three values:
   1 - graphs without cisoid chains of length 3 or longer;
   2 - graphs with cisoid chains of length 3;
   3 - graphs with cisoid chains of length 4 or longer.
# Returns
List of vertex codes of molecular graphs of the subtype defined in the target_subtype parameter.
"""
function gen_coi_subtype_edge(n::Int64,target_subtype::Int64)
    m = n - 3   
    pmo = 2^m
    set_coi_subtype = Set{Vector{Int64}}() 
    lst_coi_subtype = []
    OTHER_CONFORMER_TYPE = 3          
    for k in 1:pmo  
        edge_code = intg_digits(k-1,m)        
        if  check_min_edge(edge_code) == true           
            graph_type = graph_type_from_edge(edge_code)
            if graph_type == OTHER_CONFORMER_TYPE                                
                subtype = graph_subtype_edge(edge_code,1)
                if subtype == target_subtype
                    vertex_code = edge_to_vertex(edge_code)
                    push!(set_coi_subtype, vertex_code)                                   
                end          
            end     
        end        
    end
    lst_coi_subtype = sort(collect(set_coi_subtype))    
end 




"""
    generate_coi_non_cis3p(n::Int64) -> Vector{Vector{Int64}}

Generates vertex codes for molecular graphs of conformers of other isomers without cisoid 
    Cis3 chains using edge codes.

# Arguments
- `n`: total number of vertices in the polyene (n ≥ 6)
# Returns
 List of vertex codes for molecular graphs of conformers of other isomers without cisoid 
    Cis3 chains.

See also [`AllSmallParts.intg_digits`](@ref), [`AllSmallParts.graph_type_from_edge`](@ref),
    [`AllSmallParts.edge_to_vertex](@ref)
"""
function generate_coi_non_cis3p(n::Int64)
    m = n - 3   
    pmo = 2^m
    set_non_cis3 = Set{Vector{Int64}}() 
    lst_non_cis3 = []
    OTHER_CONFORMER_TYPE = 3
    WITHOUT_CIS3 = 1      
    for k in 1:pmo  
        edge_code = intg_digits(k-1,m)         
        bcdMin = min_edge_code(edge_code)
        if  edge_code == bcdMin           
            graph_type = graph_type_from_edge(edge_code)
            if graph_type == OTHER_CONFORMER_TYPE                                
                subtype = graph_subtype_edge(edge_code,1)
                if subtype == WITHOUT_CIS3
                    vertex_code = edge_to_vertex(edge_code)
                    push!(set_non_cis3, vertex_code)                                   
                end          
            end     
        end        
    end
    lst_non_cis3 = sort(collect(set_non_cis3))    
end 


"""
    generate_coi_cis3(n::Int64) -> Vector{Vector{Int64}}

Generates vertex codes for molecular graphs of conformers of other isomers without cisoid 
    Cis3 chains using edge codes.

# Arguments
- `n`: total number of vertices in the polyene (n ≥ 6)
# Returns
 List of vertex codes for molecular graphs of conformers of other isomers without cisoid 
    Cis3 chains.

See also [`AllSmallParts.intg_digits`](@ref), [`AllSmallParts.graph_type_from_edge`](@ref),
    [`AllSmallParts.edge_to_vertex](@ref)
"""
function generate_coi_cis3(n::Int64)
    m = n - 3   
    pmo = 2^m
    set_non_cis3 = Set{Vector{Int64}}() 
    lst_non_cis3 = []
    OTHER_CONFORMER_TYPE = 3
    WITH_CIS3 = 2      
    for k in 1:pmo  
        edge_code = intg_digits(k-1,m)         
        bcdMin = min_edge_code(edge_code)
        if  edge_code == bcdMin           
            graph_type = graph_type_from_edge(edge_code)
            if graph_type == OTHER_CONFORMER_TYPE                                
                subtype = graph_subtype_edge(edge_code,1)
                if subtype == WITH_CIS3
                    vertex_code = edge_to_vertex(edge_code)
                    push!(set_non_cis3, vertex_code)                                   
                end          
            end     
        end        
    end
    lst_non_cis3 = sort(collect(set_non_cis3))    
end 


"""
    generate_coi_cis4p(n::Int64) -> Vector{Vector{Int64}}

Generates vertex codes for molecular graphs of conformers of other isomers without cisoid 
    Cis3 chains using edge codes.

# Arguments
- `n`: total number of vertices in the polyene (n ≥ 6)
# Returns
 List of vertex codes for molecular graphs of conformers of other isomers without cisoid 
    Cis3 chains.

See also [`AllSmallParts.intg_digits`](@ref), [`AllSmallParts.graph_type_from_edge`](@ref),
    [`AllSmallParts.edge_to_vertex](@ref)
"""
function generate_coi_cis4p(n::Int64)
    m = n - 3   
    pmo = 2^m
    set_non_cis3 = Set{Vector{Int64}}() 
    lst_non_cis3 = []
    OTHER_CONFORMER_TYPE = 3
    WITH_CIS4 = 3      
    for k in 1:pmo  
        edge_code = intg_digits(k-1,m)         
        bcdMin = min_edge_code(edge_code)
        if  edge_code == bcdMin           
            graph_type = graph_type_from_edge(edge_code)
            if graph_type == OTHER_CONFORMER_TYPE                                
                subtype = graph_subtype_edge(edge_code,1)
                if subtype == WITH_CIS4
                    vertex_code = edge_to_vertex(edge_code)
                    push!(set_non_cis3, vertex_code)                                   
                end          
            end     
        end        
    end
    lst_non_cis3 = sort(collect(set_non_cis3))    
end 


# ============================================================
# Aliases for backward compatibility (old names)
# ============================================================



const gencoisubtypeedge = gen_coi_subtype_edge 
const gencoisubtypevertex = gen_coi_subtype_vertex

const  generatecoinoncis3p =  generate_coi_non_cis3p
const  generatecoicis3 =  generate_coi_cis3
const  generatecoicis4p =  generate_coi_cis4p

end  ##end of module