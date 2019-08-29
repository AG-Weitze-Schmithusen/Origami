BindGlobal("DessinFamily",NewFamily("Dessin"));
DeclareCategory("IsDessin", IsObject);

DeclareAttribute("PermX", IsDessin);

DeclareAttribute("PermY", IsDessin);

DeclareConstructor("Dessin", [IsPerm, IsPerm]);
 
DeclareAttribute("ValencyList", IsDessin);

DeclareAttribute("Genus", IsDessin);

DeclareGlobalFunction("NormalDessinsForm");

DeclareGlobalFunction("DessinOfOrigami");


DeclareAttribute("DegreeDessin", IsDessin);
