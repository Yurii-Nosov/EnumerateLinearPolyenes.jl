module AllSmallParts

export zam, invert, intg_digits, func, min_edge_code, min_vertex_code, check_min_edge, 
       check_min_vertex, edge_to_vertex, edge_to_vertex_code,
       graph_type_from_edge, graph_type_from_vertex,graph_subtype_edge,graph_subtype_vertex,
       parsing_vertex_code, lpdval,lpdstr,concate_zeros, remove_trailing_zeros
       
# Aliases for backward compatibility
export intgdig, minze, minbcd, checkminze, checkminbcd,fromzetobcd, 
       inzetobcd, graphtypefromze, graphtypefrombcd,graphsubtypeedge,graphsubtypevertex,
       lpdval,lpdst, parsingvertexcode, concatezeros, removetrailingzeros 
       


"""
    zam(x::Int64) -> Int64
Inverts a bit: 0 → 1, 1 → 0.
"""
function zam(x::Int64)
    if x == 0
        return 1
    else  # x == 1
        return 0
    end
end

"""
    invert(code::Vector{Int64}) -> Vector{Int64}
Inverts a binary vector: replaces 0 with 1 and 1 with 0.
"""
function invert(code::Vector{Int64})
    return map(zam, code)
end

"""
    intg_digits(n::Int64, p::Int64) -> Vector{Int64}
Converts a decimal number `n` to a binary vector of length `p`.

# Algorithm
Uses the successive division by 2 method.
"""
function intg_digits(n::Int64, p::Int64)
    if n == 0
        return zeros(Int64, p)
    end
    
    lst_bin = Int64[]
    
    # Successive division by 2 method
    while n > 0
        quotient = div(n, 2)   # integer part of division by 2
        remainder = n % 2      # remainder of division by 2
        push!(lst_bin, remainder)
        n = quotient           # continue with the integer part
    end
    
    reverse!(lst_bin)  # reverse because digits were obtained in reverse order
    len_b = length(lst_bin)
    
    if p > len_b
        zeros_to_add = p - len_b
        prefix = zeros(Int64, zeros_to_add)
        return vcat(prefix, lst_bin)
    else
        return lst_bin
    end
end

"""
    func(x::Int64, y::Int64) -> Int64
Compares two numbers: returns 1 if equal, 0 otherwise.
"""
function func(x::Int64, y::Int64)
    if x == y
        return 1
    else
        return 0
    end
end

"""
    min_vertex_code(vertex_code::Vector{Int64}) -> Vector{Int64}
Returns the canonical version of a vertex code as the lexicographically smallest
among: the original code, the reversed code, and the inverted reversed code.

# Arguments
- `vertex_code`: vector of length `p = n - 2` (internal vertices of the graph)
  - 0 = next edge turns left
  - 1 = next edge turns right
"""
function min_vertex_code(vertex_code::Vector{Int64})
    first_bit = vertex_code[1]
    last_bit = vertex_code[end]
    
    if first_bit == 0 && last_bit == 0
        rev_code = reverse(vertex_code)
        if vertex_code <= rev_code
            return vertex_code
        else
            return rev_code
        end
    elseif first_bit == 0 && last_bit == 1
        rev_code = reverse(vertex_code)
        inv_rev_code = invert(rev_code)
        if vertex_code <= inv_rev_code
            return vertex_code
        else
            return inv_rev_code
        end
    else
        error("Vertex code must have first_bit == 0 && last_bit == 0 or 
        first_bit == 0 && last_bit == 1)")
    end
end

"""
    min_edge_code(edge_code::Vector{Int64}) -> Vector{Int64}
Returns the canonical version of a edge code as the lexicographically smallest
among: the original code, the reversed code.

# Arguments
- `edge_code`: vector of length `m = n - 3` (internal edgees of the graph)
  - 0 = trans-configuration;
  - 1 = cis-configuration.
"""
function min_edge_code(edge_code::Vector{Int64})
    m = length(edge_code)
    
    if m < 3
        error("Edge code must have length at least 3 (n ≥ 6)")
    end
    
    rev_code = reverse(edge_code)
    if edge_code <= rev_code
        return edge_code
    else
       return rev_code 
    end    
end


"""
    check_min_vertex(vertex_code::Vector{Int64}) -> Bool
Checks if an vertex code (B-code) is canonical.
"""
function check_min_vertex(vertex_code::Vector{Int64})
    p = length(vertex_code)
    if p < 3
        error("Vertex code must have length at least 3 (n ≥ 6)")
    end

    first_bit = vertex_code[1]
    last_bit = vertex_code[end]
    if first_bit == 0 && last_bit == 0
        rev_code = reverse(vertex_code)
        if vertex_code <=  rev_code
            return true
        else
            return false
        end
    elseif first_bit == 0 && last_bit == 1
        rev_code = reverse(vertex_code)
        inv_rev_code = invert(rev_code)
        if vertex_code <= inv_rev_code
            return true
        else
            return false
        end
    else
        return false
    end
end 


"""
    check_min_edge(edge_code::Vector{Int64}) -> Bool
Checks if an edge code (ZE-code) is canonical.
"""
function check_min_edge(edge_code::Vector{Int64})
    m = length(edge_code)
    
    if m < 3
        error("Edge code must have length at least 3 (n ≥ 6)")
    end
    
    rev_code = reverse(edge_code)
    return edge_code <= rev_code
end


"""
    edge_to_vertex(edge_code::Vector{Int64}) -> Vector{Int64}
Converts an edge code (ZE-code) to a vertex code (B-code).

# Arguments
- `edge_code`: vector of length `m = n - 3` (internal edges of the graph)
  - 0 = trans-configuration
  - 1 = cis-configuration

# Returns
Vertex code of length `p = m + 1 = n - 2` (internal vertices)
  - 0 = next edge turns left
  - 1 = next edge turns right

# Algorithm
1. Start with 0 for the first vertex
2. For each edge k in the code:
   - If current vertex B[k] == edge ZE[k]: next vertex = 1
   - Otherwise: next vertex = 0
   Formula: B[k+1] = (B[k] == ZE[k]) ? 1 : 0
"""
function edge_to_vertex(edge_code::Vector{Int64})
    m = length(edge_code)
    
    if m < 3
        error("Edge code must have length at least 3 (n ≥ 6)")
    end
    
    p = m + 1  # p = n-2 internal vertices
    
    # Vertex code: start with 0
    vertex_code = zeros(Int64, p)
    vertex_code[1] = 0
    
    # Fill the remaining vertices
    for k in 1:m
        current_vertex = vertex_code[k]
        current_edge = edge_code[k]
        
        if current_vertex == current_edge
            vertex_code[k + 1] = 1  # match → 1
        else
            vertex_code[k + 1] = 0  # differ → 0
        end
    end
    
    return vertex_code
end

"""
    edge_to_vertex_code(edge_code::Vector{Int64}) -> Vector{Int64}
Alias for `edge_to_vertex`. Converts edge code to vertex code.
"""
const edge_to_vertex_code = edge_to_vertex

"""
    graph_type_from_edge(edge_code::Vector{Int64}) -> Int64
Determines the graph class from an edge code (ZE-code).

# Arguments
- `edge_code`: vector of length `m = n - 3` (internal edges of the graph)
  - 0 = trans-configuration
  - 1 = cis-configuration

# Returns
- `1`: Isomer graphs (isomeric configurations)
- `2`: Conformer graphs of trans-isomers
- `3`: Conformer graphs of other isomers

# Note
For linear polyenes:
- Even positions in the code (indices 2,4,6,...) correspond to isomeric edges
- Odd positions (indices 1,3,5,...) correspond to conformational edges
"""
function graph_type_from_edge(edge_code::Vector{Int64})
    m = length(edge_code)
    
    if m < 3
        error("Edge code must have length at least 3 (n ≥ 6)")
    end
    
    # Isomeric positions (even indices, starting from 2)
    isomer_indices = 2:2:(m-1)
    isomer_positions = Int64[]
    for k in isomer_indices
        if k <= m
            push!(isomer_positions, edge_code[k])
        end
    end
    
    # Conformational positions (odd indices, starting from 1)
    conformer_indices = 1:2:m
    conformer_positions = Int64[]
    for k in conformer_indices
        if k <= m
            push!(conformer_positions, edge_code[k])
        end
    end
    
    sum_isomer = sum(isomer_positions)
    sum_conformer = sum(conformer_positions)
    
    if sum_isomer > 0 && sum_conformer > 0
        return 3  # Conformers of other isomers
    elseif sum_isomer > 0 && sum_conformer == 0
        return 1  # Isomers
    elseif sum_isomer == 0 && sum_conformer > 0
        return 2  # Conformers of trans-isomers
    else  # sum_isomer == 0 && sum_conformer == 0
        return 1  # Isomers (zero code)
    end
end

"""
    graph_type_from_vertex(vertex_code::Vector{Int64}) -> Int64
Determines the graph class from a vertex code.

# Arguments
- `vertex_code`: vector of length `p = n - 2` (internal vertices of the graph)
  - 0 = next edge turns left
  - 1 = next edge turns right

# Returns
- `1`: Isomer graphs
- `2`: Conformer graphs of trans-isomers
- `3`: Conformer graphs of other isomers

# Algorithm
1. Convert vertex code to edge code:
   ZE[k] = (B[k] == B[k+1]) ? 1 : 0
   where 1 = cis, 0 = trans
2. Determine type from edge code
"""
function graph_type_from_vertex(vertex_code::Vector{Int64})
    p = length(vertex_code)
    
    if p < 4
        error("Vertex code must have length at least 4 (n ≥ 6)")
    end
    
    # Convert vertex code to edge code
    edge_code = Int64[]
    for k in 1:(p-1)
        if vertex_code[k] == vertex_code[k+1]
            push!(edge_code, 1)  # cis
        else
            push!(edge_code, 0)  # trans
        end
    end
    
    return graph_type_from_edge(edge_code)
end


"""
    graph_subtype_edge(edge_code::Vector{Int64}, variant=1) -> Int64

Determines the subtype of a molecular graph of conformers of other isomers
based on its edge code.
#Arguments:
- `edge_code::Vector{Int64}`: vector of length `m = n - 3` (internal edges of the graph)
  - 0 = trans-configuration
  - 1 = cis-configuration 
- `variant::Int64`: Use case number: 
- 1 - used to generate graph codes; 
- 2 - used to calculate the distribution of the number of COI graphs by their subtypes.

# Returns:
- `1`: A graph without cisoid paths of length 3 or greater 
- `2`: A graph with a cisoid path of length 3
- `3`: A graph with a cisoid path of length 4 or greater
"""
function graph_subtype_edge(edge_code::Vector{Int64}, variant=1)
    WITHOUT_CIS3 = 1
    WITH_CIS3  = 2
    if variant == 1 
        WITH_CIS4_VAL = 3
    else
        WITH_CIS4_VAL = 4
    end
    st41 = "1111"  # pattern: 4+ consecutive cis edges
    st31 = "111"
    vcstr = map(string, edge_code)
    strbcd = join(vcstr)

 if occursin(st41,strbcd)  
    return WITH_CIS4_VAL    # contains 4+ consecutive cis edges
 elseif  occursin(st31,strbcd) 
    return WITH_CIS3    # WITH_CIS3 — contains exactly 3 consecutive cis edges
 else
    return WITHOUT_CIS3    # WITHOUT_CIS3 — no 3+ consecutive cis edges
 end
end    


"""
    graph_subtype_vertex(vertex_code::Vector{Int64}, variant=1) -> Int64

Determines the subtype of a molecular graph of conformers of other isomers
based on its vertex code.
# Arguments:    
- `vertex_code::Vector{Int64}` - vector of length `p = n - 2` (internal vertices 
   of the graph):
  - 0 = next edge turns left
  - 1 = next edge turns right
- `variant::Int64`: Use case number: 
- 1 - used to generate graph codes; 
- 2 - used to calculate the distribution of the number of COI graphs by their subtypes.
# Returns:
- `1`: A graph without cisoid paths of length 3 or greater 
- `2`: A graph with a cisoid path of length 3
- `3`: A graph with a cisoid path of length 4 or greater
"""
function graph_subtype_vertex(vertex_code::Vector{Int64}, variant=1)
    WITHOUT_CIS3 = 1
    WITH_CIS3  = 2
    if variant == 1 
        WITH_CIS4_VAL = 3
    else
        WITH_CIS4_VAL = 4
    end
    st51 = "11111"; st50 = "00000" # pattern: 4+ consecutive cis edges
    st41 = "1111";  st40 = "0000"
    vcstr = map(string, vertex_code)
    strbcd = join(vcstr)

 if occursin(st51,strbcd) || occursin(st50,strbcd)  
    return WITH_CIS4_VAL    # contains 4+ consecutive cis edges
 elseif  occursin(st41,strbcd) || occursin(st40,strbcd)
    return WITH_CIS3    # WITH_CIS3 — contains exactly 3 consecutive cis edges
 else
    return WITHOUT_CIS3    # WITHOUT_CIS3 — no 3+ consecutive cis edges
 end
end    



"""
    lpdval(val::Int64,lng::Int64) -> String
The function converts an integer to a string and pads it with leading spaces to reach a 
strictly defined length.

# Arguments
- `val::Int64`: the integer to be converted to a string and optionally padded with spaces;
-`lng::Int64`: the exact required length of the resulting string (in characters).
# Returns
-`strval::String`: A string representation of val, padded with leading spaces to exactly lng characters. 
If the original string is already longer than or equal to lng, it is returned unmodified.
! Info
 Uses the lpad system function from the standard julia library.
This function pads a string with spaces (or other characters) on 
the left to a specified length.
"""
function lpdval(val::Int64,lng::Int64)
    strval = string(val)
    dlt = lng - length(strval)
    if dlt > 0
        lpad(strval, dlt + length(strval))
    else
        strval    
    end 
end 



"""
    lpdstr(str::String,lng::Int64) -> string

The lpdstr function left-pads a string with spaces to reach the specified length.
If the string is already at least as long as required, it returns the original
string unchanged.

# Arguments
- `str::String`: the input string;
- `lng::Int64`: the desired total length of the output string;
# Returns a string left-padded with spaces to length lng, or the
 original string if its length ≥ lng.
! Info
 Uses the lpad system function from the standard julia library.
This function pads a string with spaces (or other characters) on 
the left to a specified length.
"""
function lpdstr(str::String,lng::Int64)
    dlt = lng - length(str)
    if dlt > 0
        lpad(str, dlt + length(str))
    else
        str    
    end
end    






"""
    parsing_vertex_code(vertex_code::Vector{Int64}) -> String

Converts a vertex code to an edge-based molecular code using chemical notation.
# Algorithm:
 1. Computes base atom counts: pC = length + 2 (carbon), pH = length + 4 (hydrogen).
 2. For each edge (adjacent vertex pair), determines its configuration:
    - "e" (from German *entgegen* — trans): adjacent edges are on opposite sides of the encoded edge.
    - "z" (from German *zusammen* — cis): adjacent edges are on the same side of the encoded edge.
 3. Separates labels by position:
    - odd-numbered edges → isomer descriptors (isomer_text),
    - even-numbered edges → conformer descriptors (conformer_text).
 4. Constructs the molecule name as: "C{pC}H{pH}-{isomers}-{conformers}".
 
# Arguments:
   `vertex_code::Vector{Int64}` — vertex code of the molecule (sequence of vertex indices).
# Returns:
   `molecule_name::String` — molecule name with edge code (e.g., "C5H7-2e3z4e").
"""
function parsing_vertex_code(vertex_code::Vector{Int64})
    k::Int64 = length(vertex_code)
    pC::Int64 = k + 2; pH = k + 4
    name::String = "C$pC"*"H$pH-"
    binMolZE =  Vector{Int64}()
    conformer_text = String[]; isomer_text = String[]; 
    molecule_text = String[]
    for j in  1:(k-1)
        ne = j + 1
        if vertex_code[j] != vertex_code[j+1]
            bcd = 0
            txt = string(ne)  * "e"
        else
            bcd = 1
            txt = string(ne)  * "z"
        end
        push!(binMolZE,bcd)
        if   iseven(ne) == true
            push!(conformer_text, txt)
        else
            push!(isomer_text, txt)
        end
    end
    isomer_text = join(isomer_text,"")
    conformer_text = join(conformer_text,"")
    molecule_text = isomer_text * "-" * conformer_text
    molecule_name =  name*molecule_text   
    return  molecule_name
end 




"""
    remove_trailing_zeros(v::Vector{Int64}) -> Vector{Int64}

Removes trailing zeros from a vector of integers (Int64).
 If the vector contains only zeros or is empty, returns an 
 empty vector of the same type.
# Parameters:
  `v::Vector{Int64}` — input vector of integers.
# Returns:
   `Vector{Int64}` — vector with trailing zeros removed.
"""
function remove_trailing_zeros(v::Vector{Int64})
    idx = findlast(!=(0), v)
    isnothing(idx) ? eltype(v)[] : v[1:idx]
end



"""
    concate_zeros(vct::Vector{Int64},target_length::Int64) -> Vector{Int64}

Pads a vector with zeros to reach a specified length.
 If the vector length is already ≥ target_length, returns the original vector.
# Parameters:
-`vct::Vector{Int64}`  — input vector of integers.
- `target_length::Int64` — desired length of the vector.
# Returns:
 `vctzr::Vector{Int64}` — vector padded with zeros to target_length (if needed).
"""
function concate_zeros(vct::Vector{Int64},target_length::Int64)
    lngv = length(vct) 
    if lngv < target_length
        applng = target_length - lngv
        vctzr =  [vct; zeros(Int, applng)]
    else
        vctzr =  vct       
    end
    return vctzr
end     

# ============================================================
# Aliases for backward compatibility (old names)
# ============================================================

const minze = min_edge_code
const minbcd = min_vertex_code
const checkminze = check_min_edge
const checkminbcd = check_min_vertex
const fromzetobcd = edge_to_vertex
const inzetobcd = edge_to_vertex_code
const graphtypefromze = graph_type_from_edge
const graphtypefrombcd = graph_type_from_vertex
const graphsubtypeedge = graph_subtype_edge
const graphsubtypevertex = graph_subtype_vertex
const intgdig = intg_digits
const parsingvertexcode = parsing_vertex_code
const removetrailingzeros = remove_trailing_zeros
const concatezeros  = concate_zeros


end  # end of module

