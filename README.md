# EnumerateLinearPolyenes

The repository contains a Julia program for the algorithm described in the article
Yu.L. Nosov, M.N. Nazarov, "Constructive enumeration and study of molecular graphs of unbranched conjugated polyene hydrocarbons". This article is currently under review.

## Installation

To install, use Julia's built-in package manager to add the package and also to
instantiate/build all the required dependencies

```julia
julia> using Pkg
julia> Pkg.add("EnumerateLinearPolyenes")
```

Or in Julia REPL,

```julia
] add  EnumerateLinearPolyenes
```

### Running Tests

```julia
using Pkg
Pkg.test("EnumerateLinearPolyenes")
```

### Basic Usage

```julia
using EnumerateLinearPolyenes
#    Generation of codes for molecular graphs of isomers ==========
n = 8      #  Order of molecular graphs.
# ctype -  Type of code used for generation: 1-vertex or 2-edge code.
ctype = 1  #  Vertex code used  
lstbcd = generate_isomer_codes(n,ctype) #   code generation  
```

For more details, see the `input_output_guide.md` file in the "info" folder.

## The repository contains

- directory **src**  with the main module `EnumerationLinearPolyenes` and all other modules;

- directory **examples** with Julia files that include all programs necessary to obtain the results presented in the article;

- directory **results** with the article’s results in the form of text and graphic files;

- directory **test** with files for testing all core functions of the package.

### File structure in the catalog src

The catalog **src** contains Julia files of all 11 modules:

- EnumerateLinearPolyenes — the main module;

- AllSmallParts — contains all auxiliary functions used in other functions;

- GenCodeBaisicIsoConf — contains functions for generating vertex and edge codes of molecular graphs of different types: isomers, conformers of trans‑isomers, and conformers of other isomers;

- GenCodeSubgraphCOI — contains functions for generating codes of different subtypes of molecular graphs of conformers of other isomers;

- GenCodeUniversal — contains functions for generating codes of different types from the GenCodeUniversal module;

- CreateGraphs — contains functions for creating molecular graphs both with and without hydrogen atoms;

- OutputGraphs — contains functions for displaying graph images on screen;

- CountCodeIsoConf — contains functions for determining the number of molecular graphs of different types;

- DetermClassSymmetry — contains functions for calculating the distribution of graphs of different types across symmetry classes;

- DistrubGraphsOverlapping — contains functions for calculating the distribution of the number of molecular graphs by the number of pairs of overlapping vertices;

- VerificationGeomety — contains functions for calculating edge lengths and angles between pairs of adjacent vertices based on vertex coordinates x,y, as well as for verifying edge lengths and angles against specified values.

### File structure in the catalog examples

The catalog **examples** contains:

```julia
    1. Folder **code_generation** with Julia files:
        
        - `ё`exm_gen_code_basic.jl` — contains examples of generating codes for molecular graphs of isomers, conformers of trans‑isomers, and conformers of other isomers;
        
        - `exm_gen_code_subgraph_coi.jl` — contains examples of generating codes for different subtypes of molecular graphs of conformers of other isomers;
        
        - `exm_gen_code_universal.jl` — contains examples of generating codes of different types using functions from the GenCodeUniversal module.
    
    2. Folder **counting_graphs** with Julia files:
        
        - `exm_distrib_graphs_by_type.jl` — contains examples of calculating the distribution of the number of molecular graphs by graph types;
        
        - `exm_distrib_sub_graphs_coi.jl` — contains examples of calculating the distribution of the number of molecular graphs of conformers of other isomers by graph subtypes.
    
    3. Folder **create_and_output_graphs** with Julia files:
        
        - `exm_create_graphs_cc.jl` — contains examples of generating molecular graphs with suppressed hydrogen atoms;
        
        - `exm_create_graphs_hyd.jl` — contains examples of generating molecular graphs with hydrogen atoms;
        
        - `exm_output_graphs_cc.jl` — contains examples of generating and displaying images of molecular graphs with suppressed hydrogen atoms;
        
        - `exm_output_graphs_hyd.jl` — contains examples of generating and displaying images of molecular graphs with hydrogen atoms.
    
    4. Folder **distrib_graphs_by_overlap** with Julia files:
        
        - `exm_distrib_overlap_n14_26.jl` — contains examples of calculating the distribution of Yeh graphs of order 14–26 by the number of pairs of overlapping vertices;
        
        - `exm_distrib_overlap_n28_30.jl` — contains two examples of calculating the distribution of Yeh graphs of order 28 and 30 by the number of pairs of overlapping vertices;
        
        - `exm_output_list_distr_yeh_graphs.jl` — contains an example of creating a summary table of distributions of Yeh molecular graphs of order 14–26 by the number of overlapping vertex pairs;
        
        - `exm_show_select_graphs_overlap.jl` — contains two examples of selecting and displaying images of Yeh molecular graphs of order 18 and 22 with a specified number of overlapping vertex pairs.
    
    5. Folder **distrib_graphs_by_symmetry** with Julia files:
        
        - `exm_distr_isomers_by_symmetry.jl` — contains examples of calculating the distribution of molecular graphs of isomers across symmetry classes;
        
        - `exm_distr_con_trn_iso_by_symmetry.jl` — contains examples of calculating the distribution of molecular graphs of conformers of trans‑isomers across symmetry classes.
```

### File structure in the catalog results

The catalog **results** contains:

```julia
    1. Folder **Distribution_of_molecular_graphs** with text files:
        
        - `DistribNumberMolGraphs.txt` — contains results of calculating the distribution of the number of molecular graphs by graph types;
        
        - `DistribNumbSubGraphsCOI.txt` — contains results of calculating the distribution of the number of molecular graphs of conformers of other isomers by subtypes of graphs determined by the presence or absence of cisoid chains of length 3 and 4.
    
    2. Folder **Distribution_of_molecular_graphs_by_symmetry** with text files:
        
        - `DistribNumberConOthIsoBySymmetry.txt` — contains results of calculating the distribution of the number of molecular graphs of conformers of other isomers across symmetry classes;
        
        - `DistribNumberConTransIsoBySymmetry.txt` — contains results of calculating the distribution of the number of molecular graphs of conformers of trans‑isomers across symmetry classes;
        
        - `DistribNumberIsomersBySymmetry.txt` — contains results of calculating the distribution of the number of molecular graphs of isomers across symmetry classes.
    
    3. Folder **DistributionYehGraphsByOverlap** with text files:
        
        - `DistribYehGraphsByOverlapping.txt` — contains results of calculating the distribution of Yeh molecular graphs of order 14–26 by the number of overlapping vertex pairs (presented as a list);
        
        - `ListDistribYehGraphsOverlap.txt` — contains results of calculating the distribution of Yeh molecular graphs of order 14–26 by the number of overlapping vertex pairs (presented as a table);
        
        - `ResultDistribYehGraphsOverlapN28.txt` — contains results of calculating the distribution of the number of Yeh molecular graphs of order 28 by the number of overlapping vertex pairs;
        
        - `ResultDistribYehGraphsOverlapN30.txt` — contains results of calculating the distribution of the number of Yeh molecular graphs of order 30 by the number of overlapping vertex pairs.
    
    4. Folder **DistributionYehGraphsByOverlap** with subfolders:
        
        - Folder **ShowSelectOverlapN18** with image files of graphs of order 18 having a specified number of overlapping vertex pairs, and a text file ShowSelectOverlapN18.txt containing data on these graphs;
        
        - Folder **ShowSelectOverlapN22** with image files of graphs of order 22 having a specified number of overlapping vertex pairs, and a text file ShowSelectOverlapN22.txt containing data on these graphs.
    
    5. Folder **Figures** with subfolders:
        
        - Folder **Isomers** with image files of molecular graphs of isomers of order 10;
        
        - Folder **Conformers** with image files of molecular graphs of conformers of trans‑isomers of order 10.
```

### File structure in the catalog test

The catalog **test** contains:

- `runtests.jl` — runs Julia test files from the **test** folder;

- `detaills_tests.jl` — tests auxiliary functions;

- `gen_from_bcd_tests.jl` — tests functions for generating molecular graph codes using vertex codes;

- `gen_from_ze_tests.jl` — tests functions for generating molecular graph codes using edge codes;

- `count_basic_iso_tests.jl` — tests functions for counting codes of molecular graphs of isomers, conformers of trans‑isomers, and conformers of other isomers;

- `count_con_other_iso_tests.jl` — tests functions for counting codes of molecular graphs of subtypes of conformers of other isomers;

- `calc_class_sym_tests.jl` — tests functions for calculating the distribution of molecular graphs across symmetry classes;

- `calc-distr_overlap_tests.jl` — tests functions for calculating the distribution of molecular graphs by the number of pairs of overlapping vertices.

## License

- **Code** (all files outside the `info/` folder): [MIT License](LICENSE).

- **Documentation and supplementary materials** (folder `info/`): [Creative Commons Attribution-NonCommercial-NoDerivatives

4.0 International (CC BY-NC-ND 4.0)](info/LICENSE.md).

### Explanations

- The package code may be used, modified, and distributed under the MIT terms.

- Materials in 'info/' may only be read and shared (without modification or commercial gain).

For other uses, please request permission.
