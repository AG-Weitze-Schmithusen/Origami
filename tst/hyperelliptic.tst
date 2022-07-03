gap> origami:=StaircaseOrigami(4,2,1);
Origami((3,4,5,6), (1,2,3), 6)
gap> NormalformConjugators(origami);
[ (), (1,4,3,2), (1,3)(2,5,4), (1,5,2,6,3,4), (1,5)(2,6), (1,4,3,2,6) ]
gap> ConjugatorsToInverse(origami);
[ (1,2)(4,6) ]
gap> TranslationsOfOrigami(origami);
[ () ]
gap> IsHyperelliptic(origami);
false
gap> origami:=Origami((1,2,3,4),(1,2)(3,4));
Origami((1,2,3,4), (1,2)(3,4), 4)
gap> NormalformConjugators(origami);
[ (), (1,3,2), (1,3)(2,4), (1,2,4) ]
gap> ConjugatorsToInverse(origami);
[ (1,2)(3,4), (1,4)(2,3) ]
gap> TranslationsOfOrigami(origami);
[ (), (1,3)(2,4) ]
gap> IsHyperelliptic(origami);
true
gap> origami:=Origami((1,2,3,4,5,6),(1,2)(3,4)(5,6));
Origami((1,2,3,4,5,6), (1,2)(3,4)(5,6), 6)
gap> NormalformConjugators(origami);
[ (), (1,3,2), (1,5,3)(2,6,4), (1,5,2,6,4), (1,3,5)(2,4,6), (1,2,4,6)(3,5) ]
gap> ConjugatorsToInverse(origami);
[ (1,2)(3,6)(4,5), (1,4)(2,3)(5,6), (1,6)(2,5)(3,4) ]
gap> TranslationsOfOrigami(origami);
[ (), (1,3,5)(2,4,6), (1,5,3)(2,6,4) ]
gap> IsHyperelliptic(origami);
false
