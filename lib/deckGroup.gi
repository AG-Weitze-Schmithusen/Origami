InstallMethod(IsElementOfDeckGroup, [IsOrigami, IsPerm], function(origami, sigma)
	local i, p;
	for i in [1..DegreeOrigami(origami)] do
		if  (i^sigma)^ HorizontalPerm(origami)  <> (i^HorizontalPerm(origami)) ^ sigma then return false; fi;
		if  (i^sigma)^ VerticalPerm(origami)  <> (i^VerticalPerm(origami)) ^ sigma then return false; fi;
	od;
	return true;
end);

InstallMethod(DeckGroup, [IsOrigami], function(O)
	local CandidateForDeck, i, deck, Candidate;
	CandidateForDeck := function(origami, j)
		local sigma, SheetsToVisit, current, foundPredecessor, i, tau;
		sigma := [];
		SheetsToVisit := [2..DegreeOrigami(origami)];
		sigma[1] := j;
		while Length(SheetsToVisit) > 0 do
			foundPredecessor := false;
			for i in SheetsToVisit do
				for tau in [HorizontalPerm(origami), VerticalPerm(origami)] do
					if PositionSet(SheetsToVisit, i^(tau^-1)) = fail  then
						foundPredecessor := true;
						sigma[i] := (sigma[i^( tau^-1)])^tau;
						Remove(SheetsToVisit, Position(SheetsToVisit, i));
						break;
					fi;
				od;
				if foundPredecessor then break; fi;
			od;
		od;
		return PermList(sigma);
	end;

	deck := [];
	for i in [1..DegreeOrigami(O)] do
		Candidate := CandidateForDeck(O, i);
		if Candidate  <> fail and IsElementOfDeckGroup(O, Candidate) then Add(deck, Candidate); fi;
	od;
	return Group(deck);
end);

InstallMethod(IsNormalOrigami, [IsOrigami], function(origami)
	if Size(DeckGroup(origami)) < DegreeOrigami(origami) then return false; fi;
	return true;
end);
