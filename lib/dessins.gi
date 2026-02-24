InstallMethod(String, [IsDessin], function(dessin)
	return Concatenation("Dessin(", String(BlackPerm(dessin)), ", ", String(WhitePerm(dessin)), ", ",
		String(DegreeDessin(dessin)),  ")");
end);

NormalDessinsForm := function(sigmaB, sigmaW, d)
	local compList, normalComps, D, deg, permB, permW, pi;
	compList := ConnectedComponentsDessin(Dessin(sigmaB, sigmaW, d));
	normalComps := [];
	for D in compList do
		deg := DegreeDessin(D);
		permB := BlackPerm(D);
		permW := WhitePerm(D);
		# bring the permutations into a form such that they only use letters between 1 and deg
		if deg > 1 and MovedPoints( Group( permB, permW ) ) <> [1..deg] then
			pi := MappingPermListList( MovedPoints (Group ( permB, permW ) ), [1..deg]);
			permB := permB^pi;
			permW := permW^pi;
		fi;
		Add(normalComps, Dessin( permB, permW, deg ) );
	od;
	return normalComps;
end;

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
	s1 := Sum(Flat(CycleStructurePerm(BlackPerm(D)))); # all cycles where points are MovedPoints
	s1 := s1 + d - Length(MovedPoints(BlackPerm(D))); # all the points that are not moved are 1-cycles
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
	# We obtain all possible boundary point dessins of O by computing the horizontal dessin of one
	# origami from each cycle in the T action of the Veech group of O. This corresponds to the
	# boundary point dessins in all directions which are eigenvectors of a parabolic element of the
	# Veech group of O.
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

	if IsConnectedDessin(dessin) then
		return [dessin]; # if the dessin is connected we return the dessin
	fi;

	orbits := Orbits(Group(BlackPerm(dessin), WhitePerm(dessin)), [1.. DegreeDessin(dessin)]);
	conn_comp := [];
	# for each orbit Mi we receive a sigmaB_i = sigmaB|Mi and sigmaW_i = sigmaW|Mi which are again a dessin
	for o in orbits do
		Add(conn_comp, Dessin(RestrictedPermNC(sigmaB, o), RestrictedPermNC(sigmaW, o), Length(o)));
	od;
	return conn_comp;
end);

HorizontalDessinOfOrigami := function(O)
	local sigma_x, sigma_y;
	sigma_x := HorizontalPerm(O);
	sigma_y := VerticalPerm(O);
	return Dessin(Inverse(sigma_x), Inverse(sigma_y)*sigma_x*sigma_y, DegreeOrigami(O));
end;

InstallGlobalFunction(OrigamiGraph, function(O)
	local x, y, cycle_list, D, conn_comp, adjacency_matrix, c, i, j, k;
	x := HorizontalPerm(O);
	y := VerticalPerm(O);
	cycle_list := Orbits(Group(x), [1..DegreeOrigami(O)]); # with trivial cycles
	# clockwise pathwise around the singularity
	D := HorizontalDessinOfOrigami(O);
	# decomposing D into connected components
	conn_comp := Orbits(Group(BlackPerm(D), WhitePerm(D)), [1..DegreeDessin(D)]);
	# initializing adjecency matrix with the dimension being number of connected components
	adjacency_matrix := NullMat(Length(conn_comp), Length(conn_comp)); 
	for c in cycle_list do
		# finding the component with the first entry of the cycle,
		# choice of the basepoint above singularity
		i := Position(conn_comp, Filtered(conn_comp, j -> c[1]^y in j)[1]); 
		k := Position(conn_comp, Filtered(conn_comp, j -> c[1] in j)[1]);
		# there is an edge between the i-th and j-th connected component
		adjacency_matrix[i][k] := adjacency_matrix[i][k] + 1; 
	od;
	conn_comp := ConnectedComponentsDessin(D);
	conn_comp := List(conn_comp, i -> Genus(i));
	# returning the weigths of the vertices in the same ordering of the matrix
	return [conn_comp, adjacency_matrix]; 
end);

# analogous to random Origami. Useful for testing, probably not a great distribution - use with caution
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
