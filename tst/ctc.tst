gap> n:=5;; l := List([1..n^2], k->0);; GeneralizedCyclicTorusCover(n,1,l,l);
Origami((1,2,3,4,5)(6,7,8,9,10)(11,12,13,14,15)(16,17,18,19,20)(21,22,23,24,25\
), (1,6,11,16,21)(2,7,12,17,22)(3,8,13,18,23)(4,9,14,19,24)(5,10,15,20,25), 25\
)
gap> l[1]:=1;;GeneralizedCyclicTorusCover(n,2,l,l);
Origami((1,27,28,29,30,26,2,3,4,5)(6,7,8,9,10)(11,12,13,14,15)(16,17,18,19,20)\
(21,22,23,24,25)(31,32,33,34,35)(36,37,38,39,40)(41,42,43,44,45)(46,47,48,49,5\
0), (1,31,36,41,46,26,6,11,16,21)(2,7,12,17,22)(3,8,13,18,23)(4,9,14,19,24)(5,\
10,15,20,25)(27,32,37,42,47)(28,33,38,43,48)(29,34,39,44,49)(30,35,40,45,50), \
50)
gap> Stratum(CyclicTorusCoverOrigami(2, 2, [1,0,0,0,0] * Inverse(BaseChangeLToS(2))));
[  ]
gap> Stratum(CyclicTorusCoverOrigami(2, 2, [1,0,1,0,0] * Inverse(BaseChangeLToS(2))));
[ 1, 1 ]
gap> Stratum(CyclicTorusCoverOrigami(2, 2, [1,0,1,1,0] * Inverse(BaseChangeLToS(2))));
[ 1, 1 ]
gap> Stratum(CyclicTorusCoverOrigami(2, 2, [1,0,1,1,1] * Inverse(BaseChangeLToS(2))));
[ 1, 1, 1, 1 ]
gap> DegreeOrigami(CyclicTorusCoverOrigami(2, 7, [3, 2, 1, 0, 1]));
28
gap> CyclicTorusCoverOrigami(2, 2, [1, 1, 1, 0, 1]);
Origami((1,2,5,6)(3,4)(7,8), (1,7)(2,4,6,8)(3,5), 8)
gap> List([2..10], i->AbsInt(Determinant(BaseChangeLToS(i)))=1);
[ true, true, true, true, true, true, true, true, true ]
gap> Order((ActionOfTOnHomologyOfTn(2) * One(GF(3))) );
6
gap> Order((ActionOfTOnHomologyOfTn(3) * One(GF(3))) );
9
gap> Order((ActionOfTOnHomologyOfTn(4) * One(GF(3))) );
12
gap> Order((ActionOfTOnHomologyOfTn(5) * One(GF(3))) );
15
gap> Order((ActionOfTOnHomologyOfTn(6) * One(GF(3))) );
18
gap> Order((ActionOfTOnHomologyOfTn(7) * One(GF(3))) );
21
gap> Order((ActionOfTOnHomologyOfTn(8) * One(GF(3))) );
24
gap> Order((ActionOfTOnHomologyOfTn(9) * One(GF(3))) );
27
gap> Order((ActionOfTOnHomologyOfTn(10) * One(GF(3))) );
30
gap> Order((ActionOfTOnHomologyOfTn(10) * One(GF(5))) );
50
gap> Order((ActionOfTOnHomologyOfTn(10) * One(GF(7))) );
70
gap> Order((ActionOfTOnHomologyOfTn(10) * One(GF(11))) );
110
gap> Order(ActionOfSOnHomologyOfTn(2));
4
gap> Order(ActionOfSOnHomologyOfTn(3));
4
gap> Order(ActionOfSOnHomologyOfTn(4));
4
gap> Order(ActionOfSOnHomologyOfTn(5));
4
gap> Order(ActionOfSOnHomologyOfTn(6));
4
gap> Order(ActionOfSOnHomologyOfTn(7));
4
gap> Order(ActionOfSOnHomologyOfTn(8));
4
gap> Order(ActionOfSOnHomologyOfTn(9));
4
gap> Order(ActionOfSOnHomologyOfTn(10));
4