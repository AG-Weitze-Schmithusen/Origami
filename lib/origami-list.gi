#This functions calculate a complete list of origamis of a given degree up to equivalence. Here we allow disconnected origamis



# the following two functions divide the last function

# calculates all origamis O with a fixed O.x
# INPUT the permutation perm and degee d
# OUTPUT a list of all origamis O s.t. O.x = perm
InstallGlobalFunction(CalcOrigamiListForx, function(permx, d)
  local Sd, C, canonicals_y, partOfCanonicals;
  partOfCanonicals:=[];
  Sd := SymmetricGroup(d);
  C:=Centralizer(Sd, permx);
  canonicals_y := List( OrbitsDomain(C, Sd, OnPoints), Minimum);
	Append(partOfCanonicals, List(canonicals_y, y -> rec(d := d, x := permx, y := y)));
	return partOfCanonicals;
end);



#calculates a list of origamis of a given degree. Here by partition into the orbits of the conjugation of the cenralizer, we first partition Sd in the orbits of conjugation with
#the whoole Sd
# INPUT degree d
# OUTPUT a list of origamis of degree d
InstallGlobalFunction(CalcOrigamiList, function(d)
	local C, part, Sd, canonicals, canonicals_x, canonicals_y, x, i, conjugacyClassesOfx, conjugacyClassOfx;
  part := Partitions(d);
  canonicals := [];
  canonicals_x := List(part, x -> CanonicalPermFromCycleStructure(CycleStructureFromPartition(x)));
	Sd := SymmetricGroup(d);
  conjugacyClassesOfx := List( canonicals_x, x -> Set(Enumerate(Orb(Sd,x,OnPoints))) );
  #  make entries of conjugacyClassesOfx readonly
	Perform(conjugacyClassesOfx, MakeImmutable);
  # make sure the entries store that they are sorted lists
	Perform(conjugacyClassesOfx, IsSSortedList);
  for x in canonicals_x do
		C:=Centralizer(Sd, x);
    for i in [1..Length(canonicals_x)] do
      conjugacyClassOfx := conjugacyClassesOfx[i];
      canonicals_y := List( OrbitsDomain(C, conjugacyClassOfx, OnPoints), Minimum);
      Append(canonicals, List(canonicals_y, y -> rec(d := d, x := x, y := y)));
    od;
	od;
	return canonicals;
end);






InstallGlobalFunction(OrigamiList, function(d)
	local L;
	L := CalcOrigamiListExperiment(d);
	Apply(L, x -> OrigamiWithoutTest(x.x, x.y, x.d));
	return Filtered (L, IsConnectedOrigami);
end
);

InstallGlobalFunction(OrigamiListWithStratum, function(d, stratum)
	stratum := AsSortedList(stratum);
	return Filtered( OrigamiList(d), O -> Stratum(O) = stratum );
end);
