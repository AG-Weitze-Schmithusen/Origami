BindGlobal("DessinFamily",NewFamily("Dessin"));
DeclareCategory("IsDessin", IsObject);

DeclareAttribute("PermX", IsDessin);

DeclareAttribute("PermY", IsDessin);

DeclareConstructor("Dessin", [IsPerm, IsPerm]);
 
DeclareAttribute("ValenzList", IsDessin);

DeclareGlobalFunction("NormalDessinsForm");

DeclareGlobalFunction("DessinOfOrigami");


