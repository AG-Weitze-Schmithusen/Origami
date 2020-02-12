InstallMethod(String, [IsDessin], function(Origami)
	return Concatenation("Dessin(", String(PermX(Origami)), ", ", String(PermY(Origami)), ")");
end
);

InstallGlobalFunction(NormalDessinsForm, function(sigmaX, sigmaY)
	local orbitElem, ergx, ergy, i, DessinList;
	DessinList := [];	
	ergx := [];
	ergy := [];
	for orbitElem in OrbitsDomain (Group( sigmaX, sigmaY ) ) do
 		Add(ergx, RestrictedPermNC(sigmaX, orbitElem));
 		Add(ergy, RestrictedPermNC(sigmaY, orbitElem));
	od;
	for i in [1..Length(ergx)] do
		Add(DessinList, Dessin(ergx[i], ergy[i]));
	od;
	return DessinList;
end);

InstallGlobalFunction( DessinOfOrigami, function( origami )
	return NormalDessinsForm( HorizontalPerm( origami ), VerticalPerm( origami ) * HorizontalPerm( origami ) * VerticalPerm( origami ) ^(-1) );
end);

InstallMethod(Dessin, [IsPerm, IsPerm] , function(horizontal, vertical)
		local Obj, kind;
		kind:= rec( x := horizontal, y := vertical);
		Obj:= rec();

		ObjectifyWithAttributes( Obj, NewType(DessinFamily, IsDessin and IsAttributeStoringRep) , PermX, kind.x, PermY, kind.y );
		return Obj;
	end
	);

#InstallOtherMethod(Dessin, [CategoryCollections(IsPerm) and IsList, CategoryCollections( IsPerm ) and IsList] ,function(horizontal, vertical)
#		local Obj, kind;
#		kind:= rec( x := horizontal, y := vertical);
#		Obj:= rec();
#
#		ObjectifyWithAttributes( Obj, NewType(DessinFamily, IsDessin and IsAttributeStoringRep) , PermX, kind.x, PermY, kind.y );
#		return Obj;
#	end
#	);

InstallMethod(DegreeDessin, [IsDessin], function( dessin )
	return  Maximum(LargestMovedPoint( PermX( dessin ) ), LargestMovedPoint( PermY( dessin ) )) - Minimum(SmallestMovedPoint( PermX( dessin ) ), SmallestMovedPoint( PermY( dessin ) ) ) + 1;
end);

InstallMethod(ValencyList, [ IsDessin ], function( dessin )
	local whiteValency, blackValency, i, j, counter, current;
	whiteValency := [];
	blackValency := [];
	counter := 1;
	
	for i in [1..Length( CycleStructurePerm( PermX( dessin ) ))] do
		counter := counter + 1;
		if IsBound(CycleStructurePerm( PermX( dessin ) )[i]) then current := CycleStructurePerm( PermX( dessin ) )[i]; else continue; fi;	
		for j in [1..current] do Add(blackValency, counter); od;
		counter := counter + 1;
	od;	
	
	counter := 1;	

	for i in [1..Length( CycleStructurePerm( PermY( dessin ) ))] do
		counter := counter + 1;
		if IsBound(CycleStructurePerm( PermY( dessin ) )[i]) then current := CycleStructurePerm( PermY( dessin ) )[i]; else continue; fi;	
		for j in [1..current] do Add(whiteValency, counter); od;
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
	 counter := 1;
	for i in [1..Length(CycleStructurePerm( ( PermX( dessin ) * PermY( dessin ) )^(-1) ))] do
		counter := counter + 1;
		if IsBound( CycleStructurePerm( ( PermX( dessin ) * PermY( dessin ) )^(-1) )[i] )	= false then continue;	fi;
		for j in [1..i] do h := h + (counter -1); od;

	od;
	h := h - 2 * DegreeDessin( dessin );
	return (h + 2) / 2;
end);

InstallGlobalFunction(AllDessinsOfOrigami, function( origami )
	local VeechAndOrbit, TAct, orbit, current, DessinList, dessin;
	dessin := DessinOfOrigami( origami );
	DessinList := [];
	VeechAndOrbit := CalcVeechGroupAndOrbit( origami );
	TAct := TAction( VeechAndOrbit.VeechGroup );
	orbit := VeechAndOrbit.Orbit;
	for current in Cycles(TAct, [1..Index( VeechAndOrbit.VeechGroup )]) do
		Add( DessinList, DessinOfOrigami( orbit[ current[1] ] ) );
	od;
	return DessinList;
end);
