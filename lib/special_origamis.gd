#! @Chapter More special Origamis
#! @ChapterLabel Special-origamis
#! This section lists some additional functions for the construction of some special families of origamis.

#! @Section Functions for constructing special origamis

#! @Arguments d
#! @Returns An Origami
#! @Description
#! This function returns a random origami of degree $d$. It is usually used for testing.
#! As it is randomised over its permutations, the probability distribution is not guaranteed to be uniform on the orbits.
DeclareGlobalFunction("RandomOrigami");
#! @Arguments n
#! @Returns A special origami
#! @Description
#! This function returns special origamis, so called Xorigamis. Xorigamis have degree $2n$.
#! The horizontal permutation is the $2n$-cylce $(1,\ldots, n)$  and the vertical permutation is of the form:
#! $$(1,2)(3,4)..(2n-1,2n)$$
#! @BeginExampleSession
#! gap> XOrigami(2);
#! Origami((1,2,3,4), (1,2)(3,4), 4)
#! @EndExampleSession
DeclareGlobalFunction("XOrigami");

#! @Arguments a b d
#! @Returns A special origami
#! @Description
#! The elevator origami consists of $d$ steps of height $b$ and length $a$.
#! The last step is connected to the first step. 
#! @BeginExampleSession
#! gap>  Elevator(2,0,3);
#! Origami((1,2)(3,5)(4,6), (1,3)(2,4)(5,6), 6)
#! @EndExampleSession
 DeclareGlobalFunction("ElevatorOrigami");

 #! @Arguments a b d
 #! @Returns A special origami
 #! @Description
 #! The staircase origami consists of $d$ steps of height $b$ and length $a$.
  #! @BeginExampleSession
 #! gap> Staircase(2,0,3);
 #! Origami((1,2)(3,4)(5,6), (2,3)(4,5), 6)
 #! @EndExampleSession
DeclareGlobalFunction("StaircaseOrigami");
