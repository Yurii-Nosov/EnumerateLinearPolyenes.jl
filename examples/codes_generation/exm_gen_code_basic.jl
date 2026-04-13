using EnumerateLinearPolyenes

# An example of generating vertex codes for molecular graphs of isomers, conformers 
# of trans-isomers, and conformers of other isomers


#  ****    Vertex codes are used when generating graphs   ************

n = 8      #  Order of molecular graphs.
# ctype -  Type of code used for generation: 1-vertex or 2-edge code.

ctype = 1  #  Vertex code used

#  ******   Generation of codes for molecular graphs of isomers   ******

lstbcd = generate_isomer_vertex(n)

println(" lstbcd  \n",lstbcd)     # Outputting a list of codes to the terminal

#  ***   Generation of codes for molecular graphs of trans-isomer conformers   ***

lstbcd = generate_trans_conformer_vertex(n)

println(" lstbcd  \n",lstbcd)        # Outputting a list of codes to the terminal

#  *** Generation of codes for molecular graphs of conformers of other isomers  **

lstbcd = generate_other_conformer_vertex(n)

println(" lstbcd  \n",lstbcd)        # Outputting a list of codes to the terminal

# ************************************************************
# =========   Edge codes are used when generating graphs   ============

ctype = 2   #  Edge code used

# ******   Generation of codes for molecular graphs of isomers   *******

lstbcd = generate_isomer_edge(n)

println(" lstbcd  \n",lstbcd)       # Outputting a list of codes to the terminal

# ***   Generation of codes for molecular graphs of trans-isomer conformers   ***

lstbcd = generate_trans_conformer_edge(n)

println(" lstbcd  \n",lstbcd)       # Outputting a list of codes to the terminal

#  *** Generation of codes for molecular graphs of conformers of other isomers  **

lstbcd = generate_other_conformer_edge(n)

println(" lstbcd  \n",lstbcd)    # Outputting a list of codes to the terminal
