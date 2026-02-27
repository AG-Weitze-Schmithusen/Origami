gap> O := Origami((), ());
Origami((), (), 1)
gap> CylinderStructure(O);
[ [ 1, 1 ] ]
gap> O := Origami((), (1,2,3));
Origami((), (1,2,3), 3)
gap> CylinderStructure(O);
[ [ 3, 1 ] ]
gap> O := Origami((1,2,3)(4,5,6), (1,4)(2,5)(3,6));
Origami((1,2,3)(4,5,6), (1,4)(2,5)(3,6), 6)
gap> CylinderStructure(O);
[ [ 2, 3 ] ]
gap> O := Origami((1,2)(3,4)(6,8), (2,5,3,10,9,6)(4,7));
Origami((1,2)(3,4)(6,8), (2,5,3,10,9,6)(4,7), 10)
gap> CylinderStructure(O);
[ [ 1, 2 ], [ 1, 2 ], [ 1, 2 ], [ 2, 1 ], [ 1, 1 ], [ 1, 1 ] ]