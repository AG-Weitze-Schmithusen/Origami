#Test for xORigami
gap> XOrigami(2);
Origami((1,2,3,4), (1,2)(3,4), 4)
gap> XOrigami(5);
Origami((1,2,3,4,5,6,7,8,9,10), (1,2)(3,4)(5,6)(7,8)(9,10), 10)
gap> XOrigami(6);
Origami((1,2,3,4,5,6,7,8,9,10,11,12), (1,2)(3,4)(5,6)(7,8)(9,10)(11,12), 12)
gap> xPerm:=Origami((1,3,2,4), (1,3)(2,4));
Origami((1,3,2,4), (1,3)(2,4), 4)

#Test of ElevatorOrigamis
gap> ElevatorOrigami(3,1,3);
Origami((2,3,5)(4,6,8)(9,10,12), (1,2,4)(5,7,10)(6,9,11), 12)
gap>  ElevatorOrigami(2,0,3);
Origami((1,2)(3,5)(4,6), (1,3)(2,4)(5,6), 6)
gap> ElevatorOrigami(2,1,3);
Origami((2,3)(4,6)(7,8), (1,2,4)(3,5,7)(6,8,9), 9)

#Tests for StaircaseOrigami
gap> StaircaseOrigami(1,2,3);
Origami((), (1,2,3,4,5,6,7,8,9), 9)
gap> StaircaseOrigami(3,1,3);
Origami((2,3,4)(5,6,8)(9,10,12), (1,2)(3,5,7)(6,9,11), 12)
gap> StaircaseOrigami(2,0,3);
Origami((1,2)(3,4)(5,6), (2,3)(4,5), 6)
gap> StaircaseOrigami(1,0,3);
Origami((), (1,2,3), 3)
gap> O:=StaircaseOrigami(2,0,3);
Origami((1,2)(3,4)(5,6), (2,3)(4,5), 6)
