module OutputGraphs

using Plots

#using ..AllSmallParts

using ..CreateGraphs





export show_graph_cc, show_graph_hyd, show_graph_wait, output_graph_cc,
       output_graph_hyd,show_list_graphs_cc, show_list_graphs_hyd,
       print_list_graphs_hyd, print_list_graphs_cc 

# Aliases for backward compatibility
export showgraphcc, showgraphhyd, outputgraphcc, outputgraphhyd,
        showgraphwait, showlistgraphscc, showlistgraphshyd,
       printlistgraphscc, printlistgraphshyd


  

"""
    show_graph_cc(xg::Vector{Float64},yg::Vector{Float64})

Displays an image of a molecular graph with suppressed hydrogen atoms.

# Arguments
- `xg::Vector{Float64}`: A list of the X coordinates of the vertices of a molecular graph 
   representing carbon atoms in a carbon-carbon chain;
- `yg::Vector{Float64}`: A list of the Y coordinates of the vertices of a molecular graph
    representing carbon atoms in a carbon-carbon chain.

Notes!
`xg[i]`,`yg[i]` - are the x,y coordinates of the i-th vertex, representing the carbon atom.    
"""
function  show_graph_cc(xg,yg)    
    pts=plot(xg, yg,ls = :solid,lw = 4,lc = :green, showaxis = false, 
    legend = false, aspect_ratio = :equal)
    scatter!(pts,xg, yg, mc = :black, ms = 7, ma = 0.9)
    display(pts)    
end


"""
    output_graph_cc(xg::Vector{Float64},yg::Vector{Float64},fpath::String)

Displays an image of a molecular graph with suppressed hydrogen atoms.

# Arguments
- `xg::Vector{Float64}`: A list of the X coordinates of the vertices of a molecular graph 
   representing carbon atoms in a carbon-carbon chain;
- `yg::Vector{Float64}`: A list of the Y coordinates of the vertices of a molecular graph
    representing carbon atoms in a carbon-carbon chain.
- `fpath::String`: name of graphic aile
Notes!
`xg[i]`,`yg[i]` - are the x,y coordinates of the i-th vertex, representing the carbon atom.    
"""
function  output_graph_cc(xg::Vector{Float64},yg::Vector{Float64},fpath::String)    
    pts = plot(xg, yg,ls = :solid,lw = 4,lc = :green, showaxis = false, 
    legend = false, aspect_ratio = :equal)
    scatter!(pts,xg, yg, mc = :black, ms = 7, ma = 0.9)
    display(pts)
    savefig(pts,fpath)    
end



"""
    show_graph_wait(xg,yg)

Displays a molecular graph, segment by segment, without hydrogen atoms.    

# Arguments
- `xg::Vector{Float64}`: a list of the X coordinates of the vertices of a molecular graph 
   representing carbon atoms in a carbon-carbon chain;
- `yg::Vector{Float64}`: a list of the Y coordinates of the vertices of a molecular graph
    representing carbon atoms in a carbon-carbon chain.
    
Notes!
`xg[i]`,`yg[i]` - are the x,y coordinates of the i-th vertex, representing the carbon atom.
"""
function  show_graph_wait(xg,yg)
    pts = plot(xg,yg, ls = :solid, lw = 4, lc = :green,
    showaxis = false,legend = false,aspect_ratio = :equal)    
    x1 = 1;xe =2;  y1 = 1;ye =2; lngx = length(xg)
    for i = 1:(lngx-1)
        xgs = copy(xg[x1:1:xe])
        ygs = copy(yg[y1:1:ye])        
        plot!(pts,xgs, ygs, lc =:red)
        display(pts)
        xe += 1; ye += 1
    end
    display(pts)
end    


"""
    show_list_graphs_cc(list_vertex_code::Vector{Vector{Int64}})

Displays molecular graphs without hydrogen atoms generated from a list of vertex codes.    
# Arguments
- list_vertex_code::Vector{Vector{Int64}}: a list of vertex codes, where each code is a 
  two-element vector.

See also [`CreateGraphs.create_carbon_chain`](@ref), [`show_graph_cc`](@ref)
"""
function show_list_graphs_cc(list_vertex_code::Vector{Vector{Int64}})
    nmb = length(list_vertex_code) 
    for k in 1:nmb
        vertex_code = list_vertex_code[k]
        _,  xg, yg = create_carbon_chain(vertex_code)
        show_graph_cc(xg,yg)
    end
end    

 
"""
    print_list_graphs_cc(list_vertex_code::Vector{Vector{Int64}},dirpath::String)

Displays molecular graphs without hydrogen atoms generated from a list of vertex codes.    
# Arguments
- list_vertex_code::Vector{Vector{Int64}}: a list of vertex codes, where each code is a 
  two-element vector.

See also [`CreateGraphs.create_carbon_chain`](@ref), [`show_graph_cc`](@ref)
"""
function print_list_graphs_cc(list_vertex_code::Vector{Vector{Int64}},
    dirpath::String)    
    nmb = length(list_vertex_code)      
    for k in 1:nmb
        vertex_code = list_vertex_code[k]
        fname = parsing_vertex_code(vertex_code)
        filename = fname*"-$k"*".png"
        fpath = joinpath(dirpath, filename)
        _,  xg, yg = create_carbon_chain(vertex_code)
        output_graph_cc(xg,yg,fpath)        
    end
end    



"""
    show_graph_hyd(edgHydro,xg,yg, xh,yh)
Displays an image of a molecular graph with hydrogen atoms.

# Arguments
- `edgHydro::Vector{Vector{Int64}}`: a list of edges in which each edge is a two-element
   vector;
- `xg::Vector{Float64}`: a list of the X coordinates of the vertices of a molecular graph 
   representing carbon atoms in a carbon-carbon chain;
- `yg::Vector{Float64}`: a list of the Y coordinates of the vertices of a molecular graph
    representing carbon atoms in a carbon-carbon chain;
- xh::Vector{Float64}`: list of X coordinates of the vertices of the molecular graph 
  representing hydrogen atoms;
- yh::Vector{Float64}`: list of Y coordinates of the vertices of the molecular graph 
  representing hydrogen atoms.

Notes!
- `xg[i]`,`yg[i]` are the x,y coordinates of the i-th vertex, representing the carbon atom.
- `xh[i]`,`yh[i]` are the x,y coordinates of the i-th vertex representing the hydrogen atom. 

  See also [`CreateGraphs.create_hydrogen_tree`](@ref)
"""
function show_graph_hyd(edgHydro,xg,yg, xh,yh)
    pts = plot(xg, yg,ls =:solid, lw = 6, lc =:black)
    plot!(pts, showaxis = false, legend = false, aspect_ratio = :equal)    
    lnhdr = length(edgHydro)
    for j in 1:lnhdr    
        eh = edgHydro[j]
        v1=eh[1];
        v2=eh[2]
        x1=xg[v1]
        x2=xh[v2]
        y1=yg[v1]
        y2=yh[v2]
        LHX=[x1,x2]
        LHY=[y1,y2]
        plot!(pts,LHX, LHY, ls =:solid, lw = 6,lc =:blue)
    end
    scatter!(xh,yh, mc = :blue, ms = 6, ma = 0.65)
    scatter!(xg, yg, mc = :black, ms = 8, ma = 0.9)
    display(pts)    
end 

 
"""
    output_graph_hyd(edgHydro::Vector{Vector{Int64}},
    xg::Vector{Float64},yg::Vector{Float64},
     xh::Vector{Float64},yh::Vector{Float64}, fpath::String)
Displays an image of a molecular graph with hydrogen atoms.

# Arguments
- `edgHydro::Vector{Vector{Int64}}`: a list of edges in which each edge is a two-element
   vector;
- `xg::Vector{Float64}`: a list of the X coordinates of the vertices of a molecular graph 
   representing carbon atoms in a carbon-carbon chain;
- `yg::Vector{Float64}`: a list of the Y coordinates of the vertices of a molecular graph
    representing carbon atoms in a carbon-carbon chain;
- xh::Vector{Float64}`: list of X coordinates of the vertices of the molecular graph 
  representing hydrogen atoms;
- yh::Vector{Float64}`: list of Y coordinates of the vertices of the molecular graph 
  representing hydrogen atoms.

Notes!
- `xg[i]`,`yg[i]` are the x,y coordinates of the i-th vertex, representing the carbon atom.
- `xh[i]`,`yh[i]` are the x,y coordinates of the i-th vertex representing the hydrogen atom. 

  See also [`CreateGraphs.create_hydrogen_tree`](@ref)
"""
function output_graph_hyd(edgHydro::Vector{Vector{Int64}},
    xg::Vector{Float64},yg::Vector{Float64},
     xh::Vector{Float64},yh::Vector{Float64}, fpath::String)
    pts = plot(xg, yg,ls =:solid, lw = 6, lc =:black)
    plot!(pts, showaxis = false, legend = false, aspect_ratio = :equal)    
    lnhdr = length(edgHydro)
    for j in 1:lnhdr    
        eh = edgHydro[j]
        v1=eh[1];
        v2=eh[2]
        x1=xg[v1]
        x2=xh[v2]
        y1=yg[v1]
        y2=yh[v2]
        LHX=[x1,x2]
        LHY=[y1,y2]
        plot!(pts,LHX, LHY, ls =:solid, lw = 6,lc =:blue)
    end
    scatter!(xh,yh, mc = :blue, ms = 6, ma = 0.65)
    scatter!(xg, yg, mc = :black, ms = 8, ma = 0.9)
    display(pts)
    savefig(pts,fpath)        
end 


"""
    show_list_graphs_hyd(list_vertex_code::Vector{Vector{Int64}})

Displays molecular graphs with hydrogen atoms generated from a list of vertex codes .    
# Arguments
- list_vertex_code::Vector{Vector{Int64}}: a list of vertex codes, where each code is a 
  two-element vector.

See also [`CreateGraphs.create_hydrogen_tree`](@ref),  [`show_graph_hyd`](@ref)
"""
function show_list_graphs_hyd(list_vertex_code::Vector{Vector{Int64}})
    nmb = length(list_vertex_code)
    for k in 1:nmb
        vertex_code = list_vertex_code[k]
        _, edgHydro, xg, yg, xh,yh = create_hydrogen_tree(vertex_code)
        show_graph_hyd(edgHydro,xg,yg, xh,yh)
    end
end    



"""
    print_list_graphs_hyd(list_vertex_code::Vector{Vector{Int64}},dirpath::String)

Displays molecular graphs with hydrogen atoms generated from a list of vertex codes .    
# Arguments
- list_vertex_code::Vector{Vector{Int64}}: a list of vertex codes, where each code is a 
  two-element vector.

See also [`CreateGraphs.create_hydrogen_tree`](@ref),  [`show_graph_hyd`](@ref)
"""
function print_list_graphs_hyd(list_vertex_code::Vector{Vector{Int64}},
    dirpath::String)
    nmb = length(list_vertex_code)
    for k in 1:nmb
        vertex_code = list_vertex_code[k]
        fname = parsing_vertex_code(vertex_code)
        filename = fname*"-$k"*".png"
        fpath = joinpath(dirpath, filename)
        _, edgHydro, xg, yg, xh,yh = create_hydrogen_tree(vertex_code)
        output_graph_hyd(edgHydro,xg,yg, xh,yh,fpath)        
    end
end     




# ============================================================
# Aliases for backward compatibility (old names)
# ============================================================

const  showgraphcc = show_graph_cc
const  showgraphhyd = show_graph_hyd
const  outputgraphcc = output_graph_cc
const  outputgraphhyd = output_graph_hyd
const  showgraphwait = show_graph_wait
const  outputlistgraphscc = show_list_graphs_cc
const  outputlistgraphshyd = show_list_graphs_hyd
const  printlistgraphscc = print_list_graphs_cc
const  printlistgraphshyd = print_list_graphs_hyd


end  #  end of module