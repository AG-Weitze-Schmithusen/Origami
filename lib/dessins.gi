InstallMethod(String, [IsDessin], function(dessin)
	return Concatenation("Dessin(", String(BlackPerm(dessin)), ", ", String(WhitePerm(dessin)), ", ",
		String(DegreeDessin(dessin)),  ")");
end);

InstallGlobalFunction(NormalDessinsForm, function(sigmaB, sigmaW, d)
	local orbitElem, ergB, ergW, points, i, DessinList;
	DessinList := [];
	ergB := [];
	ergW := [];
	points := Set([1..d]);
	# fixed points that will lead to trivial connected components
	SubtractSet(points, MovedPoints( Group( sigmaB, sigmaW ) ));
	for orbitElem in OrbitsDomain (Group( sigmaB, sigmaW ) ) do
 		Add(ergB, RestrictedPermNC(sigmaB, orbitElem));
 		Add(ergW, RestrictedPermNC(sigmaW, orbitElem));
	od;
	for i in [1..Length(ergB)] do
		d := Length(MovedPoints(Group(ergB[i], ergW[i])));
		Add(DessinList, Dessin(ergB[i], ergW[i], d));
	od;
	for i in points do
		Add(DessinList, Dessin((), (), 1));
	od;
	return DessinList;
end);

InstallGlobalFunction( DessinOfOrigami, function( origami )
	return NormalDessinsForm( Inverse(HorizontalPerm( origami )),
		VerticalPerm( origami ) ^(-1) * HorizontalPerm( origami ) * VerticalPerm( origami ),
		DegreeOrigami(origami) );
end);

InstallMethod(Dessin, [IsPerm, IsPerm, IsPosInt] , function(black, white, d)
	local Obj, kind;
	kind:= rec( b := black, w := white, d := d);
	Obj:= rec();

	ObjectifyWithAttributes( Obj, NewType(DessinFamily, IsDessin and IsAttributeStoringRep) , BlackPerm,
		kind.b, WhitePerm, kind.w, DegreeDessin, kind.d);
	return Obj;
end);

#InstallOtherMethod(Dessin, [CategoryCollections(IsPerm) and IsList, CategoryCollections( IsPerm ) and IsList] ,function(black, white)
#		local Obj, kind;
#		kind:= rec( b := black, w := white);
#		Obj:= rec();
#
#		ObjectifyWithAttributes( Obj, NewType(DessinFamily, IsDessin and IsAttributeStoringRep) , BlackPerm, kind.b, WhitePerm, kind.w );
#		return Obj;
#	end
#	);

# InstallMethod(DegreeDessin, [IsDessin], function( dessin )
# 	return  Maximum(LargestMovedPoint( BlackPerm( dessin ) ), LargestMovedPoint( WhitePerm( dessin ) )) - Minimum(SmallestMovedPoint( BlackPerm( dessin ) ), SmallestMovedPoint( WhitePerm( dessin ) ) ) + 1;
# end);

InstallMethod(ValencyList, [ IsDessin ], function( dessin )
	local blackValency, whiteValency, d;
	d := DegreeDessin(dessin);
	blackValency := CycleLengths(BlackPerm(dessin), [1..d]);
	whiteValency := CycleLengths(WhitePerm(dessin), [1..d]);
	return rec( black := blackValency, white := whiteValency);
end);

InstallMethod( Genus, [ IsDessin ], function( D )
	local s1, s2, f, d, xi;
	d := DegreeDessin(D);
	s1 := Sum(Flat(CycleStructurePerm(BlackPerm(D)))); #all Cycles where points are MovedPoints
	s1 := s1 + d - Length(MovedPoints(BlackPerm(D))); #all the points that are not moved are 1- cycles
	s2 := Sum(Flat(CycleStructurePerm(WhitePerm(D))));
	s2 := s2 + d - Length(MovedPoints(WhitePerm(D)));
	f := Sum(Flat(CycleStructurePerm(WhitePerm(D) * BlackPerm(D))));
	f := f+ d-Length(MovedPoints(WhitePerm(D) * BlackPerm(D)));
	xi := s1 + s2 + f - d;
	return (2 - xi) / 2;
end);

InstallGlobalFunction(AllDessinsOfOrigami, function( origami )
	local VeechAndOrbit, TAct, orbit, current, DessinList, dessin;
	dessin := DessinOfOrigami( origami );
	DessinList := [];
	VeechAndOrbit := VeechGroupAndOrbit( origami );
	TAct := TAction( VeechAndOrbit.veech_group );
	orbit := VeechAndOrbit.orbit;
	for current in Cycles(TAct, [1..Index( VeechAndOrbit.veech_group )]) do
		Add( DessinList, DessinOfOrigami( orbit[ current[1] ] ) );
	od;
	return DessinList;
end);

InstallMethod(IsConnectedDessin,[IsDessin], function(dessin)
	return IsTransitive(Group(BlackPerm(dessin), WhitePerm(dessin)), [1.. DegreeDessin(dessin)]);
end);

InstallGlobalFunction(ConnectedComponentsDessin, function(dessin)
	local sigmaB, sigmaW, orbits, conn_comp, o;
	sigmaB := BlackPerm(dessin);
	sigmaW := WhitePerm(dessin);

	if sigmaB = () and sigmaW = () then
		return [dessin];
	fi;

	if IsConnectedDessin(dessin) then
		return [dessin]; #if the dessin is connected we return the dessin
	fi;

	orbits := Orbits(Group(BlackPerm(dessin), WhitePerm(dessin)), [1.. DegreeDessin(dessin)]);
	conn_comp := [];
	#for each orbit Mi we receive a sigmaB_i = sigmaB|Mi and sigmaW_i = sigmaW|Mi which are again a dessin
	for o in orbits do
		Add(conn_comp, Dessin(RestrictedPermNC(sigmaB, o), RestrictedPermNC(sigmaW, o), Length(o)));
	od;
	return conn_comp;
end);

InstallGlobalFunction(OrigamiGraph, function(O)
	local x, y, cycle_list, D, conn_comp, adjacency_matrix, c, i, j, k;
	x := HorizontalPerm(O);
	y := VerticalPerm(O);
	cycle_list := Orbits(Group(x), [1..DegreeOrigami(O)]); #with trivial cycles
	#counterclockwise pathwise around the singularity
	D := Dessin(Inverse(x), Inverse(y)*x*y, DegreeOrigami(O));
	#decomposing D into connected components
	conn_comp := Orbits(Group(BlackPerm(D), WhitePerm(D)), [1..DegreeDessin(D)]);
	#initializing adjecency matrix with the dimension being number of connected components
	adjacency_matrix := NullMat(Length(conn_comp), Length(conn_comp)); 
	for c in cycle_list do
		#finding the component with the first entry of the cycle, choice of the basepoint above singularity
		i := Position(conn_comp, Filtered(conn_comp, j -> c[1]^y in j)[1]); 
		k := Position(conn_comp, Filtered(conn_comp, j -> c[1] in j)[1]);
		#there is an edge between the i-th and j-th connected component
		adjacency_matrix[i][k] := adjacency_matrix[i][k] + 1; 
	od;
	conn_comp := ConnectedComponentsDessin(D);
	conn_comp := List(conn_comp, i -> Genus(i));
	#returning the weigths of the vertices in the same ordering of the matrix
	return [conn_comp, adjacency_matrix]; 
end);

#analogous to random Origami. Useful for testing, probably not a great distribution - use with caution
RandomDessin := function(d) 
local sigmaB, sigmaW, S_d;
	S_d := SymmetricGroup(d);
	sigmaB := Random(GlobalMersenneTwister, S_d);
	sigmaW := Random(GlobalMersenneTwister, S_d);
	while not IsTransitive(Group(sigmaB, sigmaW), [1..d]) do
		sigmaW := Random(GlobalMersenneTwister, S_d);
	od;
return Dessin(sigmaB, sigmaW, d);
end;

HorizontalDessinOfOrigami := function(O)
	local sigma_x, sigma_y;
	sigma_x := HorizontalPerm(O);
	sigma_y := VerticalPerm(O);
	return Dessin(Inverse(sigma_x), Inverse(sigma_y)*sigma_x*sigma_y, DegreeOrigami(O));
end;
