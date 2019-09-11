DeclareGlobalFunction("ConnectToOrigamiDB");
DeclareGlobalVariable("ORIGAMI_DB");
DeclareGlobalVariable("ARANGODB_MAX_INT");

DeclareOperation("InsertVeechGroupIntoDB", [IsModularSubgroup]);
DeclareOperation("GetVeechGroupDBEntry", [IsModularSubgroup]);
DeclareOperation("GetVeechGroupsFromDB", [IsRecord]);
DeclareOperation("UpdateVeechGroupDBEntry", [IsModularSubgroup]);
DeclareOperation("RemoveVeechGroupFromDB", [IsModularSubgroup]);

DeclareOperation("InsertOrigamiRepresentativeIntoDB", [IsOrigami]);
DeclareOperation("GetOrigamiOrbitRepresentativeDBEntry", [IsOrigami]);
DeclareOperation("GetOrigamiOrbitRepresentativesFromDB", [IsRecord]);
DeclareOperation("GetAllOrigamiOrbitRepresentativesFromDB", []);
DeclareOperation("UpdateOrigamiOrbitRepresentativeDBEntry", [IsOrigami]);
DeclareOperation("RemoveOrigamiOrbitRepresentativeFromDB", [IsOrigami]);

DeclareOperation("InsertOrigamiWithOrbitRepresentativeIntoDB", [IsOrigami, IsOrigami, IsMatrix]);
DeclareOperation("InsertOrigamiIntoDB", [IsOrigami]);
DeclareOperation("GetOrigamiDBEntry", [IsOrigami]);
DeclareOperation("GetOrigamiOrbit", [IsOrigami]);
DeclareOperation("UpdateRepresentativeOfOrigami", [IsOrigami, IsOrigami]);
DeclareOperation("RemoveOrigamiFromDB", [IsOrigami]);
