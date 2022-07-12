#! @Chapter More special Origamis
#! @ChapterLabel Special-origamis
#! This section lists some additional functions for the construction of some special families of orgamis.

#! @Section Functions for constructing special origamis

#! @Arguments d
#! @Returns An Origami
#! @Description
#! This function returns a random origami of degree $d$. It is usually used for testing.
#! As it is randomized over its permutations, the propability distribution is not guaranteed to be uniform on the orbits.
DeclareGlobalFunction("RandomOrigami");
#! @Arguments n
#! @Returns A special origami
#! @Description
#! This function returns special origamis, so called Xorigamis. Xorigamis have degree $2n$.
#! The horizontal permutation is the $2n$-cylce $(1,\ldots, n)$  and the vertical permutation ist of the form:
#! $$(1,2)(3,4)..(2n-1,2n)$$
#! @BeginExampleSession
#! gap> XOrigami(2);
#! Origami((1,2,3,4), (1,2)(3,4), 4)
#! @EndExampleSession
DeclareGlobalFunction("XOrigami");

#! @Arguments a b d
#! @Returns A special origami
#! @Description
#! The elevetor origami consists of $d$ steps of height $b$ and length $a$.
#! Each steps are horizontally connected and the vertical permutations are:
#! $$(a, a+1,..., a+b)(2a+b,2a+b+1,...2a+2b+1)...(da+(d-1)+b,...,d(a+b),1)$$
#! @BeginExampleSession
#! gap>  Elevator(2,0,3);
#! Origami((1,2)(3,5)(4,6), (1,3)(2,4)(5,6), 6)
#! @EndExampleSession
 DeclareGlobalFunction("ElevatorOrigami");

 #! @Arguments a b d
 #! @Returns A special origami
 #! @Description
 #! The staircase origami consists of $d$ steps of height $b$ and length $a$.
 #! Each steps are horizontally connected and the vertical permutations are:
 #! $$(a, a+1,..., a+b+1)(2a+b,2a+b+1,...2a+2b+1)...(da+(d-1)+b,...,d(a+b))$$
 #! @BeginExampleSession
 #! gap> Staircase(2,0,3);
 #! Origami((1,2)(3,4)(5,6), (2,3)(4,5), 6)
 #! @EndExampleSession
DeclareGlobalFunction("StaircaseOrigami");
