gap> origami:=StaircaseOrigami(4,2,1);
Origami((3,4,5,6), (1,2,3), 6)
gap> NormalformConjugators(origami);
[ (), (1,4,3,2), (1,3)(2,5,4), (1,5,2,6,3,4), (1,5)(2,6), (1,4,3,2,6) ]
gap> PointReflectionsOfOrigami(origami);
[ (1,2)(4,6) ]
gap> TranslationsOfOrigami(origami);
[ () ]
gap> origami:=Origami((1,2,3,4),(1,2)(3,4));
Origami((1,2,3,4), (1,2)(3,4), 4)
gap> NormalformConjugators(origami);
[ (), (1,3,2), (1,3)(2,4), (1,2,4) ]
gap> PointReflectionsOfOrigami(origami);
[ (1,2)(3,4), (1,4)(2,3) ]
gap> TranslationsOfOrigami(origami);
[ (), (1,3)(2,4) ]
gap> IsHyperelliptic(origami);
true
gap> origami:=Origami((1,2,3,4,5,6),(1,2)(3,4)(5,6));
Origami((1,2,3,4,5,6), (1,2)(3,4)(5,6), 6)
gap> NormalformConjugators(origami);
[ (), (1,3,2), (1,5,3)(2,6,4), (1,5,2,6,4), (1,3,5)(2,4,6), (1,2,4,6)(3,5) ]
gap> PointReflectionsOfOrigami(origami);
[ (1,2)(3,6)(4,5), (1,4)(2,3)(5,6), (1,6)(2,5)(3,4) ]
gap> TranslationsOfOrigami(origami);
[ (), (1,3,5)(2,4,6), (1,5,3)(2,6,4) ]
gap> IsHyperelliptic(origami);
false

# Every surface of genus 2 is hyperelliptic.
gap> IsHyperelliptic(StaircaseOrigami(4,2,1));
true
gap> ForAll([3..6], d -> ForAll(Filtered(AllOrigamisByDegree(d), O -> Genus(O) = 2), IsHyperelliptic));
true

# The identity permutation can give the hyperelliptic involution (rotating every
# square about its own centre); this happens if both gluing permutations are involutions.
gap> origami := Origami((1,2), (2,3));; # L-shaped origami, genus 2
gap> PointReflectionsOfOrigami(origami);
[ () ]
gap> Length(FixedPointsOfPointReflections(origami, ()));
6
gap> IsHyperelliptic(origami);
true
gap> origami := Origami((1,2)(3,4), (2,3)(4,5));; # genus 3, stratum [ 4 ]
gap> Length(FixedPointsOfPointReflections(origami, ()));
8
gap> IsHyperelliptic(origami);
true

# A fixed cone point counts as one fixed point, whatever its cone angle.
gap> origami := Origami((1,2), (1,2,3));; # cone angle 6*pi
gap> PointReflectionsOfOrigami(origami);
[ (1,2) ]
gap> Length(FixedPointsOfPointReflections(origami, (1,2)));
6
gap> IsHyperelliptic(origami);
true
gap> origami := Origami((1,2)(3,4), (2,3,5,4));; # genus 3, cone angle 10*pi
gap> PointReflectionsOfOrigami(origami);
[ (3,4) ]
gap> Length(FixedPointsOfPointReflections(origami, (3,4)));
8
gap> IsHyperelliptic(origami);
true

# Riemann-Hurwitz: an involutive point reflection has 2g+2-4h fixed points,
# where h is the genus of the quotient.
gap> ForAll([3..6], d -> ForAll(Filtered(AllOrigamisByDegree(d), O -> Genus(O) >= 2 and VeechGroupIsEven(O)),
>      O -> ForAll(Filtered(PointReflectionsOfOrigami(O), s -> s^2 = ()), function(s)
>             local r;
>             r := Length(FixedPointsOfPointReflections(O, s));
>             return r <= 2*Genus(O) + 2 and (2*Genus(O) + 2 - r) mod 4 = 0;
>           end)));
true

# number of hyperelliptic origamis of genus 3 and degree 5, 6
gap> List([5, 6], d -> Number(Filtered(AllOrigamisByDegree(d), O -> Genus(O) = 3), IsHyperelliptic));
[ 18, 166 ]
