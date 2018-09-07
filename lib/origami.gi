
InstallMethod(String, [IsOrigami], function(Origami)
	return Concatenation("Origami(", String(HorizontalPerm(Origami)), ", ", String(VerticalPerm(Origami)), ", ", String(DegreeOrigami(Origami)), ")");
	end
);

InstallMethod(\=, [IsOrigami, IsOrigami], function(O1, O2)
	return (VerticalPerm(O1) = VerticalPerm(O2)) and (HorizontalPerm(O1) = HorizontalPerm(O2));
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

InstallGlobalFunction(IsConnectedOrigami, function(origami)
	return IsTransitive(Group(HorizontalPerm(origami), VerticalPerm(origami)), [1..DegreeOrigami(origami)]);
end);


#This function calculates the coset Graph of the Veech group of an given Origami O
#INPUT: An origami O
#OUTPUT: The coset Graph as Permutations sigma_S and Sigma_T
InstallGlobalFunction(CalcVeechGroup, function(O)
	local  sigma, Gen,Rep, HelpCalc, D, M, foundM, W, NewGlList, canonicalOrigamiList, i, j, canonicalM, newReps;
	Gen:= [];
	Rep:= [S*S^-1];
	sigma:=[[],[]];
	canonicalOrigamiList := [OrigamiNormalForm(O)];
	HelpCalc := function(GlList)
		NewGlList := [];
		for W in GlList do
			newReps := [W*T,W*S];
			for j in [1, 2] do
				M := newReps[j];
				foundM := false;
				canonicalM := OrigamiNormalForm(ActionOfSl(M, O));
				for i in [1..Length(Rep)] do
					if canonicalOrigamiList[i] = canonicalM then
						D:=Rep[i];
						Add(Gen,  M * D^-1); # D^-1 * M ?
						foundM := true;
						sigma[j][Position(Rep, W)] := Position(Rep, D);
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

InstallGlobalFunction(CalcVeechGroupWithHashTables, function(O)
local  sigma, Gen,Rep, HelpCalc, D, M, foundM, W, NewGlList, canonicalOrigamiList, i, j, canonicalM, newReps, counter, HelpO;
counter := 2;
Gen:= [];
Rep:= [S*S^-1];
sigma:=[[],[]];
canonicalOrigamiList := [];
HelpO := CanonicalOrigami(O);
SetindexOrigami (HelpO, 1);
AddHash(canonicalOrigamiList, HelpO,  hashForOrigamis);
HelpCalc := function(GlList)
	NewGlList := [];
	for W in GlList do
		newReps := [W*T,W*S];
		for j in [1, 2] do
			M := newReps[j];
			canonicalM := OrigamiNormalForm(ActionOfSl(M, O));

			i := ContainHash(canonicalOrigamiList, canonicalM, hashForOrigamis);
			if i = 0 then foundM := false; else foundM := true; fi;

			if foundM then
				D := Rep[i];
				Add(Gen,  M * D^-1);
				sigma[j][Position(Rep, W)] := Position(Rep, D);
			fi;

			if foundM = false then
				Add(Rep, M);
				SetindexOrigami(canonicalM, counter);
				AddHash(canonicalOrigamiList, canonicalM, hashForOrigamis);
				counter := counter + 1;
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

InstallGlobalFunction(CalcVeechGroupViaEquivalentTest,  function(O)
	local  sigma, Gen,Rep, HelpCalc, D, M, foundM, W, NewGlList, OrigamiList, i, j, currentOrigami, newReps;
	Gen := [];
	Rep := [S*S^-1];
	sigma := [[],[]];
	OrigamiList := [O];
	HelpCalc := function(GlList)
		NewGlList := [];
		for W in GlList do
			newReps := [W*T,W*S];
			for j in [1, 2] do
				M := newReps[j];
				foundM := false;
				currentOrigami := ActionOfSl(M, O);
				for i in [1..Length(Rep)] do
					if EquivalentOrigami(OrigamiList[i], currentOrigami)  then
						D := Rep[i];
						Add(Gen,  M * D^-1);
						foundM := true;
						sigma[j][Position(Rep, W)] := Position(Rep, D);
						break;
					fi;
				od;
				if foundM = false then
					Add(Rep, M);
					Add(OrigamiList, currentOrigami);
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

InstallMethod(Genus, "for a origami", [IsOrigami], function(Origami)
	local s, i, e;
	e := 0;
	s := Stratum(Origami);
	for i in s do
		e := e + i;
	od;
	return ( e + 2 ) / 2;
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
InstallMethod(Stratum,"for a origami", [IsOrigami], function(O)
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
	return Stratum;
end);

InstallGlobalFunction(ToRec, function(O)
	return rec( d:= DegreeOrigami(O), x:= HorizontalPerm(O), y:= VerticalPerm(O));
end);


InstallGlobalFunction( KinderzeichnungenFromCuspsOfOrigami, function(O)
	local cycles, kz, index, orbitOrigami;
	kz := [];
	cycles := OrbitsDomain(Group(TAction(VeechGroup(O))), [1..Length(Cosets(O))]);
	for index in [1..Length(cycles)] do
		orbitOrigami := ActionOfSl( Cosets ( O ) [ cycles [ index ][ 1 ] ], O);
		Add(kz,  Kinderzeichnung( HorizontalPerm( orbitOrigami ), VerticalPerm( orbitOrigami ) * HorizontalPerm( orbitOrigami ) * VerticalPerm( orbitOrigami )^-1));
	od;
	return List(kz, NormalKZForm);
end);

InstallGlobalFunction( EquivalentOrigami, function(O1, O2)
	if RepresentativeAction(SymmetricGroup(DegreeOrigami(O1)), [HorizontalPerm(O1), VerticalPerm(O1)],
																			[HorizontalPerm(O2), VerticalPerm(O2)], OnTuples) = fail
		 then return false;
	else
		return true;
	fi;
end
);

InstallGlobalFunction(HasVeechGroupSl_2, function(O)
	if EquivalentOrigami( O, ActionOfS(O) ) then
		if EquivalentOrigami( O, ActionOfT(O)) then
			return true;
		fi;
	fi;
	return false;
end
);
