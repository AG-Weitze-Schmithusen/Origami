#This functions calculate a complete list of origamis of a given degree up to equivalence. Here we allow disconnected origamis

#calculates a list of all origamis of a given degree
# INPUT degree d
# OUTPUT a list of origamis of degree d
InstallGlobalFunction(CalcOrigamiList, function(d)
	local C, part, Sd, canonicals, canonicals_x, canonicals_y, x;
  part := Partitions(d);
  canonicals := [];
  canonicals_x := List(part, x -> CanonicalPermFromCycleStructure(CycleStructureFromPartition(x)));
	Sd := SymmetricGroup(d);
	for x in canonicals_x do
    	C:=Centralizer(Sd, x);
    	canonicals_y := List( OrbitsDomain(C, Sd, OnPoints), Minimum);
    	Append(canonicals, List(canonicals_y, y -> rec(d := d, x := x, y := y)));
	od;
	return canonicals;
end);




InstallGlobalFunction(OrigamiList, function(d)
	local L;
	L := CalcOrigamiList(d);
	Apply(L, x -> OrigamiNC(x.x, x.y, x.d));
	return Filtered (L, IsConnectedOrigami);
end
);

InstallGlobalFunction(OrigamiListWithStratum, function(d, stratum)
	stratum := AsSortedList(stratum);
	return Filtered( OrigamiList(d), O -> Stratum(O) = stratum );
end);
