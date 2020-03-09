InstallMethod(NormalStoredOrigamiNC, [IsMultiplicativeElementWithInverse, IsMultiplicativeElementWithInverse, IsGroup], function(x, y, D)
	local Obj, ori, iso_nice_group;
	iso_nice_group := IsomorphismPcGroup(D);
	if iso_nice_group = fail then
		iso_nice_group := IsomorphismFpGroup(D);
	fi;
	ori := rec(d := Size(Image(iso_nice_group)), x := Image(iso_nice_group, x), y := Image(iso_nice_group, y));
	Obj := rec();

	ObjectifyWithAttributes(
		Obj,
		NewType(OrigamiFamily, IsNormalStoredOrigami and IsAttributeStoringRep),
		HorizontalElement,  ori.x,
		VerticalElement,  ori.y,
		DegreeOrigami, Size(Image(iso_nice_group))
	);
	SetDeckGroup(Obj, Image(iso_nice_group));
	return Obj;
end);

InstallMethod(NormalStoredOrigami, [IsMultiplicativeElementWithInverse, IsMultiplicativeElementWithInverse, IsGroup], function(x, y, D)
		if not ((x in D) and (y in D))
			then Error("The first two arguments must be elements of the group supplied as third argument.");
		fi;
		
		if ( Group(x, y)  <> D)
			then Error("The described surface is not connected, the group elements must generate the deck group.");
		fi;
		return NormalStoredOrigamiNC(x, y, D);
end);

InstallMethod(AsPermutationRepresentation, [IsNormalStoredOrigami] , function(origami)
	local L, i, res, h, x, y;
	L := AsSortedList(DeckGroup(origami));
	res := [];
	for h in DeckGroup(origami) do
		res[Position(L, h)] := Position(L, HorizontalElement(origami) * h);
	od;
	x := PermList(res);
	res := [];
	for h in DeckGroup(origami) do
		res[Position(L, h)] := Position(L, VerticalElement(origami) * h);
	od;
	y := PermList(res);
	return Origami(x , y);
end);

InstallMethod(String, [IsNormalStoredOrigami], function(origami)
	return Concatenation("Normal Origami( ", String(HorizontalElement(origami)), " , ", String(VerticalElement(origami)), ", ", String(DeckGroup(origami)), " )");
end);

InstallMethod(HorizontalPerm, [IsNormalStoredOrigami], function(origami)
	local L, res, h;
	L := AsSortedList(DeckGroup(origami));
	res := [];
	for h in DeckGroup(origami) do
		res[Position(L, h)] := Position(L, HorizontalElement(origami) * h);
	od;
	return PermList(res);
end);

InstallMethod(VerticalPerm, [IsNormalStoredOrigami], function(origami)
	local L, res, h;
	L := AsSortedList(DeckGroup(origami));
	res := [];
	for h in DeckGroup(origami) do
		res[Position(L, h)] := Position(L, VerticalElement(origami) * h);
	od;
	return PermList(res);
end);

InstallMethod(ActionOfS, [IsNormalStoredOrigami], function(O)
	return NormalStoredOrigamiNC(VerticalElement(O)^(-1), HorizontalElement(O), DeckGroup(O));
end);

InstallMethod(ActionOfT, [IsNormalStoredOrigami], function(O)
	return NormalStoredOrigamiNC(HorizontalElement(O), VerticalElement(O) * HorizontalElement(O)^-1, DeckGroup(O));
end);

InstallMethod(ActionOfTInv, [IsNormalStoredOrigami], function(O)
	return NormalStoredOrigamiNC(HorizontalElement(O), VerticalElement(O) * HorizontalElement(O), DeckGroup(O));
end);

InstallMethod(ActionOfSInv, [IsNormalStoredOrigami], function(O)
	return NormalStoredOrigamiNC(VerticalElement(O), HorizontalElement(O)^-1,  DeckGroup(O));
end);

InstallMethod(AllNormalOrigamisByDegree, [IsPosInt], function(d)
	local groups, normal_origamis, F2, f2_epis, h, G;
	# groups := Filtered(AllSmallGroups(Size, d), G -> Length(MinimalGeneratingSet(G)) <= 2);

	# 'MinimalGeneratingSet' only works for finite solvable and finitely generated nilpotent groups.
	# But since we are only interested in the fact whether G is 2-generated or not, we can just
	# check if G is a quotient of F_2. Since this can be a bit slow, we first try computing
	# a SmallGeneratingSet which might not be minimal, but if we are lucky, it is small enough.

	groups := Filtered(AllSmallGroups(Size, d), function(G)
		if Length(SmallGeneratingSet(G)) <= 2 then return true; fi;
			return Length(GQuotients(FreeGroup(2), G)) >= 1;
	end);
	return Flat(List(groups, G -> AllNormalOrigamisFromGroup(G)));
end);

InstallMethod(AllNormalOrigamisFromGroup, [IsGroup and IsFinite], function(G)
	local F2, f2_epis, h, normal_origamis;
	F2 := FreeGroup(2);
	f2_epis := GQuotients(F2, G);
	normal_origamis := [];
	for h in f2_epis do
		Add(normal_origamis, NormalStoredOrigamiNC(Image(h, F2.1), Image(h, F2.2), G));
	od;
	return normal_origamis;
end);
