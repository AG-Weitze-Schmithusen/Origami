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