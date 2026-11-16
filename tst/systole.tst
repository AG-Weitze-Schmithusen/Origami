gap> origami1 := Origami((2, 3, 4, 6, 8, 7, 5, 1), (2, 1)(5, 7, 4, 3)(8, 6));
Origami((1,2,3,4,6,8,7,5), (1,2)(3,5,7,4)(6,8), 8)
gap> SystoleLength(origami1);
rec( combinatorial_length := 1, systole := 1.41421 )
gap> SystolicRatio(origami1);
rec( combinatorial_length := 1, systolic_ratio := 0.25 )
gap> origami2 := Origami((1,2,3),(1,3));
Origami((1,2,3), (1,3), 3)
gap> SystolicRatio(origami2, true);
rec( combinatorial_length := 1, systolic_ratio := 0.3849 )

# SystolicRatioOfNormalOrigamis(from, to) returns, for all normal origamis of genus
# at least 2 and degree between from and to, the list
# [ origami, stratum, systolic ratio (squares), systolic ratio (equilateral), flag ],
# sorted by stratum, where flag says whether a systole of combinatorial length 3 occurred.
# Floats are compared up to rounding; Sort is not stable, so ties are compared as sets.
gap> Approx := {a, b} -> AbsoluteValue(a - b) < 1.0e-10;;
gap> ApproxList := {l1, l2} -> Length(l1) = Length(l2) and ForAll([1..Length(l1)], i -> Approx(l1[i], l2[i]));;

# all normal origamis of degree at most 5 are abelian, i.e. tori
gap> SystolicRatioOfNormalOrigamis(1, 5);
[  ]

# degree 6: the three normal origamis with deck group S3, all in H(2,2);
# systoles of squared length 1, 1, 2, hence ratios 1/6, 1/6, 1/3
gap> L := SystolicRatioOfNormalOrigamis(6, 6);;
gap> Length(L);
3
gap> List(L, e -> e[2]);
[ [ 2, 2 ], [ 2, 2 ], [ 2, 2 ] ]
gap> ApproxList(SortedList(List(L, e -> e[3])), [1/6, 1/6, 1/3]);
true
gap> ForAll(L, e -> Approx(e[4], 1/(3*Sqrt(3.))));
true
gap> List(L, e -> e[5]);
[ false, false, false ]

# degrees 6 to 8: the S3 origamis come first (shorter stratum), then the four
# normal origamis of degree 8 in H(1,1,1,1), all with systole of squared length 4
gap> L := SystolicRatioOfNormalOrigamis(6, 8);;
gap> List(L, e -> e[2]);
[ [ 2, 2 ], [ 2, 2 ], [ 2, 2 ], [ 1, 1, 1, 1 ], [ 1, 1, 1, 1 ], [ 1, 1, 1, 1 ], [ 1, 1, 1, 1 ] ]
gap> ForAll(L{[4..7]}, e -> DegreeOrigami(e[1]) = 8 and Approx(e[3], 1/2) and Approx(e[4], 1/Sqrt(3.)));
true

# every entry agrees with SystolicRatio, and the flag is set exactly when one of
# the two systoles has combinatorial length 3
gap> L := SystolicRatioOfNormalOrigamis(6, 10);;
gap> Length(L);
10
gap> ForAll(L, e -> IsOrigami(e[1]) and Genus(e[1]) >= 2 and IsNormalOrigami(e[1]) and e[2] = Stratum(e[1]));
true
gap> ForAll(L, function(e)
>   local sq, eq;
>   sq := SystolicRatio(e[1]);
>   eq := SystolicRatio(e[1], true);
>   return Approx(e[3], sq.systolic_ratio) and Approx(e[4], eq.systolic_ratio)
>          and e[5] = (sq.combinatorial_length = 3 or eq.combinatorial_length = 3);
> end);
true
