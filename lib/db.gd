DeclareGlobalFunction("ConnectToOrigamiDB");
DeclareGlobalVariable("ORIGAMI_DB");

DeclareOperation("InsertVeechGroupIntoDB", [IsModularSubgroup]);
DeclareOperation("GetVeechGroupDBEntry", [IsModularSubgroup]);
DeclareOperation("GetVeechGroups", [IsRecord]);
DeclareOperation("UpdateVeechGroupDBEntry", [IsModularSubgroup]);
DeclareOperation("RemoveVeechGroupFromDB", [IsModularSubgroup]);

DeclareOperation("InsertOrigamiRepresentativeIntoDB", [IsOrigami]);
DeclareOperation("GetOrigamiOrbitRepresentativeDBEntry", [IsOrigami]);
DeclareOperation("GetAllOrigamiOrbitRepresentatives", []);
DeclareOperation("GetOrigamiOrbitRepresentatives", [IsRecord]);
DeclareOperation("UpdateOrigamiOrbitRepresentativeDBEntry", [IsOrigami]);
DeclareOperation("RemoveOrigamiOrbitRepresentativeFromDB", [IsOrigami]);

DeclareOperation("InsertOrigamiWithOrbitRepresentativeIntoDB", [IsOrigami, IsOrigami]);
DeclareOperation("InsertOrigamiIntoDB", [IsOrigami]);
DeclareOperation("GetOrigamiDBEntry", [IsOrigami]);
DeclareOperation("GetOrigamiOrbit", [IsOrigami]);
