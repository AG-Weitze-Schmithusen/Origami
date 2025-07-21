DeclareGlobalFunction("AllOrigamisByDegree");
DeclareGlobalFunction("AllOrigamisInStratum");

#! @Arguments d
#! @Returns The number of origamis of degree d up to equivalence.
#! @Description 
#! This number equals the number of subgroups of index d in free group on 2 generators up to conjugacy.
#! The backend of this procedure works within that setting.
#! - There is 1 degree 1 origami and hence 1 equivalence class.
#! - The equivalence classes of degree 2 origamis can by represented by {(id, id), (id, (1, 2)), ((1, 2), (1, 2))}.
#! - Of degree 3 origamis by {(id, (1, 2, 3)), ((1, 2), (1, 3)), ((1, 2), (1, 2, 3)), ((1, 2, 3), id), ((1, 2, 3), (1, 2)), ((1, 2, 3), (1, 2, 3)), ((1, 2, 3), (3, 2, 1))}.
#! @BeginExampleSession
#! gap> NumberOfOrigamisByDegree(1);
#! 1
#! gap> NumberOfOrigamisByDegree(2);
#! 3
#! gap> NumberOfOrigamisByDegree(3);
#! 7
#! @EndExampleSession
DeclareGlobalFunction("NumberOfOrigamisByDegree");
