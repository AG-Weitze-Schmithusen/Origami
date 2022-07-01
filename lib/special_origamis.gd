#! @Chapter Special Origamis
#! @ChapterLabel Special-origamis

#! @Section special oriagamis

#! @Arguments d
#! @Returns An Origami
#! @Description
#! This function returns a random origami of degree d. It is usually used for testing.
#! As it is randomized over its permutations the propability distribution is not uniform on the orbits.
DeclareGlobalFunction("RandomOrigami");
#! @Arguments n
#! @Returns A special origami
#! @Description
#! This function returns special origamis, so calles Xorigamis. Xorigamis have degree 2d.
#! The horizontal permutations are trivial and the vertical permutations are of the form:
#! v=(1,2)(3,4)..(2k-1,2k);
DeclareGlobalFunction("XOrigami");
#! @Arguments a b d
#! @Returns A special origami
#! @Description
#! The elevetor origami consists of d steps of height b and length a.
#! Each steps are horizontally connected and the vertical permutations are:
#! v=(a, a+1,..., a+b)(2a+b,2a+b+1,...2a+2b+1)...(da+(d-1)+b,...,d(a+b),1)
 DeclareGlobalFunction("ElevatorOrigami");
 #! @Arguments a b d
 #! @Returns A special origami
 #! @Description
 #! The staircase origami consists of d steps of height b and length a.
 #! Each steps are horizontally connected and the vertical permutations are:
 #! v=(a, a+1,..., a+b+1)(2a+b,2a+b+1,...2a+2b+1)...(da+(d-1)+b,...,d(a+b))
DeclareGlobalFunction("StaircaseOrigami");
