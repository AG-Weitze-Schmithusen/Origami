#! @Chapter Sytoles of Translation Surfaces
#! @ChapterLabel systoles-of-origamis
#! Let $X$ be a translation surface. Then a systole of $X$ is a shortest,
#! simple closed, not null-homotopic geodesic of $\overline{X}$. We denote by $\text{sys}(X)$ the length of the systole.
#! The systolic ratio of $X$ is the ratio $\text{SR}(X) := \text{sys}(X)^2/\text{area}(X)$.
#! @Section Computing Systoles of Origamis

#! @Arguments O [equilateral]
#! @Returns a record containing the length of the systole and its combinatorial length
#! @Description
#! Computes the length of a systole $\gamma$ of $\texttt{O}$ and the combinatorial length of $\gamma$.
#! If the optional parameter $\texttt{equilateral}$ is true, then it is assumed that
#! $\texttt{O}$ consists of equilateral triangles.
#! @BeginExampleSession
#! gap> O := Origami((1,8,4,6,2,3,5), (2,5,7,6,8), 8);
#! Origami((1,8,4,6,2,3,5), (2,5,7,6,8), 8)
#! gap> SystoleLength(O);
#! rec( combinatorial_length := 1, systole := 1. )
#! @EndExampleSession
DeclareGlobalFunction("SystoleLength");
#! @Arguments O [equilateral]
#! @Returns a record containing the systolic ratio and the combinatorial length of the systole used in the computation
#! @Description
#! Computes the systolic ratio $\text{SR}(\texttt{O})$ of $\texttt{O}$.
#! If the optional parameter $\texttt{equilateral}$ is true, then it is assumed that
#! $\texttt{O}$ consists of equilateral triangles.
#! @BeginExampleSession
#! gap> O := Origami((1,8,4,6,2,3,5), (2,5,7,6,8), 8);
#! Origami((1,8,4,6,2,3,5), (2,5,7,6,8), 8)
#! gap> SystolicRatio(O);
#! rec( combinatorial_length := 1, systolic_ratio := 0.125 )
#! @EndExampleSession
DeclareGlobalFunction("SystolicRatio");
#! @Arguments from to stratum [equilateral]
#! @Returns a record containing the maximal systolic ratio in $\texttt{stratum}$, an origami representing the maximum and
#! a bool value indicating if a combinatorial length of three occured during the computation
#! @Description
#! Computes the maximal systolic ratio of all origamis from degree $\texttt{from}$ to degree $\texttt{to}$ in the stratum
#! $\texttt{stratum}$.
#! If the optional parameter $\texttt{equilateral}$ is true, then it is assumed that all origamis
#! consist of equilateral triangles.
#! @BeginExampleSession
#! gap> MaximalSystolicRatioInStratum(4,7,[1,1]);
#! rec( origami := Origami((1,2)(3,4), (1,2,3,4), 4), systolic_ratio := 0.5, 
#!  three_occured := false )
#! @EndExampleSession
DeclareGlobalFunction("MaximalSystolicRatioInStratum");
#! @Arguments d [equilateral]
#! @Returns a record containing the maximal systolic ratio of all origamis with degree $\texttt{d}$, an origami representing the maximum and
#! a bool value indicating if a combinatorial length of three occured during the computation
#! @Description
#! Computes the maximal systolic ratio of all origamis with degree $\texttt{d}$.
#! If the optional parameter $\texttt{equilateral}$ is true, then it is assumed that all origamis
#! consist of equilateral triangles.
#! @BeginExampleSession
#! gap> MaximalSystolicRatioByDegree(6);      
#! rec( origami := Origami((1,2)(3,4)(5,6), (1,2,3,4,5,6), 6), 
#! systolic_ratio := 0.333333, three_occured := false )
#! @EndExampleSession
DeclareGlobalFunction("MaximalSystolicRatioByDegree");
#! @Arguments origamis [equilateral]
#! @Returns a record containing the maximal systolic ratio of all origamis in the list $\texttt{origamis}$, an origami representing the maximum and
#! a bool value indicating if a combinatorial length of three occured during the computation
#! @Description
#! Computes the maximal systolic ratio of all origamis in the list $\texttt{origamis}$.
#! If the optional parameter $\texttt{equilateral}$ is true, then it is assumed that all origamis
#! consist of equilateral triangles.
#! @BeginExampleSession
#! gap> o1 := Origami((1,3,5,2), (2,4,3,5), 5);
#! Origami((1,3,5,2), (2,4,3,5), 5)
#! gap> o2 := Origami((1,4,3,2,6), (1,4,5)(2,6), 6);
#! Origami((1,4,3,2,6), (1,4,5)(2,6), 6)
#! gap> origamis := [o1, o2];
#! [ Origami((1,3,5,2), (2,4,3,5), 5), Origami((1,4,3,2,6), (1,4,5)(2,6), 6) ]
#! gap> MaximalSystolicRatioOfList(origamis);
#! rec( origami := Origami((1,3,5,2), (2,4,3,5), 5), systolic_ratio := 0.2, 
#! three_occured := false )
#! @EndExampleSession
DeclareGlobalFunction("MaximalSystolicRatioOfList");