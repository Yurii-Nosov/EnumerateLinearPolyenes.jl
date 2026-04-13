module CountCodeIsoConf

using ..AllSmallParts

export count_codes_from_edge, count_codes_from_vertex, 
       count_codes_range_edge, count_codes_range_vertex, save_count_codes_range_edge,
       count_other_conformers, count_other_conformers_range, 
       save_count_other_conformers_range, count_other_conformers_subtype

# Aliases for backward compatibility
export  countcodefromze,  countcodefrombcd, countlistcodefromze,
        countlistcodefrombcd, savecountlistcode,
        countcoi, countlistcoi, savecountlistcoi,countotherconfosubtype

# Константы для типов графов (для ясности)
const ISOMER_TYPE = 1           # Изомеры
const TRANS_CONFORMER_TYPE = 2  # Конформеры транс-изомеров  
const OTHER_CONFORMER_TYPE = 3  # Конформеры других изомеров

"""
    count_codes_from_edge(n::Int64) -> Tuple{Int64, Int64, Int64, Int64, Int64}

Counts the number of non-isomorphic molecular graphs of all three classes using 
edge codes (ZE codes) for a polyene with n vertices.

# Argumemts
- `n`: molecular graph order (n ≥ 6)

# Returns:
A tuple of 5 values:
1. n (number of vertices)
2. Number of isomers
3. Number of conformers of trans-isomers
4. Number of conformers of other isomers
5. Total number of non-isomorphic graphs

# Algorithm
1. Generate all possible edge codes of length m = n-3.
2. For each code, check whether it is canonical.
3. If the code is canonical, determine its type (1,2,3).
4. Calculate the graphs by type.
"""
function count_codes_from_edge(n::Int64)
    if n < 6
        error("n must be at least 6(received n=$n)")
    end
    
    m = n - 3                     # number of internal edges
    total_combinations = 2^m      # total possible binary codes of length m
    
    num_isomers = 0
    num_trans_conformers = 0
    num_other_conformers = 0
    num_total = 0
    
    for k in 1:total_combinations
        # Generate binary code for the number (k-1), since k goes from 1 to 
        # total_combinations and we need numbers from 0 to total_combinations-1
        edge_code = intg_digits(k-1, m)
        
        # Check if the code is canonical
        canonical_code = min_edge_code(edge_code)
        
        if edge_code == canonical_code
            num_total += 1
            
            # Determine the graph type
            graph_type = graph_type_from_edge(edge_code)
            
            if graph_type == ISOMER_TYPE
                num_isomers += 1
            elseif graph_type == TRANS_CONFORMER_TYPE
                num_trans_conformers += 1
            elseif graph_type == OTHER_CONFORMER_TYPE
                num_other_conformers += 1
            end
        end
    end
    
    return (n, num_isomers, num_trans_conformers, num_other_conformers, num_total)
end

"""
    count_codes_from_vertex(n::Int64) -> Tuple{Int64, Int64, Int64, Int64, Int64}

Counts the number of non-isomorphic molecular graphs of all three classes given vertex 
codes (B-codes) for a polyene with n vertices.
# Arguments
- `n`: molecular graph order (n ≥ 6)

# Returns
Same as `count_codes_from_edge`
"""
function count_codes_from_vertex(n::Int64)
    if n < 6
        error("n must be at least 6(received n=$n)")
    end
    
    p = n - 2                     # number of internal vertices
    total_combinations = 2^(p-1)  # take symmetry into account
    
    num_isomers = 0
    num_trans_conformers = 0
    num_other_conformers = 0
    num_total = 0
    
    for k in 1:total_combinations
        # Generate binary code for number (k-1)
        vertex_code = intg_digits(k-1, p)
        
        # Check if the code is canonical
        canonical_code = min_vertex_code(vertex_code)
        
        if vertex_code == canonical_code
            num_total += 1
            
            # Determine the graph type
            graph_type = graph_type_from_vertex(vertex_code)
            
            if graph_type == ISOMER_TYPE
                num_isomers += 1
            elseif graph_type == TRANS_CONFORMER_TYPE
                num_trans_conformers += 1
            elseif graph_type == OTHER_CONFORMER_TYPE
                num_other_conformers += 1
            end
        end
    end
    
    return (n, num_isomers, num_trans_conformers, num_other_conformers, num_total)
end



"""
    save_count_codes_range_edge(n_start::Int64, n_end::Int64, dirpath::String, fname::String)

Outputs a list of the counts of graphs of all types for a range of n (by edge codes). 
Saves the list to a text file.

# Arguments
- `n_start`: the initial value of n (even, ≥ 6);
- `n_end`: the final value of n (even, ≥ n_start);
- `dirpath::String`: The absolute path to the folder where the file will be created;
- `fname::String`: The file name (without extension) in which the resultingю 
   list is saved.
"""
function save_count_codes_range_edge(n_start::Int64, n_end::Int64, dirpath::String, fname::String)
    if n_start < 6 || n_end < n_start
        error("Некорректный диапазон: n_start=$n_start, n_end=$n_end")
    end
    filename = fname*".txt"    
    fpath = joinpath(dirpath, filename)
    head1 = "Distribution of the number of molecular graphs of isomers, "
    head2 = " conformers of trans-isomers and conformers of other isomers. \n"
    
    zag1 = lpdstr("n",2)
    zag2 = lpdstr("isomers",12)
    zag3 = lpdstr("con_trans_iso",15)
    zag4 = lpdstr("con_other_iso",15)
    zag5 = lpdstr("Total",16)
    line = repeat("-", 66)
    allzag = string("|", zag1,"|", zag2, "|", zag3, "|", zag4,"|",zag5,"|")

    file = open(fpath, "w")
    write(filename, "\r\n")
    println(head1)
    println(head2)    
    write(file, head1*"\n")
    write(file, head2)
    println(line)
    write(file, line*"\n")    
    println(allzag)    
    write(file, allzag*"\n")
    println(line)
    write(file, line*"\n")
    for n in n_start:2:n_end  # только четные n
        n_val, iso, trans, other, total = count_codes_from_edge(n)
        txt = string("|", lpdval(n_val,2), "|", lpdval(iso,12),"|", 
        lpdval(trans,15), "|", lpdval(other,15),"|", lpdval(total,16),"|")
        println(txt)
        write(file, txt*"\n")
    end
    println(line)
    write(file, line) 
    close(file)
    println(" File creation completed successfully.")   
end


"""
    count_codes_range_edge(n_start::Int64, n_end::Int64)

Outputs a list of graph counts for all types over the range of n 
(based on vertex codes).

# Arguments
- `n_start`: the initial value of n (even, ≥ 6);
- `n_end`: the final value of n (even, ≥ n_start).
"""
function count_codes_range_edge(n_start::Int64, n_end::Int64)
    if n_start < 6 || n_end < n_start
        error("Некорректный диапазон: n_start=$n_start, n_end=$n_end")
    end
   
    zag1 = lpdstr("n",2)
    zag2 = lpdstr("isomers",12)
    zag3 = lpdstr("con_trans_iso",15)
    zag4 = lpdstr("con_other_iso",15)
    zag5 = lpdstr("Total",16)

    println("Distribution of the number of molecular graphs of isomers,")
    println(" conformers of trans-isomers and conformers of other isomers")    
    line = repeat("-", 65)
    println(line)
    println("|", zag1,"|", zag2, "|", zag3, "|", zag4,"|",zag5,"|")
    println(line)
    
    for n in n_start:2:n_end  # только четные n
        n_val, iso, trans, other, total = count_codes_from_edge(n)
        txt = string("|", lpdval(n_val,2), "|", lpdval(iso,12),"|", 
        lpdval(trans,15), "|", lpdval(other,15),"|", lpdval(total,16),"|")
        println(txt)
    end
    println(line)    
end



"""
    count_codes_range_vertex(n_start::Int64, n_end::Int64)

Outputs a list of graph counts for all types over the range of n 
(based on vertex codes).

# Arguments
- `n_start`: the initial value of n (even, ≥ 6);
- `n_end`: the final value of n (even, ≥ n_start).
"""
function count_codes_range_vertex(n_start::Int64, n_end::Int64)
    if n_start < 6 || n_end < n_start
        error("Некорректный диапазон: n_start=$n_start, n_end=$n_end")
    end
   
    zag1 = lpdstr("n",2)
    zag2 = lpdstr("isomers",12)
    zag3 = lpdstr("con_trans_iso",15)
    zag4 = lpdstr("con_other_iso",15)
    zag5 = lpdstr("Total",16)

    println("Distribution of the number of molecular graphs of isomers,")
    println(" conformers of trans-isomers and conformers of other isomers")    
    line = repeat("-", 65)
    println(line)
    println("|", zag1,"|", zag2, "|", zag3, "|", zag4,"|",zag5,"|")
    println(line)
    
    for n in n_start:2:n_end  # только четные n
        n_val, iso, trans, other, total = count_codes_from_vertex(n)
        txt = string("|", lpdval(n_val,2), "|", lpdval(iso,12),"|", 
        lpdval(trans,15), "|", lpdval(other,15),"|", lpdval(total,16),"|")
        println(txt)
    end
    println(line)    
end



"""
    count_other_conformers(n::Int64) -> Tuple{Int64, Int64, Int64, Int64, Int64, Int64}

Counts conformers of other isomers by subtype.

# Arguments
- `n`: общее количество вершин в полиене (n ≥ 6)

# Returns:
Tuple of 6 values:
1. n (number of vertices)
2. Total number of conformers of other isomers
3. Containing the sequence "1111" (4 consecutive cis edges)
4. Not containing "1111"
5. Containing "111" (3 consecutive cis edges) among those that do not contain "1111"
6. Containing neither "1111" nor "111"

# Note
Analyzes only type 3 graphs (conformers of other isomers)
"""
function count_other_conformers(n::Int64)
    if n < 6
        error("n должно быть не менее 6 (получено n=$n)")
    end
    
    m = n - 3
    total_combinations = 2^m
    
    total_coi = 0
    with_four_cis = 0      # содержат 1111
    without_four_cis = 0   # не содержат 1111
    with_three_cis = 0     # содержат 111 (среди without_four_cis)
    without_three_cis = 0  # не содержат 111 (среди without_four_cis)
    
    for k in 1:total_combinations
        # Генерируем двоичный код для числа (k-1)
        edge_code = intg_digits(k-1, m)
        canonical_code = min_edge_code(edge_code)
        
        if edge_code == canonical_code
            graph_type = graph_type_from_edge(edge_code)
            
            if graph_type == OTHER_CONFORMER_TYPE
                total_coi += 1
                vcstr = map(string, edge_code)
                strbcd = join(vcstr)
                # Проверяем наличие последовательности 1111
                has_four_cis = false
                if m >= 4  # только если достаточно ребер                    
                    if occursin("1111", strbcd)
                        has_four_cis = true
                    end
                end
                
                if has_four_cis
                    with_four_cis += 1
                else
                    without_four_cis += 1
                    
                    # Проверяем наличие последовательности 111
                    has_three_cis = false
                    if m >= 3  # только если достаточно ребер
                        if occursin("111", strbcd)
                            has_three_cis = true
                        end
                    end
                    
                    if has_three_cis
                        with_three_cis += 1
                    else
                        without_three_cis += 1
                    end
                end
            end
        end
    end
    
    return (n, without_three_cis, with_three_cis, without_four_cis, with_four_cis, total_coi)
end


"""
    count_other_conformers_subtype(n::Int64) -> Tuple{Int64, Int64, Int64, Int64, Int64, Int64}

Counts conformers of other isomers by subtype.

# Arguments
- `n`: Order of the molecular graph without hydrogen atoms or
       total number of vertices in the polyene (n ≥ 6).

# Returns:
Tuple of 6 values:
1. n (number of vertices)
2. Containing neither "1111" nor "111"
3. Containing "111" (3 consecutive cis edges) among those that do not contain "1111"
4. Not containing "1111"
5. Containing the sequence "1111" (4 consecutive cis edges)
6. Total number of conformers of other isomers

# Note
Analyzes only type 3 graphs (conformers of other isomers)
"""
function count_other_conformers_subtype(n::Int64)
    if n < 6
        error("n должно быть не менее 6 (получено n=$n)")
    end
    
    m = n - 3
    total_combinations = 2^m
    
    graph_type_count = [n,0,0,0,0,0]
    for k in 1:total_combinations
        # Генерируем двоичный код для числа (k-1)
        edge_code = intg_digits(k-1, m)
        canonical_code = min_edge_code(edge_code)
        
        if edge_code == canonical_code
            graph_type = graph_type_from_edge(edge_code)
            
            if graph_type == OTHER_CONFORMER_TYPE

                subtype =  graph_subtype_edge(edge_code,2)

                graph_type_count[6] += 1
                graph_type_count[subtype+1] += 1               
            end
        end
    end
    graph_type_count[4] = graph_type_count[2] + graph_type_count[3]
    return graph_type_count
end




"""
    count_other_conformers_range(n_start::Int64, n_end::Int64)


"""
function count_other_conformers_range(n_start::Int64, n_end::Int64)
    if n_start < 6 || n_end < n_start
        error("Некорректный диапазон: n_start=$n_start, n_end=$n_end")
    end

    zag1 = lpdstr("n",2)
    zag2 = lpdstr("without_cis3",14)
    zag3 = lpdstr("with_cis3",14)
    zag4 = lpdstr("without_cis4",14)
    zag5 = lpdstr("with_cis4",14)
    zag6 = lpdstr("Total_coi",16)
    head1 = ("Distribution of the number of molecular graphs of conformers ")
    head2 = (" of other isomers by the presence of cisoid chains. ")
    println(head1)
    println(head2)    
    line = repeat("-", 80)
    println(line)
    println("|", zag1,"|", zag2, "|", zag3, "|", zag4,"|",zag5,"|",zag6,"|")
    println(line)
    
    for n in n_start:2:n_end  # только четные n
        n_val, total_coi, with_cis4, without_cis4, with_cis3,
         without_cis3 = count_other_conformers(n)
        txt = string("|", lpdval(n_val,2), "|", lpdval(without_cis3,14),"|", 
        lpdval(with_cis3,14), "|", lpdval(without_cis4,14),"|",
        lpdval(with_cis4,14), "|", lpdval(total_coi,16),"|")
        println(txt)
    end
    println(line)
end    


"""
    save_count_other_conformers_range(n_start::Int64, n_end::Int64,
    dirpath::String,fname::String)


"""
function save_count_other_conformers_range(n_start::Int64, n_end::Int64,
    dirpath::String,fname::String)
    if n_start < 6 || n_end < n_start
        error("Некорректный диапазон: n_start=$n_start, n_end=$n_end")
    end
    filename = fname*".txt"    
    fpath = joinpath(dirpath, filename)    

    zag1 = lpdstr("n",2)
    zag2 = lpdstr("without_cis3",14)
    zag3 = lpdstr("with_cis3",14)
    zag4 = lpdstr("without_cis4",14)
    zag5 = lpdstr("with_cis4",14)
    zag6 = lpdstr("Total_coi",16)
    allzag = string("|", zag1,"|", zag2, "|", zag3, "|", zag4,"|",zag5,"|",zag6,"|")
    head1 = ("Distribution of the number of molecular graphs of conformers ")
    head2 = (" of other isomers by the presence of cisoid chains. ")
    line = repeat("-", 80)
    file = open(fpath, "w")
    write(filename, "\r\n")
    println(head1)
    println(head2)    
    write(file, head1*"\n")
    write(file, head2*"\n") 
    println(line)
    write(file, line*"\n")
    println(allzag)
    write(file, allzag*"\n")
    println(line)
    write(file, line*"\n")
    
    for n in n_start:2:n_end  # только четные n
        n_val, total_coi, with_cis4, without_cis4, with_cis3,
         without_cis3 = count_other_conformers(n)
        txt = string("|", lpdval(n_val,2), "|", lpdval(without_cis3,14),"|", 
        lpdval(with_cis3,14), "|", lpdval(without_cis4,14),"|",
        lpdval(with_cis4,14), "|", lpdval(total_coi,16),"|")
        println(txt)
        write(file, txt*"\n")
    end
    println(line)
    write(file, line*"\n")
    close(file)
    println(" File creation completed successfully")
end    

    
# ============================================================
# Алиасы для обратной совместимости
# ============================================================

const countcodefromze = count_codes_from_edge
const countcodefrombcd = count_codes_from_vertex
const countlistcodefromze = count_codes_range_edge
const countlistcodefrombcd = count_codes_range_vertex
const savecountlistcode   =  save_count_codes_range_edge
const countcoi = count_other_conformers
const countlistcoi = count_other_conformers_range
const savecountlistcoi = save_count_other_conformers_range
const countotherconfosubtype  = count_other_conformers_subtype

end  ## End of module