DeclareGlobalFunction("CycleStructureFromPartition");
DeclareGlobalFunction("CanonicalPermFromCycleStructure");
DeclareGlobalFunction("CanonicalPermFromPartition");
DeclareGlobalFunction("CanonicalPerm");

#! @Arguments Origami, start
#! @Returns An Origami
#! @Description This calculates a canonical representation of an origami depending on a given number start (Between 1 and the degree of
#!        of the Origami). To determine a canonical numbering the algorithm starts at the square with number start and walks over the origami
#!        in a certain way and numbers the squares in the order, they are visited . First it walks in horizontal direction one loop. Then it walks
#!        one step up (in vertical direection) and then again a loop in horizontal direction. This wil be repeated until the vertical
#!        loop is complete or all squares have been visited. If there are unvisited squares, we continue with the smallest number (in
#!        the new numbering), that has not been in a vertical loop. An Origami is connected, so that number exists.
#!  			Two origamis are equal if they are described by the same permutations in their
#!				canonical representation.
#! @ChapterInfo The Origami object, The Origami object
DeclareGlobalFunction("CanonicalOrigamiAndStart");

#! @Arguments Origami
#! @Returns An Origami
#! @Description This calculates a canonical representation of an origami. It calculates the representation from CanonicalOrigamiViaDelecroixAndStart with
#!        several start squares, independent of the given representation. Then it takes the minimum with respect to some order.
#!  			Two origamis are equal if they are described by the same permutations in their
#!				canonical representation.
#! @ChapterInfo The Origami object, The Origami object
DeclareGlobalFunction("CanonicalOrigami");


#! @Arguments Origami
#! @Returns An Origami
#! @Description This calculates a canonical representation of an origami, represented as record rec(d := * , x := *, y := *).
#!  			Two origamis are equal if they are described by the same permutations in their
#!				canonical representation.
#! @ChapterInfo The Origami object, The Origami object
#DeclareGlobalFunction("CanonicalOrigami");

DeclareGlobalFunction("OrigamiNormalForm");

DeclareGlobalFunction("CopyOrigamiInNormalForm");
