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

InstallMethod(AsNormalStoredOrigami, [IsOrigami], function(O)
	local G, x, y, Q;
	if IsNormalStoredOrigami(O) then
		return O;
	fi;
	if not IsNormalOrigami(O) then
		Error("Can't convert an origami that is not normal to a 'NormalStoredOrigami'.");
	fi;
	x := HorizontalPerm(O);
	y := VerticalPerm(O);
	G := Group(x, y);
	Q := NormalStoredOrigamiNC(x, y, G);
	if HasStratum(O) then
		SetStratum(Q, Stratum(O));
	fi;
	if HasGenus(O) then
		SetGenus(Q, Genus(O));
	fi;
	if HasVeechGroup(O) then
		SetVeechGroup(Q, VeechGroup(O));
	fi;
	if HasIndexOfMonodromyGroup(O) then
		SetIndexOfMonodromyGroup(Q, IndexOfMonodromyGroup(O));
	fi;
	if HasSumOfLyapunovExponents(O) then
		SetSumOfLyapunovExponents(Q, SumOfLyapunovExponents(O));
	fi;
	return Q;
end);
