# input_output_guide

## INPUT_OUTPUT_GUIDE

In the current package, input is handled not via files but through variables, vectors,
and tuples. The resulting outputs are printed to the console or saved to a text file,
while images are displayed on the screen and/or saved as graphic files.

## Input Data

The package functions expect data in the form of Julia variables of specific types.
Integer variables of type Int64 can be used, such as:

    - `n` or `order` — the order of a molecular graph with suppressed hydrogen atoms;
    
    - `graph_type` — the class of the molecular graph; can take one of three values: 1, 2, 3;
    
    - `code_type` — the type of code used; can take one of two values: 1 or 2;
    
    - `orders` — the range of variation for the graph order.

Note that the order of the molecular graph must be an even number and its value must
be at least 6, i.e., `n >= 6`.

Integer vectors of type `Vector{Int64}` and vectors of vectors of type `Vector{Vector{Int64}}`
can also be used as input. Examples of such vectors include:

    - `vertex_code` — the vertex code of the molecular graph;
    
    - `edge_code` — the edge code of the molecular graph;
    
    - `list_vertex_code` and `list_edge_code` — vectors of vertex or edge codes.

Any code, whether vertex or edge, is represented as a vector where elements are separated by
commas, and each element is either 0 or 1. The number `p` of elements in the vertex code is
an even number determined from the graph order as `p = n – 2`. The number mm of elements in the
edge code is an odd number determined from the graph order as `mm = n – 3`.

For example:

    - `[0,1,0,1,0,1,0,1]` — vertex code for a molecular graph of order `n = 10`;
    
    - `[0,1,0,1,1,0,1]` — edge code for a molecular graph of order `n = 10`.

## Output Data

Output data can be integer vectors of type `Int64` and vectors of vectors of type
`Vector{Vector{Int64}}`. Most commonly, these vectors represent vertex or edge codes
of molecular graphs. Vectors of type `Vector{Vector{Int64}}` typically represent lists
of vertex or edge codes.

Other examples of Int64 vectors include distribution vectors for the number of molecular
graphs by symmetry classes and by the number of overlapping vertex pairs.
A distribution vector for the number of molecular graphs by symmetry classes has 5 elements:

    1. The first element stores the graph order;
    
    2. The second element stores the number of isomers with the first symmetry class (symmetry group C2h​);
    
    3. The third element stores the number of isomers with the second symmetry class (symmetry group C2v​);
    
    4. The fourth element stores the number of isomers with the third symmetry class (symmetry group CS​);
    
    5. The fifth element stores the total number of graphs.

For instance, such a vector for molecular graph isomers of order `n = 6` is `[6, 1, 1, 0, 2]`,
and for graphs of order `n = 8` it is `[8, 0, 2, 1, 3]`.
You can obtain the distribution vector for molecular graphs by symmetry class using the
following functions:

    - `count_graphs_by_symmetry_vertex(graphs_type, order)`
    
    - `count_graphs_by_symmetry_edge(graphs_type, order)`

Example function call:

```julia
using EnumerateLinearPolyenes
graphs_type = 1 # isomers
order = 8 
# calculation
class_sym_count = count_graphs_by_symmetry_edge(graphs_type, order)
println("class_sym_count \n", class_sym_count) # output
```

A distribution vector for the number of molecular graphs by the number of overlapping
vertex pairs must have (Novrmax​ + 1) elements, where Novrmax​ is the maximum possible
number of overlapping vertex pairs determined by the graph complexity level level and
its order n using the function max_overlap_pairs(n, level). The value of Novrmax
increases with the complexity of the graphs.

For Yeh graphs, the complexity level is level = 1; for graphs with three consecutive
edges in cis-configuration, level = 2; and for graphs with four consecutive edges
in cis-configuration, level = 3.

The first element stores the number of graphs without overlapping vertices, the
second element — the number with one pair of overlapping vertices, the third — with two pairs, the fourth — with three pairs, the fifth — with four pairs, etc. For example, for Yeh molecular graphs of order n = 14, such a vector is `[422, 3, 2, 0]`.

You can obtain this distribution vector using the function:
`calc_distr_all_graphs_overlap(list_vertex_code)`.

Example of calling the function, processing the distribution vector, and outputting results:

```julia
using EnumerateLinearPolyenes

# Generate vector of Yeh graph codes

list_vertex_code = collect(mol_graph_yeh(20))

# Calculate distribution vector for number of molecular graphs
distr_overlap = calc_distr_all_graphs_overlap(list_vertex_code)

# Process distribution vector and output result

output_distr_all_graphs_overlap(distr_overlap)
```

However, a more general output format is a tuple whose elements do not necessarily
need to be of the same type.
A tuple representing the distribution of molecular graphs by their types has 5 elements:

    1. The first element stores the graph order;
    
    2. The second — the number of isomers;
   
    3. The third — the number of trans-isomer conformers;
   
    4. The fourth — the number of other isomer conformers;
    
    5. The fifth — the total count of isomer and conformer graphs.
     
For example, such a tuple for molecular graphs of order `n = 6` is `(6, 2, 2, 2, 6)`,
and for `n = 8` — `(8, 3, 5, 12, 20)`.

You can determine this tuple using:

    - `count_codes_from_edge(n)`
    
    - `count_codes_from_vertex(n)`

Example `calling count_codes_from_edge(n)`:

```julia
using EnumerateLinearPolyenes
n = 8 # order
list_vertex_code = count_codes_from_edge(n)
# output result
println("list_vertex_code \n", list_vertex_code)
```

A tuple for the distribution of other isomer conformers by subtype has 6 elements:

    1. Graph order;
    
    2. Number of other isomer conformer graphs;
    
    3. Number of graphs with 4 consecutive cis-configured edges;
    
    4. Number without 4 consecutive cis-configured edges;
    
    5. Number with 3 consecutive cis-configured edges;
    
    6. Number without 3 consecutive cis-configured edges.

For example, for molecular graphs of order `n = 6`, this tuple is `(6, 2, 2, 2, 6)`;
for `n = 8`, it is `(8, 3, 5, 12, 20)`.
You can get this tuple using the functioncount_other_conformers(n).

Example calling `count_other_conformers(n)`:

```julia

using EnumerateLinearPolyenes
n = 8    # order
# Calculate distribution
(n, total_coi, with_4_cis, without_4_cis,
with_3_cis, without_3_cis) = count_other_conformers(n)
# Output
println("n ", n, " total_coi ", total_coi, " with_4_cis ", with_4_cis,
" without_4_cis ", without_4_cis,
" with_3_cis ", with_3_cis, " without_3_cis ", without_3_cis)
```

Heterogeneous tuples are created by functions:

    - `create_carbon_chain`
    
    - `create_hydrogen_tree`

The function create_carbon_chain(vertex_code) creates a molecular graph with suppressed
hydrogen atoms as a list of edges and lists of x and y coordinates. For instance, for a
molecular graph of order `n = 8`, the edge list is `[[1,2],[2,3],[3,4],[4,5],[5,6]]`.

## Examples of Function Calls

Examples of calling and using all main functions are provided in the examples folder.
The corresponding results are stored in the Results folder. Note that all calculation
 results presented in the article were obtained using programs collected in the examples folder.

## Folder: codes_generation

### Generating Vertex Codes for Molecular Graphs of Three Main Classes

Copy and run the `file exm_gen_code_basic.jl` in REPL.
Review the resulting codes in terminale.

### Generating Vertex Codes for Conformer Graphs of Other Isomers

Copy and run the file `exm_gen_code_sub_graphs_coi.jl` in REPL.
Review the resulting codes in terminale.

### Generating Vertex Codes Using Advanced Functions

Copy and run the file `exm_gen_code_universal.jl` in REPL.
Review the resulting codes in terminale.

## Folder: counting_graphs

### Calculating Distribution of Molecular Graphs by Their Classes

Copy and run the file `exm_distrib_graphs_by_type.jl` in REPL.
The results should match those in the Distrib_molecular_graphs folder in
the DistribNumberMolGraphs.txt file.

### Calculating Distribution of Conformer Graphs of Other Isomers by Subclasses

Copy and run the file `exm_distrib_graphs_sub_graphs_coi.jl` in REPL.
The results should match those in the Distrib_molecular_graphs folder in the
DistribNumbSubGraphsCOI.ixt file.

## Folder: create_and_output_graphs

### Creating a Molecular Graph with Suppressed Hydrogen Atoms

Copy and run the file `exm_create_graph_cc.jl` in REPL.
Review the resulting edge and coordinate lists.

### Creating a Molecular Graph with Hydrogen Atoms

Copy and run the file `exm_create_graph_hyd.jl` in REPL.
Review the resulting edge and coordinate lists.

### Creating and Outputting Molecular Graphs with Suppressed Hydrogen Atoms

Copy and run the file `exm_output_graphs_cc.jl` in REPL.
The results should match those in the Figures folder
(subfolders: Isomers_and_Conformers).

### Creating and Outputting Molecular Graphs with Hydrogen Atoms

Copy and run the file `exm_output_graphs_hyd.jl` in REPL.
The results should match those in the Figures folder (subfolders: Isomers_and_Conformers).

## Folder: distrib_graphs_by_overlap

### Calculating Overlap Pair Distribution for Yeh Graphs of Order 14–26

Copy and run the file `exm_distrib_overlap_n14_26.jl` in REPL.
A text file `DistribYehGraphsByOverlap.txt` will be created in the
DistributionYehGraphsByOverlap folder.

### Calculating Overlap Pair Distribution for Yeh Graphs of Order 28–30

Copy and run the file exm_distrib_overlap_n28_30.jl in REPL.

Two text files will be created in the DistributionYehGraphsByOverlap folder:

    - `ResultDistribYehGraphsOverlapN28.txt`
    
    - `ResultDistribYehGraphsOverlapN30.txt`

### Outputting Overlap Pair Lists for Yeh Graphs

Copy and run the file `exm_output_list_yeh_graphs_overlap.jl` in REPL.
A text file `ListDistribYehGraphsOverlap.txt` will be created in the
DistributionYehGraphsByOverlap folder.

### Displaying and Saving Graph Images with Specified Overlap Pairs

Copy and run the file `exm_show_select_graphs_overlap.jl` in REPL.
For graphs of order `n = 18`, results should match those in the ShowSelectOverlapN18 folder.
For graphs of order `n = 24`, results should match those in the ShowSelectOverlapN24 folder.

## Folder: distrib_graphs_by_symmetry

### Calculating Symmetry Group Distribution for Isomers

Copy and run the file `exm_distr_isomers_by_symmetry.jl` in REPL.
The results should match those in the Distrib_molecular_graphs_by_symmetry folder in
the DistribNumberIsomersBySymmetry.txt file.

### Calculating Symmetry Group Distribution for Trans‑Isomer Conformers

Copy and run the file `exm_distr_con_trn_iso_by_symmetry.jl` in REPL.

The results should match those in the Distrib_molecular_graphs_by_symmetry folder in the
DistribNumberConTransIsoBySymmetry.txt file.
