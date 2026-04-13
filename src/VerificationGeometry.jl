module VerificationGeometry

using ..AllSmallParts
using ..CreateGraphs
using ..GenCodeBasicIsoConf

export calc_angles, calc_angles2,check_values,calc_length_cc_edges, calc_length_ch_branchs
export analyz_length_cc_edges, analyz_length_cc_edges_hyd, analyz_length_ch_branchs, 
       analyz_angle_cc_hyd,analyz_angle_cc_edges
export from_vcode_to_list_angles,from_list_angles_to_vcode


# Aliases for backward compatibility
export calcangles, calcangles2,checkvalues,calclengthcc, calclengthch
export analyzlengthcc, analyzlengthhydcc, analyzlengthch,
        analyzanglehydcc,analyzanglecc 
export fromlistanglestovcode, fromvcodetolistangles



"""
    calc_angles(list_xg::Vector{Float64}, list_yg::Vector{Float64}) -> Vector{Float64}

Computes signed angles between all adjacent edge pairs of the molecular graph's 
central path. Uses vector cross and dot products.

# Arguments
-`list_xg::Vector{Float64}`: List of x-coordinates of all vertices.
-`list_yg::Vector{Float64}`: List of y-coordinates of all vertices.
# Returns
`list_angles::Vector{Float64}`:  List of signed angles in degrees.

"""
function calc_angles(list_xg::Vector{Float64}, 
    list_yg::Vector{Float64})::Vector{Float64}
    lngx = length(list_xg)
    list_angles = Vector{Float64}(); ffi = 0
    for i in 1:1:(lngx - 2)
        x1 = list_xg[i]; y1 = list_yg[i]
        x2 = list_xg[i+1]; y2 = list_yg[i+1]
        x3 = list_xg[i+2]; y3 = list_yg[i+2]
        X1 = x2 - x1; Y1 =y2 - y1
        X2 =x3 - x2; Y2 =y3 - y2
        X3 = X1 + X2; Y3 = Y1 +Y2
        scal_prod13 = X1*X3 + Y1*Y3
        skew_prod13 = X1*Y3 - X3*Y1
        scal_prod23 = X2*X3 + Y2*Y3
        skew_prod23 = X2*Y3 - X3*Y2
        ffi13 = angle_from_prod(scal_prod13, skew_prod13)
        ffi23 = angle_from_prod(scal_prod23, skew_prod23)
        #println(" ffi13 " ,ffi13," ffi23   ", ffi23)
        ffi = pi -abs(ffi13) -abs(ffi23)
        if sign(ffi13) > 0 
            fid = -ffi*180/pi
        else 
            fid = ffi*180/pi
        end    
        push!(list_angles, fid)
    end
    return list_angles          
end    



"""
    angle_from_prod(scal_prod::Float64, skew_Prod::Float64) -> Float64

Computes the angle between two vectors using their dot and cross products.
# Arguments
-`scal_prod::Float64`: Vector dot product.
-`skew_Prod::Float64`: Vector cross product.
# Returns
`angle::Float64`: Angle between two vectors in degrees.
"""
function angle_from_prod(scal_prod::Float64, skew_Prod::Float64)
    if scal_prod == 0 && skew_Prod > 0
        angle = pi/2
    elseif  scal_prod == 0 && skew_Prod < 0 
        angle = -pi/2
    elseif  scal_prod > 0 
        angle = atan(skew_Prod/scal_prod)  
    elseif scal_prod < 0 && skew_Prod >= 0 
        angle = atan(skew_Prod/scal_prod) + pi 
    elseif scal_prod < 0 && skew_Prod < 0
        angle = atan(skew_Prod/scal_prod) - pi
    end
    return angle
end    


"""
    calc_angles2(list_xg::Vector{Float64}, list_yg::Vector{Float64}) -> Vector{Float64}

Computes the angle between two vectors.

# Arguments
-`list_xg::Vector{Float64}`: List of x-coordinates of all vertices.
-`list_yg::Vector{Float64}`: List of y-coordinates of all vertices.
# Returns
`list_angles::Vector{Float64}`:  List of angles in degrees.
"""
function calc_angles2(list_xg::Vector{Float64}, 
    list_yg::Vector{Float64})::Vector{Float64}
    lngx = length(list_xg)
    list_angles  = Vector{Float64}(); ffi = 0; fid = 0
    for i in 1:1:(lngx - 2)
        x1 = list_xg[i]; y1 =list_yg[i]
        x2 = list_xg[i+1]; y2 =list_yg[i+1]
        x3 = list_xg[i+2]; y3 =list_yg[i+2]
        X1 = x2 - x1; Y1 =y2 - y1
        X2 =x3 - x2; Y2 =y3 - y2
        X3 = X1 + X2; Y3 = Y1 + Y2        
        scal_prod13 = X1*X3 + Y1*Y3
        scal_prod23 = X2*X3 + Y2*Y3
        mdX1 = sqrt(X1^2 +Y1^2)
        mdX2 = sqrt(X2^2 +Y2^2)
        mdX3 = sqrt(X3^2 +Y3^2)
        ffi13 = acos(scal_prod13/(mdX1*mdX3))
        ffi23 = acos(scal_prod23/(mdX2*mdX3))
        ffi = pi - ffi13 - ffi23
        fid = ffi*180/pi
        push!(list_angles, fid)
    end
    return list_angles           
end



"""
    check_values(list_values::Vector{Float64}, standard::Float64, tolerance::Float64=1e-5) -> Int64

Helper function: validates each value in the input list against the standard value with a given tolerance.

# Arguments
- `list_values::Vector{Float64}`: List of values of a certain quantity.
- `standard::Float64`: Standard (reference) value.
- `tolerance::Float64`: Tolerance threshold (default: 1e-5). Values within `|value - standard| < tolerance` are considered standard.

# Returns
`Int64`: Number of non-standard elements (where `|value - standard| >= tolerance`).

# Throws
- `ArgumentError` if input contains `NaN` or `Inf` values.
"""
function check_values(list_values::Vector{Float64}, standard::Float64, tolerance::Float64=1e-5)
    # Check for NaN or Inf values
    if any(isnan, list_values) || any(isinf, list_values)
        throw(ArgumentError("Input list contains NaN or Inf values"))
    end

    count = 0
    for val in list_values
        abval = abs(val)
        if abs(standard - abval) >= tolerance
            count += 1
        end
    end
    return count
end



"""
    func(n::Int, k::Int) → Vector{Vector{Int}}
    analyz_angle_cc_hyd(func_gen::Function, n::Int64, standard::Float64) -> Vector{Int64}

Checks angles between all pairs of adjacent edges in the central chain of 
a molecular graph with hydrogen atoms, comparing each angle to the standard angle value.

# Arguments
- `func_gen::Function`: The name of the function for generating a list of vertex codes of graphs.
- `n::Int64`: The number of carbon atoms in a linear polyene molecule.
- `standard::Float64`: Standard value of the angle in degrees.

# Returns
`list_mtk::Vector{Int64}`: List, where each i-th element equals 0 or 1 
depending on the result of checking the i-th angle. If the length of the i-th angle 
is close to the standard, then list_mtk[i] = 0; otherwise, list_mtk[i] = 1.  
"""
function analyz_angle_cc_hyd(
    func::Function,
    n::Int64, 
    standard::Float64
    )
    list_vertex_code = func(n)
    list_mtk = Vector{Int64}(); 
    list_angles = Vector{Float64}(); mtk = 0
    for vertex_code in list_vertex_code
        _,_, list_xg,list_yg, _,_ = create_hydrogen_tree(vertex_code)
        list_angles = calc_angles(list_xg,list_yg)
        mtk = check_values(list_angles, standard) 
        push!(list_mtk, mtk)      
    end    
    return list_mtk
end    


"""
    func(n::Int, k::Int) → Vector{Vector{Int}}
    analyz_angle_cc_edges(func_gen::Function, n::Int64, standard::Float64) -> Vector{Int64}

Checks angles between all pairs of adjacent edges in the central chain of 
a molecular graph without hydrogen atoms, comparing each angle to the standard angle value.

# Arguments
- `func_gen::Function`: The name of the function for generating a list
   of vertex codes of graphs.
- `n::Int64`: The number of carbon atoms in a linear polyene molecule.
- `standard::Float64`: Standard value of the angle in degrees.

# Returns
`list_mtk::Vector{Int64}`: List, where each i-th element equals 0 or 1 
depending on the result of checking the i-th angle. If the length of the i-th angle 
is close to the standard, then list_mtk[i] = 0; otherwise, list_mtk[i] = 1.  
"""
function analyz_angle_cc_edges(
    func::Function,    
    n::Int64, 
    standard::Float64
    )
    list_vertex_code = func(n)
    list_mtk = Vector{Int64}(); list_angles = Vector{Float64}(); mtk = 0
    for vertex_code in list_vertex_code
        _,list_xg,list_yg = create_carbon_chain(vertex_code)
        list_angles = calc_angles(list_xg,list_yg)        
        mtk = check_values(list_angles, standard) 
        push!(list_mtk, mtk)       
    end    
    return  list_mtk
end  



"""
    calc_length_cc_edges(list_xg::Vector{Float64}, list_yg::Vector{Float64}) -> Vector{Float64}

Generates a list of lengths of all edges in the central chain of a molecular graph.

# Arguments
-`list_xg::Vector{Float64}`: List of x-coordinates of all C-vertices.
-`list_yg::Vector{Float64}`: List of y-coordinates of all C-vertices.
# Returns
`list_lengths_cc::Vector{Float64}`: List of edge lengths in the central 
chain of a molecular graph.

"""
function calc_length_cc_edges(list_xg::Vector{Float64},
     list_yg::Vector{Float64})::Vector{Float64}    
    lngx = length(list_xg)
    list_lengths_cc = Vector{Float64}(); length_cc = 0
    for i in 1:1:(lngx - 1)
        x1 = list_xg[i]; y1 = list_yg[i]
        x2 = list_xg[i+1]; y2 = list_yg[i+1]
        length_cc = sqrt((x2-x1)^2 + (y2 - y1)^2)
        push!(list_lengths_cc, length_cc)
    end
    return list_lengths_cc
end


"""
    calc_length_ch_branchs(edg_hydro::Vector{Vector{Int64}},
    list_xg::Vector{Float64},
    list_yg::Vector{Float64}, 
    list_xh::Vector{Float64}, 
    list_yh::Vector{Float64}) -> Vector{Float64}

Generates a list of lengths of all side-chain edges in a molecular graph.
# Arguments
-`list_xg::Vector{Float64}`: List of x-coordinates of all C-vertices.
-`list_yg::Vector{Float64}`: List of y-coordinates of all C-vertices.
-`list_xh::Vector{Float64}`: List of x-coordinates of all H-vertices.
- `list_yh::Vector{Float64}`: List of x-coordinates of all H-vertices.

# Returns
`list_lengths_ch::Vector{Float64}`: List of side-chain edge lengths
 in a molecular graph.

"""
function calc_length_ch_branchs(edg_hydro::Vector{Vector{Int64}},
    list_xg::Vector{Float64},
    list_yg::Vector{Float64}, 
    list_xh::Vector{Float64},
    list_yh::Vector{Float64})::Vector{Float64}
    lnhdr = length(edg_hydro)
    list_lengths_ch = Vector{Float64}()
    for j in 1:lnhdr    
        eh = edg_hydro[j]
        v1=eh[1]; v2=eh[2]
        x1=list_xg[v1]; x2=list_xh[v2]
        y1=list_yg[v1]; y2=list_yh[v2]
        lhx =(x2 - x1); lhy = (y2 - y1)
        length_ch = sqrt(lhx^2 + lhy^2)
        push!(list_lengths_ch, length_ch)
    end
    return list_lengths_ch 

end



"""
    func(n::Int, k::Int) → Vector{Vector{Int}}
    analyz_length_cc_edges(func_gen::Function, n::Int64, standard::Float64) -> Vector{Int64}

Verifies C-C edge lengths in the central path of a molecular graph without hydrogen atoms 
by comparing the length of each edge with its standard length value.     
# Arguments
- `func_gen::Function`: The name of the function for generating a list
   of vertex codes of graphs.
- `n::Int64`: The number of carbon atoms in a linear polyene molecule.
- `standard::Float64`: Standard C-C edge length.

# Returns
`list_mtk::Vector{Int64}`: List, where each i-th element equals 0 or 1 
depending on the result of checking the i-th edge. If the length of the i-th edge 
is close to the standard, then list_mtk[i] = 0; otherwise, list_mtk[i] = 1.
"""
function analyz_length_cc_edges(
    func::Function,
    n::Int64, 
    standard::Float64
    )
    list_vertex_code = func(n)
    list_mtk = Vector{Int64}(); mtk = 0
    for vertex_code in list_vertex_code
        _, list_xg,list_yg = create_carbon_chain(vertex_code)
        list_lengths_cc  = calc_length_cc_edges(list_xg,list_yg)
        #println(" lstLng  \n ",lstLng)
        mtk = check_values(list_lengths_cc, standard)
        push!(list_mtk, mtk)
    end    
    return  list_mtk
end    




"""
    func(n::Int, k::Int) → Vector{Vector{Int}}
    analyz_length_cc_edges_hyd(func_gen::Function, n::Int64, standard::Float64) -> Vector{Int64}

Verifies C-C edge lengths in the central path of a molecular graph with hydrogen atoms 
by comparing the length of each edge with its standard length value. 
   
# Arguments
- `func_gen::Function`: The name of the function for generating a list
   of vertex codes of graphs.
- `n::Int64`: The number of carbon atoms in a linear polyene molecule.
- `standard::Float64`: Standard C-C edge length.

# Returns
`list_mtk::Vector{Int64}`: List, where each i-th element equals 0 or 1 
depending on the result of checking the i-th edge. If the length of the i-th edge 
is close to the standard, then list_mtk[i] = 0; otherwise, list_mtk[i] = 1.
"""
function analyz_length_cc_edges_hyd(
    func::Function,
    n::Int64, 
    standard::Float64
    )
    list_vertex_code = func(n)
    list_mtk = Vector{Int64}(); mtk = 0
    for vertex_code in list_vertex_code
        _,_, list_xg,list_yg, _,_ = create_hydrogen_tree(vertex_code)
        list_lengths_cc = calc_length_cc_edges(list_xg,list_yg)        
        mtk = check_values(list_lengths_cc,standard)
        push!(list_mtk, mtk)
    end    
    return  list_mtk
end    


"""
    func(n::Int, k::Int) → Vector{Vector{Int}}
    analyz_length_ch_branch(func_gen::Function, n::Int64,standard::Float64) -> Vector{Int64}

Verifies C-C edge lengths of a molecular graph with hydrogen atoms 
 by comparing the length of each edge with its standard length value.
# Arguments
- `func_gen::Function`: The name of the function for generating 
   a list of vertex codes of graphs.
- `n::Int64`: The number of carbon atoms in a linear polyene molecule.
- `standard::Float64`: Standard C-H edge length.

# Returns
`list_mtk::Vector{Int64}`: List, where each i-th element equals 0 or 1 
depending on the result of checking the i-th edge. If the length of the i-th edge 
is close to the standard, then list_mtk[i] = 0; otherwise, list_mtk[i] = 1.
"""
function analyz_length_ch_branchs(
    func::Function,
    n::Int64,
    standard::Float64
    )
    list_vertex_code = func(n)
    list_mtk = Vector{Int64}(); mtk = 0
    for vertex_code in list_vertex_code
        _,edg_hydro, list_xg,list_yg, list_xh,list_yh = create_hydrogen_tree(vertex_code)
        list_lengths_ch = calc_length_ch_branchs(edg_hydro,list_xg,list_yg, list_xh,list_yh)
        #println(" lstLng  \n ",lstLng)
        mtk = check_values(list_lengths_ch, standard)
        push!(list_mtk, mtk)
    end    
    return  list_mtk
end  


"""
    from_list_angles_to_vcode(list_angles::Vector{Float64}) -> Vector{Int64}

Constructs a vertex code from the list of angles between all vertex pairs along 
the molecular graph's central path.
"""
function from_list_angles_to_vcode(list_angles::Vector{Float64})
    vertex_code = map(x->sign(x)==1.0 ? 1 : 0, list_angles)
    return vertex_code
end    


"""
    from_vcode_to_list_angles(vertex_code::Vector{Int64},type::Int64) -> Vector{Float64}

Given a vertex code of a molecular graph (type1: without H, type2: with H), constructs a 
list of angles between all adjacent vertex pairs of the carbon chain (path).
"""
function from_vcode_to_list_angles(vertex_code::Vector{Int64},type::Int64)
    if type == 1
        _,list_xg,list_yg = create_carbon_chain(vertex_code)
        list_angles = calc_angles(list_xg,list_yg)
    elseif type == 2
        _,_, list_xg,list_yg, _,_ = create_hydrogen_tree(vertex_code)
        list_angles = calc_angles(list_xg,list_yg)
    else 
        _,list_xg,list_yg = create_carbon_chain(vertex_code)
        list_angles = calc_angles(list_xg,list_yg)        
    end
end 


# ============================================================
# Aliases for backward compatibility (old names)
# ============================================================
const calcangles = calc_angles
const calcangles2 = calc_angles2
const checkvalues = check_values
const calclengthcc =  calc_length_cc_edges
const calclengthch = calc_length_ch_branchs
const analyzlengthcc = analyz_length_cc_edges
const analyzlengthhydcc = analyz_length_cc_edges_hyd
const analyzlengthch  = analyz_length_ch_branchs
const analyzanglehydcc = analyz_angle_cc_hyd
const analyzanglecc = analyz_angle_cc_edges
const fromlistanglestovcode = from_list_angles_to_vcode
const fromvcodetolistangles = from_vcode_to_list_angles


end