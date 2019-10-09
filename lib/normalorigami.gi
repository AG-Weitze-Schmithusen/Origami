########## --------------------------------- The constructors   -------------- ###########################################

InstallMethod( NormalStoredOrigamiNC, [IsMultiplicativeElementWithInverse, IsMultiplicativeElementWithInverse, IsGroup], function( horizontalElement, verticalElement, D )
		local Obj, ori, iso_pc_group;
		iso_pc_group := IsomorphismPcGroup(D);
		ori:= rec(d := Size(Image(iso_pc_group)), x := Image(iso_pc_group, horizontalElement), y := Image(iso_pc_group, verticalElement));
		Obj:= rec();

		ObjectifyWithAttributes( Obj, NewType(OrigamiFamily, IsNormalStoredOrigami and IsAttributeStoringRep) , HorizontalElement, ori.x, VerticalElement, ori.y, DegreeOrigami, Size(Image(iso_pc_group)) );
		SetDeckGroup (Obj, Image(iso_pc_group));
		return Obj;
	end
);

InstallMethod( NormalStoredOrigami, [IsMultiplicativeElementWithInverse, IsMultiplicativeElementWithInverse, IsGroup], function( horizontalElement, verticalElement, D )
		if ( ( horizontalElement in D ) and ( verticalElement in D ) ) = false
			then Error(" the first two arguments must be Elements of the third argument ");
		fi;
		
		if ( Group(  horizontalElement, verticalElement )  <> D)
			then Error( " The described surface is not connected, the group elements must generate the Deck group " );
		fi;
		return NormalStoredOrigamiNC( horizontalElement, verticalElement, D);
	end
);

InstallMethod( AsPermutationRepresentation, [IsNormalStoredOrigami] , function( origami )
	local L, i, res, h, x, y;
	L := AsSortedList( DeckGroup( origami ) );
	res := [];
	for h in DeckGroup( origami ) do
		res[Position(L, h)] := Position(L, HorizontalElement( origami ) * h);
	od;
	x := PermList( res );
	res := [];
	for h in DeckGroup( origami ) do
		res[Position( L, h )] := Position(L, VerticalElement( origami ) * h);
	od;
	y := PermList( res );
	return Origami( x , y );

end);

##########################  String and display methods

InstallMethod(String, [IsNormalStoredOrigami], function( origami )
	return Concatenation( "Normal Origami( ", String( HorizontalElement( origami ) ), " , " , String( VerticalElement( origami ) ), ", " , String(DeckGroup( origami )) , " )" );
end);



##############################################################
InstallMethod(HorizontalPerm, [IsNormalStoredOrigami], function( origami )
	local L, res, h;
	L := AsSortedList( DeckGroup( origami ) );
	res := [];
	for h in DeckGroup( origami ) do
		res[Position(L, h)] := Position(L, HorizontalElement( origami ) * h);
	od;
	return PermList( res );
end);

InstallMethod(VerticalPerm, [IsNormalStoredOrigami], function( origami )
	local L, res, h;
	L := AsSortedList( DeckGroup( origami ) );
	res := [];
	for h in DeckGroup( origami ) do
		res[Position(L, h)] := Position(L, VerticalElement( origami ) * h);
	od;
	return PermList( res );
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
