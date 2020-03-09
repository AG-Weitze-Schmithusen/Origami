InstallMethod(ActionOfS, [IsOrigami], function(O)
	return OrigamiNC(VerticalPerm(O)^(-1), HorizontalPerm(O), DegreeOrigami(O));
end);

InstallMethod(ActionOfT, [IsOrigami], function(O)
	return OrigamiNC(HorizontalPerm(O), VerticalPerm(O) * HorizontalPerm(O)^-1, DegreeOrigami(O));
end);

InstallMethod(ActionOfTInv, [IsOrigami], function(O)
	return OrigamiNC(HorizontalPerm(O), VerticalPerm(O) * HorizontalPerm(O), DegreeOrigami(O));
end);

InstallMethod(ActionOfSInv, [IsOrigami] ,function(O)
	return OrigamiNC(VerticalPerm(O), HorizontalPerm(O)^-1,  DegreeOrigami(O));
end);

InstallMethod(ActionOfSL2, [IsString, IsOrigami], function(wordString, O)
	local letter, F, word;
	F := FreeGroup("S","T");
	word := ParseRelators(GeneratorsOfGroup(F), wordString)[1];
	for letter in LetterRepAssocWord(word) do
		if letter = 1 then
			O := ActionOfS(O);
		elif letter = 2 then
			O := ActionOfT(O);
		elif letter = -1 then
			O := ActionOfSInv(O);
		else
			O := ActionOfTInv(O);
		fi;
	od;
	return O;
end);

InstallOtherMethod(ActionOfSL2, [IsMatrix, IsOrigami], function(A, origami)
	 return ActionOfSL2(String(STDecomposition(A)), origami);
end);
