gap> START_TEST( "equivalent test" );
gap>  O := Origami((1,2,4,3), (2,4), 4);
Origami((1,2,4,3), (2,4), 4)
gap> Origami((1,2,3,4), (1,4), 4)
> ;
Origami((1,2,3,4), (1,4), 4)
gap> EquivalentOrigami(O, last);
true
gap> Origami((1,3,4,2), (1,3), 4);
Origami((1,3,4,2), (1,3), 4)
gap> EquivalentOrigami(O, last); 
true
gap> Origami((1,4,2,3), (1,4,2), 4);
Origami((1,4,2,3), (1,4,2), 4)
gap> EquivalentOrigami(O, last); 
false
gap> O := Origami((1,5,2)(3,4), (1,2)(3,5), 5);
Origami((1,5,2)(3,4), (1,2)(3,5), 5)
gap> Origami((1,5)(2,4,3), (1,2)(3,4), 5)
> ;
Origami((1,5)(2,4,3), (1,2)(3,4), 5)
gap> EquivalentOrigami(O, last);
true
gap> Origami((2,5,4), (1,5,4,3), 5)
> ;
Origami((2,5,4), (1,5,4,3), 5)
gap> EquivalentOrigami(O, last);
false

gap> STOP_TEST( "equivalent.tst" );
