# Motivation

Unbranched conjugated polyene hydrocarbons, sometimes called linear polyenes,
are divided into three classes: isomers, conformers of trans isomers, and conformers
 of other isomers. (The isomers have the most practical application.)

However, in all studies on the enumeration of linear polyenes, the enumeration results
 apply to all polyenes without dividing them into classes, which reduces the value of
 the results (see [Cyvin S. J. et all][1],[Cyvin S. J.][2],[Kirby E. C.][3] ).

Most studies on the enumeration of linear polyenes use purely mathematical methods of generating functions, algebraic methods, combinatorial constructions, and methods using the Redfield-Polya theorem.

Apparently, this is why the spatial structure of conformers of other isomers has been relatively poorly studied compared to isomers and conformers of trans isomers.

This formed the goal of this article: to perform a constructive enumeration of linear polyenes separately by isomers, conformers of trans-isomers, and conformers of other isomers, as well as to investigate the spatial structure of conformers of other isomers.

Of particular interest are the molecular graphs of conformers of other isomers that do not have three consecutive edges with a cis configuration. Such graphs are called Yeh graphs in the article [Yeh C. Y.][4], since Chin Yah Yeh provided formulas for enumerating them and believed that they do not exhibit significant steric strain.

To achieve this goal, all necessary algorithms were developed, implemented in the Julia language, and compiled into this package.

[1]:https://doi.org/10.1021/ci00026a012
[2]:https://doi.org/10.1007/BF02281229
[3]:https://doi.org/10.1007/BF01164203
[4]:https://doi.org/10.1063/1.472811
