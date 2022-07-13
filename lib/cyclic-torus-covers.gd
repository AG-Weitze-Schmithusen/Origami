#! @Chapter Cyclic Torus Covers
#! @ChapterLabel cyclic-torus-covers
#! Let $T_n$ be the $n \times n$-Torus. Hence topolgically it is torus with $n^2$ punctures.
#! A **cyclic $n$-torus cover of degree $d$** is a normal covering $X \to T_n$ whose Deck-group is cyclic with $d$ elements.
#! We can obtain an origami from each cyclic $n$-torus cover by appending the map $p_n: T_n \to T_1$, which sends each square to the singular square of the
#! trivial torus. We call such origamis **cyclic torus cover origamis**.
#! The functions described in this chapter were programed and used in the context of  <Cite Key="ba_rogovskyy" /> and provide a toolkit to work with these special class of origamis.

#! @Section Monodromy vectors and bases of the fundamental group
#! A **cyclic $n$-torus cover of degree $d$** is determined by its monodromy map $m: \pi_1(T_n) \to \mathbb{Z}/d\mathbb{Z}$.
#! Recall that the fundametal group $\pi_1(T_n)$ is a free
#! group in $N = n^2 + 1$ generators. If we choose a basis of $\pi_1(T_n)$, every cyclic torus cover origami can be
#! described as vector in $(\mathbb{Z}/d\mathbb{Z})^N$. We call this vector ** monodromy vector with respect to this basis**.
#! There are two bases (which we will call $L$ and $S$) of the fundamental group of $T_n$ which we will use.
#! The base point is chosen as the midpoint of the lower left square.
#! 
#! The basis $L$ consists of the full horizontal path to the right, the full vertical path upwards and
#! loops around each of the $n^2 - 1$ corner points of the squares (numbered left to right and bottom up; the loop on the most upper right corner excluded)
#! in this order.
#! 
#! The basis $S$ consists of picking a maximal set of slits between squares such that $T_n$ without these is still simply connected. The crossing of one such
#! slit bottom up (for horizontal slits) and left to right (for vertical slits) is then an element of the basis.
#! 
#! Convertion between these two bases is performed with <Ref Func="BaseChangeLToS" />
#!
#! See <Cite Key="ba_rogovskyy" /> for more information regarding the construction of cyclic torus covers and the bases $L$ and $S$.

#! @Section General Cyclic Torus Cover functions

#! @Arguments n d vslits hslits
#! @Returns a cyclic torus cover origami
#! @Description
#!  A cyclic torus cover consists of $d$ copies of the trivial origami $T_n$. Each of the $n^2$ fields of $T_n$
#!  gets assigned a label from $1$ to $n^2$ row-wise from left to right and bottom up. Let $f$ be a field with the label
#!  $k$ in the $i$-th copy of the cyclic torus cover. Then $f$'s right neighbour's label is determined by determining the
#!  usual right neighbour in $T_n$ and its copy is $((i+\texttt{vslits[k]}) \bmod d)$. It works in the same way for the upper neighbour and
#!  $\texttt{hslits}$.
#! @BeginExampleSession
#! gap> GeneralizedCyclicTorusCover(2, 2, [1,0,0,0], [0,0,0,0]);
#! Origami((1,6,5,2)(3,4)(7,8), (1,3)(2,4)(5,7)(6,8), 8)
#! @EndExampleSession
DeclareGlobalFunction("GeneralizedCyclicTorusCover");

#! @Arguments n x y
#! @Returns a comb origami, which is a cyclic torus cover of degree 2 specified by a single point $P=(x,y)$
#! @Description A comb origami is a special cyclic torus cover of degree 2, specified by a single point $P$
#!  on $T_n$. The coordinates are given in the range ${0,..,n-1}^2$, where the
#!  point $(0,0)$ is located in the lower left corner. $P$ must not be a 2-torsion point, that is, it must not be
#!  $(0,0)$, $(n/2, n/2)$, $(n/2,0)$ or $(0,n/2)$. The coordinates are considered modulo $n$. See <Cite Key="comb" /> for more details.
#! @BeginExampleSession
#! gap> CombOrigami(3, 1, 0);
#! Origami((1,2,3)(4,5,6,13,14,15)(7,8,9)(10,11,12)(16,17,18), 
#! (1,4,7)(2,5,8,11,14,17)(3,6,9)(10,13,16)(12,15,18), 18)
#! @EndExampleSession
DeclareGlobalFunction("CombOrigami");

#! @Arguments n p H
#! @Returns a monodromy vector in $(\mathbb{Z}/p\mathbb{Z})^{n^2+1}$ representing a cyclic torus cover origami with respect to the basis $L$
#!  that has $H$ as its Veech group or $\texttt{false}$ if no such vector is found.
#! @Description $p$ must be prime. $H$ must be a congruence subgroup of level $p$ and $n$ must be $\geq 2$.
#! @BeginExampleSession
#! gap> S := [ [ 0, -1 ], [ 1, 0 ] ];; T := [ [ 1, 1 ], [ 0, 1 ] ];;
#! gap> H := ModularSubgroup([S^-2, T*S^-1, T^-1*S^-1]);;
#! gap> SearchForCyclicTorusOrigamiWithVeechGroup(4, 3, H);
#! [ 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 0, 1 ]
#! @EndExampleSession
DeclareGlobalFunction("SearchForCyclicTorusOrigamiWithVeechGroup", [IsPosInt, IsPosInt, IsMatrixGroup]);

#! @BeginGroup
#! @GroupTitle Cyclic torus cover origamis from monodromy vectors
#! @Arguments n d v
DeclareGlobalFunction("CyclicTorusCoverOrigamiS", [IsPosInt, IsPosInt, IsRowVector]);

#! @Arguments n d v
#! @Returns a cyclic torus cover origami whose monodromy vector with respect to the basis $S$ (respectively $L$) is $v$.
#! @Description $n$ must be $\geq 2$, $d\geq 1$ and $v \in (\mathbb{Z}/d\mathbb{Z})^{n^2+1}$ a vector such that its elements generate $\mathbb{Z}/d\mathbb{Z}$.
#! @BeginExampleSession
#! gap> CyclicTorusCoverOrigamiS(2,2,[1,0,1,0,0]);
#! Origami((1,2,5,6)(3,4)(7,8), (1,3,5,7)(2,4)(6,8), 8)
#! @EndExampleSession
DeclareGlobalFunction("CyclicTorusCoverOrigamiL", [IsPosInt, IsPosInt, IsRowVector]);

#! @EndGroup


#! @Section Matrices acting on the homology of the n-Torus
#! Given a homeomorphism $f: T_n \to T_n$, one can consider the induced linear map on the homology of $T_n$. If we furthermore choose two bases of the homology, we can consider this linear map as a matrix. This section computes some of these matrices.

#! @Arguments n
#! @Returns a matrix $M = D_{SL}$ representing a change of basis between the bases $L$ and $S$.
#! @Description Returns a matrix corresponding to the change of basis from $L$ to $S$ on the homology of $T_n$. The matrix has the following property: given any cyclic torus cover origami as a monodromy vector $v$ with respect to the basis $S$, you may obtain the corresponding monodromy vector with respect to basis $L$ using $v \cdot D_{SL}$.
#! @BeginExampleSession
#! gap> Display(BaseChangeLToS(2));
#! [ [   0,   1,   1,  -1,   0 ],
#!   [   0,   0,  -1,   1,   0 ],
#!   [   1,   0,  -1,   0,   1 ],
#!   [   0,   0,   1,   0,  -1 ],
#!   [   0,   1,   0,   0,   1 ] ]
#! @EndExampleSession
DeclareGlobalFunction("BaseChangeLToS", [IsPosInt]);

#! @Arguments n
#! @Returns the group of translations (as matrices) acting on monodromy vectors with respect to $L$.
#! @Description This group of order $n^2$ is generated by the matrices representing the translation by one square to the right
#!  and the translation by one square up with respect to the basis $L$.
#! @BeginExampleSession
#! gap> Order(TranslationGroupOnHomologyOfTn(3));
#! 9
#! @EndExampleSession
DeclareGlobalFunction("TranslationGroupOnHomologyOfTn", [IsPosInt]);

#! @Arguments n
#! @Returns a matrix representing the action of the generator $T$ of $\mathrm{Sl}_2(\mathbb{Z})$ on the homology of $T_n$ with respect to $L$.
#! @Description The generator $T$ (shearing to the right) of $\mathrm{Sl}_2(\mathbb{Z})$ can be viewed as an affine map on $T_n$ if we assume that the lower left corner is fixed. This function returns the corresponding map on the homology as a matrix with respect to $L$.
#! @BeginExampleSession
#! gap> Display(ActionOfTOnHomologyOfTn(2));
#! [ [   1,   1,   0,   0,   0 ],
#!   [   0,   1,   0,   0,   0 ],
#!   [   0,   0,   1,   0,  -1 ],
#!   [   0,   0,   0,   1,  -1 ],
#!   [   0,  -1,   0,   0,  -1 ] ]
#! @EndExampleSession
DeclareGlobalFunction("ActionOfTOnHomologyOfTn", [IsPosInt]);

#! @Arguments n
#! @Returns a matrix representing the action of the generator $S$ of $\mathrm{Sl}_2(\mathbb{Z})$ on the homology of $T_n$ with respect to $L$.
#! @Description The generator $S$ (rotation by $\pi/2$ counterclockwise) of $\mathrm{Sl}_2(\mathbb{Z})$ can be viewed as an affine map on $T_n$ if we assume that the lower left corner is fixed. This function returns the corresponding map on the homology as a matrix with respect to $L$.
#! @BeginExampleSession
#! gap> Display(ActionOfSOnHomologyOfTn(2));
#! [ [   0,  -1,   0,   0,   0 ],
#!   [   1,   0,   0,   0,   0 ],
#!   [  -1,   0,   1,   0,   0 ],
#!   [   0,   0,   0,   0,   1 ],
#!   [  -1,   0,   0,   1,   0 ] ]
#! @EndExampleSession
DeclareGlobalFunction("ActionOfSOnHomologyOfTn", [IsPosInt]);

#! @Arguments n A
#! @Returns a matrix representing the action of $A \in \mathrm{Sl}_2(\mathbb{Z})$ on the homology of $T_n$ with respect to $L$.
#! @Description Any matrix $A\in\mathrm{Sl}_2(\mathbb{Z})$ can be viewed as an affine map on $T_n$ if we assume that the lower left corner is fixed. $A$ must be in $\mathrm{Sl}_2(\mathbb{Z})$. It is written as a word in the generators $S$ and $T$ of $\mathrm{Sl}_2(\mathbb{Z})$, then the corresponding
#!  word with the matrices calculated by <Ref Func="ActionOfTOnHomologyOfTn" /> and <Ref Func="ActionOfSOnHomologyOfTn" /> is taken and returned.
#! @BeginExampleSession
#! gap> M := [ [ 0, -1 ], [ 1, 1 ] ];; # = S * T
#! gap> Display(ActionOfMatrixOnHomologyOfTn(2, M));
#! [ [   0,  -1,   0,   0,   0 ],
#!   [   1,   1,   0,   0,   0 ],
#!   [  -1,  -1,   1,   0,  -1 ],
#!   [   0,  -1,   0,   0,  -1 ],
#!   [  -1,  -1,   0,   1,  -1 ] ]
#! @EndExampleSession
DeclareGlobalFunction("ActionOfMatrixOnHomologyOfTn", [IsPosInt, IsMatrix]);
