
#This function let act S on an Origami (sigma_x, sigma_y)
#input An Origami O
#output the Origmi S.O
InstallMethod(ActionOfS, [IsOrigami] ,function(O)
	local NewOrigami;
	NewOrigami := OrigamiNC( VerticalPerm(O)^(-1), HorizontalPerm(O), DegreeOrigami(O));
	return NewOrigami;
end);

#This function let act T on an Origami (sigma_x, sigma_y)
#input An Origami O
#output the Origmi T.O

InstallMethod(ActionOfT, [IsOrigami] ,function(O)
	local NewOrigami;
	NewOrigami := OrigamiNC( HorizontalPerm(O), VerticalPerm(O) * HorizontalPerm(O)^-1, DegreeOrigami(O));
	return NewOrigami;
end);

#This function let act T⁻¹ on an Origami (sigma_x, sigma_y)
#input An Origami O
#output the Origmi T⁻¹.O
InstallMethod(ActionOfInvT, [IsOrigami], function(O)
	local NewOrigami;
	NewOrigami := OrigamiNC( HorizontalPerm(O), VerticalPerm(O) * HorizontalPerm(O), DegreeOrigami(O));
	return NewOrigami;
end);

#This function let act S⁻¹ on an Origami (sigma_x, sigma_y)
#input An Origami O
#output the Origmi S⁻¹.O
InstallMethod(ActionOfInvS, [IsOrigami] ,function(O)
	local NewOrigami;
	NewOrigami := OrigamiNC(VerticalPerm(O), HorizontalPerm(O)^-1,  DegreeOrigami(O));
	return NewOrigami;
end);

#This Function let act A in Sl_2(Z) on an Origami O
#INPUT: A Word word in S and T as string and an Origami O
#OUTPUT: The Origami word.O
InstallMethod(ActionOfSpecialLinearGroup,[IsString, IsOrigami], function(wordString, O)
	local letter, F, word;
	F := FreeGroup("S","T");
	word := ParseRelators(GeneratorsOfGroup(F), wordString)[1];
	for letter in LetterRepAssocWord(word) do
		if letter = 1 then
			O := ActionOfS(O);
		elif letter = 2 then
			O := ActionOfT(O);
		elif letter = -1 then
			O := ActionOfInvS(O);
		else
			O := ActionOfInvT(O);
		fi;
	od;
	return O;
end);

InstallMethod(ActionOfSpecialLinearGroup ,[IsMatrix, IsOrigami], function(A, origami)
	 return ActionOfSpecialLinearGroup(String(STDecomposition(A)), origami);
end);


#This Function let act A in Sl_2(Z) on an Origami O represented as canonical Image
#INPUT  A Word word in S and T and an Origami O in any representation
#OUTPUT The origami word.O as represented as canonical Image
InstallGlobalFunction(ActionOfF2ViaCanonical, function(o, g)
	return OrigamiNormalForm(ActionOfSpecialLinearGroup(g,o));
end);

# This function convertes the action of ActionOfF2ViaCanonical in a right action, that has the same orbits and stabilizer.
#INPUT  A Word word in S and T and an Origami O in any representation
#OUTPUT The origami O.word as represented as canonical Image
InstallGlobalFunction(RightActionOfF2ViaCanonical, function(o, g);
	return OrigamiNormalForm(ActionOfSpecialLinearGroup(String( g^-1 ) ,o));
end);

################ The Actions for normal origamis #####################################################################


InstallMethod(ActionOfS, [IsNormalStoredOrigami] ,function(O)
	local NewOrigami;
	NewOrigami := NormalStoredOrigamiNC( VerticalElement(O)^(-1), HorizontalElement(O), DeckGroup(O));
	return NewOrigami;
end);

#This function let act T on an Origami (sigma_x, sigma_y)
#input An Origami O
#output the Origmi T.O

InstallMethod(ActionOfT, [IsNormalStoredOrigami] ,function(O)
	local NewOrigami;
	NewOrigami := NormalStoredOrigamiNC( HorizontalElement(O), VerticalElement(O) * HorizontalElement(O)^-1, DeckGroup(O) );
	return NewOrigami;
end);

#This function let act T⁻¹ on an Origami (sigma_x, sigma_y)
#input An Origami O
#output the Origmi T⁻¹.O
InstallMethod(ActionOfInvT, [IsNormalStoredOrigami], function(O)
	local NewOrigami;
	NewOrigami := NormalStoredOrigamiNC( HorizontalElement(O), VerticalElement(O) * HorizontalElement(O), DeckGroup(O));
	return NewOrigami;
end);

#This function let act S⁻¹ on an Origami (sigma_x, sigma_y)
#input An Origami O
#output the Origmi S⁻¹.O
InstallMethod(ActionOfInvS, [IsNormalStoredOrigami] ,function(O)
	local NewOrigami;
	NewOrigami := NormalStoredOrigamiNC(VerticalElement(O), HorizontalElement(O)^-1,  DeckGroup(O));
	return NewOrigami;
end);


