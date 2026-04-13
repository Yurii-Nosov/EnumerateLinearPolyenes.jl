module EnumerateLinearPolyenes


include("AllSmallParts.jl")
include("GenCodeBasicIsoConf.jl")
include("GenCodeSubGraphCOI.jl")
include("GenCodeUniversal.jl")
include("CreateGraphs.jl")
include("OutputGraphs.jl")
include("CountCodeIsoConf.jl")
include("DetermClassSymmetry.jl")
include("DistribGraphsOverlapping.jl")
include("VerificationGeometry.jl")

using .AllSmallParts
using .GenCodeBasicIsoConf
using .GenCodeSubGraphCOI
using .GenCodeUniversal
using .CreateGraphs
using .OutputGraphs
using .CountCodeIsoConf
using .DetermClassSymmetry
using .DistribGraphsOverlapping
using .VerificationGeometry


using .AllSmallParts: zam, invert, intg_digits, func, min_edge_code, min_vertex_code, 
       check_min_edge,check_min_vertex, edge_to_vertex, edge_to_vertex_code,
       graph_type_from_edge, graph_type_from_vertex,graph_subtype_edge,graph_subtype_vertex, 
       parsing_vertex_code, lpdval,lpdstr,concate_zeros,remove_trailing_zeros

export zam, invert,func,intgdig, minze, minbcd, checkminze, checkminbcd,fromzetobcd, 
       inzetobcd, graphtypefromze, graphtypefrombcd,graphsubtypeedge,graphsubtypevertex,
       lpdval,lpdst, parsingvertexcode, concatezeros, removetrailingzeros

using .GenCodeBasicIsoConf: generate_all_codes, generate_isomer_vertex, 
       generate_isomer_edge, generate_trans_conformer_vertex,
       generate_trans_conformer_edge,generate_other_conformer_vertex,
       generate_other_conformer_edge

export genallcode, genisovertex, genisoedge, gentransconfvertex, gentransconfedge,
       genotherconfvertex,genotherconfedge    


using .GenCodeSubGraphCOI: gen_coi_subtype_edge, gen_coi_subtype_vertex,
       generate_coi_non_cis3p, generate_coi_cis3, generate_coi_cis4p       

export gencoisubtypeedge, gencoisubtypevertex,
       generatecoinoncis3p, generatecoicis3, generatecoicis4p       

using .GenCodeUniversal: gen_codes_all_graphs, gen_codes_graphs_type, 
       gen_codes_graphs_coiso, check_yeh_vertex, check_yeh_edge, gen_codes_yeh_graphs    
export gen_codes_all_graphs, gen_codes_graphs_type, gen_codes_graphs_coiso, 
       check_yeh_vertex, check_yeh_edge, gen_codes_yeh_graphs


using .CreateGraphs: makepolyenpathcc, makepolyentreehh
export makepolyenpathcc, makepolyentreehh

using .OutputGraphs: show_graph_cc, show_graph_hyd, show_graph_wait,
       output_graph_cc, output_graph_hyd, show_list_graphs_cc, print_list_graphs_cc, 
       show_list_graphs_hyd, print_list_graphs_hyd
       
export showgraphcc, showgraphhyd, outputgraphcc, outputgraphhyd,showgraphwait,
       showlistgraphscc, showlistgraphshyd,printlistgraphscc, printlistgraphshyd

using .CountCodeIsoConf:  countcodefromze,  countcodefrombcd, countlistcodefromze,
       countlistcodefrombcd, savecountlistcode,
       countcoi, countlistcoi, savecountlistcoi, count_other_conformers_subtype
export countcodefromze,  countcodefrombcd, countlistcodefromze,
       countlistcodefrombcd, savecountlistcode,
       countcoi, countlistcoi, savecountlistcoi, countotherconfosubtype

using .DetermClassSymmetry: symmetry_class_from_vertex, symmetry_class_from_edge,
       count_graphs_by_symmetry_vertex, count_graphs_by_symmetry_edge,
       count_graphs_by_symmetry_range, output_graphs_by_symmetry_range
export symclassfromvertex,symclassfromedge,  countgraphsbysymvertex,
       countgraphsbysymedge, countgraphsbysymrange, outputgraphsbysymrange

using .DistribGraphsOverlapping: npov, max_overlap_pairs, count_intersect, 
       show_all_graphs_overlap, show_select_graphs_overlap,save_select_graphs_overlap,
       calc_distr_all_graphs_overlap, output_distr_all_graphs_overlap,
       output_list_distr_yeh_graphs,distribution_graphs_overlap 

export  npov, maxoverlappairs, countintersect,showallgraphsoverlap, showselectgraphsoverlap, 
       saveselectgraphsoverlap,calcdistrallgraphsoverlap, outputdistrallgraphsoverlap, outputlistdistryehgraphs,
       distribgraphsoverlap 

       
using .VerificationGeometry: calcangles, calcangles2,checkvalues,calclengthcc,
       calclengthch, analyzlengthcc, analyzlengthhydcc, analyzlengthch,
       analyzanglehydcc,analyzanglecc,fromlistanglestovcode, fromvcodetolistangles

export calcangles, calcangles2,checkvalues,calclengthcc, calclengthch,
       analyzlengthcc, analyzlengthhydcc, analyzlengthch,
       analyzanglehydcc,analyzanglecc,fromlistanglestovcode, fromvcodetolistangles




end



