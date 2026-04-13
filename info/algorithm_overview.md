# Overview of Algorithms

The file algorithm_overview outlines the implementation specifics of the algorithms described in the paper by Yu. L. Nosov and M. N. Nazarov, “Constructive enumeration and study of the spatial structure of linear polyenes”.

Before reading, it is necessary to review:

- the motivation behind writing the paper (see the file motivation.md);

- the terminology used (see the file terminology.md);

- the general information required to understand the algorithms (see the file algorithms_general_information.pdf).

The need to output the content into a separate PDF file is explained by the fact that the paper has not been published and is currently under review. Therefore, to prevent the paper’s text from being flagged by plagiarism‑detection software, the general information has been converted into a PDF format without the actual text.

In the paper, in accordance with the stated objectives, a suite of programs was developed in the Julia programming language for the generation, counting, and constructive enumeration of linear polyenes. The following tasks were algorithmically addressed:

1. Generation of all binary codes of a given length;

2. Determination of the canonical code from a generated code and selection of the generated code based on the canonicity criterion;

3. Classification of a molecular graph by its code;

4. Determination of the symmetry group of a molecular graph from its code;

5. Counting the number of congruence classes of molecular graphs of order n within a given class;

6. Generation of a list of canonical (with respect to congruence) codes for all molecular graphs of order n in a given class;

7. Generation of a molecular graph with vertex coordinates from its vertex B-code;

8. Displaying (printing) an image of the molecular graph;

9. Investigation of the structure of molecular graphs of order n in a given class;

10. Verification of the adequacy of all programs’ operation and the correct implementation of the geometric structure of molecular graphs.

Therefore, in our exposition of the main properties and features of the algorithms, we will follow the order listed above.

## A high‑level description of the algorithms

## 1. Binary Codes Generation

The bisection method is one of the algorithms for converting a decimal number to binary. It is based on successively dividing the number by 2, recording the remainders.

Algorithm for converting a decimal number to binary: interneturok.ru

1. Successively divide the given number and the resulting quotients by 2 with a remainder. Continue until the quotient is zero.

2. Align the resulting remainders, which are the digits of the number in the binary system, with the alphabet (in the binary alphabet, these are the digits 0 and 1).

3. Convert the remainders to a binary number. Write it down, starting with the last remainder.

Below is the code for the `intg_digits(n, p)` function in this package, used to generate the code for a molecular graph of order `n` and length `p`. This function implements the bisection method described above.

The `intg_digits` function generates an integer vector of length p containing the binary
representation of the number n with leading zeros. It is used to model states in polynomial graphs.

```vb
ALGORITHM intg_digits(n, p)
INPUT: integer n, required vector length p
OUTPUT: vector of length p with 0s and 1s (binary representation of n with leading zeros)

1. IF n = 0 THEN
2.     RETURN vector of p zeros
3. END IF

4. CREATE empty vector lst_bin
5. WHILE n > 0 DO
6.     quotient ← integer division of n by 2 (n div 2)
7.     remainder ← remainder of n divided by 2 (n mod 2)
8.     APPEND remainder to the end of lst_bin
9.     n ← quotient
10. END WHILE

11. REVERSE vector lst_bin (digits were obtained in reverse order)
12. len_b ← length of vector lst_bin

13. IF p > len_b THEN
14.     zeros_to_add ← p − len_b
15.     prefix ← vector of zeros_to_add zeros
16.     RETURN concatenation of prefix and lst_bin
17. ELSE
18.     RETURN lst_bin
19. END IF
END ALGORITHM
```

Algorithm complexity:

- Time complexity: O(logn) — the number of loop iterations is equal to the number of bits in n;

- Space complexity: O(p) — the size of the output vector.

EXAMPLE: intg_digits(5,4) → [0,1,0,1].

Explanation: $5_{10} = 101_2$.

It is well known that the `intg_digits` function can be used to generate all possible binary
codes of length `k` by sequentially generating numbers from 0 to $2^k -1$ and then converting
them to binary numbers.

Thus, all edge codes for molecular graphs of linear polyenes of order `n` are obtained
by sequentially generating numbers from 0 to $2^m - 1$, where `m = n - 3`
is the number of internal edges of the graph.

Below, as an example, is pseudocode for generating edge codes for graphs of order `n = 6`
 and the results obtained using it.
Pseudocode

It is well known that using the intg_digits function, one can generate all possible binary
codes of length k by sequentially generating numbers from 0 to 2k−1 and then converting
them into binary numbers. Thus, all edge codes of molecular graphs of linear polyenes
of order n are obtained by sequentially generating numbers from 0 to $2^m−1$, where
m = n - 3 is the number of internal edges in the graph.

```vb
m = n-3
total_combinations = 2^m -1
FOR k IN 0 TO total_combinations
   bin_code = intg_digits(k,m) // генерация кода
   PRINT (k, bin_code)  //  вывод на консоль
END FOR
```

Results — edge codes

```vb
0  [0, 0, 0]
1  [0, 0, 1]
2  [0, 1, 0]
3  [0, 1, 1]
4  [1, 0, 0]
5  [1, 0, 1]
6  [1, 1, 0]
7  [1, 1, 1]
```

Similarly, all vertex codes of molecular graphs of linear polyenes of order `n` are obtained by sequentially generating numbers from 0 to $2^{p - 1} - 1$, where `p = n - 2` is the number of internal vertices of the graph. Below, as an example, is pseudocode for generating vertex codes for graphs of order `n = 6` and the results obtained using it.
Pseudocode

```vb
p = n-2
total_combinations = 2^p -1
FOR k IN 0 TO total_combinations
   bin_code = intg_digits(k,p) // генерация кода
   PRINT (k, bin_code)    //  вывод на консоль
END FOR
```

Results — vertex codes

```vb
0  [0, 0, 0, 0]
1  [0, 0, 0, 1]
2  [0, 0, 1, 0]
3  [0, 0, 1, 1]
4  [0, 1, 0, 0]
5  [0, 1, 0, 1]
6  [0, 1, 1, 0]
7  [0, 1, 1, 1]
8  [1, 0, 0, 0]
9  [1, 0, 0, 1]
...............
14  [1, 1, 1, 0]
15  [1, 1, 1, 1]
```

In the article by Yu.L. Nosov and M.N. Nazarov proved that to create vertex codes for molecular graphs of linear polyenes, it is sufficient to use half the codes, generating numbers from 0 to $2^{p-1}-1$ and then converting them to binary numbers.

It is easy to see that vertex codes have the following important property: the first element of the code is always 0, and the last element is either 0 or 1. This structure of vertex codes facilitates code selection using the canonical representatives method.

## 2. Selection of codes by the method of canonical representatives

In the article by Yu. L. Nosov and M. N. Nazarov, an expression was obtained for the number
 N_G(n) of all pairwise non-congruent molecular graphs of linear polyenes of order `n` of
 the following form:

 $N_G(n)=2^{n-4} + 2^{\lfloor n/2 \rfloor -2}$.

 From the generation algorithms in Section 1, it follows that the following inequalities
 hold for the number of molecular graphs generated by edge and vertex codes:

 $2^m = 2^{n-3} > N_G(n)$ and $2^{p-1} = 2^{n-3} > N_G(n)$.

In other words, the numbers of molecular graphs generated by edge and vertex codes are
 excessive, since they are much greater than $N_G(n)$.

Therefore, in the article by Yu. L. Nosov and M. N. Nazarov, for the normal operation and accurate enumeration of molecular graphs, their selection was performed using a modified method of canonical representatives.
In the well-known method, the canonical representative (graph) was selected from a set of pairwise isomorphic graphs using the criterion of lexicographic minimality. Unlike the known method, the selection of a canonical representative was performed among a set of pairwise congruent graphs according to the criterion of lexicographic minimality.

### 2.1. Definition of a canonical code

The canonical code is determined using the min_edge_code and min_vertex_code functions. The algorithms for these functions are constructed taking into account the structural features of vertex and edge codes and statements 1 and 2 from the General Information section.

### 2.1.1.Function for definition of a minimal edge code

The `min_edge_code` function normalizes the edge code of a graph by selecting the lexicographically smallest variant between the original code and its reversed version. It is used for canonical representation of edge structures in polyene graphs, allowing for unambiguous identification of isomers and avoiding duplication when enumerating structures.

```vb
ALGORITHM min_edge_code(edge_code)
INPUT: vector edge_code (edge code)
OUTPUT: lexicographically smallest edge code (original or reversed)

1. rev_code ← reverse(edge_code)  // Reversal of the edge code
2. IF edge_code ≤ rev_code THEN
3.     RETURN edge_code
4. ELSE
5.     RETURN rev_code
6. END IF
END ALGORITHM
```

Algorithm Complexity:

- Time Complexity: O(n), where n is the length of the edge code.
The reverse operation is linear time, and lexicographic comparison also
requires O(n) operations in the worst case.

- Space Complexity: O(n) additional memory for storing the expanded copy of the code (rev_code)

Examples for clarity:
Example 1:

- INPUT: [1, 0, 1, 1]
- rev_code: [1, 1, 0, 1]
- Comparison: [1, 0, 1, 1] < [1, 1, 0, 1] (by the second element: 0<1)
- OUTPUT: [1, 0, 1, 1]

Example 2:

- INPUT: [1, 1, 0, 0]
- rev_code: [0, 0, 1, 1]
- Comparison: [1, 1, 0, 0] > [0, 0, 1, 1] (by the first element: 1>0)
- OUTPUT: [0, 0, 1, 1]

The pseudocode for the minimality selection algorithm using the
`min_vertex_code(vertex_code)` function is then

```vb
m = n-3
total_combinations = 2^m -1
FOR k IN 0 TO total_combinations
   edge_code = intg_digits(k,m) // Code generation
   min_code = min_vertex_code(edge_code) // Definition of a canonical code
   IF edge_code == min_code  //  Selection by minimality criterion
      ....................    //  Required operators
   END IF   
END FOR
```

### 2.1.2.Function for definition of a minimal vertex code

The `min_vertex_code` function normalizes the vertex code of a graph by selecting the
lexicographically minimal variant from among possible transformations. It is used for
canonical representation of polynomial structures.

```vb
ALGORITHM min_vertex_code(vertex_code)
INPUT: vector vertex_code (vertex code)
OUTPUT: minimal vertex code (original or transformed)

1. first_bit ← first element of vertex_code
2. last_bit ← last element of vertex_code

3. IF first_bit = 0 AND last_bit = 0 THEN
4.     rev_code ← reverse(vertex_code)  // Code reversal
5.     IF vertex_code ≤ rev_code THEN
6.         RETURN vertex_code
7.     ELSE
8.         RETURN rev_code
9.     END IF
10. ELSE IF first_bit = 0 AND last_bit = 1 THEN
11.     rev_code ← reverse(vertex_code)  // Code reversal
12.     inv_rev_code ← invert(rev_code)  // Inversion of reversed code
13.     IF vertex_code ≤ inv_rev_code THEN
14.         RETURN vertex_code
15.     ELSE
16.         RETURN inv_rev_code
17.     END IF
18. ELSE
19.     RAISE ERROR: «Vertex code must satisfy:
         first_bit = 0 and last_bit = 0 OR
         first_bit = 0 and last_bit = 1»
20. END IF
END ALGORITHM
```

Algorithm complexity:

- Time complexity: `O(n)`, where n is the code length (the reverse and invert operations are linear).
- Space complexity: `O(n)` — creating temporary copies of the code.

EXAMPLES
Example 1 (last_bit = 0):

- INPUT: [0,1,0,0]
- rev_code: [0,0,1,0]
- Compare: [0,1,0,0] > [0,0,1,0] → return [0,0,1,0]

Example 2 (last_bit = 1)

- INPUT: [0, 1, 1, 1]
- rev_code: [1, 1, 1, 0]
- inv_rev_code: [0, 0, 0, 1]
- Compare: [0, 1, 1, 1] > [0, 0, 0, 1] → RETURN [0, 0, 0, 1]

Then the pseudocode for the algorithm for selection by minimality criterion using the function `min_vertex_code(vertex_code)` has the form

```vb
p = n-2
total_combinations = 2^p -1
FOR k IN 0 TO total_combinations
   vertex_code = intg_digits(k,p) // Code generation
   min_code = min_vertex_code(vertex_code) // Definition of a canonical code
   IF vertex_code == min_code  //  Selection by minimality criterion
      ....................    //  Required operators
   END IF   
END FOR
```

## 2.2. Checking a code for canonicity

Graph selection using the min_edge_code and min_vertex_code functions is performed in two stages: stage 1 first determines the canonical code, and stage 2 performs the selection by comparing the canonical code with the code itself. Using the check_min_edge and check_min_vertex functions allows graph selection to be performed in a single stage.

### 2.2.1. Function for checking a vertex code for minimality

The `check_min_vertex` function checks whether a vertex code is canonical
(lexicographically minimal) for a given graph structure. It is used to filter
out duplicates when enumerating polyene isomers.

```vb
ALGORITHM check_min_vertex(vertex_code)
INPUT: vector vertex_code (vertex code)
OUTPUT: boolean value (TRUE — code is canonical, FALSE — code is not canonical)

1. p ← length of vertex_code
2. IF p < 3 THEN
3.     RAISE ERROR: «Vertex code length must be at least 3 (n ≥ 6)»
4. END IF

5. first_bit ← first element of vertex_code
6. last_bit ← last element of vertex_code

7. IF first_bit = 0 AND last_bit = 0 THEN
8.     rev_code ← reverse(vertex_code)  // Code reversal
9.     IF vertex_code ≤ rev_code THEN
10.        RETURN TRUE
11.    ELSE
12.        RETURN FALSE
13.    END IF
14. ELSE IF first_bit = 0 AND last_bit = 1 THEN
15.     rev_code ← reverse(vertex_code)  // Code reversal
16.     inv_rev_code ← invert(rev_code)  // Inversion of reversed code
17.     IF vertex_code ≤ inv_rev_code THEN
18.        RETURN TRUE
19.    ELSE
20.        RETURN FALSE
21.    END IF
22. ELSE
23.     RETURN FALSE  // Code does not satisfy basic canonicity conditions
24. END IF
END ALGORITHM
```

Algorithm complexity:

- Time complexity: `O(n)`, where n is the code length. Reverse and invert operations are linear, and lexicographic comparison also takes `O(n)`.
- Space complexity: `O(n)`. Additional memory is required to store temporary copies of the code (rev_code, inv_rev_code).

Examples:
Example 1 (canonical code, last_bit = 0):

- INPUT: [0, 0, 1, 0]
- rev_code: [0, 1, 0, 0]
- Comparison: [0, 0, 1, 0] ≤ [0, 1, 0, 0] → RETURN TRUE

Example 2 (non-canonical code, last_bit = 1):

- INPUT: [0, 1, 1, 1]
- rev_code: [1, 1, 1, 0]
- inv_rev_code: [0, 0, 0, 1]
- Comparison: [0, 1, 1, 1] > [0, 0, 0, 1] → RETURN FALSE

Example 3 (incorrect code):

- INPUT: [1, 0, 1] (first_bit ≠ 0) → RETURN FALSE
- INPUT: [0, 1, 0, 1] (last_bit ≠ 0 and ≠ 1) → RETURN FALSE

Pseudocode for the graph selection algorithm using the `check_min_vertex` function is presented below.

```vb
p = n-2
total_combinations = 2^p -1
FOR k IN 0 TO total_combinations
   vertex_code = intg_digits(k,p) // Code generation   
   IF check_min_vertex(vertex_code)  //  Lexicographic minimality check
      ....................    //  Required operators
   END IF   
END FOR

```

### 2.2.2. Function for checking a edge code for minimality

The `check_min_edge` function checks whether an edge code is canonical
(lexicographically minimal) for a given graph structure. It is used
to filter out duplicates when enumerating polyene isomers, avoiding
 multiple counts of the same spatial structure.

```vb
ALGORITHM check_min_edge(edge_code)
INPUT: vector edge_code (edge code)
OUTPUT: boolean value (TRUE — code is canonical, FALSE — code is not canonical)

1. m ← length of edge_code
2. IF m < 3 THEN
3.     RAISE ERROR: «Edge code length must be at least 3 (n ≥ 6)»
4. END IF
5. rev_code ← reverse(edge_code)  // Reversal of the edge code
6. IF edge_code ≤ rev_code THEN
7.     RETURN TRUE
8. ELSE
9.     RETURN FALSE
10. END IF
END ALGORITHM
```

Algorithm Complexity:

- Time Complexity: O(n), where n is the length of the edge code. The reverse()
 operation is linear in time, and the lexicographic comparison also requires
 O(n) operations in the worst case.
- Space Complexity: O(n). Additional memory is required to store the expanded
  copy of the code (rev_code).

Examples for clarity:
Example 1 (canonical code):

- INPUT: [0, 1, 0, 1]
- rev_code: [1, 0, 1, 0]
- Comparison: [0, 1, 0, 1] < [1, 0, 1, 0] (by first element: 0<1)
- OUTPUT: TRUE

Example 2 (non-canonical code):

- INPUT: [1, 1, 0, 0]
- rev_code: [0, 0, 1, 1]
- Comparison: [1, 1, 0, 0] > [0, 0, 1, 1] (by first element: 1>0)
- OUTPUT: FALSE

Example 3 (error - code too short):

- INPUT: [1, 0] (length = 2)
- OUTPUT: ERROR — "The edge code length must be at least 3 (n ≥ 6)"  

Pseudocode for the graph selection algorithm using the `check_min_edge` function is presented below.

```vb
m = n-3
total_combinations = 2^m -1
FOR k IN 0 TO total_combinations
   edge_code = intg_digits(k,m) // Code generation   
   IF check_min_edge(edge_code)  //  Lexicographic minimality check
      ....................    //  Required operators
   END IF   
END FOR
```

## 3. Determining the graph class from  graph code

### 3.1. Function for determining the graph class from an edge code

The `graph_type_from_edge` function determines the class of a molecular graph
(isomer, trans-isomer conformer, or other-isomer conformer) based on its edge
code. This is used to systematize structures when enumerating polyene isomers.

```vb
ALGORITHM graph_type_from_edge(edge_code)
INPUT: vector edge_code (edge code)
OUTPUT: integer (graph type: 1 — isomers; 2 — conformers of trans‑isomers; 3 — conformers of other isomers)

1. m ← length of edge_code
2. IF m < 3 THEN
3.     RAISE ERROR: «Edge code length must be at least 3 (n ≥ 6)»
4. END IF

5. isomer_indices ← indices 2, 4, ..., m−1 (even positions, starting from 2)
6. isomer_positions ← elements of edge_code at positions isomer_indices
7. sum_isomer ← sum of elements in isomer_positions

8. conformer_indices ← indices 1, 3, ..., m (odd positions, starting from 1)
9. conformer_positions ← elements of edge_code at positions conformer_indices
10. sum_conformer ← sum of elements in conformer_positions

11. IF sum_isomer > 0 AND sum_conformer > 0 THEN
12.     RETURN 3  // Conformers of other isomers
13. ELSE IF sum_isomer > 0 AND sum_conformer = 0 THEN
14.     RETURN 1  // Isomers
15. ELSE IF sum_isomer = 0 AND sum_conformer > 0 THEN
16.     RETURN 2  // Conformers of trans‑isomers
17. ELSE  // sum_isomer = 0 AND sum_conformer = 0
18.     RETURN 1  // Trans‑isomers (zero code)
19. END IF
END ALGORITHM
```

Algorithm complexity:

- Time complexity: O(m), where m is the length of the edge code. The algorithm traverses
 the vector twice (for even and odd positions), and summation is performed in linear time.

- Space complexity: O(m). Additional memory is required to store subsets of positions
(isomer_positions, conformer_positions).

Examples for clarity:
Example 1 (Type 1 — isomers):

- INPUT: [1, 0, 1, 0]
- isomer_positions (even): [0, 0], sum_isomer = 0
- conformer_positions (odd): [1, 1], sum_conformer = 2
- Condition: sum_isomer = 0, sum_conformer > 0 → RETURN 2 (conformers of trans isomers)

Example 2 (Type 2 — conformers of trans isomers):

- INPUT: [0, 1, 0, 1]
- isomer_positions: [1, 1], sum_isomer = 2
- conformer_positions: [0, 0], sum_conformer = 0
- Condition: sum_isomer > 0, sum_conformer = 0 → RETURN 1 (isomers)

Example 3 (type 3 - conformers of other isomers):

- INPUT: [1, 1, 0, 1]
- isomer_positions: [1, 1], sum_isomer = 2
- conformer_positions: [1, 0], sum_conformer = 1
- Condition: sum_isomer > 0, sum_conformer > 0 → RETURN 3

Example 4 (type 1 — trans-isomers):

- INPUT: [0, 0, 0, 0]

- sum_isomer = 0, sum_conformer = 0 → RETURN 1

### 3.2. Function for determining the graph class from an vertex code

The graph_type_from_vertex function determines the class of a molecular graph based on
its vertex code. It first converts the vertex code to an edge code (encoding the
cis/trans bond configurations), then uses the graph_type_from_edge function for
classification. It is used to systematize structures when listing polyene isomers.

```vb
ALGORITHM graph_type_from_vertex(vertex_code)
INPUT: vector vertex_code (vertex code)
OUTPUT: integer (graph type: 1 — isomers; 2 — conformers of trans‑isomers; 3 — conformers of other isomers)

1. p ← length of vertex_code
2. IF p < 4 THEN
3.     RAISE ERROR: «Vertex code length must be at least 4 (n ≥ 6)»
4. END IF
5. CREATE empty vector edge_code
6. FOR k FROM 1 TO p−1 DO
7.     IF vertex_code[k] = vertex_code[k+1] THEN
8.         APPEND 1 to the end of edge_code  // «cis» (adjacent vertices are the same)
9.     ELSE
10.        APPEND 0 to the end of edge_code  // «trans» (adjacent vertices differ)
11.    END IF
12. END FOR

13. RETURN graph_type_from_edge(edge_code)  // Determine graph type from edge code
END ALGORITHM
```

Algorithm complexity:

- Time complexity: O(p), where p is the length of the vertex code. The loop is
  executed p−1 times, each iteration taking constant time.
  Calling graph_type_from_edge also has linear complexity.
- Space complexity: O(p). Additional memory is required to store the edge code
  (edge_code), the length of which is p−1.

 Examples for clarity:
Example 1 (trans isomer):

- INPUT: [0, 1, 0, 1] (vertex alternation)
- Transformation:
- vertex_code[1] ≠ vertex_code[2] → 0
- vertex_code[2] ≠ vertex_code[3] → 0
- vertex_code[3] ≠ vertex_code[4] → 0
- edge_code: [0, 0, 0]
- OUTPUT: 1 (trans isomers, zero code)

Example 2 (cis isomer):

- INPUT: [0, 0, 1, 1]
- Transformation:
◦ vertex_code[1] = vertex_code[2] → 1
◦ vertex_code[2] ≠ vertex_code[3] → 0
◦ vertex_code[3] = vertex_code[4] → 1
- edge_code: [1, 0, 1]
- sum_isomer (even positions): 0 + 1 = 1 > 0
- sum_conformer (odd positions): 1 + 0 = 1 > 0
- OUTPUT: 3 (conformers of other isomers)

Example 3 (error - code too short):

- INPUT: [0, 1, 0] (length = 3)
- OUTPUT: ERROR - "The length of the vertex code must be at least 4 (n ≥ 6)"

## 4. Definition of a subclass of graphs of conformers of other isomers

### 4.1. Function for determining the graph subclass from edge code

Purpose
The `graphs_subtype_edge` function determines the subtype of a molecular graph of conformers of other isomers (COI) based on the presence of consecutive cis edges in its edge code.
The variant parameter controls the return value for the WITH_CIS4 subtype:

Variant 1 (variant = 1): returns 3 for WITH_CIS4.

Variant 2 (variant = 2): returns 4 for WITH_CIS4.

This dual behaviour enables the same function to be used in:

Graph generation (variant 1).

Distribution counting with extended output vector (variant 2), where the result vector has 6 elements instead of 5.

Pseudocode

```vb
ALGORITHM graphs_subtype_edge(edge_code, variant=1)
INPUT:
  - edge_code: array of integers (edge code of a COI molecular graph, where 1 = cis, 0 = trans)
  - variant: integer (operation mode; 1 = generate codes, 2 = count graphs; default = 1)
OUTPUT: integer representing the COI graph subtype:
  - WITHOUT_CIS3 = 1 — no 3 or more consecutive cis edges
  - WITH_CIS3  = 2 — contains exactly 3 consecutive cis edges (but not 4+)
  - WITH_CIS4  = 3 (if variant = 1) or 4 (if variant = 2) — contains 4 or more consecutive cis edges

1. IF variant = 1 THEN
2.     WITH_CIS4_VAL ← 3
3. ELSE
4.     WITH_CIS4_VAL ← 4
5. END IF

6. st41 ← "1111"  // pattern: 4+ consecutive cis edges
7. st31 ← "111"   // pattern: exactly 3 consecutive cis edges
8. strbcd ← join elements of edge_code into a single string

9. IF contains_substring(strbcd, st41) THEN
10.     RETURN WITH_CIS4_VAL    // contains 4+ consecutive cis edges
11. ELSE IF contains_substring(strbcd, st31) THEN
12.     RETURN 2    // WITH_CIS3 — contains exactly 3 consecutive cis edges
13. ELSE
14.     RETURN 1    // WITHOUT_CIS3 — no 3+ consecutive cis edges
15. END IF
END ALGORITHM
```

Explanation of the Algorithm
Input Parameters:

edge_code: an array representing the edge configuration of a COI graph. Each element is 0 (trans) or 1 (cis).

variant: determines the return value for WITH_CIS4:

1: sets WITH_CIS4_VAL = 3.

2: sets WITH_CIS4_VAL = 4.

Variant Handling (Lines 1–5):

Based on the variant, the function sets the appropriate value for WITH_CIS4_VAL. This single value is then used in the return statement (Line 10).

Pattern Preparation (Lines 6–7):

Defines string patterns for 4+ ("1111") and 3 ("111") consecutive cis edges.

String Conversion (Line 8):

Joins the edge_code array into a single string strbcd for efficient substring searching.

Pattern Matching (Lines 9–14):

Step 1: Checks for the "1111" pattern. If found, returns WITH_CIS4_VAL (either 3 or 4, depending on variant).

Step 2: If "1111" is not found, checks for the "111" pattern. If found, returns 2 (WITH_CIS3).

Step 3: If neither pattern is found, returns 1 (WITHOUT_CIS3).

Return Values:

1 (WITHOUT_CIS3): the graph has no sequence of 3 or more consecutive cis edges.

2 (WITH_CIS3): the graph contains a sequence of exactly 3 consecutive cis edges, but not longer.

3 or 4 (WITH_CIS4): the graph contains a sequence of 4 or more consecutive cis edges. The specific value depends on the variant.

**Algorithm Complexity

Time Complexity: O(m), where m is the length of the edge_code array.
The join operation (Line 8) takes O(m) time.
Each contains_substring call performs a linear scan of the string. In the worst case,
both calls are executed, but each is O(m). Therefore, the total time complexity remains O(m).

Space Complexity: O(m).

The primary space requirement is for the string strbcd, which has a length of m characters.
Other variables (st41, st31, WITH_CIS4_VAL) use constant space.

Example Usage
Example 1 (Variant 1 — Generate Codes):

Input: edge_code = [1, 1, 1, 1, 0], variant = 1

strbcd = "11110"

Contains "1111"? Yes.

Output: 3 (WITH_CIS4, value for variant 1)

Example 2 (Variant 2 — Count Distribution):

Input: edge_code = [1, 1, 1, 1, 0], variant = 2

strbcd = "11110"

Contains "1111"? Yes.

Output: 4 (WITH_CIS4, value for variant 2)

Example 3 (No Long Cis):

Input: edge_code = [0, 1, 0, 1, 0], variant = 1 or 2

strbcd = "01010"

Contains "111" or "1111"? No.

Output: 1 (WITHOUT_CIS3)

Example 4 (Exactly 3 Cis):

Input: edge_code = [1, 1, 1, 0, 0], variant = 1 or 2

strbcd = "11100"

Contains "1111"? No. Contains "111"? Yes.

Output: 2 (WITH_CIS3)

Notes on Integration with count_coi_subtype_edge
When graphs_subtype_edge is called with variant = 2 inside count_coi_subtype_edge, the returned value (3 or 4) directly maps to the correct index in the 6‑element result vector:

graph_subtype = 1 → index 2 (non_cis3)

graph_subtype = 2 → index 3 (ci3)

graph_subtype = 4 → index 5 (cis4)

This design avoids modifying the counting algorithm (count_coi_subtype_edge) itself. The extended vector size is handled by the different return value from graphs_subtype_edge.

The function assumes that the input edge_code is valid (i.e., contains only 0s and 1s).

### 4.2. Function for determining the graph subclass from vertex code

Purpose
The `graphs_subtype_vertex` function determines the subtype of a molecular graph of conformers of other isomers (COI) based on the presence of consecutive cis edges in its vertex code.
The variant parameter controls the return value for the WITH_CIS4 subtype:

Variant 1 (variant = 1): returns 3 for WITH_CIS4.

Variant 2 (variant = 2): returns 4 for WITH_CIS4.

This dual behaviour enables the same function to be used in:

Graph generation (variant 1).

Distribution counting with extended output vector (variant 2), where the result vector has 6 elements instead of 5.

Pseudocode

```vb
ALGORITHM graphs_subtype_vertex(vertex_code, variant=1)
INPUT:
  - vertex_code: array of integers (vertex code of a COI molecular graph, where 1 = cis, 0 = trans)
  - variant: integer (operation mode; 1 = generate codes, 2 = count graphs; default = 1)
OUTPUT: integer representing the COI graph subtype:
  - WITHOUT_CIS3 = 1 — no 3 or more consecutive cis edges
  - WITH_CIS3  = 2 — contains exactly 3 consecutive cis edges (but not 4+)
  - WITH_CIS4  = 3 (if variant = 1) or 4 (if variant = 2) — contains 4 or more consecutive cis edges

1. IF variant = 1 THEN
2.     WITH_CIS4_VAL ← 3
3. ELSE
4.     WITH_CIS4_VAL ← 4
5. END IF

6. st51 ← "11111"  // pattern: 4+ consecutive cis edges
7. st50 ← "00000"  // pattern: 4+ consecutive cis edges
8. st41 ← "1111"   // pattern: exactly 3 consecutive cis edges
9. st40 ← "0000"   // pattern: exactly 3 consecutive cis edges

10. strbcd ← join elements of vertex_code into a single string

11. IF contains_substring(strbcd, st51) OR  contains_substring(strbcd, st50) THEN
12.     RETURN WITH_CIS4_VAL    // contains 4+ consecutive cis edges
13. ELSE IF contains_substring(strbcd, st41) OR contains_substring(strbcd, st40) THEN
14.     RETURN 2    // WITH_CIS3 — contains exactly 3 consecutive cis edges
15. ELSE
16.     RETURN 1    // WITHOUT_CIS3 — no 3+ consecutive cis edges
17. END IF
END ALGORITHM
```

Explanation of the Algorithm
Input Parameters:

- vertex_code: an array representing the edge configuration of a COI graph. Each element is 0 (trans) or 1 (cis).

- variant: determines the return value for WITH_CIS4:

1: sets WITH_CIS4_VAL = 3.

2: sets WITH_CIS4_VAL = 4.

Variant Handling (Lines 1–5):

Based on the variant, the function sets the appropriate value for WITH_CIS4_VAL. This single value is then used in the return statement (Line 12).

Pattern Preparation (Lines 6–9):

Defines string patterns  ("11111") and ("00000") for 4+ consecutive cis edges.
Defines string patterns ("1111") and ("0000") for 3  consecutive cis edges.

String Conversion (Line 10):

Joins the vertex_code array into a single string strbcd for efficient substring searching.

Pattern Matching (Lines 11–17):

Step 1: Checks for the "11111" and "00000" pattern. If found, returns WITH_CIS4_VAL (either 3 or 4, depending on variant).

Step 2: If "11111" and "00000" is not found, checks for the "1111" and "0000" pattern. If found, returns 2 (WITH_CIS3).

Step 3: If neither pattern is found, returns 1 (WITHOUT_CIS3).

Return Values:

1 (WITHOUT_CIS3): the graph has no sequence of 3 or more consecutive cis edges.

2 (WITH_CIS3): the graph contains a sequence of exactly 3 consecutive cis edges, but not longer.

3 or 4 (WITH_CIS4): the graph contains a sequence of 4 or more consecutive cis edges. The specific value depends on the variant.

**Algorithm Complexity

Time Complexity: `O(p)`, where p is the length of the vertex_code array.
The join operation (Line 10) takes `O(p)` time.
Each contains_substring call performs a linear scan of the string. In the worst case,
both calls are executed, but each is `O(p)`. Therefore, the total time complexity remains `O(p)`.

Space Complexity: `O(p)`.

The primary space requirement is for the string strbcd, which has a length of m characters.
Other variables (`st51`,`st50`, `st41`, `st40`, `WITH_CIS4_VAL`) use constant space.

Example Usage
1.Example 1 (Variant 1 — Generate Codes):

Input: `vertex_code = [0,1, 1, 1, 1, 1]`, variant = 1

strbcd = "011111"

Contains "11111"? Yes.

Output: 3 (WITH_CIS4, value for variant 1)

2.Example 2 (Variant 2 — Count Distribution):

Input: `vertex_code = [0, 1, 1, 1, 1, 1]`, variant = 2

strbcd = "011111"

Contains "11111"? Yes.

Output: 4 (WITH_CIS4, value for variant 2)

3.Example 3 (No Long Cis):

Input: `vertex_code = [0, 1, 0, 1, 0, 0]`, variant = 1 or 2

strbcd = "010100"

Contains "1111" and "0000" or "11111" and "00000"? No.

Output: 1 (WITHOUT_CIS3)

4.Example 4 (Exactly 3 Cis):

Input: `vertex_code = [0, 1, 1, 1, 1, 0]`, variant = 1 or 2

strbcd = "011110"

Contains "11111" or "00000"? No. Contains "1111" or "0000"? Yes.

Output: 2 (WITH_CIS3)

Notes on Integration with count_coi_subtype_edge
When graphs_subtype_edge is called with variant = 2 inside count_coi_subtype_edge, the returned value (3 or 4) directly maps to the correct index in the 6‑element result vector:

graph_subtype = 1 → index 2 (non_cis3)

graph_subtype = 2 → index 3 (ci3)

graph_subtype = 4 → index 5 (cis4)

This design avoids modifying the counting algorithm (count_coi_subtype_edge) itself. The extended vector size is handled by the different return value from graphs_subtype_edge.

The function assumes that the input edge_code is valid (i.e., contains only 0s and 1s).

## 5. Generation of codes for molecular graphs of linear polyenes

### 5.1. Generation of codes for molecular graphs of isomers and conformers

The `functions generate_isomer_vertex` and `generate_isomer_edge` are used to generate vertex codes for molecular graphs of isomers.

The functions `generate_trans_conformer_vertex` and `generate_other_conformer_vertex` are used to generate vertex codes for molecular graphs of conformers of trans‑isomers.

The functions `generate_other_conformer_vertex` and `generate_other_conformer_edge` are used to generate vertex codes for molecular graphs of conformers of other isomers.

Moreover, functions whose names include the word “vertex” use vertex codes of graphs, while functions whose names include the word “edge” use edge codes of graphs.

The pseudocode structure of all these functions is essentially the same and consists of the following blocks:

1. Input parameter validation;

2. Calculation of the number of combinations;

3. Iteration through all possible codes;

4. Filtering by canonicity (`check_min_vertex` or `check_min_edge`);

5. Filtering by graph type (`graph_type_from_vertex` or `graph_type_from_edge`);

6. Collection of generated codes;

7. Conversion of the set of codes into a list;

8. Sorting of unique codes.

### 5.1.1. Generation of codes for molecular graphs of isomers

The pseudocode structure of the isomer code generation functions exactly matches the one described above.

#### 5.1.1.1. Function generate_isomer_vertex

```vb
ALGORITHM generate_isomer_vertex(order)
INPUT: integer order (total number of atoms n)
OUTPUT: sorted list of canonical vertex codes for isomers

1. IF order < 6 THEN
2.     RAISE ERROR: «n must be at least 6 (got n = order)»
3. END IF

4. p ← order − 2  // number of internal vertices
5. total_combinations ← 2^(p−1)  // total number of possible combinations
6. length_code ← p  // length of generated code
7. CREATE empty set isomers_set (to store unique isomer codes)

8. FOR k FROM 1 TO total_combinations DO
9.     vertex_code ← intg_digits(k−1, length_code)  // generate vertex code
10.    IF check_min_vertex(vertex_code) = TRUE THEN  // check for canonicity
11.        IF graph_type_from_vertex(vertex_code) = ISOMER_TYPE THEN
12.            ADD vertex_code to isomers_set
13.        END IF
14.    END IF
15. END FOR

16. result_list ← convert isomers_set to list
17. SORT result_list lexicographically
18. RETURN result_list
END ALGORITHM
```

The actual pseudocode structure of the generate_isomer_vertex function:

1. Input parameter validation — statements 1–3;

2. Calculation of the number of combinations — statements 4–6;

3. Iteration through all possible codes — statements 8, 9;

4. Filtering by canonicity (check_min_vertex) — statement 10;

5. Classification by graph type (graph_type_from_vertex) — statement 11;

6. Collection of generated codes — statement 12;

7. Conversion of the set of codes into a list — statement 16;

8. Sorting of unique codes — statement 17.

Complexity Analysis

The computational complexity of the generate_isomer_vertex algorithm is as follows:

Time complexity: $O(2^{p−1}⋅p+m⋅p⋅logm)$, where:

`p = n − 2` is the number of internal vertices in the molecular graph (n is the total number of atoms);

$2^{p−1}$ is the total number of vertex code combinations enumerated in the main loop;

`m` is the number of unique canonical isomer codes found (typically $m ≪ 2^{p−1}$
  due to filtering by the check_min_vertex and graph_type_from_vertex functions).

The dominant term is $O(2^{p−1}⋅p)$, corresponding to the generation and validation of all possible vertex codes. The `O(m⋅p⋅logm)` component arises from the final lexicographic sorting of the output list.

Calculation Examples

Let’s calculate the number of iterations and estimate the output size for different values of order.

Example 1: order=6
p=6−2=4

total_combinations = $2^{4−1} = 2^3 = 8$

Loop iterations: 8

Maximum possible isomers: ≤8 (after filtering)

Sorting complexity: O(8⋅log8⋅6)≈O(8⋅3⋅6)=O(144)

Example 2: order=8
p=8−2=6

total_combinations = $2^{6−1} = 2^5 = 32$

Loop iterations: 32

Maximum possible isomers: ≤32

Sorting complexity: O(32⋅log32⋅8)≈O(32⋅5⋅8)=O(1280)

Example 3: order=10
p=10−2=8

total_combinations= $2^{8−1} = 2^7 = 128$

Loop iterations: 128

Maximum possible isomers: ≤128

Sorting complexity: O(128⋅log128⋅10)≈O(128⋅7⋅10)=O(8960)

Example 4: order=12
p=12−2=10

total_combinations = $2^{10−1} = 2^9 = 512$

Loop iterations: 512

Maximum possible isomers: ≤512

Sorting complexity: O(512⋅log512⋅12)≈O(512⋅9⋅12)=O(55296)

Summary

Parameter Value
Time Complexity $O(2^{order}⋅order^2)$

Space Complexity $O(2^{order}⋅order)$
Key Limiting Factor Exponential growth with order
Practical Use Suitable only for small order (e.g., order ≤ 15) due to exponential scaling
Would you like me to elaborate on any part of this analysis or help with optimizing the algorithm?

#### 5.1.1.2. Function generate_isomer_edge

The pseudocode of the `generate_isomer_edge` function has exactly the same structure as the pseudocode of the `generate_isomer_vertex` function. The only difference is that edge codes are used instead of vertex codes throughout.

```vb
ALGORITHM generate_isomer_edge(order)
INPUT: integer order (total number of atoms n)
OUTPUT: sorted list of canonical edge codes for isomers

1. IF order < 6 THEN
2.     RAISE ERROR: «n must be at least 6 (got n = order)»
3. END IF

4. m ← order − 3  // number of internal vertices
5. total_combinations ← 2^(p−1)  // total number of possible combinations
6. length_code ← m  // length of generated code
7. CREATE empty set isomers_set (to store unique isomer codes)

8. FOR k FROM 1 TO total_combinations DO
9.     edge_code ← intg_digits(k−1, length_code)  // generate edge code
10.    IF check_min_edge(edge_code) = TRUE THEN  // check for canonicity
11.        IF  graph_type_from_edge(edge_code) = ISOMER_TYPE THEN
               vertex_code ← edge_to_vertex(edge_code)
12.            ADD vertex_code to isomers_set
13.        END IF
14.    END IF
15. END FOR

16. result_list ← convert isomers_set to list
17. SORT result_list lexicographically
18. RETURN result_list
END ALGORITHM
```

The main feature of the algorithms in the `generate_isomer_vertex` and `generate_isomer_edge` functions is the use of the ISOMER_TYPE parameter for filtering by graph type.

Complexity analysis.
The algorithm’s time complexity is $O(2^m⋅m+m⋅p⋅logm)$,
 with `m = n−3` and `p = n−2`. Space complexity is `O(m⋅p)`.

Examples:

For n=8: m=5, $2^5 =32$ combinations, p=6, time ≈O(1120), space O(192).

For n=10: m=7, $2^7 =128$ combinations, p=8, time ≈O(8064), space O(1024).

Due to exponential growth $(2^{n−3})$, the method is practical only for 6≤n≤26.

### 5.1.2. Generation of codes for molecular graphs of conformers trans-isomers

#### 5.1.2.1. Function  generate_trans_conformer_vertex

The pseudocode of the `generate_trans_conformer_vertex` function has exactly the same structure as the pseudocode of the `generate_isomer_vertex` function, with the only difference being in the filtering block.

The abbreviated pseudocode (filtering block only) of the `generate_trans_conformer_vertex` function, from which all repetitive statements have been removed, is provided below:

```vb
ALGORITHM generate_trans_conformer_vertex(order)
INPUT: integer order (n ≥ 6)
OUTPUT: sorted list of canonical vertex codes for trans‑conformers
................................................
10.    IF check_min_vertex(vertex_code) = TRUE THEN  // check for canonicity
11.        IF graph_type_from_vertex(vertex_code) = TRANS_CONFORMER_TYPE THEN
12.            ADD vertex_code to trans_conformer_set
13.        END IF
14.    END IF
.................................................
END ALGORITHM
```

Complexity:

Time: $O(2^{p−1}⋅p+m⋅p⋅logm)$, where:

`p = n−2` — number of internal vertices;

$2^{p−1}$ — combinations enumerated;

`m` — unique trans‑conformer codes found $(m ≪ 2^{p−1})$;

dominant term: $O(2^{p−1}⋅p)$.

Space: O(m⋅p) — storage for m codes of length p.

Example (n=8):

p = 6, $2^5 =3^2$ combinations;

$time ≈ O(32⋅6+m⋅6⋅logm) ≈ O(192+…)$;

space `O(m⋅6)`, `m ≪ 32`.

#### 5.1.2.2. Function  generate_trans_conformer_edge

The pseudocode of the `generate_trans_conformer_edge` function has exactly the same structure as the pseudocode of the `generate_isomer_edge function`, with the only difference being in the filtering block.

The abbreviated pseudocode (filtering block only) of the `generate_trans_conformer_edge` function, from which all repetitive statements have been removed, is provided below:

```vb
ALGORITHM generate_trans_conformer_edge(order)
INPUT: integer order (n ≥ 6)
OUTPUT: sorted list of canonical vertex codes for trans‑conformers
........................................................
10.    IF check_min_edge(edge_code) = TRUE THEN  // check for canonicity
11.        IF graph_type_from_edge(edge_code) = TRANS_CONFORMER_TYPE THEN
               vertex_code ← edge_to_vertex(edge_code)
12.            ADD vertex_code to trans_conformer_set
13.        END IF
14.    END IF
.................................................
END ALGORITHM
```

The key feature of the `generate_trans_conformer_vertex` and generate_trans_conformer_edge functions is the use of the TRANS_CONFORMER_TYPE parameter for filtering by graph type.

Complexity:

Time: $O(2^m⋅m+m⋅p⋅logm+m⋅p)$, where:

`m = n−3` — number of internal edges;

`p = n−2` — vertex code length;

2^m — combinations enumerated;

additional `O(m⋅p)` for map(min_vertex_code) and final sort;

dominant term: $O(2^m⋅m)$.

Space: `O(m⋅p)` — storage for `m` vertex codes.

Example (n=8):

m = 5, $2^5 = 32$ combinations, p=6;

$time ≈ O(32⋅5+m⋅6⋅logm+m⋅6) ≈ O(160+…)$;

space `O(m⋅6)`, `m ≪ 32`.

Key notes:

Both algorithms are exponential in n due to $2^{n−3}$
  combinations.

The edge‑code version has a small extra overhead for `edge_to_vertex` conversion and additional sorting.

Filtering is effective: $m ≪ 2^{n−3}$, so actual runtime is much better than worst‑case.

Practical use: 6 ≤ n ≤ 26, as larger n leads to prohibitive computation time.

### 5.1.3. Generation of codes for molecular graphs of conformers other-isomers

#### 5.1.3.1. Function generate_other_conformer_vertex

The pseudocode of the generate_other_conformer_vertex function has exactly the same structure as the pseudocode of the `generate_isomer_vertex function`, with the only difference being in the filtering block.

The abbreviated pseudocode (filtering block only) of the `generate_other_conformer_vertex` function, from which all repetitive statements have been removed, is provided below:

```vb
ALGORITHM generate_other_conformer_vertex(order)
INPUT: integer order (n ≥ 6)
OUTPUT: sorted list of canonical vertex codes for other conformers
..........................................................
10.    IF check_min_vertex(vertex_code) = TRUE THEN  // check for canonicity
11.        IF graph_type_from_vertex(vertex_code) = OTHER_CONFORMER_TYPE THEN
12.            ADD vertex_code to other_conformer_set
13.        END IF
14.    END IF
........................................................
END ALGORITHM
```

Complexity:

Time: $O(2^{p−1}⋅p+m⋅p⋅logm)$, where:

`p = n−2` — number of internal vertices;

$2^{p−1}$ — total combinations enumerated;

m — unique other‑conformer codes found $(m ≪ 2^{p−1})$;

dominant term: $O(2^{p−1}⋅p)$.

Space: `O(m⋅p)` — storage for m codes of length p.

Example (n=8):

p=6, $2^5 = 32$ combinations;

$time ≈ O(32⋅6+m⋅6⋅logm) ≈ O(192+…)$;

space `O(m⋅6)`, `m ≪ 32`.

#### 5.1.3.2. Function generate_other_conformer_edge

The pseudocode of the `generate_other_conformer_edge` function has exactly the same structure as the pseudocode of the `generate_isomer_edge` function, with the only difference being in the filtering block.

The abbreviated pseudocode (filtering block only) of the `generate_other_conformer_edge` function, from which all repetitive statements have been removed, is provided below:

```vb
ALGORITHM generate_other_conformer_edge(order)
INPUT: integer order (n ≥ 6)
OUTPUT: sorted list of canonical vertex codes for other conformers
..........................................................
10.    IF check_min_edge(edge_code) = TRUE THEN  // check for canonicity
11.        IF  graph_type_from_edge(edge_code) = OTHER_CONFORMER_TYPE THEN
               vertex_code ← edge_to_vertex(edge_code) 
12.            ADD vertex_code to other_conformer_set
13.        END IF
14.    END IF
........................................................
END ALGORITHM
```

The key feature of the `generate_other_conformer_vertex` and `generate_other_conformer_edge` functions is the use of the OTHER_CONFORMER_TYPE parameter for filtering by graph type.

Complexity:

Time: $O(2^m ⋅m+m⋅p⋅logm+m⋅p)$, where:

`m = n−3` — number of internal edges;

`p = n−2` — vertex code length;

$2^m$ — total combinations enumerated;

additional `O(m⋅p)` for map(min_vertex_code) and final sort;

dominant term: $O(2^m⋅m)$.

Space: `O(m⋅p)` — storage for m vertex codes.

Example (n=8):

`m = 5`, $2^5 = 32$ combinations, `p = 6`;

$time ≈ O(32⋅5+m⋅6⋅logm+m⋅6) ≈ O(160+…)$;

space `O(m⋅6)`, `m ≪ 32`.

Key notes:

Both algorithms have exponential time complexity in n due to $2^{n−3}$
  combinations.

The edge‑code version includes a small overhead for edge_to_vertex conversion and an extra sorting step.

Filtering is effective: $m ≪ 2^{n−3}$, so actual runtime and memory usage are significantly better than worst‑case estimates.

Practical use is limited to $6 ≤ n ≤ 26$, as larger n leads to prohibitive computation time.

## 5.2.Generation of codes for molecular graphs of different subtypes of conformers of other isomers

The following functions are used to generate molecular graph codes for different conformer subtypes of other isomers:

- `generate_coi_no_cis3p_edge` - creates molecular graph codes without cisoid chains of length 3 or greater

- `generate_coi_cis3_edge` - creates molecular graph codes with cisoid chains of length 3

- `generate_coi_cis4p_edge` - creates molecular graph codes with cisoid chains of length 4 or greater

All functions have the same structure and consist of the following blocks:

1. Input parameter validation;

2. Calculation of the number of combinations;

3. Iteration through all possible codes;

4. Filtering by canonicity (`check_min_edge`);

5. Filtering by graph type (`graph_type_from_edge`);

6. Collection of generated codes;

7. Conversion of the set of codes into a list;

8. Sorting of unique codes.

The functions differ from each other only in block 5, which refers to the graph type

#### 5.2.1. Function generate_coi_non_cis3p

The pseudocode for the function `gen_coi_non_cis3p_edge` is given below:

```vb
ALGORITHM generate_coi_non_cis3p(order)
INPUT: integer order (order of molecular graph without hydrogen atoms)
OUTPUT: sorted list of canonical vertex codes (no 3+ consecutive cis edges)

1. IF order < 6 THEN
2.     RAISE ERROR: «n must be at least 6 (got n = $order$)»
3. END IF
4. m ← order − 3
5. total_combinations ← $2^{m}$
6. OTHER_CONFORMER_TYPE ← 3  // graph type: conformers of other isomers (COI)
7. WITHOUT_CIS3 = 1
8. CREATE empty set result_set
9. FOR k FROM 1 TO total_combinations DO
10.      edge_code ← intg_digits(k−1, m)
11.      bcdMin ← min_edge_code(edge_code)  // canonical form
12.      IF edge_code = bcdMin THEN  // check canonicity
13.          IF graph_type_from_edge(edge_code) = OTHER_CONFORMER_TYPE THEN
14.              subtype ← graphs_subtype_edge(edge_code,1)
15.             IF subtype = WITHOUT_CIS3 THEN  // only codes without 3+ cis edges
16.                 vertex_code ← edge_to_vertex(edge_code)
17.                 ADD vertex_code to result_set
18.             END IF
19.         END IF
20.     END IF
21. END FOR
22. result_list ← convert result_set to list
23. SORT result_list lexicographically
24. RETURN result_list
END ALGORITHM
```

A key feature of this function's algorithm is that the parameter WITHOUT_CIS3 = 1 is used to filter graphs by their type.

Algorithm Complexity:

Time Complexity: O(2m⋅m), where m=order−3. Operations:

- main loop: 2m iterations;
- each iteration: canonicity check (O(m)), graph type determination (O(1)),
  call to graphs_subtype_edge (O(m));
- sorting: O(klogk), where k is the number of selected codes (k≪2m).

Space Complexity: O(k⋅m) — storing up to k vertex codes, each of length m.

Example (n=6):

`m = 3`, $2^3 = 8$ combinations, `p = 6`;
Output: [[0, 0, 0, 1]]. One code generated.

Example (n=8):

`m = 5`, $2^3 = 32$ combinations, `p = 8`;
Output: [[0, 0, 0, 1, 0, 0], [0, 0, 0, 1, 0, 1], [0, 0, 0, 1, 1, 0], [0, 0, 0, 1, 1, 1], [0, 0, 1, 0, 0, 1], [0, 0, 1, 1, 1, 0], [0, 1, 0, 0, 0, 1]]. Seven codes generated.

#### 5.2.2. Function generate_coi_cis3

The pseudocode for the `generate_coi_cis3` function has the same structure as the pseudocode for the `generate_coi_non_cis3p` function. The difference lies in the graph type filtering block.
The abbreviated pseudocode (filtering block only) of the `generate_coi_cis3` function, from which all repetitive statements have been removed, is provided below:

```vb
ALGORITHM generate_coi_cis3(order)
INPUT: integer order (order of molecular graph without hydrogen atoms)
OUTPUT: sorted list of canonical vertex codes (with 3 consecutive cis edges)
........................................................................
13.         IF graph_type_from_edge(edge_code) == OTHER_CONFORMER_TYPE THEN
14.             subtype ← graphs_subtype_edge(edge_code)
15.             IF subtype == WITH_CI3 THEN  // only codes with 3 cis edges
16.                 vertex_code ← edge_to_vertex(edge_code)
17.                 ADD vertex_code to result_set
18.             END IF
19.         END IF
.........................................................................
END ALGORITHM
```

A key feature of this function's algorithm is that the parameter WITH_CIS3 = 2 is used to filter graphs by their type.

Algorithm Complexity:

Time Complexity: O(2m⋅m), where m=order−3. Operations:

- main loop: 2m iterations;
- each iteration: canonicity check (O(m)), graph type determination (O(1)),
  call to graphs_subtype_edge (O(m));
- sorting: O(klogk), where k is the number of selected codes (k≪2m).

Space Complexity: O(k⋅m) — storing up to k vertex codes, each of length m.

Example (n=6):

`m = 3`, $2^3 = 8$ combinations, `p = 6`;
Output: [[0, 0, 0, 0]]. One code generated.

Example (n=8):

`m = 5`, $2^3 = 32$ combinations, `p = 8`;
Output: [[0, 0, 1, 1, 1, 1], [0, 1, 0, 0, 0, 0], [0, 1, 1, 1, 1, 0]]. Three codes generated.

#### 5.2.3. Function generate_coi_cis4p

The pseudocode for the `generate_coi_cis4p` function has the same structure as the pseudocode for the `generate_coi_non_cis3p` function. The difference lies in the graph type filtering block.
The abbreviated pseudocode (filtering block only) of the `generate_coi_cis4p` function, from which all repetitive statements have been removed, is provided below:

```vb
ALGORITHM generate_coi_cis4p(order)
INPUT: integer order (order of molecular graph without hydrogen atoms)
OUTPUT: sorted list of canonical vertex codes (with 4 consecutive cis edges)
.........................................................................
13.         IF graph_type_from_edge(edge_code) = OTHER_CONFORMER_TYPE THEN
14.             subtype ← graphs_subtype_edge(edge_code)
15.             IF subtype = WITH_CIS4 THEN  // only codes with 4 cis edges
16.                 vertex_code ← edge_to_vertex(edge_code)
17.                 ADD vertex_code to result_set
18.             END IF
19.         END IF
..................................................................
END ALGORITHM
```

A key feature of this function's algorithm is that the parameter WITH_CIS4 = 3 is used to filter graphs by their type.

Algorithm Complexity:

Time Complexity: O(2m⋅m), where m=order−3. Operations:

- main loop: 2m iterations;
- each iteration: canonicity check (O(m)), graph type determination (O(1)),
  call to graphs_subtype_edge (O(m));
- sorting: O(klogk), where k is the number of selected codes (k≪2m).

Space Complexity: O(k⋅m) — storing up to k vertex codes, each of length m.

Example (n=6):

`m = 3`, $2^3 = 8$ combinations, `p = 6`;
Output: [ ]. No codes generated.

Example (n=8):

`m = 5`, $2^3 = 32$ combinations, `p = 8`;
Output: [[0, 0, 0, 0, 0, 0], [0, 1, 1, 1, 1, 1]]. Two codes generated.

## 6. Enumeration of graphs of different classes (counting codes)

### 6.1. Calculation of the distribution of the number of molecular graphs by their type

#### 6.1.1. Calculating the distribution of the number of molecular graphs of a given order by their type using a vertex code

The `count_codes_from_vertex` function calculates the distribution of molecular graphs
by their types (isomers, conformers of trans-isomers, conformers of other isomers)
for a given number of atoms n. It uses a complete enumeration of all possible vertex
codes with filtering by canonicity. It is used for statistical analysis of spatial
isomerism of linear polyenes.

```vb
ALGORITHM count_codes_from_vertex(n)
INPUT: integer n (total number of atoms)
OUTPUT: vector [n, Niso, $Ncti$, Ncoi, total] — distribution by graph types

1. IF n < 6 THEN
2.     RAISE ERROR: «n must be at least 6 (got n = n)»
3. END IF

4. p ← n − 2  // number of internal vertices
5. total_combinations ← 2^(p−1)  // total number of possible codes (accounting for symmetry)
6. CREATE vector graph_type_count = [n, 0, 0, 0, 0]
   // [n, Niso (isomers), Ncti (conformers of trans‑isomers), Ncoi (conformers of other isomers), total]

7. FOR k FROM 1 TO total_combinations DO
8.     vertex_code ← intg_digits(k−1, p)  // generate vertex code
9.     canonical_code ← min_vertex_code(vertex_code)  // obtain canonical code
10.    IF vertex_code = canonical_code THEN  // check for canonicity
11.        graph_type_count[5] ← graph_type_count[5] + 1  // increment total counter
12.        graph_type ← graph_type_from_vertex(vertex_code)  // determine graph type
13.        graph_type_count[graph_type + 1] ← graph_type_count[graph_type + 1] + 1
           // increment counter for corresponding type (index = graph_type + 1)
14.    END IF
15. END FOR
16. RETURN graph_type_count
END ALGORITHM
```

Algorithm complexity:

- Time complexity: $O(2^{p−1}⋅p)$, where `p=n−2`. The main loop is executed $2^{p−1}$ times,
  each iteration includes `O(p)` operations (code generation, canonical code
  generation, classification).
- Space complexity: `O(1)`. Fixed data structures are used (5-element vector,
  time codes of length `p`).

Examples for clarity:
Example 1 (n = 6):

- p = 4, total_combinations = $2^3$ = 8
- Generate codes from [0,0,0,0] to [0,1,1,1]
- Filtering and classification:
- [0,0,0,0]: canonical, type 3 (conformer of the other isomer) → $N_{COI} = 1$
- [0,0,0,1]: canonical, type 3 (conformer of the other isomer) → $N_{COI} = 2$
- [0,0,1,0]: canonical, type 2 (conformer of the trans-isomer) → $N_{CTI} = 1$
- [0,0,1,1]: canonical, type 2 (conformer of the trans-isomer) → $N_{CTI} = 2$
- [0,1,0,1]: canonical, type 1 (isomer) → $N_{ISO} = 1$
- [0,1,1,0]: canonical, type 1 (isomer) → $N_{ISO} = 2$
- The remaining codes are either non-canonical or belong to other types
- OUTPUT: [6, 2, 2, 2, 6] (n=6, $N_{iso}=2$, $N_{CTI}=2$, $N_{COI}=2$, total=6)

Example 2 (error - n is too small):

- INPUT: n = 4
- OUTPUT: ERROR - "n must be at least 6 (got n = 4)"

#### 6.1.2. Calculating the distribution of the number of molecular graphs of a given order by their type using an edge code

The `count_codes_from_edge` function calculates the distribution of molecular graphs
by their types (isomers, conformers of trans-isomers, conformers of other isomers)
for a given number of atoms `n`. It uses a complete enumeration of all possible vertex
codes with filtering by canonicity. It is used for statistical analysis of spatial
isomerism of linear polyenes.  

```vb
ALGORITHM count_codes_from_edge(n)
INPUT: integer n (total number of atoms)
OUTPUT: vector [n, Niso, $Ncti$, Ncoi, total] — distribution by graph types

1. IF n < 6 THEN
2.     RAISE ERROR: «n must be at least 6 (got n = n)»
3. END IF

4. m ← n − 3  // number of internal edges
5. total_combinations ← 2^m   // total number of possible codes (accounting for symmetry)
6. CREATE vector graph_type_count = [n, 0, 0, 0, 0]
   // [n, Niso (isomers), Ncti (conformers of trans‑isomers), Ncoi (conformers of other isomers), total]

7. FOR k FROM 1 TO total_combinations DO
8.     vertex_code ← intg_digits(k−1, m)  // generate vertex code
9.     canonical_code ← min_edge_code(vertex_code)  // obtain canonical code
10.    IF edge_code = canonical_code THEN  // check for canonicity
11.        graph_type_count[5] ← graph_type_count[5] + 1  // increment total counter
12.        graph_type ← graph_type_from_edge(edge_code)  // determine graph type
13.        graph_type_count[graph_type + 1] ← graph_type_count[graph_type + 1] + 1
           // increment counter for corresponding type (index = graph_type + 1)
14.    END IF
15. END FOR
16. RETURN graph_type_count
END ALGORITHM
```

Algorithm complexity:

- Time complexity: $O(2^m⋅m)$, where `m=n−3`. The main loop is executed $2^m$ times,
  each iteration includes `O(m)`  operations (code generation, canonical code
  generation, classification).
- Space complexity: `O(1)`. Fixed data structures are used (5-element vector,
  time codes of length `m`).

Examples for clarity:
Example 1 (n = 6):

- m = 3, total_combinations = $2^3$ = 8
- Generate codes from [0,0,0] to [1,1,1]
- Filtering and classification:
- [0,0,0]: canonical, type 1 (isomer) → $N_{iso} = 1$
- [0,1,0]: canonical, type 1 (isomer) → $N_{iso} = 2$
- [0,0,1]: canonical, type 2 (conformer of the trans-isomer) → $N_{CTI} = 1$
- [1,0,1]: canonical, type 2 (conformer of the trans-isomer) → $N_{CTI} = 2$
- [0,1,1]: canonical, type 3 (conformer of the other isomer) → $N_{COI} = 1$
- [1,1,1]: canonical, type 3 (conformer of the other isomer) → $N_{COI} = 2$
- The remaining codes are non-canonical.
- OUTPUT: [6, 2, 2, 2, 6] (n=6, $N_{iso}=2$, $N_{CTI}=2$, $N_{COI}=2$, total=6)

Example 2 (error - n is too small):

- INPUT: n = 4
- OUTPUT: ERROR - "n must be at least 6 (got n = 4)"

## 6.2. Calculating the distributions of molecular graphs of order n = 6–30 by their type

### 6.2.1. Calculating the distributions of molecular graphs of order n = 6–30 by their type using a vertex code

Purpose
The `count_code_range_vertex` function automates the batch calculation of molecular graph distributions for a range of atom counts `n`. It calls the `count_codes_from_vertex` function iteratively, prints results to the console for real‑time monitoring, and saves them to a text file for subsequent analysis and inclusion in the scientific article.

Pseudocode

```vb
ALGORITHM count_code_range_vertex(start_n, end_n, step)
INPUT:
  - start_n: integer (initial number of atoms, default = 6)
  - end_n: integer (final number of atoms, default = 30)
  - step: integer (step size, default = 2)
OUTPUT: None (results printed to console and saved to file)

1. IF start_n < 6 THEN
2.     RAISE ERROR: "start_n must be at least 6"
3. END IF
4. IF end_n < start_n THEN
5.     RAISE ERROR: "end_n must be greater than or equal to start_n"
6. END IF
7. IF step <= 0 THEN
8.     RAISE ERROR: "step must be positive"
9. END IF

10. OPEN file "results_distribution.txt" for writing
11. WRITE to file: "Molecular Graph Distribution Analysis Results"
12. WRITE to file: "=============================================="
13. WRITE to file: "n | N_ISO | N_CTI | N_COI | TOTAL"
14. WRITE to file: "----------------------------------------------"

15. PRINT "Molecular Graph Distribution Analysis Results"
16. PRINT "=============================================="
17. PRINT "n | N_ISO | N_CTI | N_COI | TOTAL"
18. PRINT "----------------------------------------------"

19. FOR n FROM start_n TO end_n WITH STEP step DO
20.     result_vector ← count_codes_from_vertex(n)
21.     // Extract values from the result vector
22.     n_val ← result_vector[1]
23.     N_iso ← result_vector[2]
24.     N_cti ← result_vector[3]
25.     N_coi ← result_vector[4]
26.     total ← result_vector[5]

27.     // Format output string
28.     output_line ← FORMAT_STRING("%d | %d | %d | %d | %d", n_val, N_iso, N_cti, N_coi, total)

29.     // Print to console
30.     PRINT output_line

31.     // Write to file
32.     WRITE to file: output_line
33. END FOR

34. CLOSE file "results_distribution.txt"
35. PRINT ""
36. PRINT "Analysis completed. Results saved to 'results_distribution.txt'"
END ALGORITHM
```

Explanation of the Algorithm
Input Validation (Lines 1–9):

Ensures start_n is at least 6, as required by the underlying count_codes_from_vertex algorithm.

Checks that the range is valid (end_n ≥ start_n).

Verifies the step size is positive to prevent infinite or invalid loops.

File and Console Initialization (Lines 10–18):

Opens the output file `results_distribution.txt` for writing.

Writes a header and table header to both the file and the console for consistent formatting.

Main Loop over n (Lines 19–33):

Iterates over the range of n values with the specified step.

Calls `count_codes_from_vertex(n)` to compute the graph distribution for the current n.

Extracts individual values (n, $N_{iso}$, $N_{cti}$, $N_{coi}$, total) from the returned vector.

Formats the data into a standardized string for output.

Prints the formatted line to the console (for real‑time progress tracking).

Writes the same line to the output file (for permanent storage).

Finalization (Lines 34–36):

Closes the output file to ensure all data is properly saved and system resources are freed.

Prints a completion message to the console, confirming success and indicating the location of the results file.

Algorithm Complexity

Time Complexity:

$O(\sum_{n = 6}^{30} 2^(n−3)⋅(n−2))$.
For each n, the function count_codes_from_vertex is called, which has a time complexity of
$O(2^(p−1)⋅p)$, where p=n−2.
The summation is over all n in the range from 6 to 30 with a step of 2.

Space Complexity: `O(1)`.

Uses fixed‑size data structures (a 5‑element vector and temporary variables).
The file is written line‑by‑line, avoiding the need to store all results in memory simultaneously.

Example Output
Below is a representative fragment of the console and file output. The values for n=6 are exact (from the provided example). Values for n>6 are illustrative and should be replaced with actual data from your package.

Molecular Graph Distribution Analysis Results

|n  | $N_{ISO}$ | $N_{CTI}$ | $N_{COI}$ | TOTAL   |
|--:|----------:|----------:|----------:|--------:|
|6  | 2         | 2         | 2         | 6       |
|8  | 3         | 5         | 12        | 20      |
|10 | 6         | 9         | 57        | 72      |
|12 | 10        | 19        | 243       | 272     |
|...| ...       |   ...     | ...       | ...     |
|28 | 2080      | 4159      | 16775073  | 16781312|
|30 | 4160      | 8255      | 67104641  | 67117056|

Analysis completed. Results saved to 'results_distribution.txt'
Notes on the Output Table
n: Total number of atoms in the linear polyene.

$N_{ISO}$: Number of isomers (graph type 1).

$N_{CTI}$: Number of conformers of trans‑isomers (graph type 2).

$N_{COI}$: Number of conformers of other isomers (graph type 3).

TOTAL: Total number of canonical codes. This is the sum $N_{iso}$  + $N_{cti}$ + $N_{coi}$ ​
  and represents the count of unique, non‑symmetric molecular graphs found for the given `n`.

Important: When finalizing the documentation, replace the illustrative values for n>6 with the exact values obtained by running your Julia package. This ensures the documentation fully and accurately reflects the computational results used in your article.

### 6.2.2. Calculating the distributions of molecular graphs of order n = 6–30 by their type using a edge code

Purpose
The `count_code_range_vertex` function automates the batch calculation of molecular graph distributions for a range of atom counts n. It calls the count_codes_from_vertex function iteratively, prints results to the console for real‑time monitoring, and saves them to a text file for subsequent analysis and inclusion in the scientific article.

The pseudocode for the `count_code_range_edge` algorithm has the same structure as the `count_code_range_vertex` algorithm.  
However, in operator 20, the function `count_codes_from_edge(n)` is used instead of the function `count_codes_from_vertex(n)`.
Thus, operator 20 has the form `result_vector ← count_codes_from_edge(n)`.

Explanation of the Algorithm
Input Validation (Lines 1–9):

Ensures start_n is at least 6, as required by the underlying count_codes_from_vertex algorithm.

Checks that the range is valid (end_n ≥ start_n).

Verifies the step size is positive to prevent infinite or invalid loops.

File and Console Initialization (Lines 10–18):

Opens the output file `results_distribution.txt` for writing.

Writes a header and table header to both the file and the console for consistent formatting.

Main Loop over n (Lines 19–33):

Iterates over the range of n values with the specified step.

Calls `count_codes_from_vertex(n)` to compute the graph distribution for the current n.

Extracts individual values (n, $N_{iso}$, $N_{cti}$, $N_{coi}$, total) from the returned vector.

Formats the data into a standardized string for output.

Prints the formatted line to the console (for real‑time progress tracking).

Writes the same line to the output file (for permanent storage).

Finalization (Lines 34–36):

Closes the output file to ensure all data is properly saved and system resources are freed.

Prints a completion message to the console, confirming success and indicating the location of the results file.

Algorithm Complexity

Time Complexity:

$O(\sum_{n = 6}^{30} 2^(n−3)⋅(n−2))$.
For each n, the function `count_codes_from_edge` is called, which has a time complexity of
$O(2^(m)⋅m)$, where m=n−3.
The summation is over all n in the range from 6 to 30 with a step of 2.

Space Complexity: `O(1)`.

Uses fixed‑size data structures (a 5‑element vector and temporary variables).
The file is written line‑by‑line, avoiding the need to store all results in memory simultaneously.

### 6.3.1. Calculation of the distribution of the number of molecular graphs of conformers of other isomers by their subtypes

```vb
ALGORITHM count_coi_subtype_edge(n,variant)
INPUT: integer n (total number of atoms)
OUTPUT: vector [n, non_cis3, ci3, non_cis4, cis4,total] — distribution coi graph by subtypes

1. IF n < 6 THEN
2.     RAISE ERROR: «n must be at least 6 (got n = n)»
3. END IF

4. m ← n − 3  // number of internal edges
5. total_combinations ← 2^m   // total number of possible codes (accounting for symmetry)
6. CREATE vector graph_subtype_count = [n, 0, 0, 0, 0, 0]
   // [n, without_cis3, with_cis3, without_cis4, with_cis4,total]

7. FOR k FROM 1 TO total_combinations DO
8.     edge_code ← intg_digits(k−1, m)  // generate vertex code
9.     canonical_code ← min_edge_code(edge_code)  // obtain canonical code
10.    IF edge_code = canonical_code THEN  // check for canonicity
11.        graph_subtype_count[6] ← graph_subtype_count[6] + 1  // increment total counter
12.        graph_subtype ← graphs_subtype_edge(edge_code,2)  // determine graph subtype
13.        graph_subtype_count[graph_type + 1] ← graph_subtype_count[graph_type + 1] + 1
           // increment counter for corresponding type (index = graph_type + 1)           
14.    END IF
15. END FOR
16. graph_subtype_count[4] ← graph_subtype_count[2] + graph_subtype_count[3]
17. RETURN graph_subtype_count
END ALGORITHM
```

### 6.3.2. Calculation of COI graph subtype distributions for a range of atom counts `n`

Purpose
The `count_coi_subtype_range` function automates the batch calculation of COI graph subtype distributions for a range of atom counts `n`. It calls the `count_coi_subtype_edge` function iteratively for n from 6 to 30 with a step of 2, prints results to the console for real‑time monitoring, and saves them to a text file for subsequent analysis and inclusion in the scientific article.
Pseudocode

```vb
ALGORITHM count_coi_subtype_range(start_n=6, end_n=30, step=2)
INPUT:
- start_n: integer (initial number of atoms, default = 6)  
- end_n: integer (final number of atoms, default = 30)
- step: integer (step size, default = 2)

OUTPUT: None (results printed to console and saved to file)

1. IF start_n < 6 THEN
2.     RAISE ERROR: "start_n must be at least 6"
3. END IF
4. IF end_n < start_n THEN
5.     RAISE ERROR: "end_n must be greater than or equal to start_n"
6. END IF
7. IF step <= 0 THEN
8.     RAISE ERROR: "step must be positive"
9. END IF

10. OPEN file "coi_subtype_distribution.txt" for writing
11. WRITE to file: "COI Graph Subtype Distribution Analysis Results"
12. WRITE to file: "=========================================================="
13. WRITE to file: "n | WITHOUT_CIS3 | WITH_CIS3 | WITHOUT_CIS4 | CIS4 | TOTAL"
14. WRITE to file: "--------------------------------------------------------------"

15. PRINT "COI Graph Subtype Distribution Analysis Results"
16. PRINT "=========================================================="
17. PRINT "n | WITHOUT_CIS3 | WITH_CIS3 | WITHOUT_CIS4 | CIS4 | TOTAL"
18. PRINT "--------------------------------------------------------------"

19. FOR n FROM start_n TO end_n WITH STEP step DO
20.     result_vector ← count_coi_subtype_edge(n, 2)
21.     // Extract values from the result vector
22.     n_val ← result_vector[1]
23.     without_cis3 ← result_vector[2]
24.     with_cis3 ← result_vector[3]
25.     without_cis4 ← result_vector[4]
26.     cis4 ← result_vector[5]
27.     total ← result_vector[6]

28.     // Format output string
29.     output_line ← FORMAT_STRING("%d | %d | %d | %d | %d | %d", 
                        n_val, without_cis3, with_cis3, without_cis4, cis4, total)

30.     // Print to console
31.     PRINT output_line

32.     // Write to file
33.     WRITE to file: output_line
34. END FOR

35. CLOSE file "coi_subtype_distribution.txt"
36. PRINT ""
37. PRINT "Analysis completed. Results saved to 'coi_subtype_distribution.txt'"
END ALGORITHM
```

Explanation of the Algorithm

    1. Input Validation (Lines 1–9):
        ◦ Ensures start_n ≥ 6, as required by the underlying count_coi_subtype_edge algorithm.
        ◦ Checks that the range is valid (end_n ≥ start_n).
        ◦ Verifies the step size is positive to prevent infinite or invalid loops.
    2. File and Console Initialization (Lines 10–18):
        ◦ Opens the output file coi_subtype_distribution.txt for writing.
        ◦ Writes a header and table header to both the file and the console for consistent formatting.
    3. Main Loop over n (Lines 19–34):
        ◦ Iterates over the range of n values with the specified step.
        ◦ Line 20: Calls count_coi_subtype_edge(n, 2) to compute the COI graph distribution for the current n. The variant = 2 ensures compatibility with the 6‑element output vector.
        ◦ Lines 22–27: Extracts individual values from the returned vector:
            ▪ n_val: number of atoms;
            ▪ without_cis3: graphs without 3+ consecutive cis edges;
            ▪ with_cis3: graphs with exactly 3 consecutive cis edges (but not 4+);
            ▪ without_cis4: graphs without 4+ consecutive cis edges (sum of without_cis3 and with_cis3);
            ▪ cis4: graphs with 4+ consecutive cis edges;
            ▪ total: total number of canonical COI graphs.
        ◦ Lines 28–29: Formats the data into a standardized string for output.
        ◦ Lines 30–33: Prints the formatted line to the console (for real‑time progress tracking) and writes it to the output file (for permanent storage).
    4. Finalization (Lines 35–37):
        ◦ Closes the output file to ensure all data is properly saved and system resources are freed.
        ◦ Prints a completion message to the console, confirming success and indicating the location of the results file.
Algorithm Complexity

    • Time Complexity: O(∑n=6,8,…,30​ 2n−3⋅(n−3)).
        ◦ For each n, the function count_coi_subtype_edge is called, which has a time complexity of O(2m⋅m), where m=n−3.
        ◦ The summation is over all n in the range from 6 to 30 with a step of 2.
    • Space Complexity: O(1).
        ◦ Uses fixed‑size data structures (a 6‑element vector and temporary variables).
        ◦ The file is written line‑by‑line, avoiding the need to store all results in memory simultaneously.

Example Output

Below is a representative fragment of the console and file output. The values are illustrative and should be replaced with actual data from your package.
COI Graph Subtype Distribution Analysis Results

| n | WITHOUT_CIS3 | WITH_CIS3 | WITHOUT_CIS4 | CIS4    | TOTAL     |
|--:|-------------:|----------:|-------------:|--------:|----------:|
|6  | 1            | 1         | 2            | 0       | 2         |
|8  | 7            | 3         | 10           | 2       | 12        |  
|10 | 31           | 15        | 46           | 11      | 57        |
|12 | 118          | 67        | 185          | 58      | 243       |
|14 | 427          | 289       | 716          |  285    | 1001      |
|...|  ...         |  ...      |  ...         |  ...    |  ...      |
|28 | 2345462      | 84933133  | ...          | 94964478| 16775073  |
|30 |7941301       | 19108459  | ...          | 40054881| 67104641  |

Analysis completed. Results saved to 'coi_subtype_distribution.txt'
Notes on the Output Table:

- `n`: Total number of atoms in the linear polyene.
- `WITHOUT_CIS3`: Number of COI graphs without 3 or more consecutive cis edges.
- `WITH_CIS3`: Number of COI graphs with exactly 3 consecutive cis edges (but not 4+).
- `WITHOUT_CIS4`: Number of COI graphs without 4 or more consecutive cis edges.
    This is the sum `without_cis3 + with_cis3`.
- `CIS4`: Number of COI graphs with 4 or more consecutive cis edges.
- `TOTA`L: Total number of canonical COI graphs found for the given `n`.

Important: When finalizing the documentation,replace the illustrative values with the exact values obtained by running your Julia package.This ensures the documentation fully and accurately reflects the computational results used in your article.

## 7. Determination of the symmetry group from a vertex or edge code

### 7.1. Determination of the symmetry group from a vertex code

The `symmetry_class_from_vertex` function determines the symmetry class of a
graph based on its vertex code.

``` vb
ALGORITHM: symmetry_class_from_vertex
Purpose: Determines the symmetry class of a graph based on its vertex code.
INPUT: vertex_code — vector of length $p = n - 2$ (internal vertices of the graph)
  - $0$ = next edge turns left;
  - $1$ = next edge turns right.
OUTPUT: symmetry class of graph (one of three values):
  - MIRROR_SYMMETRY = $1$ — mirror symmetry (symmetry group $C_{2h}$);
  - ROTATIONAL_SYMMETRY = $2$ — rotational symmetry (symmetry group $C_{2v}$);
  - NO_SYMMETRY = $3$ — no symmetry (symmetry group $C_S$).

1.  p = length(vertex_code)  // length of vertex code (number of internal vertices)

2.  IF $p < 4$ THEN
3.      error("Vertex code must have length at least 4 (n ≥ 6)")
4.  END IF

5.  first_bit = vertex_code[1]      // first element of the code
6.  last_bit = vertex_code[p]     // last element of the code (using 1‑based indexing)

7.  IF first_bit == $0$ AND last_bit == $0$ THEN
        // Case: beginning and end of code are both 0
8.      reversed_code = reverse(vertex_code)

9.      IF vertex_code == reversed_code THEN
10.          RETURN MIRROR_SYMMETRY  // $C_{2h}$ — mirror symmetry
11.     ELSE
12.          RETURN NO_SYMMETRY      // $C_S$ — no symmetry
13.     END IF
14. ELSE IF first_bit == $0$ AND last_bit == $1$ THEN
       // Case: beginning = 0, end = 1
15.    reversed_code = reverse(vertex_code)
16.    inverted_reversed_code = invert(reversed_code)  // flip all bits: 0→1, 1→0

17.    IF vertex_code == inverted_reversed_code THEN
18.         RETURN ROTATIONAL_SYMMETRY  // $C_{2v}$ — rotational symmetry
19.    ELSE
20.         RETURN NO_SYMMETRY           // $C_S$ — no symmetry
21.    END IF
22. ELSE
23.     error("Invalid vertex code: first_bit must be 0, and last_bit must be 0 or 1")
24. END IF
END ALGORITHM
```

Algorithm steps:

Length check. If p<4, the function raises an error because at least 4 internal vertices are required for symmetry analysis (n≥6).

Extract boundary bits. The algorithm reads the first (first_bit) and last (last_bit) elements of the vertex code.

Case analysis:

Case 1: `first_bit = 0` and `last_bit = 0`. The code is checked for palindromic structure. If it is a palindrome, the graph has mirror symmetry (MIRROR_SYMMETRY, group $C_{2h}$). Otherwise, it has no symmetry (NO_SYMMETRY,
group $C_S$).

Case 2: `first_bit = 0` and `last_bit = 1`. The algorithm reverses the code and then inverts all bits (0↔1). If the original code matches this transformed version, the graph has rotational symmetry (ROTATIONAL_SYMMETRY, group
$C_{2v}$). Otherwise, it has no symmetry.

Invalid cases. If the first bit is not 0, or the last bit is neither 0 nor 1, an error is raised.

Time complexity: `O(p)`, where p is the length of the vertex code. The main operations are:

Reversing the array: `O(p)`.

Inverting the array (if needed): `O(p)`.

Comparing arrays: `O(p)`.

Space complexity: `O(p)`. Additional memory is required to store the reversed and possibly inverted versions of the vertex code.

Example 1. Mirror symmetry (palindromic code, first = last = 0)

Input: `vertex_code = [0, 1, 1, 0]`

Length: p=4 (valid)

Boundary bits: first_bit = 0, last_bit = 0 → Case 1

Palindrome check: [0,1,1,0]=[0,1,1,0] → palindrome

Result: MIRROR_SYMMETRY ($C_{2h}$)

Explanation: the sequence is symmetric around the center, and boundary conditions are met.

Example 2. Rotational symmetry (inverted palindrome, first = 0, last = 1)

Input: `vertex_code = [0, 1, 0, 1]`

Length: p=4 (valid)

Boundary bits: `first_bit = 0`, `last_bit = 1` → Case 2

Reverse: [1, 0, 1, 0]

Invert reverse: [0, 1, 0, 1] → matches original

Result: ROTATIONAL_SYMMETRY ($C_{2v}$)

Explanation: the original code equals the inverted reverse, indicating rotational symmetry.

Example 3. No symmetry (not a palindrome, first = last = 0)

Input: `vertex_code = [0, 1, 0, 0]`

Length: p=4 (valid)

Boundary bits: `first_bit = 0`, `last_bit = 0` → Case 1

Palindrome check: [0,1,0,0]

=[0,0,1,0] → not a palindrome

Result: NO_SYMMETRY ($C_S$)

Explanation: the sequence does not match its reverse.

Example 4. No symmetry (does not match inverted reverse, first = 0, last = 1)

Input: `vertex_code = [0, 1, 1, 1]`

Length: p=4 (valid)

Boundary bits: `first_bit = 0, last_bit = 1` → Case 2

Reverse: [1, 1, 1, 0]

Invert reverse: [0, 0, 0, 1] ≠ original [0, 1, 1, 1]

Result: NO_SYMMETRY ($C_S$)

Explanation: the original code does not equal the inverted reverse.

Example 5. Error due to short length

Input: `vertex_code = [0, 1]`

Length: p=2<4

Result: error “Vertex code must have length at least 4 (n ≥ 6)”

Example 6. Error due to invalid boundary bits

Input: `vertex_code = [1, 0, 1, 0]`

Boundary bits: `first_bit = 1, last_bit = 0`

Result: error “Invalid vertex code: `first_bit` must be 0, and `last_bit` must be 0 or 1”

### 7.2. Determination of the symmetry group from a edge code

The `symmetry_class_from_edge` function determines the symmetry class of a
graph based on its edge code.

```vb
ALGORITHM: symmetry_class_from_edge
Purpose: Determines the symmetry class of a graph based on its edge code.
INPUT: edge_code: vector of length `m = n - 3` (internal edgees of the graph)
  - 0 = trans-configuration;
  - 1 = cis-configuration.
OUTPUT: symmetry class of graph can take one of three values:
MIRROR_SYMMETRY = 1 -   mirror symmetry (symmetry group $C_{2h}$);
ROTATIONAL_SYMMETRY = 2 - rotational symmetry (symmetry group $C_{2v}$);
NO_SYMMETRY = 3 - no symmetry (symmetry group $C_S$).

m = length(edge_code) // edge code length (equal to the number of internal edges of the graph)
    
1. IF m < 3 THEN
2.     error("Edge code must have length at least 3 (n ≥ 6)")
3. END IF
    
// Check if the code is a palindrome (equals its reverse)
4. IF edge_code != reverse(edge_code)  THEN
5.     RETURN NO_SYMMETRY  // C_S - no symmetry
6. ELSE
    // Code is a palindrome, analyze the central element
7.     middle_index = div(m, 2) + 1  // index of the central element
        
8.     IF edge_code[middle_index] == 1   THEN
9.         RETURN MIRROR_SYMMETRY     // C_{2h} - mirror symmetry
10.    else
11.        RETURN ROTATIONAL_SYMMETRY // C_{2v} - rotational symmetry
12.    END IF
END IF
END ALGORITHM
```

Algorithm steps:

Length check. If m<3, the function raises an error because at least 3 internal edges are required for symmetry analysis (n≥6).

Palindrome check. The edge code is compared with its reverse. If they do not match, the graph has no symmetry (NO_SYMMETRY, group $C_S$).

Central element analysis. If the code is a palindrome:

If the central element equals 1 (cis‑configuration), the graph has mirror symmetry (MIRROR_SYMMETRY,
 group $C_{2h}$).

If the central element equals 0 (trans‑configuration), the graph has rotational symmetry
(ROTATIONAL_SYMMETRY, group $C_{2v}$).

Algorithm complexity
Time complexity: `O(m)`, where m is the length of the edge code. The main contribution
comes from comparing the code with its reverse (requires `O(m)` time to create the
reversed copy and `O(m)` for comparison).

Space complexity: `O(m)`. Additional memory is required to store the reversed version of the edge code.

Examples of operation
Example 1. No symmetry

Input: `edge_code = [0, 1, 0, 1]`

Length: m=4 (valid)

Palindrome check: [0,1,0,1]

=[1,0,1,0] → not a palindrome

Result: NO_SYMMETRY ($C_{S}$)

Explanation: the sequence is not symmetric around the center.

Example 2. Mirror symmetry

Input: `edge_code = [0, 1, 1, 0]`

Length: m=4 (valid)

Palindrome check: [0,1,1,0]=[0,1,1,0] → palindrome

Central element: index floor(4/2)+1=3, value `edge_code[3] = 1`

Result: MIRROR_SYMMETRY ($C_{2h}$)

Explanation: the code is symmetric, and the central element indicates a cis‑configuration.

Example 3. Rotational symmetry

Input: `edge_code = [1, 0, 0, 1]`

Length: m=4 (valid)

Palindrome check: [1,0,0,1]=[1,0,0,1] → palindrome

Central element: index 3, value  `edge_code[3] = 0`

Result: ROTATIONAL_SYMMETRY ($C_{2v}$)

Explanation: the code is symmetric, and the central element indicates a trans‑configuration.

Example 4. Error due to short length

Input: `edge_code = [0, 1]`

Length: `m=2<3`

Result: error “Edge code must have length at least 3 (n ≥ 6)”

### 7.3. Calculation of the distribution of graphs of a given order by symmetry classes using an vertex code

```vb
ALGORITHM: count_graphs_by_symmetry_vertex
Purpose: Counts the number of graphs of a given order and type, distributed by symmetry class.
INPUT:
  - graphs_type — integer (1, 2, or 3): type of graphs to count;
  - order — integer ≥ 6: order of the graphs (number of edges).
OUTPUT: vector [n, C_{2h}, C_{2v}, C_S, total] with counts:
  - n — order of graphs (input value);
  - C_{2h} — count of graphs with mirror symmetry (MIRROR_SYMMETRY);
  - C_{2v} — count of graphs with rotational symmetry (ROTATIONAL_SYMMETRY);
  - C_S — count of graphs with no symmetry (NO_SYMMETRY);
  - total — total number of graphs of given type and order that satisfy conditions.

// Validation
1.  IF order < 6 THEN
       error("Order must be at least 6 (got order = $order$)")
2.  END IF

3.  IF graphs_type < 1 OR graphs_type > 3 THEN
        error("Graphs_type must be 1, 2, or 3 (got $graphs_type$)")
4.  END IF

// Setup
5.  p = order - 2  // number of internal edges (length of edge code)
6.  total_combinations = 2^(p-1)  // total number of possible edge codes
7.  length_code = p

// Initialize counter vector: [n, C_{2h}, C_{2v}, C_S, total]
8.  class_sym_count = [order, 0, 0, 0, 0]

// Iterate over all possible edge codes (from 0 to 2^m - 1)
9.  FOR k = 1 TO total_combinations DO
        // Generate edge code for number (k-1) in binary representation
10.     code = intg_digits(k - 1, length_code)  

        // Check if the code is canonical (minimal representative)
11.     canonical_code = min_vertex_code(code)

12.     IF code == canonical_code THEN
           // Determine the graph type from the edge code
13.          current_type = graph_type_from_vertex(code)

          // Only process codes that match the requested graph type
14.         IF current_type == graphs_type THEN
                // Determine symmetry class of the graph
15.             symmetry_class = symmetry_class_from_edge(code)

            // Update counters:
            // symmetry_class is 1, 2, or 3 → index = symmetry_class + 1
16.             class_sym_count[symmetry_class + 1] = class_sym_count[symmetry_class + 1] + 1

            // Increment total count
17.             class_sym_count[5] = class_sym_count[5] + 1
18.         END IF
19.     END IF
20. END FOR

RETURN class_sym_count
END ALGORITHM
```

### 7.4. Calculation of the distribution of graphs of a given order by symmetry classes using an edge code

```vb
ALGORITHM: count_graphs_by_symmetry_edge
Purpose: Counts the number of graphs of a given order and type, distributed by symmetry class.
INPUT:
  - graphs_type — integer (1, 2, or 3): type of graphs to count;
  - order — integer ≥ 6: order of the graphs (number of edges).
OUTPUT: vector [n, C_{2h}, C_{2v}, C_S, total] with counts:
  - n — order of graphs (input value);
  - C_{2h} — count of graphs with mirror symmetry (MIRROR_SYMMETRY);
  - C_{2v} — count of graphs with rotational symmetry (ROTATIONAL_SYMMETRY);
  - C_S — count of graphs with no symmetry (NO_SYMMETRY);
  - total — total number of graphs of given type and order that satisfy conditions.

// Validation
1.  IF order < 6 THEN
       error("Order must be at least 6 (got order = $order$)")
2.  END IF

3.  IF graphs_type < 1 OR graphs_type > 3 THEN
        error("Graphs_type must be 1, 2, or 3 (got $graphs_type$)")
4.  END IF

// Setup
5.  m = order - 3  // number of internal edges (length of edge code)
6.  total_combinations = 2^m  // total number of possible edge codes
7.  length_code = m

// Initialize counter vector: [n, C_{2h}, C_{2v}, C_S, total]
8.  class_sym_count = [order, 0, 0, 0, 0]

// Iterate over all possible edge codes (from 0 to 2^m - 1)
9.  FOR k = 1 TO total_combinations DO
        // Generate edge code for number (k-1) in binary representation
10.     code = intg_digits(k - 1, length_code)  

        // Check if the code is canonical (minimal representative)
11.     canonical_code = min_edge_code(code)

12.     IF code == canonical_code THEN
           // Determine the graph type from the edge code
13.          current_type = graph_type_from_edge(code)

          // Only process codes that match the requested graph type
14.         IF current_type == graphs_type THEN
                // Determine symmetry class of the graph
15.             symmetry_class = symmetry_class_from_edge(code)

            // Update counters:
            // symmetry_class is 1, 2, or 3 → index = symmetry_class + 1
16.             class_sym_count[symmetry_class + 1] = class_sym_count[symmetry_class + 1] + 1

            // Increment total count
17.             class_sym_count[5] = class_sym_count[5] + 1
18.         END IF
19.     END IF
20. END FOR

RETURN class_sym_count
END ALGORITHM
```

Algorithm steps:

Input validation. Ensures `order ≥ 6` and `graphs_type ∈ {1, 2, 3}`.

Setup. Calculates the number of internal edges m = order − 3 and the total number of possible edge codes 2^m.

Initialization. Prepares a counter vector class_sym_count with zeros.

Iteration. Loops through all possible edge codes from 0 to $2^m − 1$:

Converts the current number to a binary edge code.

Checks if the code is canonical (i.e., the minimal representative of its equivalence class).

If canonical, determines the graph type using graph_type_from_edge.

If the type matches graphs_type, determines the symmetry class using symmetry_class_from_edge.

Updates the counters accordingly.

Return. Returns the final count vector.

Time complexity: $O(2^m⋅f(m))$, where:

`m = order−3` - is the length of the edge code;

$2^m$  - is the total number of codes to iterate over;

f(m) - is the cost of operations per code (including `min_edge_code`, `graph_type_from_edge`, and `symmetry_class_from_edge`).

Space complexity: `O(m)`. Dominated by storage of the current code and canonical_code
vectors of length `m`. The counter vector uses constant space.

**Examples

Example 1. Small case: `order = 6, graphs_type = 1`

Input: `graphs_type = 1, order = 6`

Setup: m=6−3=3, total_combinations = 8

Process: iterates over codes `000` to `111`

For each code: checks if canonical, then checks type and symmetry.

Output: e.g., [6, 2, 1, 3, 6]

2 graphs with mirror symmetry ($C_{2h}$);

1 graph with rotational symmetry ($C_{2v}$);

3 graphs with no symmetry ($C_S$);

total 6 graphs of type 1 and order 6.

Example 2. Error case: invalid order

Input: `graphs_type = 2, order = 5`

Result: error “Order must be at least 6 (got order = 5)”

Example 3. Error case: invalid graph type

Input: `graphs_type = 4, order = 7`

Result: error “Graphs_type must be 1, 2, or 3 (got 4)”

Notes on the implementation of the algorithm:

- `intg_digits(num, length)` — converts an integer num to a binary vector of specified length.

- `min_edge_code(code)` — returns the canonical (minimal) form of the edge code under graph isomorphism.

- `graph_type_from_edge(code)` — determines the topological type of the graph from its edge code.

- `symmetry_class_from_edge(code)` — uses the logic from the earlier algorithm to classify symmetry.

### 7.4. Calculation of the distribution of graphs of a given order by symmetry classes using an vertex code

```vb
ALGORITHM: count_graphs_by_symmetry_vertex
Purpose: Counts the number of graphs of a given order and type, distributed by symmetry
class from a vertex code.
INPUT:
  - graphs_type — integer (1, 2, or 3): type of graphs to count;
  - order — integer ≥ 6: order of the graphs (number of edges).
OUTPUT: vector [n, C_{2h}, C_{2v}, C_S, total] with counts:
  - n — order of graphs (input value);
  - C_{2h} — count of graphs with mirror symmetry (MIRROR_SYMMETRY);
  - C_{2v} — count of graphs with rotational symmetry (ROTATIONAL_SYMMETRY);
  - C_S — count of graphs with no symmetry (NO_SYMMETRY);
  - total — total number of graphs of given type and order that satisfy conditions.
//  ....................................
11.     canonical_code = min_vertex_code(code)
//..............................................
13.          current_type = graph_type_from_vertex(code)
//.................................................
15.             symmetry_class = symmetry_class_from_vertex(code)
//...........................................
// ......................................
END ALGORITHM
```  

The pseudocode for the `count_graphs_by_symmetry_vertex` algorithm has the same structure as the pseudocode for the `count_graphs_by_symmetry_edge` algorithm.

Only operators 11, 13, and 15 differ.
In operator 11, `canonical_code = min_vertex_code(code)` is used instead of `canonical_code = min_edge_code(code)`.

In operator 13, `current_type = graph_type_from_vertex(code)` is used instead
of `current_type = graph_type_from_edge(code)`.

In operator 15, `symmetry_class = symmetry_class_from_vertex(code)` is used instead
of `symmetry_class = symmetry_class_from_edge(code)`.

Notes on the implementation of the algorithm:

- `intg_digits(num, length)` — converts an integer num to a binary vector of specified length.

- `min_vertex_code(code)` — returns the canonical (minimal) form of the edge code under graph isomorphism.

- `graph_type_from_vertex(code)` — determines the topological type of the graph from its edge code.

- `symmetry_class_from_vertex(code)` — uses the logic from the earlier algorithm to classify symmetry.

### 7.5.Calculating the distribution of graphs of orders n = 6-30 by symmetry classes

```vb
ALGORITHM: count_graphs_by_symmetry_range
Purpose: Computes the symmetry class distribution for graphs of a given type across 
a range of orders (e.g., n=6 to 30), collecting and sorting the results.
INPUT:
  - graphs_type — integer (1, 2, or 3): type of graphs to count;
  - orders — range of integers (e.g., 6:2:30): sequence of graph orders to process 
    (typically even numbers from 6 to 30).
OUTPUT: sorted list of vectors [n, C_{2h}, C_{2v}, C_S, total], one per order in the input range.

// Validation
1. IF graphs_type < 1 OR graphs_type > 3 THEN
2.    error("Graphs_type must be 1, 2, or 3 (got $graphs_type$)")
3. END IF

// Initialize data structures
4. set_distrib_graphs_by_symclass = empty set of vectors  // set to store unique symmetry distributions
5. list_distrib_graphs_by_symclass = empty list of vectors  // list for final sorted output

// Iterate over each order in the given range
6. FOR each n IN orders DO
    // Calculate symmetry distribution for graphs of order n and given type
7.     class_sym_count = count_graphs_by_symmetry_edge(graphs_type, n)

    // Add result to set (ensures uniqueness)
8.     ADD class_sym_count TO set_distrib_graphs_by_symclass
9. END FOR

// Convert set to list and sort it (by order n, then by other fields if needed)
10. list_distrib_graphs_by_symclass = SORT(COLLECT(set_distrib_graphs_by_symclass))

11. RETURN list_distrib_graphs_by_symclass
END ALGORITHM
```

Algorithm steps:

Input validation. Checks that graphs_type is in {1, 2, 3}. If not, raises an error.

Initialization. Creates:

an empty set set_distrib_graphs_by_symclass to store unique distribution vectors (avoiding duplicates);

an empty list list_distrib_graphs_by_symclass for the final sorted output.

Iteration. For each order n in the input orders range:

Calls count_graphs_by_symmetry_edge(graphs_type, n) to compute the symmetry distribution for that order.

Adds the resulting vector to the set (duplicates are automatically ignored).

Sorting. Converts the set to a list and sorts it. Sorting is typically by n (ascending), then by the other fields if necessary.

Return. Returns the sorted list of distribution vectors.

Time complexity: O(k⋅T_single + klogk), where:

k — number of orders in the orders range (e.g., for 6:2:30, k=13);

T_single — time complexity of a single call to count_graphs_by_symmetry_edge, which is
$O(2^m⋅f(m))$ with m=n−3;

`klogk` — cost of sorting the final list (usually negligible compared to the main computation).

Space complexity: O(k+m), where:

`k` — space for storing up to k distribution vectors;

`m` — space used internally by count_graphs_by_symmetry_edge for a single order n (dominated by edge code storage).

Example 1. Valid input: `graphs_type = 1, orders = 6:2:10`

Input: `graphs_type = 1, orders = [6, 8, 10]`

Process:

For n=6: calls `count_graphs_by_symmetry_edge(1, 6)` → returns [6, a, b, c, d]

For n=8: calls `count_graphs_by_symmetry_edge(1, 8)` → returns [8, e, f, g, h]

For n=10: `calls count_graphs_by_symmetry_edge(1, 10)` → returns [10, i, j, k, l]

Output: sorted list `[[6, a, b, c, d], [8, e, f, g, h], [10, i, j, k, l]]`

Example 2. Error case: invalid graph type

Input: `graphs_type = 4, orders = 6:2:20`

Result: error “Graphs_type must be 1, 2, or 3 (got 4)”

Example 3. Empty range

Input: `graphs_type = 2, orders = []` (empty range)

Process: loop does not execute

Output: empty list []

Notes on the implementation of the algorithm

Set usage. The use of a set (set_distrib_graphs_by_symclass) ensures that only unique
distribution vectors are kept. This is useful if different orders produce identical
symmetry counts (though unlikely in practice).

Sorting. The final SORT(COLLECT(...)) step ensures the output is ordered by n, making it easy to read and analyze.

Efficiency. The algorithm’s performance is dominated by the calls to count_graphs_by_symmetry_edge. For large ranges or high orders, this can be computationally expensive.

### 7.6. Output of the results of calculating the distribution of graphs by symmetry classes

```vb
ALGORITHM: output_graphs_by_symmetry_range
Purpose: Prints the symmetry class distribution data in a formatted table to the console
and saves the same table to a text file.
INPUT:
  - list_result — list of vectors [n, C_{2h}, C_{2v}, C_S, total], one per order;
  - graphs_type — integer (1, 2, or 3): type of graphs being reported;
  - dirpath — string: directory path where the output file will be saved;
  - fname — string: base name of the output file (without extension).
OUTPUT: none (prints table to console and saves to a text file)

// Construct full file path
full_path = dirpath + "/" + fname + ".txt"  // e.g., "results/graphs_type_1.txt"

// Open file for writing
file = OPEN(full_path, "write")

// Write header to both console and file
PRINT "Symmetry Class Distribution for Graphs (Type $graphs_type$)"
PRINT "=========================================================="
PRINT "Order | Mirror (C_{2h}) | Rotational (C_{2v}) | None (C_S) | Total"
PRINT "------|---------------|-------------------|-----------|------"
WRITE_LINE(file, "Symmetry Class Distribution for Graphs (Type $graphs_type$)")
WRITE_LINE(file, "========================================================")
WRITE_LINE(file, "Order | Mirror (C_{2h}) | Rotational (C_{2v}) | None (C_S) | Total")
WRITE_LINE(file, "------|---------------|-------------------|-----------|------")

// Iterate over each result vector in the list
FOR each entry IN list_result DO
    n = entry[1]        // order of graphs
    C_2h = entry[2]     // count with mirror symmetry
    C_2v = entry[3]    // count with rotational symmetry
    C_S = entry[4]     // count with no symmetry
    total = entry[5]   // total count

    // Format row: align numbers, use fixed width for readability
    row_console = FORMAT("%4d | %12d | %17d | %9d | %5d", n, C_2h, C_2v, C_S, total)
    row_file = FORMAT("%4d | %12d | %17d | %9d | %5d", n, C_2h, C_2v, C_S, total)

    // Print to console
    PRINT row_console

    // Write to file
    WRITE_LINE(file, row_file)
END FOR

// Close the file
CLOSE(file)

// Final message to console
PRINT ""
PRINT "Results saved to: $full_path$"
END ALGORITHM
```

Algorithm steps:

File setup. Constructs the full output file path by combining dirpath, fname, and the .txt extension. Opens the file for writing.

Header output. Prints a descriptive header and table column labels to both the console and the file. Includes the graphs_type in the title for clarity.

Table body. For each entry in list_result:

Extracts the values: $n$, $C_{2h}$, $C_{2v}$, $C_S$, and total.

Formats them into a neatly aligned row using fixed‑width formatting for readability.

Prints the formatted row to the console.

Writes the same formatted row to the output file.

Cleanup. Closes the file handle to ensure data is saved and resources are freed.

Final message. Prints a confirmation message to the console indicating where the results were saved.

Algorithm complexity

- Time complexity: `O(k)`, where k is the number of entries in list_result. Each entry is processed exactly once. The dominant operations are string formatting and I/O operations, both linear in the number of rows.

- Space complexity: `O(1)` additional space (excluding input and output). The algorithm processes one row at a time and does not store the entire table in memory.

Examples

- Example 1. Valid input with 3 entries

Input:

`list_result = [[6, 2, 1, 3, 6], [8, 5, 4, 7, 16], [10, 12, 9, 15, 36]]`

graphs_type = 1

dirpath = "results"

fname = "graphs_type_1"

Console output:

Symmetry Class Distribution for Graphs (Type 1)

|Order | Mirror ($C_{2h}$) | Rotational ($C_{2v}$) | None ($C_S$) | Total|
|------|-------------------|-----------------------|--------------|------|
|   6  |            1      |                 1     |         0    |     2|
|   8  |            0      |                 2     |         1    |    3 |
|  10  |            2      |                 2     |         2    |     6|
|  12  |            0      |                 4     |         6    |   10 |
|  14  |            4      |                 4     |        12    |   29 |
|  16  |            0      |                 8     |        28    |   36 |
|  18  |            8      |                 8     |        56    |   72 |

Results saved to: results/graphs_type_1.txt
File content: identical to the console output, saved in results/graphs_type_1.txt.

- Example 2. Empty input list

Input: list_result = [], graphs_type = 2, dirpath = "output", fname = "data"

Process: header is printed, then the loop does nothing

Output:

Symmetry Class Distribution for Graphs (Type 2)

|Order | Mirror ($C_{2h}$) | Rotational ($C_{2v}$) | None ($C_S$) | Total|
|------|-------------------|-----------------------|--------------|------|
|  6   |          0        |           1           |        1     |  2   |
|  8   |          2        |           1           |        2     |  5   |
| 10   |          0        |           3           |        6     |  9   |
| 12   |          4        |           3           |       12     | 19   |
| 14   |          0        |           7           |       28     | 35   |
| 16   |          8        |           7           |       56     | 71   |
| 18   |          0        |          15           |      120     | 135  |
|      |                   |                       |              |      |

Results saved to: output/data.txt

Results saved to: output/data.txt

- Example 3. Error case: invalid directory path

Input: valid list_result, but dirpath = "/invalid/path" (directory does not exist)

Result: error when trying to open file (e.g., “Permission denied” or “No such file or directory”)

Notes on the implementation of the algorithm:

- Formatting. Uses fixed‑width columns (%4d, %12d, etc.) to ensure the table aligns properly even with large numbers.

- I/O handling. Explicitly opens and closes the file to prevent resource leaks.

- Consistency. The console and file outputs are identical, ensuring reproducibility.

- User feedback. The final message confirms the save location, helping users locate their results.

## 8.Construction of a geometric molecular graph of linear polyenes

### 8.1.Construction of a geometric molecular graph of linear polyenes without hydrogen atoms

Pseudocode for Function create_carbon_chain (Exact Match to Julia Code)
Description
The algorithm constructs a zigzag chain graph for linear polyenes (without hydrogen atoms) on a hexagonal lattice. Each vertex corresponds to a carbon atom, each edge — to a C–C bond. All edges have the same length (CC_LEN=1,44), angles between adjacent edges are $120^{\circ}$.

Attributes

- Graph type: zigzag chain (linear polyene without H).

- Vertices: carbon atoms ©.

- Edges: C–C bonds, length `CC_LEN=1.44`.

-Angles: $120^{\circ}$ between adjacent edges.

- Lattice: hexagonal (honeycomb type).

- Initial edge: direction NE (northeast).

Vertex code:

- 0 — next edge turns left;

- 1 — next edge turns right.

Edge directions: 6 variants (NE, SE, N, SW, NW, S).

``` vb
Constants:
CC_LEN=1,44 — C–C bond length.

INIT_X=7,1023, INIT_Y=3.3107 — initial coordinates of the first vertex.

DX_CC=CC_LEN⋅3/2, DY_CC=CC_LEN⋅0.5 — displacement components for C–C edges.

VARIANTS — a dictionary of 6 direction variants, each contains displacements for the right (dXR, dYR) and left (dXL, dYL) edges.
VARIANTS = {
  1: (dXR =  DX_CC, dYR = -DY_CC, dXL = 0.0, dYL = CC_LEN),
  2: (dXR = -DX_CC, dYR =  DY_CC, dXL = 0.0, dYL = -CC_LEN),
  3: (dXR = 0.0,    dYR = CC_LEN,  dXL = -DX_CC, dYL = -DY_CC),
  4: (dXR = 0.0,    dYR = -CC_LEN, dXL =  DX_CC, dYL =  DY_CC),
  5: (dXR =  DX_CC, dYR =  DY_CC,  dXL = -DX_CC, dYL = DY_CC),
  6: (dXR = -DX_CC, dYR = -DY_CC,  dXL = DX_CC,  dYL = -DY_CC)
}
```

Helper Function: determine_variant (Verbatim from Code)

Psevdocode

```vb
ALGORITHM: determine_variant
Input:
arrays x_coords, y_coords;
current_vertex — current vertex number (≥ 2).
Output: direction variant number (1–6).

IF current_vertex < 2:
  THROW ERROR "At least two vertices needed"

x_prev = x_coords[current_vertex - 1]
y_prev = y_coords[current_vertex - 1]
x_curr = x_coords[current_vertex]
y_curr = y_coords[current_vertex]

IF x_prev < x_curr AND y_prev < y_curr THEN
  RETURN 1
ELSE IF x_prev > x_curr AND y_prev > y_curr THEN
  RETURN 2
ELSE IF x_prev > x_curr AND y_prev < y_curr THEN
  RETURN 3
ELSE IF x_prev < x_curr AND y_prev > y_curr THEN
  RETURN 4
ELSE IF x_prev == x_curr AND y_prev < y_curr THEN
  RETURN 5
ELSE IF x_prev == x_curr AND y_prev > y_curr THEN
  RETURN 6
ELSE:
  RETURN 1  // fallback option
end if
END ALGORITHM
```

Main Algorithm: create_carbon_chain
Psevdocode

```vb
ALGORITHM create_carbon_chain(vertex_code)
INPUT:
OUTPUT: 

// Step 1. Create empty coordinate arrays and edge list
x_coords = []
y_coords = []
edges = []

P = length(vertex_code) // length of vertex_code

// Step 2. Add first vertex — initial coordinates
APPEND INIT_X TO x_coords
APPEND INIT_Y TO y_coords

// Step 3. Add second vertex: first edge always points northeast (variant 1)
APPEND (x_coords[1] + DX_CC) TO x_coords
APPEND (y_coords[1] - DY_CC) TO y_coords

// Add first edge (vertex 1 to vertex 2)
APPEND [1, 2] TO edges

current_vertex = 2

// Step 4. Build remaining vertices (from 3rd to nth)
FOR i FROM 1 TO p  DO
    next_vertex = current_vertex + 1

    // 4.1. Determine current direction variant based on last two vertices
    variant = determine_variant(x_coords, y_coords, current_vertex)

    // 4.2. Get displacements from VARIANTS dictionary for current variant
    dXR = VARIANTS[variant].dXR
    dYR = VARIANTS[variant].dYR
    dXL = VARIANTS[variant].dXL
    dYL = VARIANTS[variant].dYL

    // 4.3. Vertex code (0 or 1) determines next edge direction
  
    IF vertex_code[i] == 0 THEN
        // Turn left: use left direction
        x_next = x_coords[i] + dXL
        y_next = y_coords[i] + dYL
    ELSE  // code == 1
        // Turn right: use right direction
        x_next = x_coords[i] + dXR
        y_next = y_coords[i] + dYR
    END IF
        // 4.4. Add new vertex coordinates to arrays
    APPEND x_next TO x_coords
    APPEND y_next TO y_coords

        // 4.5. Add new edge (from previous vertex i-1 to current vertex i)
    APPEND [current_vertex, next_vertex] TO edges

    current_vertex = next_vertex
END FOR

// Step 5. Return results
RETURN x_coords, y_coords, edges
END ALGORITHM
```

Algorithm complexity

Time complexity: O(n), where n is the length of vertex_code. Each loop step (adding a vertex and determining the variant) runs in O(1).

Space complexity: O(n) for storing the coordinate arrays x_coords and y_coords.

Example
Input: vertex_code = [0, 1, 0, 1]

Construction steps:

Vertex 1: (7.1023; 3.3107) — starting point.

Vertex 2: (7.1023+DX_CC;3.3107−DY_CC) — initial NE edge.

Vertex 3: turn left (code 0) from variant 1 → use dXL, dYL of variant 1.

Vertex 4: turn right (code 1) from the new variant → use dXR, dYR of the current variant.

Vertex 5: turn left (code 0) → use dXL, dYL.

Vertex 6: turn right (code 1) → use dXR, dYR.

Result: a zigzag chain of 6 vertices, edges form $120^{\circ}$
  angles, all lengths are 1,44, coordinates lie on a hexagonal lattice.

### 8.2. Construction of a geometric molecular graph of linear polyenes with hydrogen atoms

Description
The create_hydrogen_tree function constructs a geometric molecular graph of linear polyenes with hydrogen atoms. The algorithm builds on a pre‑existing carbon chain and adds hydrogen atoms at appropriate positions relative to each carbon atom — taking into account the local geometry (zigzag pattern) of the carbon backbone.

Key insight for the first carbon atom: the first carbon–carbon bond is treated in reverse order (with variant = 2 instead of following the default path) to ensure correct placement of hydrogen atoms. If we used the direct forward pass for the first bond, the hydrogen atoms would be positioned incorrectly due to the initial orientation of the chain. By using the reverse variant, we align the hydrogen attachment directions properly with the overall chain geometry.

Algorithm: create_hydrogen_tree
Input:

vertex_code — array of integers (0 or 1) of length p, defining turn directions for the carbon chain.

Output:

cc_edges — list of C–C edges (pairs of vertex indices);

ch_edges — list of C–H edges (pairs of vertex indices);

c_x_coords, c_y_coords — arrays of x and y coordinates for carbon atoms;

h_x_coords, h_y_coords — arrays of x and y coordinates for hydrogen atoms.

Steps:

```vb
ALGORITHM create_hydrogen_tree(vertex_code)

// Step 1. Parameter calculation
p = LENGTH(vertex_code)
IF p < 1:
    THROW ERROR "Vertex code must contain at least 1 element (n ≥ 4)"
n = p + 2  // total number of carbon atoms

// Step 2. Build carbon chain
cc_edges, c_x_coords, c_y_coords = create_carbon_chain(vertex_code)

// Step 3. Initialize hydrogen data structures
ch_edges = []  // empty list of C–H edges
h_x_coords = []  // empty array for H x‑coordinates
h_y_coords = []  // empty array for H y‑coordinates

// Step 4. Add hydrogen atoms for each carbon
FOR c_idx FROM 1 TO n DO
    cx = c_x_coords[c_idx]  // x coordinate of current carbon
    cy = c_y_coords[c_idx]  // y coordinate of current carbon

    IF c_idx == 1 THEN
        // First terminal carbon — use fixed variant 2 for correct H placement
        variant = 2
        dXR = VARIANTS[variant].dXR
        dYR = VARIANTS[variant].dYR
        dXL = VARIANTS[variant].dXL
        dYL = VARIANTS[variant].dYL

        IF LENGTH(vertex_code) > 0 AND vertex_code[1] == 0   THEN
            h1_x = cx + 0.75 * dXR
            h1_y = cy + 0.75 * dYR
            h2_x = cx + 0.75 * dXL
            h2_y = cy + 0.75 * dYL
        ELSE
            h1_x = cx + 0.75 * dXL
            h1_y = cy + 0.75 * dYL
            h2_x = cx + 0.75 * dXR
            h2_y = cy + 0.75 * dYR
        END IF

        h_idx1 = LENGTH(h_x_coords) + 1
        h_idx2 = h_idx1 + 1

        APPEND h1_x, h2_x TO h_x_coords
        APPEND h1_y, h2_y TO h_y_coords
        APPEND [c_idx, h_idx1] TO ch_edges
        APPEND [c_idx, h_idx2] TO ch_edges

    ELSE IF c_idx == n  THEN
        // Last terminal carbon — determine variant from chain geometry
        variant = determine_variant(c_x_coords, c_y_coords, n)
        dXR = VARIANTS[variant].dXR
        dYR = VARIANTS[variant].dYR
        dXL = VARIANTS[variant].dXL
        dYL = VARIANTS[variant].dYL

        h1_x = cx + 0.75 * dXR
        h1_y = cy + 0.75 * dYR
        h2_x = cx + 0.75 * dXL
        h2_y = cy + 0.75 * dYL

        h_idx1 = LENGTH(h_x_coords) + 1
        h_idx2 = h_idx1 + 1

        APPEND h1_x, h2_x TO h_x_coords
        APPEND h1_y, h2_y TO h_y_coords
        APPEND [c_idx, h_idx1] TO ch_edges
        APPEND [c_idx, h_idx2] TO ch_edges

    ELSE
        // Internal carbon — one hydrogen atom
        variant = determine_variant(c_x_coords, c_y_coords, c_idx)
        dXR = VARIANTS[variant].dXR
        dYR = VARIANTS[variant].dYR
        dXL = VARIANTS[variant].dXL
        dYL = VARIANTS[variant].dYL

        IF c_idx <= LENGTH(vertex_code) + 1 AND vertex_code[c_idx - 1] == 0 THEN
            h_x = cx + 0.75 * dXR
            h_y = cy + 0.75 * dYR
        ELSE:
            h_x = cx + 0.75 * dXL
            h_y = cy + 0.75 * dYL
        END IF

        APPEND h_x TO h_x_coords
        APPEND h_y TO h_y_coords
        APPEND [c_idx, LENGTH(h_x_coords)] TO ch_edges
    END IF
END FOR

// Step 5. Return all data
RETURN cc_edges, ch_edges, c_x_coords, c_y_coords, h_x_coords, h_y_coords
END ALGORITHM
```

Complexity
Time complexity: `O(n)`, where n is the number of carbon atoms. Each operation (variant lookup, coordinate calculation, array append) runs in `O(1)`.

Space complexity: `O(n)` for storing coordinates and edge lists. The total number of hydrogen atoms is `n+2` (2 for terminal carbons, 1 for each internal), so all arrays scale linearly with `n`.

Examples
Example 1. Short chain: `vertex_code = [0]`

p=1, so n=3 carbon atoms.

Carbon chain: 3 atoms in a zigzag (one turn).

Hydrogen atoms:

- C1 (terminal): 2 H atoms placed using variant 2;

- C2 (internal): 1 H atom based on `vertex_code[1] = 0`;

- C3 (terminal): 2 H atoms using variant determined from chain geometry.

- Total: 3 C, 5 H, 2 C–C edges, 5 C–H edges.

Example 2. Longer chain: `vertex_code = [0, 1, 0]`

- p=3, so n=5 carbon atoms.

- Chain has three turns (zigzag).

- Hydrogen placement:

- C1: 2 H (variant 2);

- C2: 1 H (left turn → use right direction);

- C3: 1 H (right turn → use left direction);

- C4: 1 H (left turn → use right direction);

- C5: 2 H (terminal, variant from geometry).

- Total: 5 C, 7 H, 4 C–C edges, 7 C–H edges.

Graph Properties

- Type: caterpillar tree (linear backbone with pendant vertices).

- Backbone: carbon chain (C–C bonds) with zigzag geometry.

- Pendant atoms: hydrogen atoms attached to carbons.

Bond angles: $120^{\circ}$
  between adjacent bonds (hexagonal lattice).

Bond lengths:

C–C: 1.44 Å;

C–H: 1.08 Å

## 9. Displaying a graph image on the screen

All functions for displaying molecular graph images on the screen use the Plots function
from the Plots package. The official documentation for the Plots.jl package is available at
[docs.juliaplots.org](https://docs.juliaplots.org/stable/).

## 9.1. Displaying a molecular graph without hydrogen atoms on the screen

The `show_graph_cc` function displays an image of a molecular graph without hydrogen atoms.
It uses the Plots function of the Plots package.
Input: xg, yg - lists of x, y coordinates of the C-vertices of the molecular graph without
hydrogen atoms, which is a path graph.

```julia
function  show_graph_cc(xg,yg)  
    # Drawing a line
    pts=plot(xg, yg,ls = :solid,lw = 4,lc = :green, showaxis = false, 
    legend = false, aspect_ratio = :equal)
    scatter!(pts,xg, yg, mc = :black, ms = 7, ma = 0.9) #   Drawing C-vertices
    display(pts)    #  Displaying the image
end
```

### 9.2. Displaying a molecular graph with hydrogen atoms on the screen

The `show_graph_hyd` function displays an image of a molecular graph with hydrogen atoms.
It uses the Plots function of the Plots package.
Input:

- `edgHydro` - list of CH-edges;
- `xg, yg` - x, y coordinates of the vertices of the central chain;
- `xh, yh` - x, y coordinates of the pendant vertices (H-vertices modeling hydrogen atoms).

```julia
function show_graph_hyd(edgHydro,xg,yg, xh,yh)
    pts = plot(xg, yg,ls =:solid, lw = 6, lc =:black)
    plot!(pts, showaxis = false, legend = false, aspect_ratio = :equal)  #  Drawing the central path
    lnhdr = length(edgHydro)
    for j in 1:lnhdr    
        eh = edgHydro[j]  # Edge CH
        v1=eh[1]        #  C-vertex of the j-th edge C-H
        v2=eh[2]         #  H-vertex of the j-th edge C-H
        x1=xg[v1]      #   x-coordinate of the C-vertex
        x2=xh[v2]      #   x-coordinate of the H-vertex
        y1=yg[v1]      #   Y-coordinate of the C-vertex
        y2=yh[v2]      #   Y-coordinate of the H-vertex
        LHX=[x1,x2]     #   List of x-coordinates
        LHY=[y1,y2]     #   List of y-coordinates
        plot!(pts,LHX, LHY, ls =:solid, lw = 6,lc =:blue)  #   Drawing a C-H edge
    end
    scatter!(xh,yh, mc = :blue, ms = 6, ma = 0.65)     #   Drawing H-vertices
    scatter!(xg, yg, mc = :black, ms = 8, ma = 0.9)    #   Drawing C-vertices
    display(pts)                                       #  Displaying the image
end
```

### 9.3. Displaying a list of graphs without  hydrogen atoms

Pseudocode for Function `output_list_graphs_cc`
Input:

list_vertex_code — a list (vector of vectors) of vertex codes, where each element is an array of integers (0 or 1) of length p, defining the turn direction for a separate carbon chain.

Output:

Visualization of a series of carbon chain graphs (without hydrogen atoms) — each graph is displayed sequentially.

```vb
ALGORITHM output_list_graphs_cc(list_vertex_code)

// Step 1. Determine the number of graphs to build
nmb = LENGTH(list_vertex_code)  // number of codes in the list

// Step 2. Loop through all codes in the list
FOR k FROM 1 TO nmb:

  // Step 2.1. Extract the current vertex code
  vertex_code = list_vertex_code[k]

  // Step 2.2. Build a carbon chain for the current code
  // Call the create_carbon_chain function:
  //   - input parameter: vertex_code
  //   - output parameters: _ (ignored), xg, yg
  _, xg, yg = create_carbon_chain(vertex_code)

  // Step 2.3. Visualize the carbon chain graph
  // The show_graph_cc function takes carbon atom coordinates
  // and displays the graph on screen
  show_graph_cc(xg, yg)

END FOR
END ALGORITHM
```

Detailed Step‑by‑Step Description
Determine the number of graphs (nmb):

calculate the length of the input list list_vertex_code;

the variable nmb stores the number of graphs to be built and visualized.

Loop through list elements (FOR k FROM 1 TO nmb):

iterate over all vertex codes in the input list;

for each code, build and visualize the corresponding graph.

Extract the vertex code (vertex_code = list_vertex_code[k]):

on each loop iteration, select one vertex code from the list;

this code is used as an input parameter to build the carbon chain.

Build the carbon chain (_, xg, yg = create_carbon_chain(vertex_code)):

call the create_carbon_chain function, which:

takes the vertex code vertex_code;

returns three values:

the first value is ignored (denoted by _);

xg — array of x coordinates of carbon atoms;

yg — array of y coordinates of carbon atoms.

Visualize the graph (show_graph_cc(xg, yg)):

call the show_graph_cc function, which:

accepts arrays of carbon atom coordinates (xg and yg);

displays the carbon chain graph on screen (e.g., using a visualization library like Plots.jl);

output occurs immediately — the user sees the image before moving to the next iteration.

Algorithm Characteristics
Time complexity: `O(m⋅Tcc)`, where:

m — number of codes in list_vertex_code (m=nmb);

`Tcc` — execution time of the `create_carbon_chain` function for a single code (depends on code length).

Space complexity: `O(L)`, where `L` — maximum length of coordinate arrays (x and y) for one carbon chain; memory is freed after each iteration (if no data accumulation occurs).

Behavior: sequential processing — each graph is built and shown one after another; no accumulation or comparison of results between iterations.

Example of Operation
Input:

list_vertex_code = [
  [0],           // code 1: one left turn
  [1, 0],       // code 2: right turn, then left
  [0, 0, 1]   // code 3: two left turns, then right
]
Process:

1.Iteration 1 (k=1):

- `vertex_code = [0]`;

- build a chain of 3 carbon atoms with one turn;

- display the graph using show_graph_cc.

2.Iteration 2 (k=2):

- `vertex_code = [1, 0]`;

- build a chain of 4 carbon atoms with two turns;

- display the graph.

3.Iteration 3 (k=3):

- `vertex_code = [0, 0, 1]`;

- build a chain of 5 carbon atoms with three turns;

- display the graph.

Result: 3 images of carbon chains with different shapes are displayed sequentially on screen.

Notes

- The function does not return any values — its purpose is visualization.

- It is assumed that the functions create_carbon_chain and show_graph_cc are already defined and work correctly.

- The visualization order matches the order of codes in the input list.

Pseudocode for Function output_list_graphs_hyd
Input:

`list_vertex_code` — a list (vector of vectors) of vertex codes, where each element is an array of integers (0 or 1) of length p, defining the turn direction for a separate carbon chain with hydrogen atoms.

Output:

Visualization of a series of molecular graphs of linear polyenes with hydrogen atoms — each graph is displayed sequentially.

### 9.4. Displaying a list of graphs with hydrogen atoms

Algorithm: `output_list_graphs_hyd`

```vb
ALGORITHM output_list_graphs_hyd(list_vertex_code)

// Step 1. Determine the number of graphs to build
nmb = LENGTH(list_vertex_code)  // number of codes in the list

// Step 2. Loop through all codes in the list
FOR k FROM 1 TO nmb:

  // Step 2.1. Extract the current vertex code
  vertex_code = list_vertex_code[k]

  // Step 2.2. Build a complete molecular graph (carbon chain + hydrogens)
  // Call the create_hydrogen_tree function:
  //   - input parameter: vertex_code
  //   - output parameters: _ (ignored), edgHydro, xg, yg, xh, yh
  _, edgHydro, xg, yg, xh, yh = create_hydrogen_tree(vertex_code)

  // Step 2.3. Visualize the full molecular graph with hydrogens
  // The show_graph_hyd function takes:
  //   - edgHydro: list of C–H edges
  //   - xg, yg: coordinates of carbon atoms
  //   - xh, yh: coordinates of hydrogen atoms
  show_graph_hyd(edgHydro, xg, yg, xh, yh)

END FOR
END ALGORITHM
```

Detailed Step‑by‑Step Description

1. Determine the number of graphs (nmb):

- calculate the length of the input list list_vertex_code;

- the variable nmb stores the number of molecular graphs to be built and visualized.

2.Loop through list elements (FOR k FROM 1 TO nmb):

- iterate over all vertex codes in the input list;

- for each code, build and visualize the corresponding full molecular graph.

3.Extract the vertex code (vertex_code = list_vertex_code[k]):

- on each loop iteration, select one vertex code from the list;

- this code is used as an input parameter to build the complete molecular structure.

4.Build the full molecular graph (_, edgHydro, xg, yg, xh, yh = create_hydrogen_tree(vertex_code)):

- call the create_hydrogen_tree function, which:

- takes the vertex code vertex_code;

- returns six values:

-the first value (C–C edges) is ignored (_);

- edgHydro — list of C–H edges (pairs of vertex indices);

- xg, yg — arrays of x and y coordinates of carbon atoms;

- xh, yh — arrays of x and y coordinates of hydrogen atoms.

- Visualize the full graph (show_graph_hyd(edgHydro, xg, yg, xh, yh)):

- call the show_graph_hyd function, which:

accepts the list of C–H bonds and coordinates of all atoms;

displays the complete molecular graph on screen (including both carbon and hydrogen atoms, and all bonds);

output occurs immediately — the user sees the molecule before moving to the next iteration.

Algorithm Characteristics
Time complexity: $O(m⋅T_{hyd})$, where:

m — number of codes in list_vertex_code (m=nmb);

$T_{hyd}$  — execution time of the create_hydrogen_tree function for a single code (depends on code length and number of atoms).

Space complexity: $O(L_C +L_H)$, where: $L_C$ — maximum length of coordinate arrays for carbon atoms in one graph;

$L_H$  — maximum length of coordinate arrays for hydrogen atoms in one graph.

memory is freed after each iteration (if no data accumulation occurs).

Behavior: sequential processing — each full molecular graph is built and shown one after another; no accumulation or comparison of results between iterations.

Example of Operation
Input:

list_vertex_code = [
  [0],           // code 1: one left turn
  [1, 0],       // code 2: right turn, then left
  [0, 0, 1]   // code 3: two left turns, then right
]
Process:

Iteration 1 (k=1):

`vertex_code = [0]`;

build a molecule with 3 carbon atoms and 5 hydrogen atoms;

generate coordinates for all atoms and C–H bond list;

display the full structure using show_graph_hyd.

Iteration 2 (k=2):

- `vertex_code = [1, 0]`;

- build a molecule with 4 carbon atoms and 6 hydrogen atoms;

- generate all necessary data;

- display the graph.

Iteration 3 (k=3):

- `vertex_code = [0, 0, 1]`;

- build a molecule with 5 carbon atoms and 7 hydrogen atoms;

- generate all coordinates and edges;

- display the complete molecular graph.

Result: 3 images of polyene molecules with hydrogen atoms are displayed sequentially
on screen, showing the correct 3D‑like geometry (zigzag carbon chain with attached hydrogens).

Notes

- The function does not return any values — its sole purpose is visualization of molecular structures.

- It is assumed that the functions create_hydrogen_tree and show_graph_hyd are already defined and work correctly.

- The visualization order matches the order of codes in the input list.

Each displayed graph includes:

- carbon atoms (typically shown as larger dark circles);

- hydrogen atoms (typically smaller light circles);

- C–C bonds (lines between carbons);

- C–H bonds (lines from carbons to hydrogens).

## 10. Study of the spatial structure of molecular graphs of linear polyenes

### 10.1. Function for calculating the number of vertex overlaps

Pseudocode for `count_intersect`

```vb
FUNCTION count_intersect(XG, YG)
    INPUT:
        XG — array of x‑coordinates of molecular graph vertices (Float64[])
        YG — array of y‑coordinates of molecular graph vertices (Float64[])
    OUTPUT:
        kin — number of vertex overlaps (Int64)

    SET kin = 0
    SET q = length of XG

    FOR i FROM 1 TO q DO
        SET fr = i + 1
        SET x1 = absolute value of XG[i]
        SET y1 = absolute value of YG[i]

        FOR j FROM fr TO q DO
            SET x2 = XG[j]
            SET y2 = YG[j]

            SET dlx = absolute difference between x1 and x2
            SET dly = absolute difference between y1 and y2

            IF (dlx ≤ 0.000001) AND (dly ≤ 0.000001) THEN
                INCREMENT kin BY 1
            END IF
        END FOR
    END FOR

    RETURN kin
END FUNCTION
```

Description
The `count_intersect` function calculates the number of vertex overlaps (pairwise coinciding vertices) in a molecular graph. Two vertices are considered overlapping if their Euclidean coordinates are nearly identical — the absolute differences in both x‑ and y‑coordinates do not exceed a small threshold (0,000001).

Key steps:

Iterate through all pairs of vertices (i,j) where i<j.

For each pair, compute the absolute differences in x‑ and y‑coordinates.

If both differences are below the threshold, count the pair as an overlap.

Return the total number of such overlapping pairs.

This count corresponds to the number of pairwise overlaps, which is used to characterize the spatial structure of molecular graphs of linear polyenes.

Algorithm
Initialize a counter kin to zero.

Determine the total number of vertices q from the length of the coordinate arrays.

For each vertex i (from 1 to q):

Set the reference point $(x_1,y_1)$ as the absolute values of the coordinates of vertex i.

Compare vertex i with all subsequent vertices j (from i+1 to q).

For each j, compute the coordinate differences $dlx=∣x_1 − x_2∣$ and $dly=∣y_1 −y_2∣$.

If both dlx and dly are ≤0,000001, increment the counter `kin`.

After all pairs are checked, return kin.

Complexity Analysis
Time complexity: $O(n^2)$, where n is the number of vertices (i.e., the length of XG/YG). The function uses nested loops: the outer loop runs n times, and the inner loop runs approximately n/2  times on average,
resulting in ∼ $n^2/2$ comparisons.

Space complexity: `O(1)` — only a constant amount of extra space is used (for variables kin, q, fr, x1, y1, x2, y2, dlx, dly).

Examples
Example 1: No overlaps

Input:

`XG = [0.0, 1.0, 2.0]`

`YG = [0.0, 0.5, 1.0]`

Process: All coordinate pairs differ by more than 0,000001.

Output: 0

Example 2: One overlap

Input:

`XG = [0.0, 1.0, 1.0]`

`YG = [0.0, 0.5, 0.5]`

Process:

Pair (2,3): ∣1.0−1.0∣ = 0 ≤ 0,000001, ∣0.5−0.5∣ = 0 ≤ 0,000001 → counted as overlap.

Output: 1

Example 3: Multiple overlaps

Input:

`XG = [0.0, 1.0, 1.0, 1.0]`

`YG = [0.0, 0.5, 0.5, 0.5]`

Process:

Pairs (2,3), (2,4), (3,4) all satisfy the condition.

Output: 3

### 10.2. Function for displaying images of all graphs with overlapping vertices

Pseudocode for `show_all_graphs_overlap`

```vb
FUNCTION show_all_graphs_overlap(list_vertex_code, nglob)
    INPUT:
        list_vertex_code — list of vertex codes (each code is a vector of 0s and 1s, Vector{Vector{Int64}})
        nglob — global counter of processed graphs (Int64)
    OUTPUT:
        nbd — number of graphs with vertex overlaps (Int64)

    SET res = 0
    SET nbd = 0
    SET lngh = length of list_vertex_code

    FOR k FROM 1 TO lngh DO
        SET res = 0
        SET vertex_code = list_vertex_code[k]

        // Generate coordinates for the molecular graph
        IGNORE, XG, YG = create_carbon_chain(vertex_code)

        // Count vertex overlaps in the generated graph
        SET res = count_intersect(XG, YG)

        IF res ≠ 0 THEN
            INCREMENT nbd BY 1
            INCREMENT nglob BY 1

            PRINT "Nglob ", nglob, "  k  ", k,
                  " number of vertex overlaps ", res,
                  " vertex_code ", vertex_code

            // Display the graph visually
            CALL show_graph_cc(XG, YG)
        END IF
    END FOR

    PRINT "number of graphs with the vertex overlaps ", nbd

    RETURN nbd
END FUNCTION
```

Description
The `show_all_graphs_overlap` function processes a list of molecular graph codes, generates the corresponding spatial representations, identifies graphs with vertex overlaps, and displays them visually.

Key steps:

Iterate through each vertex code in the input list.

For each code:

Generate the molecular graph (coordinates of vertices) using create_carbon_chain.

Count vertex overlaps using the count_intersect function.

If overlaps are detected:

Increment counters for graphs with overlaps (nbd) and global processed graphs (nglob).

Print detailed information about the graph (global ID, index in list, number of overlaps, vertex code).

Display the graph using show_graph_cc.

After processing all graphs, print the total number of graphs with overlaps.

Return the count of graphs with overlaps (nbd).

Algorithm
Initialize counters: res (overlaps per graph) and nbd (graphs with overlaps) to 0.

Determine the total number of vertex codes: `lngh = length(list_vertex_code)`.

For each vertex code k (from 1 to lngh):

Extract the code: `vertex_code = list_vertex_code[k]`.

`Call create_carbon_chain(vertex_code)` to get coordinates XG, YG.

Use count_intersect(XG, YG) to compute res — the number of overlaps.

If res ≠ 0:

Increment nbd and nglob.

Print metadata: global ID (nglob), index (k), number of overlaps (res), and the vertex code.

`Call show_graph_cc(XG, YG)` to display the graph.

Print the total count of graphs with overlaps: nbd.

Return nbd.

Complexity Analysis
Time complexity: $O(m⋅(T_{chain} +T_{intersect}))$, where:

m — number of vertex codes in list_vertex_code;

$T_{chain}$ — time complexity of create_carbon_chain (depends on graph size);

$T_{intersect}$ — time complexity of count_intersect, which is $O(n^2)$ for a graph with n vertices.
The dominant factor is usually $O(m⋅n^2)$, assuming $T_{chain}$ is linear or near‑linear in `n`.

Space complexity: `O(n)` per iteration, where n is the number of vertices in a graph. This is needed to store coordinates `XG` and `YG`. No significant additional data structures are used across iterations.

Examples
Example 1: No graphs with overlaps

Input:

`list_vertex_code = [[0, 1, 0], [1, 1, 0]]`

`nglob = 5`

Process:

For both codes, count_intersect returns 0.

No graphs are displayed.

Output:

Printed message: "number of graphs with the vertex overlaps 0"

Return value: 0

Example 2: One graph with overlaps

Input:

`list_vertex_code = [[0, 0, 0], [1, 0, 1]]`

`nglob = 10`

Process:

Code [0, 0, 0]: count_intersect returns 2 → displayed, `nbd = 1, nglob = 11`.

Code [1, 0, 1]: count_intersect returns 0 → skipped.

Output:

Printed lines:

"Nglob 11 k 1 number of vertex overlaps 2 vertex_code [0, 0, 0]"

"number of graphs with the vertex overlaps 1"

Return value: 1

Example 3: All graphs have overlaps

Input:

`list_vertex_code = [[1, 1], [0, 0]]`

`nglob = 0`

Process:

Both codes yield res > 0.

Each graph is displayed with incremented nglob (1 and 2).

Output:

Two printed lines with graph details.

Final message: "number of graphs with the vertex overlaps 2"

Return value: 2

### 10.3. Function for filters and displays molecular graphs that have at least a specified number of vertex overlap pairs

Pseudocode for `show_select_graphs_overlap`

```vb
FUNCTION show_select_graphs_overlap(list_vertex_code, npf, nglob, dirpath, fname)
    INPUT:
        list_vertex_code — list of vertex codes (Vector{Vector{Int64})
        npf — minimum number of overlap pairs required (threshold, Int64)
        nglob — global counter of previously displayed graphs (Int64)
        dirpath — path to output directory (String)
        fname — base file name without extension (String)
    OUTPUT:
        None (prints information and saves files)

    SET filename = fname + ".txt"
    SET fpath = joinpath(dirpath, filename)
    OPEN file f at fpath for writing

    SET res = 0
    SET nbd = 0
    SET lngh = length of list_vertex_code

    FOR k FROM 1 TO lngh DO
        SET res = 0
        SET vertex_code = list_vertex_code[k]

        // Generate coordinates for the molecular graph
        IGNORE, XG, YG = create_carbon_chain(vertex_code)

        // Count vertex overlaps in the generated graph
        SET res = count_intersect(XG, YG)

        IF res ≥ npf THEN
            INCREMENT nbd BY 1
            INCREMENT nglob BY 1

            // Print to terminal
            PRINT "Nglob ", nglob, " nbd ", nbd, " k ", k,
                  " num_over ", res, " vertex_code ", vertex_code

            // Write to output file
            WRITE to f: "Nglob = $nglob, nbd = $nbd, k = $k, numb overlaps $res, vertex_code $vertex_code"

            // Prepare and save graph image
            SET figname = "plot_$nbd.png"
            SET fgrpath = joinpath(dirpath, figname)
            CALL show_graph_cc(XG, YG)  // Display graph
            CALL savefig(fgrpath)         // Save graph as PNG
        END IF
    END FOR

    // Final summary
    PRINT "number of graphs with the vertex overlaps ", nbd
    WRITE to f: "number of graphs with the vertex overlaps - $nbd"
    CLOSE file f
    PRINT "Done, file created"
END FUNCTION
```

Description
The `show_select_graphs_overlap` function filters and displays molecular graphs that have at least a specified number of vertex overlap pairs (npf). It generates visual representations of qualifying graphs, saves them as image files, and logs detailed information in a text file.

Key steps:

Set up an output file (*.txt) in the specified directory.

Iterate through each vertex code in the input list.

For each code:

Generate the molecular graph (coordinates of vertices) using create_carbon_chain.

Count vertex overlaps using the count_intersect function.

If the number of overlaps `is ≥ npf`:

Increment counters for qualifying graphs (nbd) and global processed graphs (nglob).

Print metadata to the terminal (global ID, sequence number, index, overlaps, vertex code).

Write the same data to the output text file.

Display the graph using show_graph_cc.

Save the graph as a PNG image with a unique name.

After processing all graphs:

Print the total number of qualifying graphs.

Write this count to the text file.

Close the file and print a completion message.

Algorithm
Construct the output file path: `fpath = joinpath(dirpath, fname + ".txt")`.

Open the file for writing.

Initialize counters: res (overlaps per graph), nbd (qualifying graphs) to 0.

Determine the total number of vertex codes: `lngh = length(list_vertex_code)`.

For each vertex code k (from 1 to lngh):

Extract the code: `vertex_code = list_vertex_code[k]`.

Call create_carbon_chain(vertex_code) to get coordinates XG, YG.

Use `count_intersect(XG, YG)` to compute res.

If res ≥ npf:

Increment nbd and nglob.

Print and write metadata.

Generate and save the graph image.

Print and write the final count of qualifying graphs (nbd).

Close the output file.

Print "Done, file created".

Complexity Analysis
Time complexity: $O(m⋅(T_{chain} + T_{intersect} + T_{savefig}))$, where:

m — number of vertex codes in list_vertex_code;

$T_{chain}$ — time to generate graph coordinates (create_carbon_chain);

$T_{intersect}$ — time to count overlaps $(O(n^2)$ for n vertices);

$T_{savefig}$ — time to render and save a graph image (depends on graph size and rendering engine).
The dominant factor is typically $O(m⋅n^2)$, assuming $T_{chain}$ and $T_{savefig}$ are linear or near‑linear in n.

Space complexity: `O(n)` per iteration, where n is the number of vertices in a graph. This is needed to store coordinates `XG` and `YG`. The output files grow linearly with the number of qualifying graphs `(O(nbd))`, but this is external storage.

Examples
Example 1: No graphs meet the threshold

Input:

`list_vertex_code = [[0, 1], [1, 0]]`

`npf = 3`

`nglob = 10`

`dirpath = "/results"`

`fname = "output"`

Process:

For both codes, count_intersect returns 0 or 1 (< 3).

No graphs are displayed or saved.

Output:

Printed message: "number of graphs with the vertex overlaps 0"

"Done, file created"

Text file contains: "number of graphs with the vertex overlaps - 0"

Example 2: One graph meets the threshold

Input:

`list_vertex_code = [[0, 0, 0], [1, 1, 1]]`

`npf = 2`

`nglob = 5`

`dirpath = "/data"`

`fname = "report"`

Process:

Code [0, 0, 0]: count_intersect returns 3 → displayed, saved as plot_1.png, `nbd = 1, nglob = 6`.

Code [1, 1, 1]: count_intersect returns 1 → skipped.

Output:

Terminal prints:

"Nglob 6 nbd 1 k 1 num_over 3 vertex_code [0, 0, 0]"

"number of graphs with the vertex overlaps 1"

"Done, file created"

Text file includes:

Line: "Nglob = 6, nbd = 1, k = 1, numb overlaps 3, vertex_code [0, 0, 0]"

Final line: "number of graphs with the vertex overlaps - 1"

Image file: /data/plot_1.png

Example 3: All graphs meet the threshold

Input:

`list_vertex_code = [[1, 1], [0, 0]]`

`npf = 1`

`nglob = 0`

`dirpath = "./images"`

`fname = "summary"`

Process:

Both codes yield res ≥ 1.

Each graph is displayed, saved (plot_1.png, plot_2.png), and logged.

Output:

Two printed lines with graph details.

Final messages: "number of graphs with the vertex overlaps 2", "Done, file created"

Text file lists both graphs and ends with `"number of graphs with the vertex overlaps -

### 10.4. Function for computing the distribution of molecular graphs by the number of vertex overlap pairs

Pseudocode for `calc_distr_all_graphs_overlap`

```vb
FUNCTION calc_distr_all_graphs_overlap(list_vertex_code)
    INPUT:
        list_vertex_code — list of vertex codes (Vector{Vector{Int64}})
    OUTPUT:
        dist_num_overlap — distribution vector: count of graphs per number of vertex overlap pairs (Vector{Int64})
        // dist_num_overlap[i] = number of graphs with (i−1) overlap pairs

    SET level = 2
    SET n = length of first vertex code + 2  // graph order
    SET lng_dno = max_overlap_pairs(n, level) + 2
    INITIALIZE dist_num_overlap as vector of zeros with length lng_dno

    SET lngh = length of list_vertex_code

    FOR k FROM 1 TO lngh DO
        SET res = 0
        SET vertex_code = list_vertex_code[k]

        // Generate coordinates for the molecular graph
        IGNORE, XG, YG = create_carbon_chain(vertex_code)

        // Count vertex overlaps in the generated graph
        SET res = count_intersect(XG, YG)

        IF res ≥ 0 THEN
            // Increment count for res overlap pairs
            // res=0 → index 1, res=1 → index 2, etc.
            INCREMENT dist_num_overlap[res + 1] BY 1
        END IF
    END FOR

    RETURN dist_num_overlap
END FUNCTION
```

Description of `calc_distr_all_graphs_overlap`
The `calc_distr_all_graphs_overlap` function computes the distribution of molecular graphs by the number of vertex overlap pairs. It counts how many graphs have exactly 0, 1, 2, … overlap pairs and returns this as a vector.
Key steps:
    1. Determine the graph order n from the length of the first vertex code.
    2. Calculate the maximum possible number of overlap pairs using max_overlap_pairs, then set the distribution vector length as `max + 2`.
    3. Initialize a zero vector `dist_num_overlap` of that length.
    4. For each vertex code:
        ◦ Generate the molecular graph (coordinates of vertices) using create_carbon_chain.
        ◦ Count vertex overlaps using count_intersect.
        ◦ Increment the corresponding bin in dist_num_overlap: graphs with k overlaps increment the (k+1)‑th element.
    5. Return the full distribution vector.

### 10.5. Function for determining the maximum number of pairwise overlapping vertices

Pseudocode for `max_overlap_pairs`

```vb
FUNCTION max_overlap_pairs(n, level)
    INPUT:
        n — graph order (number of vertices, Int64)
        level — graph complexity level (Int64)
    OUTPUT:
        ndst — maximum possible number of vertex overlap pairs (Int64)

    IF level == 1 THEN
        SET del = 12
    ELSE IF level == 2 THEN
        SET del = 10
    ELSE
        SET del = 6
    END IF

    SET p = integer division of n by del  // p = n ÷ del
    SET q = remainder of n divided by del // q = n mod del

    // Compute maximum overlap pairs based on partitioning
    SET ndst = (del − q) × npov(p) + q × npov(p + 1) + 1

    RETURN ndst
END FUNCTION
```

Enhanced description of `max_overlap_pairs`

Mathematical and structural rationale
The `max_overlap_pairs` function computes the theoretical maximum number of vertex overlap pairs for a molecular graph of order n at a given complexity level. The calculation is based on the geometric properties of spiral‑like structures that maximize vertex overlaps when laid out on a hexagonal lattice.

Structural interpretation by complexity level
Research has shown that graphs with the maximum number of overlapping vertex pairs form spiral‑like structures (arranged on the vertices and edges of the lattice). On screen, they appear as closed cycles.

The cycle geometry depends on the complexity level:

- Level 1 (graphs without three consecutive edges in cis configuration): the cycle resembles a “maple leaf”
  with 12 vertices. This structure allows moderate overlap due to its larger cycle size.

- Level 2 (graphs with exactly three consecutive edges in cis configuration): the cycle is shaped like a “propeller” with 10 vertices. The smaller cycle enables tighter winding and more overlaps than Level 1.

- Level 3 (graphs with four or more consecutive edges in cis configuration): the cycle forms a “hexagon” with 6 vertices.

- The smallest cycle diameter results in the highest number of winding turns and thus the largest possible
overlap count.

Key observation:
the fewer vertices in the cycle (i.e., the smaller the cycle diameter), the more winding turns are “wrapped” around the cycle, and consequently, the higher the maximum number of overlap pairs.

Formula derivation

The formula in max_overlap_pairs models this winding behavior mathematically:
ndst=(del−q)⋅npov(p)+q⋅npov(p+1)+1,

where:

    - del — cycle size (12 for Level 1, 10 for Level 2, 6 for Level 3);
    - p=div(n,del) — integer division of n by del, representing the base number of vertices per winding turn;
    - q=rem(n,del) — remainder of n divided by del, indicating how many turns have one extra vertex;
    - npov(x)=2x(x−1)​ — number of pairwise overlaps in a group of x vertices (complete graph edges);
    - the term +1 accounts for an additional overlap contribution from the closed cycle structure.

Step‑by‑step algorithm

    1. Select cycle size del based on level:
     
        - Level 1 → del=12;
        - Level 2 → del=10;
        - Levels 3+ → del=6.
         
    2. Partition the graph order n into del parts:
     
        - del−q parts have p vertices;
        - q parts have p+1 vertices.
         
    3. Compute overlap contributions:
     
        - (del−q)⋅npov(p) — overlaps from smaller turns;
        - q⋅npov(p+1) — overlaps from larger turns.
         
    4. Add +1 for the cycle closure effect.
     
    5. Return ndst as the theoretical maximum.

Key notes

The function assumes `npov(x)` is defined as `x(x−1)/2`, the number of edges in a complete graph of x vertices.

The +1 term reflects empirical observations of closed‑cycle overlaps in spiral structures.

Smaller del (Level 3) yields higher ndst, aligning with the principle: fewer cycle vertices → more winding turns → more overlaps.

Algorithm for calc_distr_all_graphs_overlap

    1. Set default level = 2.
     
    2. Compute graph order: n=length(list_vertex_code[1])+2.
     
    3. Call max_overlap_pairs(n, 2) to get max possible overlaps.
     
    4. Set distribution vector length: lng_dno = max + 2.
     
    5. Initialize dist_num_overlap as a zero vector of length lng_dno.
     
    6. For each code k:
     
        - Extract vertex_code.
         
        - Generate coordinates XG, YG via create_carbon_chain.
         
        - Compute res = count_intersect(XG, YG).
         
        - If res ≥ 0, increment dist_num_overlap[res + 1].
         
    7. Return dist_num_overlap.
     
Complexity Analysis

For  `calc_distr_all_graphs_overlap`:

    - Time complexity: O(m⋅(Tchain​+Tintersect​)), where:
     
        - `m` — number of vertex codes;
        - $T_{chain}$​ — time to generate coordinates (assumed `O(n)`);
        - $T_{intersect}$​ — time to count overlaps (`O(n2)`).
         
Total: O(m⋅n2)

    - Space complexity: O(L+n), where:
     
        - L — length of distribution vector (L≈max_overlap_pairs(n,level)+2);
        - n — space for storing coordinates XG, YG.
         
For max_overlap_pairs:

    - Time complexity: `O(1)` — constant time, only arithmetic operations.
    - Space complexity: `O(1)`.

Examples

Example 1: Simple case, no overlaps

    - Input:
        - list_vertex_code = [[0, 1], [1, 0]]

    - Process:
        - n=2+2=4
        - max_overlap_pairs(4, 2) = ? → assume returns 5 → lng_dno = 7
        - Initialize dist_num_overlap = [0, 0, 0, 0, 0, 0, 0]
        - For both codes: res = 0 → increment dist_num_overlap[1]
         
    - Output:
    - 
        - dist_num_overlap = [2, 0, 0, 0, 0, 0, 0]
        - Interpretation: 2 graphs with 0 overlap pairs, 0 graphs with 1, 2, … pairs.
         
Example 2: Mixed overlaps

    - Input:
        - list_vertex_code = [[0,0,0], [1,1,1], [0,1,0]]

    - Assume:
     
        - Code 1 → res = 3
        - Code 2 → res = 1
        - Code 3 → res = 0
         
    - `n = 3+2 = 5`, max_overlap_pairs(5,2) ≈ 6 → lng_dno = 8
     
    - Output:
     
        - dist_num_overlap = [1, 1, 0, 1, 0, 0, 0, 0]
        - 1 graph with 0 overlaps, 1 with 1 overlap, 1 with 3 overlaps.
         
Example 3: Edge case — large overlaps possible

    - Input:
     
        - Single code [[0,0,0,0]] → n=4+2=6
    - Assume max_overlap_pairs(6,2) = 10 → lng_dno = 12
     
    - If res = 5:
     
        - Output: dist_num_overlap[6] += 1
    - Final vector: `[0, 0, 0, 0, 0, 1, 0, 0,

### 10.6.  Function `output_distr_all_graphs_overlap`

Pseudocode for `output_distr_all_graphs_overlap`

```vb
FUNCTION output_distr_all_graphs_overlap(dist_num_overlap)
    INPUT:
        dist_num_overlap — distribution vector: count of graphs per number of vertex overlap pairs (Vector{Int64})
        // dist_num_overlap[i] = number of graphs with exactly (i−1) overlap pairs
    OUTPUT:
        None (prints summary statistics and distribution)

    // Number of graphs with zero overlap pairs (index 1 → 0 overlaps)
    SET num_non_over = dist_num_overlap[1]

    // Total number of graphs
    SET sum_prov = sum of all elements in dist_num_overlap

    // Number of graphs with at least one overlap pair
    SET num_with_over = sum_prov − num_non_over

    // Percentage of graphs with zero overlaps
    SET dnov = (num_non_over / sum_prov) × 100.0

    // Percentage of graphs with one or more overlap pairs
    SET dwt = (num_with_over / sum_prov) × 100.0

    // Print summary statistics
    PRINT "Total: ", sum_prov, ", No overlaps: ", num_non_over, ", With overlaps: ", num_with_over
    PRINT "Zero-overlap %: ", dnov, ", Overlap %: ", dwt

    // Print full distribution
    PRINT "Distribution by overlap pairs: \n", dist_num_overlap
END FUNCTION
```

Description
The `output_distr_all_graphs_overlap` function processes a distribution vector of molecular graphs by vertex overlap pair count and computes key statistical parameters. It then prints a comprehensive summary, including percentages and the raw distribution.

Key parameters computed:

sum_prov — total number of graphs (sum of all distribution bins);

num_non_over — number of graphs with zero vertex overlaps (value at index 1 of the distribution vector);

num_with_over — number of graphs with at least one vertex overlap pair (total minus zero‑overlap graphs);

dnov — percentage of graphs with zero overlaps (num_non_over / sum_prov × 100);

dwt — percentage of graphs with one or more overlap pairs (num_with_over / sum_prov × 100).

Algorithm
Extract the number of zero‑overlap graphs: num_non_over = dist_num_overlap[1].

Compute the total number of graphs: sum_prov = sum(dist_num_overlap).

Calculate the number of graphs with overlaps: num_with_over = sum_prov − num_non_over.

Convert counts to percentages:

dnov = (num_non_over / sum_prov) × 100.0;

dwt = (num_with_over / sum_prov) × 100.0.

Print a formatted summary of the key parameters.

Print the full distribution vector for detailed analysis.

Complexity Analysis
Time complexity: O(k), where k is the length of the dist_num_overlap vector. The dominant operation is summing all elements of the vector (step 2), which requires one pass through k elements. All other operations are constant time.

Space complexity: O(1) — only a constant amount of extra space is used for the five output variables (num_non_over, sum_prov, num_with_over, dnov, dwt). The input vector is not modified.

Examples
Example 1: All graphs have zero overlaps

Input: dist_num_overlap = [5, 0, 0, 0]

Process:

num_non_over = 5

sum_prov = 5

num_with_over = 0

dnov = (5 / 5) × 100 = 100.0

dwt = (0 / 5) × 100 = 0.0

Output:

Total: 5, No overlaps: 5, With overlaps: 0
Zero-overlap %: 100.0, Overlap %: 0.0
Distribution by overlap pairs:
[5, 0, 0, 0]
Example 2: Mixed distribution

Input: dist_num_overlap = [2, 3, 1, 4]

Interpretation:

2 graphs with 0 overlaps;

3 graphs with 1 overlap;

1 graph with 2 overlaps;

4 graphs with 3 overlaps.

Process:

num_non_over = 2

sum_prov = 2 + 3 + 1 + 4 = 10

num_with_over = 10 − 2 = 8

dnov = (2 / 10) × 100 = 20.0

dwt = (8 / 10) × 100 = 80.0

Output:

Total: 10, No overlaps: 2, With overlaps: 8
Zero-overlap %: 20.0, Overlap %: 80.0
Distribution by overlap pairs:
[2, 3, 1, 4]
Example 3: No zero‑overlap graphs

Input: dist_num_overlap = [0, 7, 3]

Process:

num_non_over = 0

sum_prov = 0 + 7 + 3 = 10

num_with_over = 10 − 0 = 10

dnov = (0 / 10) × 100 = 0.0

dwt = (10 / 10) × 100 = 100.0

Output:

Total: 10, No overlaps: 0, With overlaps: 10
Zero-overlap %: 0.0, Overlap %: 100.0
Distribution by overlap pairs:
[0, 7, 3]

### 10.7. Function  `output_list_distr_yeh_graphs`

Pseudocode for `output_list_distr_yeh_graphs`

```vb
FUNCTION output_list_distr_yeh_graphs(orders, dirpath, fname)
    INPUT:
        orders — range of graph orders to analyze (StepRange{Int, Int})
        dirpath — output directory path (String)
        fname — base file name without extension (String)
    OUTPUT:
        None (creates and saves a formatted table file)

    SET filename = fname + ".txt"
    SET fpath = joinpath(dirpath, filename)

    // Get maximum order for reference calculations
    SET mxn = last element of orders

    // Generate reference codes and distribution
    SET lstBcd = collect(gen_codes_yeh_graphs(mxn))
    SET grporder, distr = calc_distr_all_graphs_overlap(lstBcd)

    // Remove trailing zeros and determine max distribution length
    SET distr = remove_trailing_zeros(distr)
    SET max_length = length of distr

    // Initialize data structures
    SET setdistr = empty set of distribution vectors (Set{Vector{Int64}})
    SET heade_list = empty vector for order headers (Vector{Int64})

    // Process each order in the range
    FOR each order IN orders DO
        SET lstbcd = collect(gen_non_cis3_from_edge(order))
        SET grporder, distr = calc_distr_all_graphs_overlap(lstbcd)

        // Store order and pad distribution to uniform length
        APPEND grporder TO heade_list
        SET distr = concatezeros(distr, max_length)
        APPEND distr TO setdistr
    END FOR

    // Prepare final data for table
    SORT heade_list in ascending order
    SET listdistr = sorted list of unique distributions from setdistr
    SET length_list_distr = length of listdistr

    // Create and write formatted table
    SET mainhead = "Distribution of Yeh’s n-order molecular graphs by vertex overlap count Novr"
    SET hdstr = "The number of molecular graphs of order n"
    SET lng1 = length of hdstr
    SET applng = 57 − lng1
    SET line = string of 57 dashes ("−")

    OPEN file at fpath for writing

    // Write table header
    WRITE mainhead + "\n" TO file
    WRITE line + "\n" TO file

    SET headstring = "|" + lpdstr(hdstr, applng) + "|"
    WRITE headstring + "\n" TO file
    WRITE line + "\n" TO file

    // Write column headers (orders)
    SET z1 = heade_list[1], z2 = heade_list[2], ..., z7 = heade_list[7]
    SET strzag = "|" + lpdstr("Novr", 6) + "|" +
                   lpdstr(" n=$z1 ", 6) + "|" + ... +
                   lpdstr(" n=$z7 ", 6) + "|"
    WRITE strzag + "\n" TO file
    WRITE line + "\n" TO file

    // Write data rows (one per overlap count)
    FOR j FROM 1 TO max_length DO
        SET k = j − 1  // overlap count (0, 1, 2, ...)
        SET str = "|" + lpdstr("$k", 6) + "|"

        FOR i FROM 1 TO length_list_distr DO
            SET vctr = listdistr[i]
            SET lds = vctr[j]  // count of graphs with k overlaps for this distribution
            SET str = str + lpdval(lds, 6) + "|"
        END FOR

        WRITE str + "\n" TO file
    END FOR

    WRITE line + "\n" TO file
    CLOSE file

    PRINT "File creation completed successfully"
END FUNCTION
```

Description
The `output_list_distr_yeh_graphs` function generates a comprehensive table summarizing the distribution of Yeh’s molecular graphs by vertex overlap count across multiple graph orders. The output is saved as a formatted text file.

Key steps:

Reference setup:

Determine the maximum graph order (mxn) from the input range.

Generate reference vertex codes and compute their overlap distribution.

Remove trailing zeros from the distribution and set the maximum length (max_length) for uniform formatting.

Data collection:

For each graph order in orders:

Generate vertex codes using `gen_non_cis3_from_edge`.

Compute the overlap distribution using `calc_distr_all_graphs_overlap`.

Store the order in heade_list and the padded distribution in setdistr.

Table preparation:

Sort the order list (heade_list) and unique distributions (listdistr).

File creation:

Write a formatted table with:

Header and title.

Column headers showing graph orders (n=$z1, n=$z2, etc.).

Rows for each overlap count (k = 0, 1, ..., max_length−1).

Cell values showing the number of graphs with k overlaps for each order.

Output:

Save the table to a .txt file in the specified directory.

Print a success message.

Algorithm
Construct the output file path (fpath).

Determine mxn (maximum order) and generate reference codes (lstBcd).

Compute and trim the reference distribution (distr), set max_length.

Initialize setdistr (unique distributions) and heade_list (order headers).

For each order in orders:

Generate codes (lstbcd) and compute distribution (grporder, distr).

Add grporder to heade_list, pad distr to max_length, add to setdistr.

Sort heade_list and listdistr, set length_list_distr.

Write the table:

Header (mainhead, line, headstring).

Column headers (strzag with order labels).

Data rows: for each j (1 to max_length), build a row string with overlap counts.

Close the file and print success message.

Complexity Analysis

Time complexity: $O(m⋅(T_{gen} + T_{distr})+k⋅L)$, where:

m — number of orders in orders;

$T_{gen}$ — time to generate codes (gen_non_cis3_from_edge);

$T_{distr}$ — time for calc_distr_all_graphs_overlap $(O(n^2)$ per code list);

k — number of unique distributions (length_list_distr);

L — max_length (number of overlap bins).
The dominant factor is usually $O(m⋅n^2)$, where n is the average graph order.

Space complexity: $O(k⋅L+m⋅n)$, where:

`O(k⋅L)` — storage for unique distributions;

`O(m⋅n)` — temporary storage for codes and distributions during processing.

Example

Input:

orders = 12:2:26 (orders 12, 144, 16, …, 26)

dirpath = "/results"

fname = "yeh_distributions"

Output file (/results/yeh_distributions.txt):

Distribution of Yeh’s n-order molecular graphs by vertex overlap count Novr

----------------------------------------------------------------------
     The number of molecular graphs of order n                        |
|---------------------------------------------------------------------|
|Novr  | n=12  | n=14  | n=16 | n=18 | n=20  | n=22  | n=24  | n=26   |
|-----:|------:|------:|-----:|-----:|------:|------:|------:|-------:|
| 0    |  118  |  422  | 1456 | 4938 | 16546 | 55069 | 182392| 602404 |
| 1    |  0    |  3    |  17  |  76  |  304  | 1155  | 4238  | 15155  |
| 2    |  0    |  2    |  17  |  95  |  487  | 2184  | 9267  | 37554  |
| 3    |  0    |  0    |  3   |  35  |  192  | 965   | 4323  | 18220  |
| 4    |  0    |  0    |  2   |  11  |   79  | 461   | 2353  | 10892  |
| 5    |  0    |  0    |  0   |   3  |   29  | 185   | 1046  | 5447   |
| 6    |  0    |  0    |  0   |   2  |   11  |  64   |  404  | 2130   |
| 7    |  0    |  0    |  0   |   0  |    3  |  29   |  147  | 910    |  
| 8    |  0    |  0    |  0   |   0  |    2  |  11   |   71  | 414    |
| 9    |  0    |  0    |  0   |   0  |    0  |   3   |   33  | 179    |
| 10   |  0    |  0    |  0   |   0  |    0  |   2   |   11  | 72     |  
| 11   |  0    |  0    |  0   |   0  |    0  |   0   |    3  | 35     |
| 12   |  0    |  0    |  0   |   0  |    0  |   0   |    2  | 13     |
| 14   |  0    |  0    |  0   |   0  |    0  |   0   |    0  |  3     |
| 16   |  0    |  0    |  0   |   0  |    0  |   0   |    0  |  2     |

## 11. Efficient Computation of Graph Overlap Distributions for Large Molecular Systems

Abstract
We present a memory‑efficient algorithm for computing the distribution of molecular graphs by vertex overlap pair count, specifically designed to handle large graph orders (n=30,32,34 and beyond). The method uses batch processing and lazy evaluation to overcome memory limitations of previous approaches.

Key Challenges Addressed
Previous methods struggled with large n due to:

excessive memory consumption when loading all graphs simultaneously;

long computation times for overlap calculations;

memory overflow at n≥30.

Our solution introduces iterative batch processing using Julia’s Iterators.partition, enabling scalable computation.

Algorithm Overview (Pseudocode)

```vb
FUNCTION distribution_graphs_overlap(list_vertex_code, level, npr)
    INPUT:
        list_vertex_code — list of graph vertex codes (Vector{Vector{Int64}})
        level — graph complexity level (Int64)
        npr — number of graphs per batch (Int64)
    OUTPUT:
        distr_vector — distribution by overlap pairs (Vector{Int64})
        sum_distr — total number of graphs (Int64)
        prc_nia_nul — % of graphs with zero overlaps (Float64)
        prc_nia_ss — % of graphs with overlaps (Float64)

    1. SET n = length(list_vertex_code[1]) + 2
    2. SET lng_distr_vect = max_overlap_pairs(n, level) + 2
    3. PARTITION list_vertex_code INTO batches of size npr
    4. INITIALIZE distr_vector = zeros(lng_distr_vect)
    5. FOR each batch:
          a. CALL processing_part_graphs(batch, lng_distr_vect)
          b. UPDATE distr_vector with partial results
          c. ACCUMULATE total graph count
    6. CALCULATE final percentages
    7. RETURN results
END FUNCTION
```

Detailed Implementation in Julia

1. Main Function: distribution_graphs_overlap
Purpose: Orchestrates the batch processing workflow.

Code with step‑by‑step explanation:

```julia
function distribution_graphs_overlap(
    list_vertex_code::Vector{Vector{Int64}},
    level::Int64,
    npr::Int64
)
    # Step 1: Determine graph order from vertex code length
    n = length(list_vertex_code[1]) + 2

    # Step 2: Calculate required distribution vector length
    # Uses max_overlap_pairs to estimate maximum possible overlaps
    lng_distr_vect = max_overlap_pairs(n, level) + 2

    # Step 3: Create lazy iterator for batch processing
    # This is the key memory optimization — no full array loading
    prt_gry = Iterators.partition(list_vertex_code, npr)

    # Step 4: Initialize result structures
    distr_vector = fill(0, lng_distr_vect)  # Final distribution accumulator
    sum_distr = 0  # Total graph counter

    # Step 5: Process each batch sequentially
    for (i, gy) in enumerate(prt_gry)
        # Process current batch and get partial results
        partial_distr_vector, sum_part_distr, prc_nia_nul =
            processing_part_graphs(gy, lng_distr_vect)

        # Optional: Print progress (can be removed for production)
        println("Batch $i: processed $sum_part_distr graphs")

        # Update global distribution with batch results
        zam_distr(partial_distr_vector, lng_distr_vect, distr_vector)

        # Accumulate total graph count
        sum_distr += sum_part_distr
    end

    # Step 6: Calculate final statistics
    prc_nia_nul = (distr_vector[1] / sum_distr) * 100  # % zero overlaps
    prc_nia_ss = 100.0 - prc_nia_nul  # % with overlaps

    # Step 7: Return complete results
    return distr_vector, sum_distr, prc_nia_nul, prc_nia_ss
end
```

2.Batch Processor: processing_part_graphs
Purpose: Computes overlap distribution for a single batch of graphs.

```julia
function processing_part_graphs(list_vertex_code, lng_distr_vect::Int64)
    # Initialize accumulator for this batch
    distr_num_over_accum = fill(0, lng_distr_vect)

    # For each graph in the batch:
    for gy in list_vertex_code
        # Count overlaps using dedicated function
        nmi = count_overlappings(gy)
        # Update distribution: nmi overlaps → index nmi+1
        distr_num_over_accum[nmi + 1] += 1
    end

    # Calculate batch statistics
    sum_nia = sum(distr_num_over_accum)
    prc_nia_zero = (distr_num_over_accum[1] / sum_nia) * 100

    return distr_num_over_accum, sum_nia, prc_nia_zero
end
```

3.Overlap Counter: count_overlappings
Purpose: Counts vertex overlap pairs for a single graph.

```julia
function count_overlappings(vertex_code::Vector{Int64})
    # Generate graph coordinates from vertex code
    _, x, y = create_carbon_chain(vertex_code)
    lngX = length(x); lngY = length(y)

    # Lazy generator: creates pairs for overlap checking
    # Only evaluates when summed — memory efficient
    lstNIns = (check_overlap(x, y, i, j)
               for i in 1:lngX
               for j in (i + 1):lngY)

    # Sum all overlap indicators (1 = overlap, 0 = no overlap)
    numIns = sum(lstNIns)
    return numIns
end
```

4.Overlap Checker: check_overlap
Purpose: Determines if two vertices occupy the same spatial position.

```julia
function check_overlap(X, Y, i::Int64, j::Int64)
    x1 = X[i]; y1 = Y[i]
    x2 = X[j]; y2 = Y[j]

    # Check coordinate proximity within tolerance
    if abs(x1 - x2) <= 0.0001 && abs(y1 - y2) <= 0.0001
        return 1  # Vertices overlap
    else
        return 0  # No overlap
    end
end
```

5.Accumulator: zam_distr
Purpose: Updates the global distribution vector with batch results.

```julia
function zam_distr(partial_distr_vector, lng_distr_vect, distr_vector_local)
    for i in 1:lng_distr_vect
        distr_vector_local[i] += partial_distr_vector[i]
    end
end
```

Memory and Performance Optimizations

Lazyocation avoidance: Iterators.partition creates a lazy iterator instead of loading all data.

Batch processing: npr parameter controls memory usage vs. speed trade‑off.

Lazyocate‑free operations: The generator expression in `count_overlappings` computes values on‑demand.

In‑place updates: `zam_distr` modifies the global vector directly.

Early aggregation: Partial results are combined immediately, minimizing stored data.

Based on the comparative calculations, the following conclusions can be drawn:

When n ranges from 14 to 28, the upgraded version offers no memory savings and is even slightly slower than the old version. However, when n is 30 or higher, the old version stops working, while the new one does. However, both versions of the program require improvement.

## 12. Verification of geometric correctness of molecular structures (Module `VerificationGeometry`)

The module contains functions for checking the geometric correctness of molecular structures: compliance of bond lengths, angles, planarity of fragments, etc.

## 12.1 Function `calc_angles`

Computes signed angles between all adjacent edge pairs of the molecular graph’s central path. Uses vector cross and dot products to determine both the magnitude and direction (sign) of angles. Used to verify the correctness of the molecular chain geometry, especially in systems with expected regular angles (e.g., aromatic rings or conjugated systems).

### Purpose

The function checks that the angles between consecutive bonds in the central path correspond to expected values. This helps identify:

- deviations from expected bond angles (e.g., $120^\circ$ in aromatic systems);
- kinks or distortions in the molecular chain;
- incorrect vertex ordering in the coordinate list;
- structural anomalies that may indicate modeling errors.

### Arguments

- `list_xg::Vector{Float64}` — list of x‑coordinates of all vertices in the central path.
- `list_yg::Vector{Float64}` — list of y‑coordinates of all vertices in the central path.

### Return value

 `list_angles::Vector{Float64}` — list of signed angles in degrees. Positive values typically indicate clockwise turns, negative — counterclockwise (depending on coordinate system orientation).

### Example of use

```julia
# Coordinates of vertices in the central path
list_xg = [
    7.1023,
    8.34937658144959,
    8.34937658144959,
    9.59645316289918,
    9.59645316289918,
    10.843529744348771,
    10.843529744348771,
    12.090606325798362
]

list_yg = [
    3.3107,
    4.0307,
    5.470700000000001,
    6.1907000000000005,
    7.630700000000001,
    8.350700000000002,
    9.790700000000001,
    10.510700000000002
]

# Calculate signed angles between adjacent edge pairs
list_angles = calc_angles(list_xg, list_yg)

# Print the result
println("Signed angles between adjacent edges (degrees):")
println(list_angles)
```

Result of execution:

Signed angles between adjacent edges (degrees):
`[-120.00000000000004, 120.00000000000001, -120.00000000000001, 120.00000000000004, -120.00000000000006, 120.00000000000006]`

How to interpret the result

Number of elements. The result contains 6 values — exactly n−2, where n=8 is the number of vertices. This is expected: each angle is formed by three consecutive vertices, so n vertices yield n−2 angles.

Angle values. All angles are close to $±120^{\circ}$, which is typical for systems with trigonal planar geometry (e.g., benzene rings or conjugated chains).

Sign pattern. The alternating signs (-120, +120, -120, etc.) indicate a regular zigzag pattern in the chain — a common feature in aromatic or conjugated molecular structures.

Minor deviations (e.g., −120,00000000000004 instead of exactly −120) are caused by:

floating‑point calculation errors;

acceptable small distortions in the model geometry.

Signs of an error. If any value significantly differs from $±120^{\circ}$  (e.g., $90^{\circ}$,
$150^{\circ}$, or $0^{\circ}$), it indicates a problem:

incorrect atomic coordinates;

missing or extra vertices in the chain;

wrong vertex ordering (vertices not listed sequentially along the path);

structural anomaly in the molecule (e.g., a kink or bend not expected in the system);

data input error.

Consistency check. A regular alternation of $±120^{\circ}$  values confirms that the
chain is properly constructed and vertices are ordered correctly. Irregular sign
patterns or large variations in magnitude suggest structural issues.

**Notes on the implementation:**

- **Fixed data formatting:** Organized coordinate arrays into readable multi‑line format for clarity.
- **Clarified angle meaning:** Explained that signs indicate turn direction and the pattern reflects molecular geometry.
- **Contextualized expected values:** Linked $120^{\circ}$ to trigonal planar geometry common in organic chemistry.
- **Enhanced interpretation:** Added specific guidance on what irregular patterns might mean.
- **Consistency:** Followed the same documentation template as previous functions for uniformity across `algorithm_overview.md`.

## 12.2. Function `calc_angles2`

Computes angles between all adjacent edge pairs of the molecular graph’s central path. Uses vector cross and dot products to determine both the magnitude of angles. Used to verify the correctness of the molecular chain geometry, especially in systems with expected regular angles (e.g., aromatic rings or conjugated systems).

### Purpose

The function checks that the angles between consecutive bonds in the central path correspond to expected values. This helps identify:

- deviations from expected bond angles (e.g., $120^\circ$ in aromatic systems);
- kinks or distortions in the molecular chain;
- incorrect vertex ordering in the coordinate list;
- structural anomalies that may indicate modeling errors.

### Arguments

- `list_xg::Vector{Float64}` — list of x‑coordinates of all vertices in the central path.
- `list_yg::Vector{Float64}` — list of y‑coordinates of all vertices in the central path.

### Return value

 `list_angles::Vector{Float64}` — list of angles in degrees.

### Example of use

```julia
# Coordinates of vertices in the central path
list_xg = [
    7.1023,
    8.34937658144959,
    8.34937658144959,
    9.59645316289918,
    9.59645316289918,
    10.843529744348771,
    10.843529744348771,
    12.090606325798362
]

list_yg = [
    3.3107,
    4.0307,
    5.470700000000001,
    6.1907000000000005,
    7.630700000000001,
    8.350700000000002,
    9.790700000000001,
    10.510700000000002
]

# Calculate signed angles between adjacent edge pairs
list_angles = calc_angles(list_xg, list_yg)

# Print the result
println("Angles between adjacent edges (degrees):")
println(list_angles)
```

Result of execution:

Angles between adjacent edges (degrees):
`[120.00000000000004, 120.00000000000001, 120.00000000000001, 120.00000000000004, 120.00000000000006, 120.00000000000006]`

How to interpret the result

Number of elements. The result contains 6 values — exactly `(n−2)`, where n=8 is the number of vertices. This is expected: each angle is formed by three consecutive vertices, so n vertices yield `(n - 2)` angles.

Angle values. All angles are close to $120^{\circ}$, which is typical for systems with trigonal planar geometry
(e.g., benzene rings or conjugated chains).

Minor deviations (e.g., 120,00000000000004 instead of exactly 120) are caused by:

- floating‑point calculation errors;

- acceptable small distortions in the model geometry.

If any value significantly differs from $120^{\circ}$  (e.g., $90^{\circ}$,
$150^{\circ}$, or $0^{\circ}$), it indicates a problem:

incorrect atomic coordinates;

- missing or extra vertices in the chain;

- wrong vertex ordering (vertices not listed sequentially along the path);

- structural anomaly in the molecule (e.g., a kink or bend not expected in the system);

- data input error.

## 12.3.Function `angle_from_prod`

Computes the angle between two vectors using their dot (scalar) and cross (skew) products. This function is essential in molecular geometry verification for accurately determining bond angles from vector representations of atomic coordinates.

### Algorithm complexity

- **Time complexity:** $O(1)$ — constant time, as it involves a fixed number of arithmetic operations and conditional checks.
- **Space complexity:** $O(1)$ — constant space, as it uses a fixed number of variables regardless of input size.

### Arguments

- `scal_prod::Float64` — vector dot product (scalar product). Represents the projection of one vector onto another; related to the cosine of the angle.
- `skew_Prod::Float64` — vector cross product (skew product). Magnitude is related to the sine of the angle; sign indicates orientation (clockwise/counter‑clockwise).

### Return value

- `angle::Float64` — angle between two vectors in degrees. The result ranges from $-180^\circ$ to $+180^\circ$, preserving directional information:
  - positive values: counter‑clockwise orientation;
  - negative values: clockwise orientation.

### Example of use

```julia
println("variant 1")
scal_prod = 0.0; skew_Prod = 0.5
angle = angle_from_prod(scal_prod, skew_Prod)
println("angle $angle°, scal_prod $scal_prod, skew_Prod $skew_Prod")

println("\nvariant 2")
scal_prod = 0.0; skew_Prod = -0.5
angle = angle_from_prod(scal_prod, skew_Prod)
println("angle $angle°, scal_prod $scal_prod, skew_Prod $skew_Prod")

println("\nvariant 3")
scal_prod = 0.6; skew_Prod = -0.5
angle = angle_from_prod(scal_prod, skew_Prod)
println("angle $angle°, scal_prod $scal_prod, skew_Prod $skew_Prod")

println("\nvariant 4")
scal_prod = -0.6; skew_Prod = 0.42
angle = angle_from_prod(scal_prod, skew_Prod)
println("angle $angle°, scal_prod $scal_prod, skew_Prod $skew_Prod")

println("\nvariant 5")
scal_prod = -0.6; skew_Prod = -0.7
angle = angle_from_prod(scal_prod, skew_Prod)
println("angle $angle°, scal_prod $scal_prod, skew_Prod $skew_Prod")
```

Result of execution

```julia
variant 1
angle 90.0°, scal_prod 0.0, skew_Prod 0.5

variant 2
angle -90.0°, scal_prod 0.0, skew_Prod -0.5

variant 3
angle -39.8055710922652°, scal_prod 0.6, skew_Prod -0.5

variant 4
angle 145.00797980144134°, scal_prod -0.6, skew_Prod 0.42

variant 5
angle -130.6012946450045°, scal_prod -0.6, skew_Prod -0.7
```

Interpretation of the result

Special cases (perpendicular vectors):

When scal_prod == 0:

skew_Prod > 0 → $+90^{\circ}$ (variant 1);

skew_Prod < 0 → $−90^{\circ}$ (variant 2).

Acute angles:

scal_prod > 0 — angle is acute or obtuse but in the first/fourth quadrant.

Example: variant 3 ($−39,8^{\circ}$) — acute angle with clockwise orientation.

Obtuse angles:

scal_prod < 0 — angle is obtuse, requiring adjustment by ±π radians.

If skew_Prod >= 0, add π (variant 4: 145,0^{\circ}$).

If skew_Prod < 0, subtract π (variant 5: −130,6^{\circ}$).

Significance of sign:

Positive angles ($>0^{\circ}$) indicate counter‑clockwise rotation from the first to the second vector.

Negative angles ($<0^{\circ}$) indicate clockwise rotation.

Expected values in molecular contexts:

$±120^{\circ}$ — typical for trigonal planar systems (e.g., aromatic or conjugated chains);

$±90^{\circ}$ — perpendicular bonds;

$0^{\circ}$ or $±180^{\circ}$ — collinear atoms.

Error indicators:

Extreme deviations from expected values (e.g., ∣angle∣

$≈120^{\circ}$ in a conjugated system) may indicate:

- structural anomalies (kinks, bends);

- coordinate generation errors;

- issues in upstream vector calculations.

Practical notes
Numerical stability. The function handles edge cases (zero dot product) explicitly
to avoid division by zero in atan().

Unit conversion. Result is converted from radians to degrees (×180/π) for user convenience.

Use in pipeline. This function is typically called by higher‑level functions like calc_angles to compute bond angles from atomic coordinates.

Validation. For verification tasks, compare the output to expected angles using check_values with an appropriate tolerance (e.g., $10^{−5}$).

Limitations. Assumes input products are computed from 2D vectors or coplanar 3D vectors. For non‑coplanar cases, additional projection steps are required.

## 12.4. Function `calc_length_cc_edges`

Calculates the lengths of edges in the central chain of a molecular graph based on the coordinates of C‑vertices. Used to verify the correctness of the carbon skeleton construction.

### Purpose

The function checks that the bond lengths between consecutive C‑atoms in the central chain correspond to expected values (typically around $1{,}44$ Å for single C–C bonds). This helps identify:

- errors in atomic coordinates;
- abnormally short or long bonds;
- breaks in the carbon chain.

### Arguments

- `list_xg::Vector{Float64}` — list of x‑coordinates of all C‑vertices in the central chain.
- `list_yg::Vector{Float64}` — list of y‑coordinates of all C‑vertices in the central chain.

### Return value

- `list_lengths_cc::Vector{Float64}` — list of edge lengths in the central chain of the molecular graph (the array length is 1 less than the number of vertices).

### Example of use

```julia
# Define coordinates of C‑vertices in the central chain
list_xg = [
    7.1023,
    8.34937658144959,
    8.34937658144959,
    9.59645316289918,
    9.59645316289918,
    10.843529744348771,
    12.090606325798362,
    13.337682907247952
]

list_yg = [
    3.3107,
    4.0307,
    5.470700000000001,
    6.1907000000000005,
    7.630700000000001,
    8.350700000000002,
    7.630700000000002,
    8.350700000000002
]

# Calculate edge lengths
list_lengths_cc = calc_length_cc_edges(list_xg, list_yg)

# Print the result
println("Edge lengths in the central chain:")
println(list_lengths_cc)
```

Result of execution:

Edge lengths in the central chain:
`[1.4399999999999993, 1.4400000000000004, 1.4399999999999988, 1.4400000000000004, 1.4399999999999993, 1.4399999999999988, 1.4399999999999988]`

How to interpret the result
Number of elements. The result contains 7 values — 1 less than the number of vertices (8).
This is normal: a linear chain with n vertices always has n−1 edges.

Length values. All lengths are close to 1,44 Å — this corresponds to the expected length of a single C–C bond.

Minor deviations (e.g., 1,4399999999999993 instead of 1,44) are caused by:

floating‑point calculation errors;

acceptable small distortions in the model geometry.

Signs of an error. If any value significantly differs from 1,44 (e.g., 0,8 or 2,5 Å), it indicates a problem:

incorrect atomic coordinates;

chain break;

data input error.

## 12.5. Function `calc_length_ch_branchs`

Calculates the lengths of all side‑chain edges (C–H bonds) in a molecular graph based on the coordinates of C‑ and H‑vertices and a list of hydrogen bonds. Used to verify the correctness of side‑chain attachment to the carbon skeleton.

### Purpose

The function checks that the lengths of C–H bonds in molecular side chains correspond to expected values (typically around $1{,}08$ Å for C–H single bonds). This helps identify:

- errors in atomic coordinates of H‑atoms;
- incorrectly assigned hydrogen bonds (e.g., H attached to wrong C);
- abnormal bond lengths indicating structural errors;
- missing or extra hydrogen atoms.

### Arguments

- `edg_hydro::Vector{Vector{Int64}}` — list of hydrogen bond pairs, where each pair `[c_idx, h_idx]` indicates a bond between a C‑vertex (index `c_idx` in `list_xg`/`list_yg`) and an H‑vertex (index `h_idx` in `list_xh`/`list_yh`).
- `list_xg::Vector{Float64}` — list of x‑coordinates of all C‑vertices.
- `list_yg::Vector{Float64}` — list of y‑coordinates of all C‑vertices.
- `list_xh::Vector{Float64}` — list of x‑coordinates of all H‑vertices.
- `list_yh::Vector{Float64}` — list of y‑coordinates of all H‑vertices.

### Return value

 `list_lengths_ch::Vector{Float64}` — list of side‑chain edge lengths (C–H bond lengths) in the molecular graph.

### Example of use

```julia
# Coordinates of C‑vertices (carbon skeleton)
list_xg = [
    7.1023,
    8.34937658144959,
    8.34937658144959,
    9.59645316289918,
    9.59645316289918,
    10.843529744348771,
    12.090606325798362,
    13.337682907247952
]

list_yg = [
    3.3107,
    4.0307,
    5.470700000000001,
    6.1907000000000005,
    7.630700000000001,
    8.350700000000002,
    7.630700000000002,
    8.350700000000002
]

# Coordinates of H‑vertices (hydrogen atoms)
list_xh = [
    6.166992563912806,
    7.1023,
    9.284684017536783,
    7.414069145362396,
    10.531760598986374,
    8.661145726811988,
    10.843529744348771,
    12.090606325798362,
    14.272990343335145,
    13.337682907247952
]

list_yh = [
    3.8507000000000002,
    2.2307,
    3.4907000000000004,
    6.010700000000001,
    5.6507000000000005,
    8.1707,
    9.430700000000002,
    6.550700000000002,
    7.8107000000000015,
    9.430700000000002
]

# Define hydrogen bonds: each [c_idx, h_idx] pair
edg_hydro = [
    [1, 1], [1, 2], [2, 3], [3, 4],
    [4, 5], [5, 6], [6, 7], [7, 8],
    [8, 9], [8, 10]
]

# Calculate side‑chain (C–H) bond lengths
list_lengths_ch = calc_length_ch_branchs(edg_hydro, list_xg, list_yg, list_xh, list_yh)

# Print the result
println("Side‑chain (C–H) bond lengths:")
println(list_lengths_ch)
```

Result of execution:
Side‑chain (C–H) bond lengths:
[1.08, 1.08, 1.0799999999999994, 1.08, 1.0799999999999994, 1.079999999999999, 1.08, 1.08, 1.0799999999999994, 1.08]

How to interpret the result

1. Number of elements. The result contains 10 values — exactly one per defined hydrogen bond in edg_hydro. This confirms that all specified bonds were processed.
2. Length values. All lengths are close to 1,08 Å — this corresponds to the expected length of a single C–H bond in organic molecules.
3. Minor deviations (e.g., 1,0799999999999994 instead of 1,08) are caused by:
    - floating‑point calculation errors;
    - acceptable small distortions in the model geometry.
4. Signs of an error. If any value significantly differs from 1,08 (e.g., 0,8 or 1,5 Å), it indicates a problem:
    - incorrect atomic coordinates (especially for H‑atoms);
    - wrong bond assignment (H attached to wrong C‑atom);
    - missing hydrogen atom (if bond count is lower than expected);
    - data input error in coordinate lists or bond definitions.

## 12.6. Function `check_values`

Helper function that validates each value in the input list against a standard (reference) value, with configurable tolerance. Returns the count of elements that deviate from the standard beyond the specified threshold. Used for quick consistency checks — e.g., in bond lengths or angles.

### Purpose

The function checks how many values in a list differ significantly from a given standard. This helps:

- verify uniformity of bond lengths (e.g., all C–C bonds ≈ $1{,}44$ Å);
- check consistency of bond angles (e.g., all ≈ $120^\circ$ in aromatic systems);
- flag potential outliers that may indicate structural errors;
- automate quality control in batch processing of molecular geometries.

### Arguments

- `list_values::Vector{Float64}` — list of values of a certain quantity (e.g., bond lengths in Å, angles in degrees).
- `standard::Float64` — standard (reference) value to compare against.
- `tolerance::Float64` (optional) — tolerance threshold. Values within `|value - standard| < tolerance` are considered standard. Default: $10^{-5}$.

### Return value

 `Int64` — number of non‑standard elements in the list. A result of `0` means all values are within tolerance of the standard.

### Example of use

```julia
println("**********  Good cases  **********")

# Case 1: All angles exactly 120° (default tolerance)
lstAngles = [120.0, 120.0, 120.0, 120.0, 120.0, 120.0]
mtk = check_values(lstAngles, 120.0)
println("Number of non‑standard angles: $mtk")

# Case 2: All bond lengths exactly 1.44 Å (custom tolerance 1e-4)
lstEdges = [1.44, 1.44, 1.44, 1.44, 1.44, 1.44]
mtk = check_values(lstEdges, 1.44, 1e-4)
println("Number of non‑standard bond lengths: $mtk")

println("************  Bad cases  ************")

# Case 3: Angles with some deviations (default tolerance)
lstAngles = [120.01, 120.1, 120.001, 119.09, 120.0, 120.0]
mtk = check_values(lstAngles, 120.0)
println("Number of non‑standard angles: $mtk")

# Case 4: Bond lengths with some deviations (custom tolerance)
lstEdges = [1.439, 1.4401, 1.44001, 1.441, 1.44, 1.44]
mtk = check_values(lstEdges, 1.44, 1e-3)  # Larger tolerance catches fewer deviations
println("Number of non‑standard bond lengths (tol=1e-3): $mtk")
```

Result of execution:

**********  Good cases  **********
Number of non‑standard angles: 0

Number of non‑standard bond lengths: 0

************  Bad cases  ************
Number of non‑standard angles: 4

Number of non‑standard bond lengths (tol=1e-3): 2

How to interpret the result

Return value meaning:

0 — all values in the list are within tolerance of the standard. Data is uniform.

>0 — the returned number is the count of values that differ from the standard by >= tolerance. These are flagged as “non‑standard”.

Tolerance flexibility:

Default tolerance: $10^{−5}$ — strict check.

Custom tolerance (e.g., $10^{−3}$) — looser check, useful when small deviations are acceptable.

Error handling:

If the input contains NaN or Inf, the function throws an ArgumentError. This prevents silent failures during automated checks.

Practical notes:

The function remains fast and simple — ideal for quick validation.

Use default tolerance for high‑precision checks.

Adjust tolerance for more permissive comparisons.

Combine with other functions (`calc_angles`, `calc_length_cc_edges`) to locate and analyze specific deviations.

## 12.7. Function `analyz_length_cc_edges`

Verifies C‑C edge lengths in the central path of a molecular graph (without hydrogen atoms) by comparing each edge length with a standard value. Used to validate the structural integrity of carbon chains across multiple isomeric configurations.

### Purpose

The function checks the uniformity of C–C bond lengths in the central chains of multiple molecular graphs. This helps:

- identify isomers with abnormal bond lengths;
- detect structural defects in specific molecular configurations;
- validate the output of isomer generation algorithms;
- flag molecules where the carbon skeleton deviates from expected geometry.

### Arguments

- `func_gen::Function` — function for generating a list of vertex codes of graphs (e.g., `generate_isomer_vertex`). Each vertex code represents a possible isomeric structure.
- `n::Int64` — number of carbon atoms in a linear polyene molecule. Determines the size of the system being analyzed.
- `standard::Float64` — standard C–C edge length (typically $1{,}44$ Å for single bonds). Used as the reference value for comparison.

### Return value

 `list_mtk::Vector{Int64}` — list where each i‑th element equals `0` or `1`:

- `0` — all C–C bonds in the i‑th graph are within tolerance of the standard length;
- `>0` — the value indicates the number of non‑standard C–C bonds in the i‑th graph.
   A higher count means more    bonds deviate from the standard.

### Example of use

```julia
println("************  Good cases (standard = 1.44 Å)  ****************")
# Analyze 8‑carbon isomers using standard bond length of 1.44 Å
mtk = analyz_length_cc_edges(generate_isomer_vertex, 8, 1.44)
println("Defect count per isomer: $mtk")

println("************  Bad cases (standard = 1.45 Å)  ****************")
# Same isomers, but with incorrect standard (1.45 Å — not typical for C–C)
mtk = analyz_length_cc_edges(generate_isomer_vertex, 8, 1.45)
println("Defect count per isomer (with wrong standard): $mtk")
```

Result of execution:

************  Good cases (standard = 1.44 Å)  ****************

Defect count per isomer: `[0, 0, 0]`

************  Bad cases (standard = 1.45 Å)  ****************

Defect count per isomer (with wrong standard): `[7, 7, 7]`

How to interpret the result

Number of elements in list_mtk. The length of the returned list corresponds to
the number of isomers (vertex codes) generated by func_gen(n). Each element represents one isomer.

Value meaning per element:

`0` — in this isomer, all C–C bond lengths are within tolerance of the standard.
The carbon chain is geometrically correct.

`>0` — this isomer has N bonds that deviate from the standard. For example:

`[7, 7, 7]` means each of the 3 isomers has 7 non‑standard bonds. Since a chain
of 8 carbons has 7 edges, this implies all bonds in each isomer differ from the given standard (1.45 Å).

Context for the “bad” case:

When using standard = 1.45 Å, the result `[7, 7, 7]` does not necessarily mean the structures are defective. It reflects that the actual bond lengths (~1.44 Å) differ from the incorrectly specified standard. This highlights the importance of choosing the correct reference value.

Locating the defect:

The function identifies which isomer has issues (by position in list_mtk).

To find the specific bond(s) causing the deviation, use calc_length_cc_edges on the corresponding vertex code to get detailed bond lengths.

Practical notes:

Use standard = 1.44 Å for typical single C–C bonds.

A result of `[0, 0, ...]` confirms all generated isomers have correct bond lengths.

Non‑zero values prompt further inspection: either the structure is anomalous, or the standard is mis‑specified.

Combine with create_carbon_chain and calc_length_cc_edges to drill down into problematic isomers.

**Notes on the implementation:**

- **Clarified workflow:** The function calls `func_gen` to get vertex codes, then for each code:
  1. Builds the carbon chain (`create_carbon_chain`).
  2. Computes bond lengths (`calc_length_cc_edges`).
  3. Checks deviations (`check_values`).

- **Interpreted the example results:**
  - `[0, 0, 0]` → 3 isomers, all bonds correct (standard = 1.44 Å).
  - `[7, 7, 7]` → 3 isomers, each with 7 deviating bonds (standard = 1.45 Å).
    Since 8 C atoms → 7 bonds, this means *all* bonds differ from 1.45 Å
    (expected, as real bonds are ~1.44 Å).

- **Emphasized diagnostics:** The function is a high‑level filter. It flags *which* isomers need attention; detailed analysis requires lower‑level functions.

- **Consistency:** Followed the same documentation template as previous functions for uniformity across `algorithm_overview.md`.

## 12.8. Function `analyz_length_ch_branchs`

Verifies C‑H bond lengths in side chains of a molecular graph with hydrogen atoms by comparing each bond length with a standard value. Similar to other `analyz_*` functions, but focuses on C–H bonds instead of C–C.

### Purpose

Checks uniformity of C–H bond lengths across multiple isomeric configurations with hydrogen atoms. Helps identify isomers where side‑chain hydrogen placement deviates from expected geometry (standard ≈ $1{,}08$ Å).

### Arguments

- `func_gen::Function` — function for generating a list of vertex codes of graphs (e.g.,    `generate_other_conformer_edge`).
- `n::Int64` — number of carbon atoms in a linear polyene molecule.
- `standard::Float64` — standard C–H edge length (typically $1{,}08$ Å for single bonds).

### Return value

 `list_mtk::Vector{Int64}` — list where each i‑th element:

- `0` — all C–H bonds in the i‑th graph are within tolerance of the standard length;
- `>0` — number of non‑standard C–H bonds in the i‑th graph.

### Example of use

```julia
println("************  Good cases (standard = 1.08 Å)  ****************")
mtk = analyz_length_ch_branchs(generate_other_conformer_edge, 8, 1.08)
println("Defect count per isomer: $mtk")

println("************  Bad cases (standard = 1.09 Å)  ****************")
mtk = analyz_length_ch_branchs(generate_other_conformer_edge, 8, 1.09)
println("Defect count per isomer (with wrong standard): $mtk")
```

Result of execution:

************  Good cases (standard = 1.08 Å)  ****************

Defect count per isomer: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
----

## 12.9. Function `analyz_angle_cc_hyd`

Checks angles between adjacent edges in the central chain of a molecular
graph *with hydrogen atoms* by comparing each angle to a standard value.
Similar to `analyz_angle_cc_edges`, but processes structures including hydrogen atoms.

### Purpose

Validates the uniformity of bond angles in carbon chains across multiple isomeric configurations *that include hydrogen atoms*. Helps identify isomers where the geometry of the central path deviates from expected values (typically $120^\circ$ for trigonal planar systems).

### Arguments

- `func_gen::Function` — function for generating a list of vertex codes of graphs
  (e.g., `generate_isomer_vertex`).
- `n::Int64` — number of carbon atoms in a linear polyene molecule.
- `standard::Float64` — standard angle value in degrees (e.g., $120^\circ$).

### Return value

 `list_mtk::Vector{Int64}` — list where each i‑th element:

- `0` — all angles in the i‑th graph are within tolerance of the standard;
- `>0` — number of angles in the i‑th graph that deviate from the standard.

### Example of use

```julia
println("**********  Good cases (standard = 120°)  **********")
mtk = analyz_angle_cc_hyd(generate_isomer_vertex, 8, 120.0)
println("Angle deviation count per isomer: $mtk")

println("************  Bad cases (standard = 120.001°)  **************")
mtk = analyz_angle_cc_hyd(generate_isomer_vertex, 8, 120.001)
println("Angle deviation count per isomer (with slightly wrong standard): $mtk")
```

Result of execution:

**********  Good cases (standard = 120°)  **********

Angle deviation count per isomer: `[0, 0, 0]`

************  Bad cases (standard = 120.001°)  **************

Angle deviation count per isomer (with slightly wrong standard): `[6, 6, 6]`

How to interpret the result

List length equals the number of isomers generated by func_gen(n).

Element values:

0 — all bond angles in this isomer match the standard (correct geometry).

6 (for 8 C atoms) — all 6 angles in this isomer deviate from the standard. In the example,
using $120{,}001^{\circ}$ as the standard causes all angles to be flagged as non‑standard due
to the strict tolerance of check_values.

Key difference from analyz_angle_cc_edges:

This function uses create_hydrogen_tree() to build structures with hydrogen atoms,
then extracts C‑atom coordinates for angle calculation.

The core validation logic (via calc_angles and check_values) remains identical.

Context for the “bad” case:

The result [6, 6, 6] does not mean the structures are defective. It reflects that
the actual angles $(~120^{\circ})$ differ from the slightly mis‑specified standard
$(120,001^{\circ})$, given the default tolerance of $10^{−5}$.

Practical notes

Use `standard = 120.0°` for systems with trigonal planar geometry (e.g., aromatic or conjugated chains).

A result of [0, 0, ...] confirms all generated isomers have correct bond angles.

Non‑zero values indicate either:

structural anomalies in specific isomers (e.g., kinks or bends);

a mis‑specified standard value (even small deviations can trigger flags).

To locate specific problematic angles, use calc_angles on the corresponding vertex code to get detailed angle values.

The function uses the same tolerance as check_values $(10^{−5})$, which is suitable for high‑precision checks.

## 12.10. Function `from_vcode_to_list_angles`

Converts a vertex code of a molecular graph into a list of bond angles between adjacent
carbon atoms in the chain. Supports two graph types: with and without hydrogen atoms.

### Purpose

Constructs a list of angles between all adjacent vertex pairs of the carbon chain (path)
based on the vertex code.

This function:

- serves as a pre‑processing step for angle analysis (e.g., before calling `analyz_angle_cc_edges` or `analyz_angle_cc_hyd`);
- unifies angle calculation for different molecular representations;
- enables consistent geometry checks across isomeric structures.

### Arguments

- `vertex_code::Vector{Int64}` — vertex code representing a molecular graph (generated by functions like `generate_isomer_vertex`). **Note:** the code encodes only *internal vertices* of the carbon chain, so its length $p = n - 2$, where $n$ is the total number of carbon atoms.

- `type::Int64` — molecular graph type:
  - `1` — structure *without hydrogen atoms* (uses `create_carbon_chain`);
  - `2` — structure *with hydrogen atoms* (uses `create_hydrogen_tree`).

### Return value

`Vector{Float64}` — list of bond angles in degrees. Each element corresponds to
an angle between three consecutive carbon atoms in the chain.

### Example of use

```julia
println("variant 1 — structure without H atoms (type = 1)")
list_vertex_code = generate_isomer_vertex(8)
vertex_code = list_vertex_code[1]
println("vertex_code: $vertex_code")
lstAngles = from_vcode_to_list_angles(vertex_code, 1)
println("lstAngles (angles in degrees): $lstAngles")

println("\nvariant 2 — structure with H atoms (type = 2)")
list_vertex_code = generate_trans_conformer_edge(8)
vertex_code = list_vertex_code[1]
println("vertex_code: $vertex_code")
lstAngles = from_vcode_to_list_angles(vertex_code, 2)
println("lstAngles (angles in degrees): $lstAngles")

Result of execution (actual output):
variant 1
vertex_code  [0, 1, 0, 1, 0, 1]
lstAngles
[-120.00000000000004, 120.00000000000001, -120.00000000000001, 120.00000000000004, 
-120.00000000000006, 120.00000000000006]

variant 2
vertex_code  [0, 0, 1, 0, 1, 0]
lstAngles
[-120.00000000000004, -119.99999999999999, 119.99999999999999, -120.00000000000001, 
120.00000000000004, -120.00000000000001]
```

How to interpret the result

    1. List length and vertex code relation. The length of vertex_code is p=n−2, where:
        - n — total number of carbon atoms in the molecule;
        - p — number of internal vertices encoded (excluding the two terminal atoms).

Consequently, the number of angles returned is also p=n−2. For n=8 C atoms, we expect p=6 elements in both vertex_code and lstAngles.
    2. Angle signs. The presence of negative angles (−120∘) indicates:
        - the algorithm computes signed angles (direction‑aware);
        - positive values: angles measured in one direction;
        - negative values: angles measured in the opposite direction.

    3. Numerical precision. Values like 120,00000000000001∘ reflect floating‑point arithmetic limitations. These are effectively 120∘, with deviations at the 10−14 ° level.
    
    4. Expected values. In ideal trigonal planar systems (e.g., aromatic or conjugated chains), angles cluster around ±120∘. Small deviations (e.g., 119,99999999999999∘) are normal and do not indicate structural issues.
    
    5. Type‑dependent patterns:
        - type = 1 (without H): Alternating signs (−120∘,+120∘,…) may reflect a regular
         zigzag carbon backbone.
        
        - type = 2 (with H): Less regular sign pattern may arise from hydrogen‑induced perturbations in coordinate generation.

Practical notes

    - Normalization. If only angle magnitudes matter, apply abs() to the result: abs.(lstAngles).
    - Tolerance. Use check_values(lstAngles, 120.0) with default tolerance (10−5) to flag only meaningful deviations (ignores floating‑point noise).
    
    - Downstream use. This function feeds directly into:
        - check_values for pass/fail validation;
        - plotting tools for visualizing angle distributions;
        - statistical analysis of conformational flexibility.
   
    - Debugging. To inspect coordinate generation:
        - for type = 1: call create_carbon_chain(vertex_code) directly;
        - for type = 2: call create_hydrogen_tree(vertex_code) directly.
    
    - Consistency check. Verify that `length(vertex_code) == n - 2` holds
     for your input, where n is the known number of carbon atoms. This confirms the vertex code encodes internal vertices correctly.

## 12.11. Function `from_list_angles_to_vcode`

Constructs a vertex code from a list of angles between consecutive carbon atoms along the molecular graph’s central path. Performs the inverse operation to `from_vcode_to_list_angles`.

### Purpose

Converts geometric information (bond angles) into a compact topological representation (vertex code).
This function:

- enables reconstruction of vertex codes from angle data;
- supports round‑trip conversion: `vertex_code → angles → vertex_code`;
- provides a binary encoding of angle directionality for structural analysis.

### Arguments

- `list_angles::Vector{Float64}` — list of bond angles in degrees between consecutive carbon atoms. Each element corresponds to an angle formed by three consecutive carbon atoms: $C_{i-1}$–$C_i$–$C_{i+1}$.

### Return value

 `Vector{Int64}` — vertex code where each element is:

- `0` — if the corresponding angle is negative (indicating a bend in one direction);
- `1` — if the corresponding angle is positive (indicating a bend in the opposite direction).

### Conversion logic

The function applies the following rule to each angle:

- if $\text{sign}(\text{angle}) = +1$ (positive angle) → output `1`;
- if $\text{sign}(\text{angle}) = -1$ (negative angle) → output `0`.

This creates a binary representation of the carbon chain’s zigzag pattern.

### Example of use

```julia
println("*********  from_list_angles_to_vcode  ***********")
lstAngles = [-120.00000000000004, -119.99999999999999, 119.99999999999999, -120.00000000000001, 120.00000000000004, -120.00000000000001]
println("lstAngles: $lstAngles")
vertex_code = from_list_angles_to_vcode(lstAngles)
println("vertex_code: $vertex_code")
Result of execution:
*********  from_list_angles_to_vcode  ***********
lstAngles: [-120.00000000000004, -119.99999999999999, 119.99999999999999, -120.00000000000001, 120.00000000000004, -120.00000000000001]
vertex_code: [0, 0, 1, 0, 1, 0]
```

How to interpret the result

    1. Length preservation. The length of the output vertex_code equals the length of the input list_angles. For p angles, you get a vertex code of length p.
    
    2. Binary encoding. The vertex code represents the directionality of bends in the carbon chain:
        - 0 → negative angle (bend in direction A);
        - 1 → positive angle (bend in direction B).
    
    3. Numerical robustness. The function uses sign() which is insensitive to floating‑point noise. Small deviations from exact ±120∘ do not affect the result.
    
    4. Geometric meaning. The resulting code captures the zigzag pattern of the carbon backbone. For example:
        - `[0, 0, 1, 0, 1, 0]` indicates a sequence of bends: A‑A‑B‑A‑B‑A.
    
    5. Round‑trip consistency. When used with from_vcode_to_list_angles, the pair enables:
        - encoding: vertex_code → angles;
        - decoding: angles → vertex_code.

The decoded code matches the original if angles preserve sign information.

Practical notes
    - Input requirements. The function expects a non‑empty list_angles vector. For empty input, it returns an empty vector.
    - Angle sign dependence. Results depend solely on the sign of angles, not their magnitude. Angles of −179∘ and −90∘ both yield 0.

    - Use cases:
        - reconstructing vertex codes after geometric optimization;
        - comparing structural patterns across molecules using binary codes;
        - compressing geometric data into topological fingerprints;
        - validating the consistency of angle calculation pipelines.
    
    - Limitations. The function:
        - cannot recover original coordinates;
        - loses magnitude information (all positive angles → 1, regardless of value);
        - assumes angles are correctly signed (consistent coordinate system).

    - Debugging tip. To verify the conversion, compare:

Verifies that the pair of functions:

- `from_vcode_to_list_angles` (encoding: topology → geometry);
- `from_list_angles_to_vcode` (decoding: geometry → topology)
   forms a consistent transformation pipeline where the original
   vertex code is fully recoverable from its angle representation.

## 12.12.Comprehensive consistency check: round‑trip conversion

Demonstrates the consistency of the angle‑based vertex code pipeline through a round‑trip test: `vertex_code → angles → vertex_code`.

### Purpose

Verifies that the pair of functions:

- `from_vcode_to_list_angles` (encoding: topology → geometry);
- `from_list_angles_to_vcode` (decoding: geometry → topology)
forms a consistent transformation pipeline where the original vertex code is fully recoverable from its angle representation.

### Test example

```julia
println("********* комплексная проверка   ***********")
vertex_code = [0, 1, 0, 1, 0, 1]
println("vertex_code: $vertex_code")
result = from_vcode_to_list_angles(vertex_code, 1) |> from_list_angles_to_vcode == vertex_code
println("Round‑trip consistency: $result")

Result of execution:
********* комплексная проверка   ***********
vertex_code: [0, 1, 0, 1, 0, 1]
Round‑trip consistency: true
```

How the pipeline works

    1. Step 1: `from_vcode_to_list_angles(vertex_code, 1)`
        - Input: `vertex_code = [0, 1, 0, 1, 0, 1]`
        - Uses create_carbon_chain (since type = 1) to build the carbon skeleton.
        - Computes bond angles via calc_angles, yielding a vector of ±120∘ values 
          with floating‑point precision (e.g., −120,00000000000004∘, 120,00000000000001∘).
    
    2. Step 2: `from_list_angles_to_vcode(list_angles)`
        - Takes the list of angles from Step 1.
        - Applies sign() to each angle:
            - negative angles (−120∘) → 0;
            - positive angles (+120∘) → 1.
        - Outputs a new vertex code: `[0, 1, 0, 1, 0, 1]`.
    
    3. Comparison: == vertex_code
        - The reconstructed code is compared element‑wise with the original vertex_code.
        - Result: true indicates perfect reconstruction.

Key properties validated by this test
    - Information preservation. The sign of angles fully encodes the topological pattern of the vertex code.
    - Numerical robustness. Floating‑point inaccuracies (e.g., 120,00000000000001∘ vs 120∘) do not affect the result because sign() is insensitive to small deviations.
    - Pipeline consistency. The two functions form a lossless transformation pair for the given encoding scheme.
    - Type safety. Using type = 1 ensures consistent coordinate generation (carbon‑only structures).

Practical implications

A true result confirms:
    - The functions from_vcode_to_list_angles and from_list_angles_to_vcode are correctly implemented.
    - The vertex code representation is minimal and sufficient: it captures all necessary geometric information for reconstruction.

    - The pipeline can be used in workflows requiring:
        - serialization of structural data;
        - transmission of molecular topology via angle descriptors;
        - validation of geometry optimization algorithms (if structure changes, the code will reflect it).

Limitations and assumptions

    - Sign dependence. The pipeline preserves only the sign of angles, not their magnitude. Angles of −179∘ and −90∘ are treated identically (0).
    
    - Coordinate system. Assumes a consistent coordinate system where angle signs are meaningful and stable.
    
    - Graph type. The test uses type = 1 (carbon‑only). For type = 2 (with H), the same logic applies, but coordinate generation involves create_hydrogen_tree.
    
    - Input validity. The vertex code must be valid for the generator functions (create_carbon_chain or create_hydrogen_tree). Malformed codes may cause errors.

All the above functions and functions from the `AllSmartParts` module were used for testing.
