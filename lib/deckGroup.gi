InstallMethod( IsElementOfDeckGroup, [IsOrigami, IsPerm], function( origami, sigma )
	local i, p;
	for i in [1.. DegreeOrigami( origami )] do
		if  (i^sigma)^ HorizontalPerm( origami )  <> (i^HorizontalPerm( origami ) ) ^ sigma then return false; fi;
		if  (i^sigma)^ VerticalPerm( origami )  <> (i^VerticalPerm( origami ) ) ^ sigma then return false; fi;
	od;
	return true;
end);



InstallMethod(DeckGroup, [IsOrigami], function( origami )
	local CandidateForDeck, i, deck, Candidate;
	CandidateForDeck := function( origami, j )
		local sigma, SheetsToVisit, current, foundPredecessor, i, tao;
		sigma := [];
		SheetsToVisit := [2.. DegreeOrigami( origami )]; # This should always be a set
		sigma[1] := j;
		while SheetsToVisit <> [] do
			foundPredecessor := false;
			for i in SheetsToVisit do
				for tao in [VerticalPerm( origami ), HorizontalPerm( origami )] do # here we may invert all elements or before the function definition
					if PositionSet( SheetsToVisit , i^(tao^-1) ) = fail  then
						foundPredecessor := true;
						sigma[ i ] := ( sigma[ i^( tao ^ -1 )] )^ tao;
						Remove(SheetsToVisit, Position(SheetsToVisit, i ));
						break;
					fi;
				od;
				if foundPredecessor then break; fi;
			od;
		od;
		return PermList( sigma );
		end;

	deck := [];
	for i in [1..DegreeOrigami( origami )] do
		Candidate := CandidateForDeck( origami, i);
		if Candidate  <> fail and IsElementOfDeckGroup(origami, Candidate) then Add(deck, Candidate); fi;
	od;
	return Group(deck);
end);

InstallMethod( IsNormalOrigami, [IsOrigami], function( origami )
	if Size( DeckGroup( origami ) ) < DegreeOrigami( origami ) then return  false; fi;
	return true;
end);
