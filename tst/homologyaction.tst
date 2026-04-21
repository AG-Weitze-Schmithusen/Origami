# Atention this test must be run with the option rec( compareFuncion := f) , where f is a function that compares two strings up to Whitespace
gap> # First the tests for the homology of an origami. The tests assume, that the basis of the holology and the representants of the homology are not changed.
gap> O := Origami( (1,2,3,4,5)(6,7), (1,6,8)(2,7) );
Origami((1,2,3,4,5)(6,7), (1,6,8)(2,7), 8)
gap> HomologyOrigami(O);
[ [ 0, 0, 1, 1, 1, -1, 0, 0, 1, 0, 0, -1, 0, 0, -1, 0 ], 
[ 0, 0, 0, 0, 0, 0, 1, 0, 0, -1, 0, 0, 0, 0, -2, 0 ], 
[ 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, -1, 0, 0, 0, 0, 0 ], 
[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 ], 
[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0 ], 
[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ] ]
gap> O1 := Origami((1,2,3,4)(5,6,7)(8,9), (1,5,8,10)(2,6,9)(3,7));
Origami((1,2,3,4)(5,6,7)(8,9), (1,5,8,10)(2,6,9)(3,7), 10)
gap> HomologyOrigami(O1 );
[ [ 0, 0, 0, 1, -1, 1, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1, 1, 0, -2, 0 ], 
[ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, -1, 0, 0, 0, 0, 0, -1, 0, 0, 0 ], 
[ 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, -1, 0, 0, 0, -1, 0, -1, 0 ], 
[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], 
[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 ], 
[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 ], 
[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ] ]
gap> #Now the test for the nontatutological part of the homology
gap> NonTautPartOfHomologyOrigami( O, HomologyOrigami(O));
[ [ 0, 0, 1, 1, 1, -1, 0, -2, 1, 0, 2, -1, 0, 0, -1, -1 ], [ 0, 0, 0, 0, 0, 0, 1, -1, 0, -1, 1, 0, 0, 0, -2, 2 ], [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, -1 ], 
  [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, -1 ] ]
gap> NonTautPartOfHomologyOrigami( O1, HomologyOrigami(O1));
[ [ 0, 0, 0, 1, -1, 1, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1, 1, 0, -2, 1 ], [ 0, 0, 0, 0, 0, 0, 1, 0, 0, -1, -1, 0, 0, 0, 0, 0, -1, 0, 0, 2 ], 
  [ 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, 0, 0, -1, 0, 0, 0, -1, 0, -1, 3 ], [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, -1 ], [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, -1 ], 
  [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, -1 ] ]
gap> # Now the tests for HomologyToString
gap> List( HomologyOrigami( O ), HomologyToString);
[ "1s_3 + 1s_4 + 1s_5 - 1s_6 + 1z_1 - 1z_4 - 1z_7", "1s_7 - 1z_2 - 2z_7", "1s_8 - 1z_3", "1z_5", "1z_6", "1z_8" ]
gap> List( HomologyOrigami( O1 ), HomologyToString);
[ "1s_4 - 1s_5 + 1s_6 - 1s_8 + 1z_2 - 1z_6 + 1z_7 - 2z_9", "1s_7 - 1z_1 - 1z_7", "1s_9 - 1z_3 - 1z_7 - 1z_9", "1s_10", "1z_4", "1z_5", "1z_8", "1z_10" ]
gap> #Now the tests for ActionOfMatrixOnHom
gap> L := GeneratorsOfGroup(VeechGroup(O));;
gap> A := L[2]; ActionOfMatrixOnHom( O, A );
[ [ -7, 18 ], [ -2, 5 ] ]
[ [ -4, -9, -3, 2, 3, 2 ], [ -7, -16, -6, 4, 5, 6 ], [ -17, -27, -13, 10, 7, 8 ], 
  [ -30, -56, -23, 17, 16, 16 ], [ -19, -44, -17, 11, 14, 17 ], 
  [ -2, -1, -1, 1, 0, 0 ] ]
gap> A := L[5]; ActionOfMatrixOnHom( O, A );
[ [ 1, -10 ], [ 0, 1 ] ]
[ [ 1, 2, 2, -2, 0, 0 ], [ 5, 13, 2, -2, -5, 0 ], [ 5, 14, 5, -4, -5, -10 ], 
  [ 10, 26, 6, -5, -10, -10 ], [ 10, 26, 6, -6, -9, 0 ], [ 0, 0, 0, 0, 0, 1 ] ]
gap> ActionOfMatrixOnHom( O, L[2], HomologyOrigami(O) );
[ [ -4, -9, -3, 2, 3, 2 ], [ -7, -16, -6, 4, 5, 6 ], [ -17, -27, -13, 10, 7, 8 ], 
  [ -30, -56, -23, 17, 16, 16 ], [ -19, -44, -17, 11, 14, 17 ], 
  [ -2, -1, -1, 1, 0, 0 ] ]
gap> ActionOfMatrixOnHom( O, L[5], HomologyOrigami(O) );
[ [ 1, 2, 2, -2, 0, 0 ], [ 5, 13, 2, -2, -5, 0 ], [ 5, 14, 5, -4, -5, -10 ], 
  [ 10, 26, 6, -5, -10, -10 ], [ 10, 26, 6, -6, -9, 0 ], [ 0, 0, 0, 0, 0, 1 ] ]
gap> # Now the tests for ActionOfMatrixOnNonTaut
gap> ActionOfMatrixOnNonTaut( O, L[2] );
[ [ 0, -2, 0, 1 ], [ -1, 2, -2, -1 ], [ 0, -1, 1, 0 ], [ -2, 7, -6, -3 ] ]
gap> ActionOfMatrixOnNonTaut( O, L[5] );
[ [ -3, 0, -2, 0 ], [ 1, 11, -2, -5 ], [ 8, 0, 5, 0 ], [ -2, 20, -6, -9 ] ]
gap> ActionOfMatrixOnNonTaut( O, L[2], HomologyOrigami(O) );
[ [ 0, -2, 0, 1 ], [ -1, 2, -2, -1 ], [ 0, -1, 1, 0 ], [ -2, 7, -6, -3 ] ]
gap> ActionOfMatrixOnNonTaut( O, L[5], HomologyOrigami(O) );
[ [ -3, 0, -2, 0 ], [ 1, 11, -2, -5 ], [ 8, 0, 5, 0 ], [ -2, 20, -6, -9 ] ]
gap> ActionOfMatrixOnNonTaut( O, L[2], NonTautPartOfHomologyOrigami(O, HomologyOrigami(O)), HomologyOrigami(O) );
[ [ 0, -2, 0, 1 ], [ -1, 2, -2, -1 ], [ 0, -1, 1, 0 ], [ -2, 7, -6, -3 ] ]
gap> ActionOfMatrixOnNonTaut( O, L[5], NonTautPartOfHomologyOrigami(O, HomologyOrigami(O)), HomologyOrigami(O) );
[ [ -3, 0, -2, 0 ], [ 1, 11, -2, -5 ], [ 8, 0, 5, 0 ], [ -2, 20, -6, -9 ] ]
gap> # Tests for the shadow veech group are not implemented.
