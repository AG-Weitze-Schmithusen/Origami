#! @Chapter Functions for listing Origamis
#! @ChapterLabel Functions for listing Origamis
#! This section describes functions that list or count all origamis with certain properties.

#! @Section Listing Origamis

#! @Arguments d
#! @Returns a list of origamis
#! @Description 
#! This function returns a list of all origamis of degree $d$ up to equivalence.
#! @BeginExampleSession
#! gap> AllOrigamisByDegree(2);
#! [ Origami((), (1,2), 2), Origami((1,2), (), 2), Origami((1,2), (1,2), 2) ]
#! gap> AllOrigamisByDegree(3);
#! [ Origami((), (1,2,3), 3), Origami((1,2), (2,3), 3), Origami((1,2), (1,2,3), 3),
#!   Origami((1,2,3), (), 3), Origami((1,2,3), (2,3), 3),
#!   Origami((1,2,3), (1,2,3), 3), Origami((1,2,3), (1,3,2), 3) ]
#! @EndExampleSession
DeclareGlobalFunction("AllOrigamisByDegree");

#! @Arguments d, strat
#! @Returns a list of origamis
#! @Description 
#! This function returns a list of all origamis of degree $d$ in the given stratum up to equivalence.
#! @BeginExampleSession
#! gap> AllOrigamisInStratum(4, [1,1]);
#! [ Origami((1,2), (1,3)(2,4), 4), Origami((1,2), (1,3,2,4), 4),
#!   Origami((1,2)(3,4), (2,3), 4), Origami((1,2)(3,4), (2,3,4), 4),
#!   Origami((1,2)(3,4), (1,2,3,4), 4), Origami((1,2,3), (2,3,4), 4), 
#!   Origami((1,2,3), (2,4,3), 4), Origami((1,2,3), (1,2)(3,4), 4),
#!   Origami((1,2,3,4), (2,4), 4), Origami((1,2,3,4), (1,2)(3,4), 4) ]
#! @EndExampleSession
DeclareGlobalFunction("AllOrigamisInStratum");

#! @Section Counting Origamis

#! @Arguments d
#! @Returns a positive integer
#! @Description 
#! This function returns the number of origamis of degree $d$ up to equivalence, i.e. the number of subgroups
#! of index $d$ in the free group on 2 generators up to conjugacy.
#! @BeginExampleSession
#! gap> NumberOfOrigamisByDegree(1);
#! 1
#! gap> NumberOfOrigamisByDegree(2);
#! 3
#! gap> NumberOfOrigamisByDegree(3);
#! 7
#! @EndExampleSession
DeclareGlobalFunction("NumberOfOrigamisByDegree");
