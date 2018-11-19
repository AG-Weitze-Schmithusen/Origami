#The following functions calculate a canonical representation, the "canonical Image", of an origami w.r.t equivalence

#------------------------------ help functions ----------------------------------------------------------------------

#this function calculates the CycleStructure in "GAP-style" from a given partition of a number
#Example partition = [2,2,3,4] => CycleStructureFromPartition([2,2,3,5]) = [2, 1, ,1]
#INPUT A partition of a number
#OUTPUT the Cyclestructure of the partition
InstallGlobalFunction(CycleStructureFromPartition, function(partition)
	local i,  permList, cycleStructure;
  cycleStructure:=[];
  for i in partition do
    if i <> 1 then
      if not IsBound(cycleStructure[i-1]) then
        cycleStructure[i-1]:=1;
      else
        cycleStructure[i-1]:=cycleStructure[i-1]+1;
      fi;
    fi;
  od;
	return cycleStructure;
end);

#calculates the canonical image of a permutation from its cyclestructure
#INPUT the cyclestructure of a permutation
#OUTPUT the canonical image of a permutation
InstallGlobalFunction(CanonicalPermFromCycleStructure, function(cycleStructure)
  local currentIndex, l, numberOfCycle, permList, d, i;
  if IsEmpty(cycleStructure) then
    return ();
  fi;
  currentIndex := 1;
  d:=0;
  for i in [1..Length(cycleStructure)] do
    if IsBound(cycleStructure[i]) then
      d:=d+(cycleStructure[i])*(i+1);
    fi;
  od;
  permList:=[2.. d];
  Add(permList, 1);
  for l in [1..Length(cycleStructure) ] do
    if IsBound(cycleStructure[l]) then
      for numberOfCycle in [1.. cycleStructure[l]] do
        permList[currentIndex + l ]:= currentIndex;
        currentIndex:= currentIndex + l + 1;
      od;
    fi;
  od;
  return PermList(permList);
end);

#calculates the canonical image of a permutation from its suitable partition of a number
#INPUT partition of a permutation
#OUTPUT the canonical image of a permutation
InstallGlobalFunction(CanonicalPermFromPartition, function(part)
    return CanonicalPermFromCycleStructure(CycleStructureFromPartition(part));
end);


#Calculates a canonical image of a permutation
#Input: a permutation perm
#output: the canonical representation of perm
InstallGlobalFunction(CanonicalPerm, function(perm)
	local cycleStructure;
	cycleStructure := CycleStructurePerm( perm );
	return CanonicalPermFromCycleStructure(cycleStructure);
end);

#----------------------------------------------   main function -----------------------------------------------




## Graph equivaltent test
InstallGlobalFunction(OrigamiNormalForm, function(origami)
  local n, i, j, L, Q, seen, numSeen, v, wx, wy, G, minimalCycleLengths,
        minimizeCycleLengths, cycleLengths, m, l, x, y;

	x := HorizontalPerm(origami);
	y := VerticalPerm(origami);
  n := Maximum(LargestMovedPoint([x,y]), 1);

  # Find points which minimize the lengths of the cycles in which they occur.
  # In most cases, this greatly reduces the number of breadths-first searches below.
  minimalCycleLengths := [n, n];
  minimizeCycleLengths := [];
  for i in [1..n] do
    cycleLengths := [CycleLength(x, i), CycleLength(y, i)];
    if cycleLengths = minimalCycleLengths then
      Add(minimizeCycleLengths, i);
    elif cycleLengths < minimalCycleLengths then
      minimizeCycleLengths := [i];
      minimalCycleLengths := cycleLengths;
    fi;
  od;

  m := Length(minimizeCycleLengths);
  G := [];

  # Starting from each of the vertices found above, do a breadth-first search
  # and list the vertices in the order they appear.
  # This defines a permutation l with which we conjugate x and y.
  # From the resulting list of pairs of permutations (all of which are by
  # definition simultaneously conjugated to (x,y)) we choose the lexicographically
  # smallest one as the canonical form.
  for i in minimizeCycleLengths do
    L := ListWithIdenticalEntries(n, 0);
    seen := ListWithIdenticalEntries(n, false);
    Q := [i];
    seen[i] := true;
    numSeen := 1;
    L[i] := 1;
    while numSeen < n do
      v := Remove(Q, 1);
      wx := v^x;
      wy := v^y;
      if not seen[wx] then
        Add(Q, wx);
        seen[wx] := true;
        numSeen := numSeen + 1;
        L[wx] := numSeen;
      fi;
      if not seen[wy] then
        Add(Q, wy);
        seen[wy] := true;
        numSeen := numSeen + 1;
        L[wy] := numSeen;
      fi;
    od;
		Add(G, L);
  od;

  Apply(G, PermList);
  Apply(G, l -> [l^-1 * x * l, l^-1 * y * l]);

  return OrigamiWithoutTest(Minimum(G)[1], Minimum(G)[2], DegreeOrigami(origami) );
end);
