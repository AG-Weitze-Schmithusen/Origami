gap> O := Origami((1,2,4,3), (), 4);
Origami((1,2,4,3), (), 4)
gap> IsSimultanConjugatedForTestfile := function(a1, a2, b1, b2, n)
>   if RepresentativeAction( SymmetricGroup(n), [a1, a2], [b1, b2], OnTuples) = fail then return false;
>   else return true;
>   fi;
> end;
function( a1, a2, b1, b2, n ) ... end
gap> IsSimultanConjugatedForTestfile(SAction(VeechGroup(O)), TAction(VeechGroup(O)), (1,3)(2,5)(4,6), (1,2,4,5), DegreeOrigami(O));
true
gap> CosetsTest := function(TestCoset, O)
> 	local RepTest1, RepTest2, CTest;
> 	for RepTest1 in TestCoset do
> 		CTest:= false;
> 		for RepTest2 in Cosets(O) do
> 			if SameCoset(RepTest1, RepTest2, SAction(VeechGroup(O)), TAction(VeechGroup(O))) then CTest := true; fi;
> 		od;
> 		if CTest = false then return false; fi;
> 	od;
> 	return true;
> end;
function( TestCoset, O ) ... end
gap> CosetsTest([ S*S^-1 , T, S, T^2, T*S, T^2*S ], O);
true
gap> quit;
