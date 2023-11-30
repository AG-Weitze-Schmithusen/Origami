DeclareOperation("HomologyOrigami", [IsOrigami]); 
DeclareOperation("NonTautPartOfHomologyOrigami", [IsOrigami , IsList]);
DeclareOperation("ActionOfMatrixOnHom", [IsOrigami, IsMatrixObj]);
DeclareOperation("ActionOfMatrixOnNonTaut", [IsOrigami, IsMatrixObj ]);
DeclareOperation("ShadowVeechGroup", [IsOrigami]);
DeclareGlobalFunction("HomologyToString");
