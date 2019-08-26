InstallMethod(String, [IsDessin], function(Origami)
	return Concatenation("Dessin(", String(PermX(Origami)), ", ", String(PermY(Origami)), ")");
end
);

InstallGlobalFunction(NormalDessinsForm, function(kinderzeichnung)
	local orbitElem, ergx, ergy;
	ergx := [];
	ergy := [];
	for orbitElem in OrbitsDomain (Group(PermX(kinderzeichnung), PermY(kinderzeichnung))) do
 		Add(ergx, RestrictedPermNC(PermX(kinderzeichnung), orbitElem));
 		Add(ergy, RestrictedPermNC(PermY(kinderzeichnung), orbitElem));
	od;
	return Dessin(ergx, ergy);
end);

InstallGlobalFunction( DessinOfOrigami, function( origami )
	return NormalDessinsForm( Dessin( HorizontalPerm( origami ), VerticalPerm( origami ) * HorizontalPerm( origami ) * VerticalPerm( origami ) ^(-1) ));
end);

InstallMethod(Dessin, [IsPerm, IsPerm] , function(horizontal, vertical)
		local Obj, kind;
		kind:= rec( x := horizontal, y := vertical);
		Obj:= rec();

		ObjectifyWithAttributes( Obj, NewType(DessinFamily, IsDessin and IsAttributeStoringRep) , PermX, [kind.x], PermY, [kind.y] );
		return Obj;
	end
	);

InstallOtherMethod(Dessin, [CategoryCollections(IsPerm) and IsList, CategoryCollections(IsPerm) and IsList] ,function(horizontal, vertical)
		local Obj, kind;
		kind:= rec( x := horizontal, y := vertical);
		Obj:= rec();

		ObjectifyWithAttributes( Obj, NewType(DessinFamily, IsDessin and IsAttributeStoringRep) , PermX, kind.x, PermY, kind.y );
		return Obj;
	end
	);

