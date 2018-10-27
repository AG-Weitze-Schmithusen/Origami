gap> O := Origami((1,2,4,3), (), 4);
Origami((1,2,4,3), (), 4)
gap> IsSameVeechGroupForTestfile := function(a1, a2, b1, b2,n)
>   n := 1;
>   local n;
>   if Length(RightCosetRepresentatives( ModularSubgroup(a1, a2) )) = Length(RightCosetRepresentatives( ModularSubgroup(b1, b2) )) then 
>	n := Length(RightCosetRepresentatives( ModularSubgroup(a1, a2) ));
>  	else return false;
>   fi;
>   if RepresentativeAction( SymmetricGroup(n), [a1, a2], [b1, b2], OnTuples) = fail then return false;
>   else return true;
>   fi;
> end;
function( a1, a2, b1, b2, n ) ... end
gap> IsSameVeechGroupForTestfile(SAction(VeechGroup(O)), TAction(VeechGroup(O)), (1,3)(2,5)(4,6), (1,2,4,5), 5);
true
gap> quit;
