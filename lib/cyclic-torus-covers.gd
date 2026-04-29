#! @Chapter Cyclic Torus Covers
#! @ChapterLabel cyclic-torus-covers
#! Let <M>T_n</M> be the <M>n \times n</M>-Torus. Hence topologically it is a torus with <M>n^2</M> punctures.
#! A **cyclic <M>n</M>-torus cover of degree <M>d</M>\** is a normal covering <M>X \to T_n</M> whose Deck-group is cyclic with <M>d</M> elements.
#! We can obtain an origami from each cyclic <M>n</M>-torus cover by appending the map <M>p_n: T_n \to T_1</M>, which sends each square to the singular square of the
#! trivial torus. We call such origamis **cyclic torus cover origamis**.
#! The functions described in this chapter were programmed and used in the context of  <Cite Key="ba_rogovskyy" /> and provide a toolkit to work with this special class of origamis.

#! @Section Monodromy vectors and bases of the fundamental group
#! A **cyclic <M>n</M>-torus cover of degree <M>d</M>\** is determined by its monodromy map <M>m: \pi_1(T_n) \to &ZZ;/d&ZZ;</M>.
#! Recall that the fundamental group <M>\pi_1(T_n)</M> is a free
#! group in <M>N = n^2 + 1</M> generators. If we choose a basis of <M>\pi_1(T_n)</M>, every cyclic torus cover origami can be
#! described as vector in <M>(&ZZ;/d&ZZ;)^N</M>. We call this vector ** monodromy vector with respect to this basis**.
#! There are two bases (which we will call <M>L</M> and <M>S</M>\) of the fundamental group of <M>T_n</M> which we will use.
#! The base point is chosen as the midpoint of the lower left square.
#! 
#! The basis <M>L</M> consists of the full horizontal path to the right, the full vertical path upwards and
#! loops around each of the <M>n^2 - 1</M> corner points of the squares (numbered left to right and bottom up; the loop on the rightmost upper corner excluded)
#! in this order.
#! 
#! The basis <M>S</M> consists of picking a maximal set of slits between squares such that <M>T_n</M> without these is still simply connected. The crossing of one such
#! slit bottom up (for horizontal slits) and left to right (for vertical slits) is then an element of the basis.
#! 
#! Conversion between these two bases is performed with <Ref Func="BaseChangeLToS" />
#!
#! See <Cite Key="ba_rogovskyy" /> for more information regarding the construction of cyclic torus covers and the bases <M>L</M> and <M>S</M>.

#! @Section General Cyclic Torus Cover functions

#! @Arguments n d vslits hslits
#! @Returns a cyclic torus cover origami
#! @Description
#!  A cyclic torus cover consists of <M>d</M> copies of the trivial origami <M>T_n</M>. Each of the <M>n^2</M> fields of <M>T_n</M>
#!  gets assigned a label from <M>1</M> to <M>n^2</M> row-wise from left to right and bottom up. Let <M>f</M> be a field with the label
#!  <M>k</M> in the <M>i</M>-th copy of the cyclic torus cover. Then <M>f</M>'s right neighbour's label is determined by determining the
#!  usual right neighbour in <M>T_n</M> and its copy is <M>((i+</M> <C>vslits[k]</C><M>) \bmod d)</M>. It works in the same way for the upper neighbour and
#!  <C>hslits</C>.
#! @BeginExampleSession
#! gap> GeneralizedCyclicTorusCover(2, 2, [1,0,0,0], [0,0,0,0]);
#! Origami((1,6,5,2)(3,4)(7,8), (1,3)(2,4)(5,7)(6,8), 8)
#! @EndExampleSession
DeclareGlobalFunction("GeneralizedCyclicTorusCover");

#! @Arguments n x y
#! @Returns a comb origami, which is a cyclic torus cover of degree 2 specified by a single point <M>P=(x,y)</M>
#! @Description A comb origami is a special cyclic torus cover of degree 2, specified by a single point <M>P</M>
#!  on <M>T_n</M>. The coordinates are given in the range <M>{0,..,n-1}^2</M>, where the
#!  point <M>(0,0)</M> is located in the lower left corner. <M>P</M> must not be a 2-torsion point, that is, it must not be
#!  <M>(0,0)</M>, <M>(n/2, n/2)</M>, <M>(n/2,0)</M> or <M>(0,n/2)</M>. The coordinates are considered modulo <M>n</M>. See <Cite Key="comb" /> for more details.
#! @BeginExampleSession
#! gap> CombOrigami(3, 1, 0);
#! Origami((1,2,3)(4,5,6,13,14,15)(7,8,9)(10,11,12)(16,17,18), 
#! (1,4,7)(2,5,8,11,14,17)(3,6,9)(10,13,16)(12,15,18), 18)
#! @EndExampleSession
DeclareGlobalFunction("CombOrigami");

#! @Arguments n p H
#! @Returns a monodromy vector in <M>(&ZZ;/p&ZZ;)^{n^2+1}</M> representing a cyclic torus cover origami with respect to the basis <M>L</M>
#!  that has <M>H</M> as its Veech group or <C>false</C> if no such vector is found.
#! @Description <M>p</M> must be prime. <M>H</M> must be a congruence subgroup of level <M>p</M> and <M>n</M> must be <M>\geq 2</M>.
#! @BeginExampleSession
#! gap> S := [ [ 0, -1 ], [ 1, 0 ] ];; T := [ [ 1, 1 ], [ 0, 1 ] ];;
#! gap> H := ModularSubgroup([S^-2, T*S^-1, T^-1*S^-1]);;
#! gap> SearchForCyclicTorusOrigamiWithVeechGroup(4, 3, H);
#! [ 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 0, 1 ]
#! @EndExampleSession
DeclareGlobalFunction("SearchForCyclicTorusOrigamiWithVeechGroup");

#! @BeginGroup
#! @GroupTitle Cyclic torus cover origamis from monodromy vectors
#! @Arguments n d v
DeclareGlobalFunction("CyclicTorusCoverOrigamiS");

#! @Arguments n d v
#! @Returns a cyclic torus cover origami whose monodromy vector with respect to the basis <M>S</M> (respectively <M>L</M>\) is <M>v</M>.
#! @Description <M>n</M> must be <M>\geq 2</M>, <M>d\geq 1</M> and <M>v \in (&ZZ;/d&ZZ;)^{n^2+1}</M> a vector such that its elements generate <M>&ZZ;/d&ZZ;</M>.
#! @BeginExampleSession
#! gap> CyclicTorusCoverOrigamiS(2,2,[1,0,1,0,0]);
#! Origami((1,2,5,6)(3,4)(7,8), (1,3,5,7)(2,4)(6,8), 8)
#! @EndExampleSession
DeclareGlobalFunction("CyclicTorusCoverOrigamiL");

#! @EndGroup


#! @Section Matrices acting on the homology of the n-Torus
#! Given a homeomorphism <M>f: T_n \to T_n</M>, one can consider the induced linear map on the homology of <M>T_n</M>. If we furthermore choose two bases of the homology, we can consider this linear map as a matrix. This section computes some of these matrices.

#! @Arguments n
#! @Returns a matrix <M>M = D_{SL}</M> representing a change of basis between the bases <M>L</M> and <M>S</M>.
#! @Description Returns a matrix corresponding to the change of basis from <M>L</M> to <M>S</M> on the homology of <M>T_n</M>. The matrix has the following property: given any cyclic torus cover origami as a monodromy vector <M>v</M> with respect to the basis <M>S</M>, you may obtain the corresponding monodromy vector with respect to basis <M>L</M> using <M>v \cdot D_{SL}</M>.
#! @BeginExampleSession
#! gap> Display(BaseChangeLToS(2));
#! [ [   0,   1,   1,  -1,   0 ],
#!   [   0,   0,  -1,   1,   0 ],
#!   [   1,   0,  -1,   0,   1 ],
#!   [   0,   0,   1,   0,  -1 ],
#!   [   0,   1,   0,   0,   1 ] ]
#! @EndExampleSession
DeclareGlobalFunction("BaseChangeLToS");

#! @Arguments n
#! @Returns the group of translations (as matrices) acting on monodromy vectors with respect to <M>L</M>.
#! @Description This group of order <M>n^2</M> is generated by the matrices representing the translation by one square to the right
#!  and the translation by one square up with respect to the basis <M>L</M>.
#! @BeginExampleSession
#! gap> Order(TranslationGroupOnHomologyOfTn(3));
#! 9
#! @EndExampleSession
DeclareGlobalFunction("TranslationGroupOnHomologyOfTn");

#! @Arguments n
#! @Returns a matrix representing the action of the generator <M>T</M> of <M>{\rm SL}_2(&ZZ;)</M> on the homology of <M>T_n</M> with respect to <M>L</M>.
#! @Description The generator <M>T</M> (shearing to the right) of <M>{\rm SL}_2(&ZZ;)</M> can be viewed as an affine map on <M>T_n</M> if we assume that the lower left corner is fixed. This function returns the corresponding map on the homology as a matrix with respect to <M>L</M>.
#! @BeginExampleSession
#! gap> Display(ActionOfTOnHomologyOfTn(2));
#! [ [   1,   1,   0,   0,   0 ],
#!   [   0,   1,   0,   0,   0 ],
#!   [   0,   0,   1,   0,  -1 ],
#!   [   0,   0,   0,   1,  -1 ],
#!   [   0,  -1,   0,   0,  -1 ] ]
#! @EndExampleSession
DeclareGlobalFunction("ActionOfTOnHomologyOfTn");

#! @Arguments n
#! @Returns a matrix representing the action of the generator <M>S</M> of <M>{\rm SL}_2(&ZZ;)</M> on the homology of <M>T_n</M> with respect to <M>L</M>.
#! @Description The generator <M>S</M> (rotation by <M>\pi/2</M> counterclockwise) of <M>{\rm SL}_2(&ZZ;)</M> can be viewed as an affine map on <M>T_n</M> if we assume that the lower left corner is fixed. This function returns the corresponding map on the homology as a matrix with respect to <M>L</M>.
#! @BeginExampleSession
#! gap> Display(ActionOfSOnHomologyOfTn(2));
#! [ [   0,  -1,   0,   0,   0 ],
#!   [   1,   0,   0,   0,   0 ],
#!   [  -1,   0,   1,   0,   0 ],
#!   [   0,   0,   0,   0,   1 ],
#!   [  -1,   0,   0,   1,   0 ] ]
#! @EndExampleSession
DeclareGlobalFunction("ActionOfSOnHomologyOfTn");

#! @Arguments n A
#! @Returns a matrix representing the action of <M>A \in {\rm SL}_2(&ZZ;)</M> on the homology of <M>T_n</M> with respect to <M>L</M>.
#! @Description Any matrix <M>A\in{\rm SL}_2(&ZZ;)</M> can be viewed as an affine map on <M>T_n</M> if we assume that the lower left corner is fixed. <M>A</M> must be in <M>{\rm SL}_2(&ZZ;)</M>. It is written as a word in the generators <M>S</M> and <M>T</M> of <M>{\rm SL}_2(&ZZ;)</M>, then the corresponding
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
DeclareGlobalFunction("ActionOfMatrixOnHomologyOfTn");
