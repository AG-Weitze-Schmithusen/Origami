
InstallMethod(String, [IsOrigami], function(Origami)
	return Concatenation("Origami(", String(HorizontalPerm(Origami)), ", ", String(VerticalPerm(Origami)), ", ", String(DegreeOrigami(Origami)), ")");
	end
);


# determines an random origami of a given degree
# INPUT degree d
# OUTPUT a random origami of degree d
InstallGlobalFunction(ExampleOrigami, function (d)
	local x, y;
	repeat
		x:=PseudoRandom(SymmetricGroup(d));
		y:=PseudoRandom(SymmetricGroup(d));
	until IsTransitive(Group(x,y), [1..d]);
	return Origami(x, y, d);
end);



#This function calculates the coset Graph of the Veech group of an given Origami O
#INPUT: An origami O
#OUTPUT: The coset Graph as Permutations sigma_S and Sigma_T
InstallGlobalFunction(CalcVeechGroup, function(O)
	local  sigma, Gen,Rep, HelpCalc, D, M, foundM, W, NewGlList, canonicalOrigamiList, i, j, canonicalM, newReps;
	Gen:= [];
	Rep:= [S*S^-1];
	sigma:=[[],[]];
	canonicalOrigamiList:=[CanonicalOrigami(O)];
	HelpCalc := function(GlList)
		NewGlList := [];
		for W in GlList do
			newReps := [W*T,W*S];
			for j in [1, 2] do
				M := newReps[j];
				foundM := false;
				canonicalM := CanonicalOrigamiViaDelecroix(ActionOfSl(M, O));
				for i in [1..Length(Rep)] do
					if Equals(canonicalOrigamiList[i], canonicalM) then
						D:=Rep[i];
						Add(Gen,  M * D^-1); # D^-1 * M ?
						foundM := true;
						sigma[j][Position(Rep, W)]:=Position(Rep, D);
						break;
					fi;
				od;
				if foundM = false then
					Add(Rep, M);
					Add(canonicalOrigamiList, canonicalM);
					Add(NewGlList, M);
					sigma[j][Position(Rep, W)]:=Position(Rep, M);  # = Length(Rep) -1 ?
				fi;
			od;
		od;
		if Length(NewGlList) > 0 then HelpCalc(NewGlList); fi;
	end;
	HelpCalc([S*S^-1]);
	return [ModularSubgroup(PermList(sigma[2]), PermList(sigma[1])), Rep];
end);

InstallMethod(VeechGroup, "for a origami", [IsOrigami], function(Origami)
	local help;
	help := CalcVeechGroup(Origami);
#	SetCosets(help[2]);
	return help[1];
end);

InstallMethod(Cosets, "for a origami", [IsOrigami], function(Origami)
	local help;
	help := CalcVeechGroup(Origami);
#	SetVeechGroup(help[1]);
	return help[2];
end);


#This function calculates the Stratum of an given Origami
#INPUT: An Origami O
#OUTPUT: The Stratum of the Origami as List of Integers.
InstallGlobalFunction(CalcStratum, function(O)
	local com, Stratum, CycleStructure, current,i, j;
	com:=HorizontalPerm(O)* VerticalPerm(O) * HorizontalPerm(O)^(-1) * VerticalPerm(O)^(-1);
	CycleStructure:= CycleStructurePerm(com);
	Stratum:=[];
	for i in [1..Length(CycleStructure)] do
		if IsBound(CycleStructure[i]) then
			for j in [1..CycleStructure[i]] do
				Add(Stratum, i);
			od;
		fi;
	od;
	SetStratum(O ,Stratum);
end);

InstallGlobalFunction(ToRec, function(O)
	return rec( d:= DegreeOrigami(O), x:= HorizontalPerm(O), y:= VerticalPerm(O));
end);

InstallGlobalFunction(Equals, function(O1, O2)
	if (HorizontalPerm(O1) = HorizontalPerm(O2)) and (VerticalPerm(O1) = VerticalPerm(O2) ) then return true; fi;
	return false;
	end
);

InstallGlobalFunction( KinderzeichnungenFromCuspsOfOrigami, function(O)
	local cycles, kz, index, orbitOrigami;
	kz := [];
	cycles := OrbitsDomain(Group(TAction(VeechGroup(O))), [1..Length(Cosets(O))]);
	for index in [1..Length(cycles)] do
		orbitOrigami := ActionOfSl( Cosets ( O ) [ cycles [ index ][ 1 ] ], O);
		Add(kz, Origami( HorizontalPerm( orbitOrigami ), VerticalPerm( orbitOrigami ) * HorizontalPerm( orbitOrigami ) * VerticalPerm( orbitOrigami )^-1, DegreeOrigami(O) ));
	od;
	return List( kz, o -> OrbitsDomain(Group(HorizontalPerm(o), VerticalPerm(o))));
end);

InstallGlobalFunction( EquivalentOrigami, function(O1, O2)
	return Equals( CanonicalOrigami(O1), CanonicalOrigami(O2));
end
);
