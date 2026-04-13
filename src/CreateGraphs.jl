module CreateGraphs

export create_carbon_chain, create_hydrogen_tree

# Aliases for backward compatibility
export makepolyenpathcc, makepolyentreehh

# ============================================================
# SHORT CONSTANT NAMES
# ============================================================

# Original long names:
# const CARBON_CARBON_BOND_LENGTH = 1.44
# const CARBON_HYDROGEN_BOND_LENGTH = 1.08

# Short names (keeping same values):
const CC_LEN = 1.44    # Carbon-carbon bond length
const CH_LEN = 1.08    # Carbon-hydrogen bond length

# Initial coordinates
const INIT_X = 7.1023
const INIT_Y = 3.3107

# Precomputed geometric constants (using short names)
const DX_CC = CC_LEN * sqrt(3) / 2
const DY_CC = CC_LEN * 0.5

const DX_CH = CH_LEN * sqrt(3) / 2
const DY_CH = CH_LEN * 0.5

# 6 direction variants
const VARIANTS = Dict(
    1 => (dXR =  DX_CC, dYR = -DY_CC, dXL = 0.0, dYL = CC_LEN),     # VAR 1
    2 => (dXR = -DX_CC, dYR =  DY_CC, dXL = 0.0, dYL = -CC_LEN),   # VAR 2
    3 => (dXR = 0.0, dYR = CC_LEN, dXL = -DX_CC, dYL = -DY_CC),    # VAR 3
    4 => (dXR = 0.0, dYR = -CC_LEN, dXL =  DX_CC, dYL =  DY_CC),   # VAR 4
    5 => (dXR =  DX_CC, dYR =  DY_CC, dXL =  -DX_CC, dYL = DY_CC), # VAR 5
    6 => (dXR = -DX_CC, dYR = -DY_CC, dXL = DX_CC, dYL =  -DY_CC)  # VAR 6
)

"""
    create_carbon_chain(vertex_code::Vector{Int64}) -> Tuple{Vector{Vector{Int64}}, Vector{Float64}, Vector{Float64}}

Creates a geometric model of a linear polyene molecular graph without hydrogen atoms.

# Arguments
- `vertex_code`: vector of length p = n-2 (vertex code, internal vertices)
  - 0 = next edge turns left
  - 1 = next edge turns right

# Returns
A tuple of three elements:
1. List of graph edges
2. Vector of X-coordinates of vertices
3. Vector of Y-coordinates of vertices
"""
function create_carbon_chain(vertex_code::Vector{Int64})
    p = length(vertex_code)
    
    if p < 1
        error("Vertex code must contain at least 1 element (n ≥ 4)")
    end
    
    n = p + 2
    
    # Initialize data structures
    edges = Vector{Vector{Int64}}()
    x_coords = Vector{Float64}()
    y_coords = Vector{Float64}()
    
    # Step 1: Initialize coordinates
    x1, y1 = INIT_X, INIT_Y
    x2 = x1 + DX_CC
    y2 = y1 + DY_CC
    
    push!(x_coords, x1, x2)
    push!(y_coords, y1, y2)
    push!(edges, [1, 2])
    
    # Step 2: Build chain
    current_vertex = 2
    
    for i in 1:p
        next_vertex = current_vertex + 1
        
        # Determine geometric variant
        variant = determine_variant(x_coords, y_coords, current_vertex)
        
        # Get displacements
        dXR, dYR, dXL, dYL = VARIANTS[variant]
        
        # Choose direction
        if vertex_code[i] == 0
            next_x = x_coords[current_vertex] + dXL
            next_y = y_coords[current_vertex] + dYL
        else
            next_x = x_coords[current_vertex] + dXR
            next_y = y_coords[current_vertex] + dYR
        end
        
        # Add new vertex and edge
        push!(x_coords, next_x)
        push!(y_coords, next_y)
        push!(edges, [current_vertex, next_vertex])
        
        current_vertex = next_vertex
    end
    
    return edges, x_coords, y_coords
end

"""
    create_hydrogen_tree(vertex_code::Vector{Int64}) -> Tuple{
        Vector{Vector{Int64}},  # C-C edges
        Vector{Vector{Int64}},  # C-H edges  
        Vector{Float64},        # C X-coordinates
        Vector{Float64},        # C Y-coordinates
        Vector{Float64},        # H X-coordinates
        Vector{Float64}         # H Y-coordinates
    }

Creates a complete geometric model with hydrogen atoms.
"""
function create_hydrogen_tree(vertex_code::Vector{Int64})
    p = length(vertex_code)
    
    if p < 1
        error("Vertex code must contain at least 1 element (n ≥ 4)")
    end
    
    n = p + 2
    
    # Create carbon chain
    cc_edges, c_x_coords, c_y_coords = create_carbon_chain(vertex_code)
    
    # Initialize for hydrogen atoms
    ch_edges = Vector{Vector{Int64}}()
    h_x_coords = Vector{Float64}()
    h_y_coords = Vector{Float64}()
    
    # Add hydrogen atoms
    for c_idx in 1:n
        cx = c_x_coords[c_idx]
        cy = c_y_coords[c_idx]
        
        if c_idx == 1
            # First terminal carbon
            #variant = determine_variant(c_x_coords, c_y_coords, 2)
            variant = 2
            dXR, dYR, dXL, dYL = VARIANTS[variant]
            
            if length(vertex_code) > 0 && vertex_code[1] == 0
                h1_x = cx + 0.75 * dXR
                h1_y = cy + 0.75 * dYR
                h2_x = cx + 0.75 * dXL
                h2_y = cy + 0.75 * dYL
            else
                h1_x = cx + 0.75 * dXL
                h1_y = cy + 0.75 * dYL
                h2_x = cx + 0.75 * dXR
                h2_y = cy + 0.75 * dYR
            end
            
            h_idx1 = length(h_x_coords) + 1
            h_idx2 = h_idx1 + 1
            
            push!(h_x_coords, h1_x, h2_x)
            push!(h_y_coords, h1_y, h2_y)
            push!(ch_edges, [c_idx, h_idx1])
            push!(ch_edges, [c_idx, h_idx2])
            
        elseif c_idx == n
            # Last terminal carbon
            variant = determine_variant(c_x_coords, c_y_coords, n)
            dXR, dYR, dXL, dYL = VARIANTS[variant]
            
            h1_x = cx + 0.75 * dXR
            h1_y = cy + 0.75 * dYR
            h2_x = cx + 0.75 * dXL
            h2_y = cy + 0.75 * dYL
            
            h_idx1 = length(h_x_coords) + 1
            h_idx2 = h_idx1 + 1
            
            push!(h_x_coords, h1_x, h2_x)
            push!(h_y_coords, h1_y, h2_y)
            push!(ch_edges, [c_idx, h_idx1])
            push!(ch_edges, [c_idx, h_idx2])
            
        else
            # Internal carbon
            variant = determine_variant(c_x_coords, c_y_coords, c_idx)
            dXR, dYR, dXL, dYL = VARIANTS[variant]
            
            if c_idx <= length(vertex_code) + 1 && vertex_code[c_idx-1] == 0
                h_x = cx + 0.75 * dXR
                h_y = cy + 0.75 * dYR
            else
                h_x = cx + 0.75 * dXL
                h_y = cy + 0.75 * dYL
            end
            
            push!(h_x_coords, h_x)
            push!(h_y_coords, h_y)
            push!(ch_edges, [c_idx, length(h_x_coords)])
        end
    end
    
    return cc_edges, ch_edges, c_x_coords, c_y_coords, h_x_coords, h_y_coords
end

# ============================================================
# Helper functions
# ============================================================

"""
    determine_variant(x_coords::Vector{Float64}, y_coords::Vector{Float64}, 
                      current_vertex::Int64) -> Int64

Determines geometric variant (1-6).
"""
function determine_variant(x_coords::Vector{Float64}, y_coords::Vector{Float64}, 
                           current_vertex::Int64)
    if current_vertex < 2
        error("At least two vertices needed")
    end
    
    x_prev = x_coords[current_vertex - 1]
    y_prev = y_coords[current_vertex - 1]
    x_curr = x_coords[current_vertex]
    y_curr = y_coords[current_vertex]
    
    if x_prev < x_curr && y_prev < y_curr
        return 1
    elseif x_prev > x_curr && y_prev > y_curr
        return 2
    elseif x_prev > x_curr && y_prev < y_curr
        return 3
    elseif x_prev < x_curr && y_prev > y_curr
        return 4
    elseif x_prev == x_curr && y_prev < y_curr
        return 5
    elseif x_prev == x_curr && y_prev > y_curr
        return 6
    else
        return 1
    end
end

# ============================================================
# Aliases
# ============================================================

const makepolyenpathcc = create_carbon_chain
const makepolyentreehh = create_hydrogen_tree

end  # end of module