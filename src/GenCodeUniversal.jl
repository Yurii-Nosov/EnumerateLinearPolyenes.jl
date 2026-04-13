module GenCodeUniversal

using ..AllSmallParts


export gen_codes_all_graphs, gen_codes_graphs_type, gen_codes_graphs_coiso, 
       check_yeh_vertex, check_yeh_edge, gen_codes_yeh_graphs

# Aliases for backward compatibility
export gencodesallgraphs, gencodesgraphstype, gencodesgraphscoiso, checkyehvertex,
       checkyehedge,gencodesyehgraphs


"""
   gen_codes_all_graphs(n::Int64)

Generates the complete, duplicate-free list of edge codes for molecular 
graphs of all linear polyene classes. This is a utility function; its output 
serves as input for other functions.
# Arguments
`n::Int64`: total number of vertices in the polyene (n ≥ 6).

# Returns
- `y::Vector{Vector{Int64}}` : list of edge codes.
"""
function gen_codes_all_graphs(n::Int64)
    m = n-3
    kf = 2^m
    xx = (intg_digits(k-1, m) for k in 1:kf)
    y = (x for x in xx if check_min_edge(x)== true)
    return y
end

 
"""
   gen_codes_graphs_type(n::Int64, cls::Int64) -> Vector{Vector{Int64}}

Generates the complete, duplicate-free list of edge codes for molecular graphs of a 
specified linear polyene class. The three possible classes are:
- Isomers
- Trans-isomer conformers
- Other-isomer conformers

# Arguments
- `n::Int64`: total number of vertices in the polyene (n ≥ 6).
- `cls::Int64` : given graph class.
# Returns
- `y::Vector{Vector{Int64}}` : list of vertex codes.
"""
function gen_codes_graphs_type(n::Int64, cls::Int64)
    m = n-3
    kf = 2^m
    xx = (intg_digits(k-1, m) for k in 1:kf)
    yy = (x for x in xx if check_min_edge(x)== true)
    z = (edge_to_vertex(y) for y in yy if graph_type_from_edge(y)== cls)
end

 
"""
    gen_codes_graphs_coiso(n::Int64) -> Vector{Vector{Int64}}

Generates the complete, duplicate-free list of vertex codes for molecular graphs 
of 'other-isomer conformers' of linear polyenes.
# Arguments
`n::Int64`: total number of vertices in the polyene (n ≥ 6).

# Returns
- `z::Vector{Vector{Int64}}` : list of vertex codes.
"""
function gen_codes_graphs_coiso(n::Int64)
    m = n-3
    kf = 2^m
    xx = (intg_digits(k-1, m) for k in 1:kf)
    yy = (x for x in xx if check_min_edge(x)== true)
    z = (edge_to_vertex(y) for y in yy if graph_type_from_edge(y)== 3)
end

 
"""
    check_yeh_vertex(vertex_code::Vector{Int64}) -> Bulean
Determines from a graph's vertex code whether it is a Yeh's graph.
Returns `true`` if the graph constructed from a vertex code is a Yeh's graph,
and `false`` otherwise.
"""
function check_yeh_vertex(vertex_code::Vector{Int64})    
    st51 = string(1,1,1,1,1); st41 = string(1,1,1,1)
    st50 = string(0,0,0,0,0);  st40 = string(0,0,0,0)
    vcstr = map(string, vertex_code)
    strbcd = join(vcstr)
    if !occursin(st51, strbcd) && !occursin(st50, strbcd)                
        if !occursin(st41, strbcd) && !occursin(st40, strbcd)
            return true
        else
            return false                        
        end
    else 
        return false                    
    end 
end    

 
"""
    check_yeh_edge(edge_code)

Determines from a graph's edge code whether it is a Yeh's graph.
Returns `true`` if the graph constructed from a edge code is a Yeh's graph,
and `false`` otherwise.
"""
function check_yeh_edge(edge_code)
    st41 = string(1,1,1,1)
    st31 = string(1,1,1)
    vcstr = map(string, edge_code)
    strbcd = join(vcstr)    
    if !occursin(st41, strbcd) && !occursin(st31, strbcd)
        return true
    else
        return false                        
    end     
end
  
 
"""
    gen_codes_yeh_graphs(n::Int64) -> Vector{Vector{Int64}} 

Creates a complete list, without repetitions, of vertex codes for molecular graphs of 
conformers of other linear polyene isomers that do not have three consecutive edges in
the cis configuration. For brevity, I called these graphs Yeh graphs in my work.
# Arguments
`n::Int64` : total number of vertices in the polyene (n ≥ 6).
# Returns
 `z::Vector{Vector{Int64}}` : list of vertex codes.
"""
function gen_codes_yeh_graphs(n::Int64)
    m = n-3
    kf = 2^m
    xx = (intg_digits(k-1, m) for k in 1:kf)
    yy = (x for x in xx if check_min_edge(x)== true)
    zz = (y for y in yy if graph_type_from_edge(y)== 3)
    yeh = (edge_to_vertex(z) for z in zz if check_yeh_edge(z)== true)
    return yeh    
end 

# ============================================================
# Aliases for backward compatibility (old names)
# ============================================================

const gencodesallgraphs =  gen_codes_all_graphs
const gencodesgraphstype = gen_codes_graphs_type
const gencodesgraphscoiso = gen_codes_graphs_coiso
const checkyehvertex =  check_yeh_vertex
const checkyehedge =   check_yeh_edge
const gencodesyehgraphs = gen_codes_yeh_graphs




end  ## end of module