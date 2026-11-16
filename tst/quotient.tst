gap> START_TEST( "quotient.tst" );

# Tests for GenusOfQuotient and OrigamiQuotient, i.e. the quotient O/Trans(O)
# of an origami by its translation group. Expected genera were checked with
# Riemann-Hurwitz: 2g-2 = |Trans(O)|(2g'-2) + sum over fixed points of (e_p - 1).

# trivial translation group: the quotient is the origami itself
gap> O := Origami((1,2), (1,2,3));
Origami((1,2), (1,2,3), 3)
gap> TranslationsOfOrigami(O);
[ () ]
gap> GenusOfQuotient(O);
2
gap> OrigamiQuotient(O);
Origami((1,2), (1,2,3), 3)

# Trans(O) = C2 fixing both singularities of order 1: 2 = 2(2g'-2) + 2, so g' = 1
gap> O := Origami((1,2,3,4), (1,2)(3,4));
Origami((1,2,3,4), (1,2)(3,4), 4)
gap> GenusOfQuotient(O);
1
gap> Q := OrigamiQuotient(O);
Origami((1,2), (1,2), 2)
gap> Genus(Q);
1

# Eierlegende Wollmilchsau: normal origami with Trans(O) = Q8, so the quotient
# is a single square
gap> O := Origami((1,2,3,4)(5,6,7,8), (1,5,3,7)(2,8,4,6));
Origami((1,2,3,4)(5,6,7,8), (1,5,3,7)(2,8,4,6), 8)
gap> IsNormalOrigami(O);
true
gap> GenusOfQuotient(O);
1
gap> OrigamiQuotient(O);
Origami((), (), 1)

# Trans(O) = C4: the two singularities of order 3 are fixed by all of C4, the
# two of order 1 only by the subgroup C2; 8 = 4(2g'-2) + 2*3 + 2*1, so g' = 1.
# Regression test: points fixed by several translations with different fixed
# point sets used to be counted more than once, giving 1/4.
gap> O := Origami((2,3,5,8)(4,7)(6,9), (1,2,4)(3,6,10)(5,7,11)(8,9,12));
Origami((2,3,5,8)(4,7)(6,9), (1,2,4)(3,6,10)(5,7,11)(8,9,12), 12)
gap> Stratum(O);
[ 1, 1, 3, 3 ]
gap> Length(TranslationsOfOrigami(O));
4
gap> GenusOfQuotient(O);
1
gap> Q := OrigamiQuotient(O);
Origami((), (1,2,3), 3)
gap> Genus(Q);
1

#
gap> STOP_TEST( "quotient.tst" );
