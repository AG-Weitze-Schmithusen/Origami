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

InstallOtherMethod(Dessin, [CategoryCollections(IsPerm) and IsList, CategoryCollections( IsPerm ) and IsList] ,function(horizontal, vertical)
		local Obj, kind;
		kind:= rec( x := horizontal, y := vertical);
		Obj:= rec();

		ObjectifyWithAttributes( Obj, NewType(DessinFamily, IsDessin and IsAttributeStoringRep) , PermX, kind.x, PermY, kind.y );
		return Obj;
	end
	);

InstallMethod(DegreeDessin, [IsDessin], function( dessin )
	return  Maximum(LargestMovedPoint( PermX( dessin ) ), LargestMovedPoint( PermY( dessin ) )) - Minimum(SmallestMovedPoint( PermX( dessin ) ), SmallestMovedPoint( PermY( dessin ) ) ) + 1;
end);

InstallMethod(ValencyList, [ IsDessin ], function( dessin )
	local whiteValency, blackValency, i, j, counter;
	whiteValency := [];
	blackValency := [];
	counter := 2;
	
	for i in CycleStructurePerm( PermX( dessin ) ) do
		for j in [1..i] do Add(blackValency, counter); od;
		counter := counter + 1;
	od;	

	for i in CycleStructurePerm( PermY( dessin ) ) do
		for j in [1..i] do Add(whiteValency, counter); od;
		counter := counter + 1;
	od;	
	return rec( white := whiteValency, black := blackValency);
end);

InstallMethod( Genus, [ IsDessin ], function( dessin ) 
	local h, i, j, counter;
	h := 0;
	for i in ValencyList( dessin ).white do
		h := h + (i - 1);
	od; 

	for i in ValencyList( dessin ).black do
		h := h + (i - 1);
	od;
	 counter := 2;
	for i in CycleStructurePerm( ( PermX( dessin ) * PermY( dessin ) )^(-1) ) do
		for j in [1..i] do h := h + (counter -1); od;
		counter := counter + 1;
	od;
	 
	h := h - 2 * DegreeDessin( dessin );
	return (h + 2) / 2;
end);
