module DistribGraphsOverlapping

using ..AllSmallParts
using ..GenCodeUniversal
using ..CreateGraphs
using ..OutputGraphs

export npov, max_overlap_pairs, count_intersect, show_all_graphs_overlap, show_select_graphs_overlap,
    save_select_graphs_overlap,calc_distr_all_graphs_overlap, output_distr_all_graphs_overlap,
    output_list_distr_yeh_graphs,distribution_graphs_overlap 


# Aliases for backward compatibility
export maxoverlappairs, countintersect,showallgraphsoverlap, showselectgraphsoverlap, 
       calcdistrallgraphsoverlap, outputdistrallgraphsoverlap, outputlistdistryehgraphs,
       distribgraphsoverlap, saveselectgraphsoverlap

#  npov -- number pairs overlap vertex


"""
    npov(k::Int64) -> Int64

Computes the number of vertex overlap pairs in a set of k vertices where every pair
 of vertices overlaps.
"""
function npov(k::Int64)
    if isodd(k) == true
        res = div(k-1, 2) * k
    elseif iseven(k) == true
        res = div(k, 2) * (k-1) 
    end
    return res
end          

"""
    max_overlap_pairs(n::Int64,level::Int64) -> Int64
Computes the maximum possible number of vertex overlap pairs for a graph of order n.
This value is used in the `calc_distr_all_graphs_overlap`` function to set the length
of the distribution vector for graph counts by overlap pair count.
# Arguments
- `n::Int64`: graph order.
- `level::Int64`: graph complexity level. 
# Returns
- `ndst::Int64`: maximum possible number of vertex overlap pairs.
"""
function max_overlap_pairs(n::Int64,level::Int64)
    if level == 1
        del = 12
    elseif  level == 2
        del = 10
    elseif level == 3
        del = 6
    else
        del = 6
    end
    p = div(n,del); q = rem(n, del)    
    ndst = (del - q)*npov(p) + q*npov(p+1) + 1   #### new
    return ndst
end    

"""
    count_intersect(XG::Vector{Float64}, YG::Vector{Float64}) -> Int64

Returns the number of vertex overlaps for the carbon atoms in the molecular graph.
# Arguments
- `XG::Vector{Float64}`: List/Array of x-coordinates for all vertices of the 
   molecular graph.
- `YG::Vector{Float64}`: List/Array of y-coordinates for all vertices of the 
   molecular graph.    
"""
function count_intersect(XG::Vector{Float64}, YG::Vector{Float64})
    kin = 0    
    q = length(XG)
    for i in 1:q
        fr = i+1
        x1 = abs(XG[i])
        y1 = abs(YG[i])
        for j in fr:q
            x2 = XG[j]
            y2 = YG[j]
            dlx = abs(x1-x2)
            dly = abs(y1-y2)
            if (dlx <= 0.000001) && (dly <= 0.000001)
                kin += 1                
            end 
        end
    end
    return kin
end            

"""
    show_all_graphs_overlap(list_vertex_code::Vector{Vector{Int64}}, nglob::Int64) -> Int64

Displays images of all molecular graphs with vertex overlaps.    
# Arguments
- `list_vertex_code::Vector{Vector{Int64}}`:
- `nglob::Int64`: 
# Returns
- `nbd::Int64`: number of graphs  with the vertex overlaps.
-  
See also [`CreateGraphs.create_carbon_chain`](@ref), [`OutputGraphs.show_graph_cc`](@ref)
    [`count_intersect`](@ref)
"""
function show_all_graphs_overlap(list_vertex_code::Vector{Vector{Int64}},
    nglob::Int64)    
    res = 0; nbd = 0     
    lngh = length(list_vertex_code)    
    for k in 1:1:lngh
        res = 0        
        vertex_code = list_vertex_code[k]                 
        _, XG, YG = create_carbon_chain(vertex_code)
        res = count_intersect(XG, YG)
        if res != 0 
            nbd += 1
            nglob += 1
            println(" Nglob ", nglob, "  k  ", k," number of vertex overlaps ", res, "  vertex_code  ", vertex_code)
            show_graph_cc(XG,YG)            
        end        
    end
    println(" number of graphs  with the vertex overlaps ", nbd)    
end        


"""
    show_select_graphs_overlap(list_vertex_code,npf::Int64, 
    nglob::Int64)

Displays molecular graphs with at least a specified number of vertex overlap pairs.    
# Arguments
- `list_vertex_code::Vector{Vector{Int64}}`: List of graph vertex codes.
- `npf::Int64`: Threshold for vertex overlap pairs (for graph filtering).
- `nglob::Int64`: Number of previously displayed molecular graphs.

# Returns
- Prints the count of selected graphs and the vertex overlap pair threshold.
- For each graph displayed, a tuple of 4 elements is output to the terminal
  and a text file:
  1. Display sequence number (global).
  2. Current index in the list.
  3. Vertex overlap pair count for the graph.
  4. Vertex code of the graph.
See also [`CreateGraphs.create_carbon_chain`](@ref), [`OutputGraphs.show_graph_cc`](@ref)
    [`count_intersect`](@ref) 
"""
function show_select_graphs_overlap(list_vertex_code::Vector{Vector{Int64}},
    npf::Int64, nglob::Int64)
    res = 0; nbd = 0       
    lngh = length(list_vertex_code)    
    for k in 1:1:lngh
        res = 0        
        vertex_code = list_vertex_code[k]                 
        _, XG, YG = create_carbon_chain(vertex_code)
        res = count_intersect(XG, YG)
        if res >= npf 
            nbd += 1           
            nglob += 1
            println("Nglob ", nglob," nbd ", nbd, " k ", k," num_over ", res, 
            " vertex_code ", vertex_code)            
            show_graph_cc(XG,YG)            
        end        
    end
    println(" number of graphs ", nbd," with the vertex overlaps >= ", npf)        
end        


"""
    save_select_graphs_overlap(list_vertex_code,npf::Int64, 
    nglob::Int64, dirpath::String, fname::String)

Displays molecular graphs with at least a specified number of vertex overlap pairs.    
# Arguments
- `list_vertex_code::Vector{Vector{Int64}}`: List of graph vertex codes.
- `npf::Int64`: Threshold for vertex overlap pairs (for graph filtering).
- `nglob::Int64`: Number of previously displayed molecular graphs.
- `dirpath::String`: Path to the folder containing the file.
- `fname::String`: File name without extension

# Returns
- Prints the count of selected graphs and the vertex overlap pair threshold.
- For each graph displayed, a tuple of 4 elements is output to the terminal
  and a text file:
  1. Display sequence number (global).
  2. Current index in the list.
  3. Vertex overlap pair count for the graph.
  4. Vertex code of the graph.
See also [`CreateGraphs.create_carbon_chain`](@ref), [`OutputGraphs.show_graph_cc`](@ref)
    [`count_intersect`](@ref) 
"""
function save_select_graphs_overlap(list_vertex_code::Vector{Vector{Int64}},
    npf::Int64, nglob::Int64, dirpath::String, fname::String)
    filename = fname*".txt"    
    fpath = joinpath(dirpath, filename)
    f = open(fpath, "w")
    res = 0; nbd = 0       
    lngh = length(list_vertex_code)    
    for k in 1:1:lngh
        res = 0        
        vertex_code = list_vertex_code[k]                 
        _, XG, YG = create_carbon_chain(vertex_code)
        res = count_intersect(XG, YG)
        if res >= npf 
            nbd += 1           
            nglob += 1
            println("Nglob ", nglob," nbd ", nbd, " k ", k," num_over ", res, 
            " vertex_code ", vertex_code)
            println(f,"Nglob = $nglob, nbd = $nbd, k = $k, numb overlaps $res,
             vertex_code  $vertex_code")
            figname = "fig_$nbd"*".png"
            fgrpath = joinpath(dirpath, figname)
            output_graph_cc(XG,YG,fgrpath)            
        end        
    end
    println(" number of graphs  with the vertex overlaps ", nbd)
    println(f," number of graphs with the vertex overlaps - $nbd")
    close(f)
    println("Done, file created")
end        




"""
    calc_distr_all_graphs_overlap(list_vertex_code::Vector{Vector{Int64}})

Computes the distribution of molecular graphs by vertex overlap pair count.
# Arguments
- `list_vertex_code::Vector{Vector{Int64}}`: List of graph vertex codes.
- `level::Int64`: graph complexity level.
# Returns
- `dist_num_overlap::Vector{Int64}`: Distribution list (graph count per number of vertex
   overlap pairs). A list where the *n*-th element contains the number of graphs with exactly
   *n-1* vertex overlap pairs. List length is set by length_distr.    

See also [`CreateGraphs.create_carbon_chain`](@ref), [`count_intersect`](@ref)  
"""
 function calc_distr_all_graphs_overlap(list_vertex_code::Vector{Vector{Int64}})
    res = 0; level = 2 
    n = length(list_vertex_code[1]) + 2 
    lng_dno = max_overlap_pairs(n,level) + 2
    dist_num_overlap = fill(0,lng_dno)        
    lngh = length(list_vertex_code)    
    for k in 1:1:lngh
        res = 0        
        vertex_code = list_vertex_code[k]        
        _, XG, YG = create_carbon_chain(vertex_code)
        res = count_intersect(XG, YG)
        if res >= 0            
            dist_num_overlap[res + 1] += 1                                
        end        
    end
    return  dist_num_overlap
end 


"""
    output_distr_all_graphs_overlap(dist_num_overlap)
Given a distribution list of graph counts by vertex overlap pair count, the function
 computes,  prints the list, and outputs the following key parameters:
- `sum_prov::Int64` — Total number of graphs.
- `num_non_over::Int64` — Number of graphs with zero vertex overlaps.
- `num_with_over::Int64` — Number of graphs with at least one vertex overlap pair.
- `dnov::Float64` — Percentage of graphs with zero overlaps.
- `dwt::Float64` — Percentage of graphs with one or more overlap pairs.
"""
function output_distr_all_graphs_overlap(dist_num_overlap)
    num_non_over = dist_num_overlap[1]; 
    num_with_over = sum(dist_num_overlap) - num_non_over
    sum_prov = sum(dist_num_overlap)
    dnov = num_non_over/sum_prov *100.; dwt = num_with_over/sum_prov*100.
    println("Total: ", sum_prov, ", No overlaps: ", num_non_over, ", With overlaps: ", num_with_over)
    println("Zero-overlap %: ", dnov, ", Overlap %: ", dwt)
    println("Distribution by overlap pairs: \n", dist_num_overlap)   
end    



"""
    output_list_distr_yeh_graphs(orders::StepRange{Int, Int},
    dirpath::String, fname::String)


"""
function output_list_distr_yeh_graphs(orders::StepRange{Int, Int},
    dirpath::String, fname::String)
    filename = fname*".txt" 
    fpath = joinpath(dirpath, filename) 
    mxn = orders[end]
    lstBcd = collect(gen_codes_yeh_graphs(mxn))
    distr = calc_distr_all_graphs_overlap(lstBcd)
    println(" 1 \n ",distr)   
    distr = remove_trailing_zeros(distr)
    max_length = length(distr) 
    println(" 2 max_length ",max_length) 
    setdistr = Set{Vector{Int64}}()
    global heade_list = Vector{Int64}()

    for n in orders
        println(" n  ",n)
        lstbcd = collect(generate_coi_non_cis3p(n)) 
        # Явно указываем локальные переменные
        local  distr
      
        distr = calc_distr_all_graphs_overlap(lstbcd)
    
        push!(heade_list,n)
        
        distr = concate_zeros(distr,max_length)
    
        println(distr)
        push!(setdistr,distr)
    end

    heade_list = sort(heade_list)   
    println(" heade_list   \n ",heade_list)

   listdistr = sort(collect(setdistr))
   length_list_distr = length(listdistr)
   println(" length_list_distr  ",length_list_distr)
   mainhead = "Distribution of Yeh’s n-order molecular graphs by vertex overlap count Novr"
   hdstr = "    The number of molecular graphs of order n          "
   lng1 = length(hdstr); applng = 57 - lng1
   line = repeat("-", 57)
   file = open(fpath, "w")
   write(filename, "\r\n")
   println(mainhead)
   write(file, mainhead*"\n")
   println(line)
   write(file,line*"\n")
   headstring  = string("|", lpdstr(hdstr,applng),"|")
   println(headstring)
   write(file,headstring*"\n")
   println(line)
   write(file,line*"\n")
   z1 = heade_list[1]; z2 = heade_list[2]; z3 = heade_list[3]
   z4 = heade_list[4]; z5 = heade_list[5];z6 = heade_list[6]; z7 = heade_list[7];
   strzag = string("|", lpdstr("Novr",6),"|",lpdstr(" n=$z1 ",6),"|", lpdstr(" n=$z2 ",6), 
   "|",lpdstr(" n=$z3 ",6), "|", lpdstr(" n=$z4 ",6),"|", lpdstr(" n=$z5 ",6),"|",
   lpdstr(" n=$z6 ",6),"|", lpdstr(" n=$z7 ",6), "|")
   println(strzag)
   write(file,strzag*"\n")
   println(line)
   write(file,line*"\n")
   for j in 1:max_length
        k = j - 1    
        str = string("|", lpdstr("$k",6),"|") 
       lds::Int64 = 0
       for i in 1:length_list_distr
            vctr = listdistr[i]
            lds = vctr[j]
            str = string(str,lpdval(lds,6),"|")        
        end 
        println(str)
        write(file,str*"\n")    
    end
    println(line)
    write(file,line*"\n")
    close(file)
    println("File creation completed successfully") 
end    


####     New Developments Section =====================================
"""
This section presents upgraded functions for exploring graphs with vertex overlaps.
These functions allow you to work with graphs of the order of 30 or more.
"""

"""
    count_overlappings(vertex_code::Vector{Int64}) -> Int64

Computes the number of vertex overlap pairs for a graph constructed from its vertex code.
"""
function count_overlappings(vertex_code::Vector{Int64})
    _, x, y = create_carbon_chain(vertex_code)
    lngX = length(x); lngY = length(y)
    lstNIns = (check_overlap(x,y,i,j) for i in 1:lngX  for j in (i+1):lngY)
    numIns = sum(lstNIns)
    return numIns
end 

 
"""
    check_overlap(X,Y,i::Int64,j::Int64)

Checks whether vertices `i` and `j` coincide in (x, y) coordinates.

Returns:
- `1` if coordinates (xg[i], yg[i]) and (xg[j], yg[j]) are approximately 
   equal (using `isapprox`);
- `0` otherwise.

Parameters:
- `xg`, `yg` :: Vector{Float64} — x- and y-coordinates of all vertices;
- `i`, `j` :: Int — vertex indices (1 ≤ i, j ≤ length(xg)).
"""
function check_overlap(X,Y,i::Int64,j::Int64)
    x1 =X[i]; y1 = Y[i]
    x2 =X[j]; y2 = Y[j]
    if abs(x1-x2) <= 0.0001 && abs(y1-y2) <= 0.0001
        return   1
    else
        return 0
    end          
end    

 
"""
    processing_part_graphs(list_vertex_code, lng_distr_vect::Int64)

The helper function is used in the function `distribution_graphs_overlap` to create and process a given number
of graphs. Computes the distribution of molecular graphs by vertex overlap pair count.
    
# Arguments
- `list_vertex_code::Vector{Vector{Int64}}`: List of graph vertex codes.
- `lng_distr_vect::Int64`: Length of the graph distribution vector by the number
   of vertex overlaps. 
# Returns
- `distr_num_over_accum::Vector{Int64}`: Distribution list (graph count per number of vertex
   overlap pairs). A list where the *n*-th element contains the number of graphs with exactly
   *n-1* vertex overlap pairs. List length is set by length_distr.   
- `sum_nia::Int64` : Total number of graphs
- `prc_nia_zero::Float64` : Percentage of graphs with zero overlaps.
"""
function  processing_part_graphs(list_vertex_code,lng_distr_vect::Int64)        
    distr_num_over_accum = fill(0, lng_distr_vect)
    for (i,gy) in enumerate(list_vertex_code)
        nmi = count_overlappings(gy) 
        distr_num_over_accum[nmi+1] += 1
    end
    sum_nia = sum(distr_num_over_accum)
    prc_nia_zero = (distr_num_over_accum[1]/sum_nia)*100
    return  distr_num_over_accum, sum_nia, prc_nia_zero
end 

"""
    zam_distr(partial_distr_vector, lng_dstr_vect, distr_vector_local)

The helper function is used in the `distribution_graphs_overlap` function to
update the graph distribution vector by the number of vertex overlaps, based
on the data obtained in the `processing_part_graphs` function.

# Arguments
- `partial_distr_vector::Vector{Int64}`: Partial distribution vector of graphs by 
   number of vertex overlaps, obtained in function `processing_part_graphs`. 
- `lng_dstr_vect::Int64`: Length of the graph distribution vector by the number
   of vertex overlaps. 
- `distr_vector_local::Vector{Int64}`: Local distribution vector of graphs by 
   number of vertex overlaps, used to update the resulting (aggregate) 
   distribution vector
"""
function zam_distr(partial_distr_vector, lng_distr_vect, distr_vector_local)
    #global dstr_nia_sum
    for i in 1:lng_distr_vect
        distr_vector_local[i] += partial_distr_vector[i]
    end
end    


"""
    distribution_graphs_overlap(list_vertex_code::Vector{Vector{Int64}},level::Int64,npr::Int64)

Computes the distribution of molecular graphs by vertex overlap pair count. Generation 
and calculation of the distribution of graphs by the number of vertex overlaps is performed
 in parts, with `npr` graphs in each part.
# Arguments
- `list_vertex_code::Vector{Vector{Int64}}`: List of graph vertex codes.
- `level::Int64`: graph complexity level.
- `npr::Int64` : A specified number of graphs created and processed in a single part.

# Returns
A tuple of three elements:
- `distr_vector::Vector{Int64}`: 
- `sum_distr::Int64` : Total number of graphs.
- `prc_nia_nul::Float84`: Percentage of graphs with zero overlaps.
- `prc_nia_ss::Float84`: Percentage of graphs with overlappings.
"""
function distribution_graphs_overlap(list_vertex_code::Vector{Vector{Int64}},level::Int64,npr::Int64)
    n = length(list_vertex_code[1]) + 2 
    lng_distr_vect = max_overlap_pairs(n,level) + 2 
    gry = list_vertex_code
    prt_gry  = Iterators.partition(gry, npr)
    distr_vector = fill(0, lng_distr_vect)
    sum_distr = 0
    for (i,gy) in enumerate(prt_gry)
        partial_distr_vector, sum_part_distr, prc_nia_nul = processing_part_graphs(gy,lng_distr_vect)
        println(" i =   ", i,"  partial distribution vector \n", partial_distr_vector) 
        println(" sumNIA    ", sum_part_distr, "    n/N 0%    ", prc_nia_nul, "   n_s/N %   ", (100. - prc_nia_nul))
        zam_distr(partial_distr_vector,lng_distr_vect,distr_vector)        
        sum_distr += sum_part_distr 
    end
    prc_nia_nul = (distr_vector[1]/sum_distr)*100; prc_nia_ss = 100. - prc_nia_nul
    return distr_vector, sum_distr, prc_nia_nul, prc_nia_ss
end 


# ============================================================
# Aliases for backward compatibility (old names)
# ============================================================
const maxoverlappairs = max_overlap_pairs
const countintersect = count_intersect 
const showallgraphsoverlap = show_all_graphs_overlap
const showselectgraphsoverlap = show_select_graphs_overlap
const saveselectgraphsoverlap = save_select_graphs_overlap
const outputdistrallgraphsoverlap = output_distr_all_graphs_overlap
const calcdistrallgraphsoverlap = calc_distr_all_graphs_overlap
const outputlistdistryehgraphs = output_list_distr_yeh_graphs
const distribgraphsoverlap = distribution_graphs_overlap

end