# test for favourite sequences
#
#
# test for staircase origamis
gap> Staircase(1,2,3);
Origami((), (1,2,3,4,5,6,7,8,9), 9)
gap> Staircase(3,1,3);
Origami((2,3,4)(5,6,8)(9,10,12), (1,2)(3,5,7)(6,9,11), 12)
gap> Staircase(2,0,3);
Origami((1,2)(3,4)(5,6), (2,3)(4,5), 6)
gap> Staircase(1,0,3);
Origami((), (1,2,3), 3)
gap> O:=Staircase(2,0,3);
Origami((1,2)(3,4)(5,6), (2,3)(4,5), 6)
gap> stairperm:=Origami((2,1)(4,3)(6,5),(1,4)(3,6));
Origami((1,2)(3,4)(5,6), (1,4)(3,6), 6)
gap> EquivalentOrigami(O,stairperm);
true
gap> OrigamiNormalForm(O);
Origami((1,2)(3,4)(5,6), (2,3)(4,5), 6)
gap>  OrigamiNormalForm(stairperm);
Origami((1,2)(3,4)(5,6), (2,3)(4,5), 6)

##
#
# test for elevator origamis
gap> Elevator(3,1,3);
Origami((2,3,5)(4,6,8)(9,10,12), (1,2,4)(5,7,10)(6,9,11), 12)
gap>  Elevator(2,0,3);
Origami((1,2)(3,5)(4,6), (1,3)(2,4)(5,6), 6)
gap> Elevator(2,1,3);
Origami((2,3)(4,6)(7,8), (1,2,4)(3,5,7)(6,8,9), 9)

##
#
#test for x Origamis
gap> XOrigami(2);
Origami((1,2,3,4), (1,2)(3,4), 4)
gap> XOrigami(5);
Origami((1,2,3,4,5,6,7,8,9,10), (1,2)(3,4)(5,6)(7,8)(9,10), 10)
gap> XOrigami(6);
Origami((1,2,3,4,5,6,7,8,9,10,11,12), (1,2)(3,4)(5,6)(7,8)(9,10)(11,12), 12)
gap> xPerm:=Origami((1,3,2,4), (1,3)(2,4));
Origami((1,3,2,4), (1,3)(2,4), 4)
gap> EquivalentOrigami(xPerm, XOrigami(2));
true
