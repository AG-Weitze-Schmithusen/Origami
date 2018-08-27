BindGlobal("KinderzeichnungenFamily",NewFamily("Kinderzeichnug"));
DeclareCategory("IsKinderzeichnung", IsObject);

DeclareAttribute("PermX", IsKinderzeichnung);

DeclareAttribute("PermY", IsKinderzeichnung);

BindGlobal(
	"Kinderzeichnung", function(horizontal, vertical)
		local Obj, kind;
		kind:= rec( x := horizontal, y := vertical);
		Obj:= rec();

		ObjectifyWithAttributes( Obj, NewType(KinderzeichnungenFamily, IsKinderzeichnung and IsAttributeStoringRep) , PermX, kind.x, PermY, kind.y );
		return Obj;
	end
	);

	DeclareGlobalFunction("NormalKZForm");
