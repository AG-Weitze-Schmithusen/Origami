BindGlobal("OrigamiFamily",NewFamily("Origami"));
DeclareCategory("IsOrigami", IsObject);
DeclareOperation("Origami", [IsPerm, IsPerm]);
DeclareOperation("OrigamiNC", [IsPerm, IsPerm]);



DeclareAttribute("HorizontalPerm", IsOrigami);
DeclareAttribute("VerticalPerm", IsOrigami);
DeclareAttribute("DegreeOrigami", IsOrigami);
DeclareAttribute("Stratum", IsOrigami);
DeclareAttribute("Genus", IsOrigami);
DeclareAttribute("IndexOfMonodromyGroup", IsOrigami);
DeclareAttribute("SumOfLyapunovExponents", IsOrigami);
DeclareAttribute("TranslationsOfOrigami", IsOrigami);
DeclareAttribute("IsHyperelliptic", IsOrigami);
DeclareGlobalFunction("CylinderStructure");

DeclareOperation("ComputeVeechGroup", [IsOrigami]);
DeclareOperation("ComputeVeechGroupWithHashTables", [IsOrigami]);
DeclareAttribute("VeechGroup", IsOrigami);
DeclareOperation("VeechGroupAndOrbit", [IsOrigami]);
DeclareGlobalFunction("VeechGroupIsEven");
# this is a hidden attribute only used in the veech group computation
DeclareAttribute("_IndexOrigami", IsOrigami);

DeclareOperation("OrigamisEquivalent", [IsOrigami, IsOrigami]);

DeclareGlobalFunction("NormalformConjugators");
DeclareGlobalFunction("PointReflectionsOfOrigami");
DeclareGlobalFunction("AutomorphismsOfOrigami");
DeclareGlobalFunction("QuasiRegularOrigami");
DeclareGlobalFunction("ContainsNormalSubgroups");
DeclareGlobalFunction("QROFromGroup");
DeclareGlobalFunction("QROFromOrder");
DeclareGlobalFunction("DefinesQuasiRegularOrigami");
DeclareGlobalFunction("FixedPointsOfPointReflections");
DeclareGlobalFunction("FixedPointsOfTranslation");
DeclareGlobalFunction("FixedPointsOfAutomorphism");
DeclareGlobalFunction("OrigamiQuotient");
DeclareGlobalFunction("GenusOfQuotient");
DeclareGlobalFunction("OrigamiSingularities");
