gap> START_TEST( "lyapunov.tst" );

# Tests for SumOfLyapunovExponents. The expected values are known results,
# not just the output of the implementation:
#  - genus 1: the only positive exponent is lambda_1 = 1
#  - every Teichmueller curve in H(2) has sum 4/3, and in H(1,1) sum 3/2
#    (Bainbridge; Eskin-Kontsevich-Zorich)
#  - the Eierlegende Wollmilchsau has spectrum 1, 0, 0

# genus 1, including a normal origami and a NormalStoredOrigami
gap> SumOfLyapunovExponents(Origami((), ()));
1
gap> SumOfLyapunovExponents(Origami((1,2,3,4,5), (), 5));
1
gap> G := CyclicGroup(IsPermGroup, 4);;
gap> N := NormalStoredOrigami(G.1, One(G), G);;
gap> Genus(N);
1
gap> SumOfLyapunovExponents(N);
1

# stratum H(2): two origamis in different SL(2,Z)-orbits
gap> O := Origami((1,2), (1,2,3));
Origami((1,2), (1,2,3), 3)
gap> Stratum(O);
[ 2 ]
gap> SumOfLyapunovExponents(O);
4/3
gap> O := Origami((1,2,3,4,5), (1,2));
Origami((1,2,3,4,5), (1,2), 5)
gap> Stratum(O);
[ 2 ]
gap> SumOfLyapunovExponents(O);
4/3

# stratum H(1,1)
gap> O := Origami((1,2,3,4), (1,2)(3,4));
Origami((1,2,3,4), (1,2)(3,4), 4)
gap> Stratum(O);
[ 1, 1 ]
gap> SumOfLyapunovExponents(O);
3/2

# Eierlegende Wollmilchsau, as a permutation origami and as a NormalStoredOrigami
gap> O := Origami((1,2,3,4)(5,6,7,8), (1,5,3,7)(2,8,4,6));
Origami((1,2,3,4)(5,6,7,8), (1,5,3,7)(2,8,4,6), 8)
gap> IsNormalOrigami(O);
true
gap> SumOfLyapunovExponents(O);
1
gap> Q8 := Group(HorizontalPerm(O), VerticalPerm(O));;
gap> N := NormalStoredOrigami(HorizontalPerm(O), VerticalPerm(O), Q8);;
gap> SumOfLyapunovExponents(N);
1

#
gap> STOP_TEST( "lyapunov.tst" );
