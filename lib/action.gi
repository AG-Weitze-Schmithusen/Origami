InstallMethod(ActionOfS, [IsOrigami], function(O)
	# we have: S.(sigma_x, sigma_y) = (sigma_y^-1, sigma_x)
	return OrigamiNC(VerticalPerm(O)^(-1), HorizontalPerm(O), DegreeOrigami(O));
end);

InstallMethod(ActionOfT, [IsOrigami], function(O)
	# we have: T.(sigma_x, sigma_y) = (sigma_x, sigma_y * sigma_x^-1)
	# but note, that GAP multiplies permutations the other way around
	return OrigamiNC(HorizontalPerm(O), HorizontalPerm(O)^-1 * VerticalPerm(O), DegreeOrigami(O));
end);

InstallMethod(ActionOfTInv, [IsOrigami], function(O)
	return OrigamiNC(HorizontalPerm(O), HorizontalPerm(O) * VerticalPerm(O), DegreeOrigami(O));
end);

InstallMethod(ActionOfSInv, [IsOrigami], function(O)
	return OrigamiNC(VerticalPerm(O), HorizontalPerm(O)^-1,  DegreeOrigami(O));
end);

InstallMethod(ActionOfSL2, [IsString, IsOrigami], function(wordString, O)
	local letter, F, word;
	F := FreeGroup("S","T");
	word := ParseRelators(GeneratorsOfGroup(F), wordString)[1];
	for letter in Reversed(LetterRepAssocWord(word)) do
		if letter = 1 then
			O := ActionOfS(O);
		elif letter = 2 then
			O := ActionOfT(O);
		elif letter = -1 then
			O := ActionOfSInv(O);
		elif letter = -2 then
			O := ActionOfTInv(O);
		else
			Error("<word> must be a word in two generators");
		fi;
	od;
	return O;
end);

InstallOtherMethod(ActionOfSL2, [IsMatrixObj, IsOrigami], function(A, O)
	 return ActionOfSL2(String(STDecomposition(A)), O);
end);

InstallOtherMethod(ActionOfSL2, [IsAssocWord, IsOrigami], function(word, O)
	local letter;
	# 'word' is assumed to be a word in S and T
	for letter in Reversed(LetterRepAssocWord(word)) do
		if letter = 1 then
			O := ActionOfS(O);
		elif letter = 2 then
			O := ActionOfT(O);
		elif letter = -1 then
			O := ActionOfSInv(O);
		elif letter = -2 then
			O := ActionOfTInv(O);
		else
			Error("<word> must be a word in two generators");
		fi;
	od;
	return O;
end);
