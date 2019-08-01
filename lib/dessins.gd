BindGlobal("DessinFamily",NewFamily("Dessin"));
DeclareCategory("IsDessin", IsObject);

DeclareAttribute("PermX", IsDessin);

DeclareAttribute("PermY", IsDessin);

BindGlobal(
	"Dessin", function(horizontal, vertical)
		local Obj, kind;
		kind:= rec( x := horizontal, y := vertical);
		Obj:= rec();

		ObjectifyWithAttributes( Obj, NewType(DessinFamily, IsDessin and IsAttributeStoringRep) , PermX, kind.x, PermY, kind.y );
		return Obj;
	end
	);

	DeclareGlobalFunction("NormalDessinsForm");

DeclareGlobalFunction("DessinOfOrigami");


