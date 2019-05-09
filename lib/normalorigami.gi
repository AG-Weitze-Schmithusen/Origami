########## --------------------------------- The constructors   -------------- ###########################################

InstallMethod( NormalStoredOrigamiNC, [IsMultiplicativeElementWithInverse, IsMultiplicativeElementWithInverse, IsGroup], function( horizontalElement, verticalElement, D )
		local Obj, ori;
		ori:= rec(d := Size(D), x := horizontalElement, y := verticalElement);
		Obj:= rec();

		ObjectifyWithAttributes( Obj, NewType(OrigamiFamily, IsNormalStoredOrigami and IsAttributeStoringRep) , HorizontalElement, ori.x, VerticalElement, ori.y, DegreeOrigami, Size(D) );
		SetDeckGroup (Obj, D);
		return Obj;
	end
);

InstallMethod( NormalStoredOrigami, [IsMultiplicativeElementWithInverse, IsMultiplicativeElementWithInverse, IsGroup], function( horizontalElement, verticalElement, D )
		if ( ( horizontalElement in D ) and ( verticalElement in D ) ) = false 
			then Error(" the first two arguments must be Elements of the third argument ");
		fi;
		
		if ( Group(  horizontalElement, verticalElement )  <> D) 
			then Error( " The described surface is not connected, the group elements must gernerate the Deck group " );
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

InstallMethod(String, [IsNormalStoredOrigami], function( origami )
	return Concatenation( "Normal Origami( ", String( HorizontalElement( origami ) ), " , " , String( VerticalElement( origami ) ), ")" , String(DeckGroup( origami )));
end);


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
