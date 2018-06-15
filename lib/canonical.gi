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

#Calculates the canonical image of an origami
#INPUT: an origami Origami
#OUTPUT: the canonical representation ("image") of the origami Origami
InstallGlobalFunction(CanonicalOrigami, function(O)
	local g,C, y, Sd, Cent;
	Sd:=SymmetricGroup(DegreeOrigami(O));
	C := CanonicalPerm(HorizontalPerm(O));
	g := RepresentativeActionOp(Sd, HorizontalPerm(O), C , OnPoints);
	y := VerticalPerm(O)^g;
	Cent:= Centralizer(Sd,C);
	#y := CanonicalImage(Cent, y, OnPoints);
	y := Minimum( Orbit( Cent, y, OnPoints ) );
	return Origami(C, y, DegreeOrigami(O));
end);

InstallGlobalFunction(CanonicalOrigamiViaDelecroixAndStart, function(O, start)
	local xLoopStart, yLoopStart, NotVisitedY, xlevel, i, newxPerm, newyPerm, renumbering, currentxPosition, currentyPosition, help;
	renumbering := [ ];
	NotVisitedY := [ 1.. DegreeOrigami(O) ];
	xlevel := 0;
	yLoopStart := start;
	currentyPosition := start;
	i := 1;
	while NotVisitedY <> [ ] do
		repeat
			#if i = 2 then i := 1/0; fi; i := i + 1;
			if IsBound( renumbering[ currentyPosition ] ) = false then
				xlevel := xlevel + 1;
				xLoopStart := currentyPosition;
				currentxPosition := xLoopStart;
				renumbering[ xLoopStart ] := xlevel;
				if (currentxPosition ^ HorizontalPerm(O) <> xLoopStart) then
					repeat
						xlevel := xlevel + 1;
#						newxPerm[xlevel - 1] := xlevel;
						renumbering[Position(renumbering, xlevel - 1)^HorizontalPerm(O)] := xlevel;
						currentxPosition := currentxPosition^HorizontalPerm(O);#Position(renumbering, xlevel + 1);
					until currentxPosition^HorizontalPerm(O) = xLoopStart;
				fi;
				#newxPerm[ xlevel - 1] := renumbering[ xLoopStart ];
			fi;
			#if IsBound(renumbering[ currentyPosition^VerticalPerm(O) ]) = false then
				#newyPerm[ renumbering[ currentyPosition ]] := xlevel;
			#else
				#newyPerm[ renumbering[ currentyPosition ] ] := renumbering[currentyPosition^VerticalPerm(O)];
			#fi;
			RemoveSet( NotVisitedY, renumbering[ currentyPosition ]  );
			currentyPosition := currentyPosition ^ VerticalPerm(O);
		until currentyPosition = yLoopStart;#^ VerticalPerm(O) = yLoopStart;

		#Print(renumbering[ currentyPosition ] ); Print("\n");
		#Print(Position(NotVisitedY, renumbering[ currentyPosition ])); Print("\n");
		if IsBound(renumbering[ currentyPosition ]) = false then
					#renumbering[ currentyPosition ] := xlevel + 1;
					RemoveSet( NotVisitedY, xlevel + 1 );
		else
					RemoveSet( NotVisitedY, renumbering[ currentyPosition ] );
		fi;
		#Print(NotVisitedY); Print("\n");
		#Print(currentyPosition); Print("\n");
		#newyPerm
		if NotVisitedY <> [] then
			yLoopStart := Position(renumbering, NotVisitedY[1]);
			if yLoopStart = fail then  Print(" Huhu \n"); fi;
			currentyPosition := yLoopStart;
		fi;
	od;
	#return [ newxPerm, newyPerm, renumbering ];

	newxPerm := PermList(renumbering)^-1 * HorizontalPerm( O ) * PermList(renumbering);
	newyPerm := PermList(renumbering)^-1 * VerticalPerm( O ) * PermList(renumbering);
	return Origami(newxPerm, newyPerm, DegreeOrigami(O));
end);

InstallGlobalFunction(CanonicalOrigamiViaDelecroix, function(O)
	local i, res, resOrigami;
	res := [];
	for i in [1 .. DegreeOrigami(O)] do
		Add(res, CanonicalOrigamiViaDelecroixAndStart(O, i));
	od;
	resOrigami := Minimum( List(res, o -> [HorizontalPerm(o), VerticalPerm(o)]) );
	return Origami(resOrigami[1], resOrigami[2], DegreeOrigami(O));
end);
