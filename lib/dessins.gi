InstallMethod(String, [IsDessin], function(Origami)
	return Concatenation("Dessin(", String(PermX(Origami)), ", ", String(PermY(Origami)), ")");
end);

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
	end);

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

InstallMethod(IsConnectedDessin,[IsDessin], function(dessin)
return(IsTransitive(Group(PermX(dessin), PermY(dessin)), [1.. DegreeDessin(dessin)]));
end);

InstallGlobalFunction(ConnectedComponentsDessin, function(dessin)
local sigmax, sigmay, orbits, conn_comp, o;
sigmax:=PermX(dessin);
sigmay:=PermY(dessin);

if IsConnectedDessin(dessin)
	then return [dessin]; #if the dessin is connected we return the dessin
fi;
orbits:=Orbits(Group(PermX(dessin), PermY(dessin)), [1.. DegreeDessin(dessin)]);
conn_comp:=[];
for o in orbits do #for each orbit Mi we receive a sigmax_i=sigmax|Mi and sigmay_i=sigmay|Mi which are again a dessin
	Add(conn_comp,Dessin(Permutation(sigmax, o), Permutation(sigmay, o)));
od;
return conn_comp;
end);

InstallGlobalFunction(OrigamiGraph, function(O)
local x, y, cycle_list, D, conn_comp, adjacency_matrix, c, i, j;
x:=HorizontalPerm(O);
y:=VerticalPerm(O);
cycle_list:=Orbits(Group(x), MovedPoints(x)); # mit trivialen Zykeln
D:=Dessin(x, y*x*Inverse(y));
conn_comp:=Orbits(Group(PermX(D),PermY(D)), [1.. DegreeDessin(D)]); #decomposing D in connected Components
adjacency_matrix:=NullMat(Length(conn_comp), Length(conn_comp)); #initiating adjecency matrix with dimension being number of connected components
if Length(conn_comp)>1 then # so nicht, Es kann Kanten auf sich selbst geben
for c in cycle_list do
	i:=Position(conn_comp, Filtered(conn_comp, j-> c[1] in j)[1]);
	j:=Position(conn_comp, Filtered(conn_comp, j-> c[1]^y in j)[1]);
	adjacency_matrix[i][j]:=adjacency_matrix[i][j]+1; #there is a edge between the i-th and j-th connected component
od;
fi;
conn_comp:=ConnectedComponentsDessin(D);
conn_comp:=List(conn_comp,i->Genus(i)); #maybe better to return rec?
return [conn_comp, adjacency_matrix]; #returning the weigths of the vertices in the same ordering of the matrix
end);
