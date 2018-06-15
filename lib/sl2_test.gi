InstallGlobalFunction(CalcMatrix, function(C)                      
	local B,k;
	k:=(C[2][2] - (C[2][2] mod C[2][1]))/C[2][1];
	B:=[[0,0],[0,0]];
	B[1][1]:= - C[1][1] * k + C[1][2];         # a_(n + 1) = - a_n * k  + b_n
	B[1][2]:= -C[1][1];                        # b_(n + 1) = -a_n
	B[2][1]:=C[2][2] mod C[2][1];              # c_(n + 1) = d_n mod c_n
	B[2][2]:= - C[2][1];                        # d_(n + 1) = c_n
	return(B);
end);

InstallGlobalFunction(DecompositionOfMatritToFreeGroup, function(A)
	local k, sign, Decomposition; # the k_n from the Algorithm, sign tracks the sign of the decomposition, Here the result wil be stored;
	Decomposition := One(F);
	sign:= 1;
	while A[2][1] <> 0 do
		sign:= sign * (-1);
		k := (A[2][2] - (A[2][2] mod A[2][1]))/A[2][1]; #A_2,2 div A_2,1
		Decomposition := S * T^(k) * Decomposition;
		if k < 0 then if k mod 2 = 1 then sign := sign * (-1); fi; fi;  #one "-" for each T^-1
		A := CalcMatrix(A);
	od;
	if A[1][1] = -1
		then sign:=sign*(-1);  Decomposition := T^ -A[1][2] * Decomposition;
		else Decomposition := T^A[1][2] * Decomposition;
	fi;
	if sign = -1 then Decomposition := Decomposition * S^2; fi;
	return Decomposition;
end);


Matrix_T := [
		[ 1, 1],
		[ 0, 1]
	];

Matrix_S := [
		[ 0, -1],
		[1, 0]
	];

G:=Group(Matrix_S, Matrix_T);
hom_to_Sl := GroupHomomorphismByImages( F, G, [S, T], [Matrix_S, Matrix_T] );

InstallGlobalFunction(ToMatrix, list -> List(list, x -> ImageElm(hom_to_Sl, x)));

# Here we describe elements of Sl_2(Z) as free words in S and T

# this function tests, wether two elements of Sl_2(Z) are in the same right coset of a given
# INPUT: The cosetgraph as permutations sigma_S and sigma_T, and the number of the cosets c1, c2
# OUTPUT: true iif they are
InstallGlobalFunction(SameCoset, function(c1, c2 ,sigma_S, sigma_T)
	local hom;
	hom := GroupHomomorphismByImages( F, Group(sigma_S, sigma_T), [S, T], [sigma_S, sigma_T] );
	return 1^ImageElm(hom, c1) = 1^ImageElm(hom, c2);
end);

# tests wether an element is in a subgroup of sl2(Z)
InstallGlobalFunction(ElemOfVeechGroup, function(c ,sigma_S, sigma_T)
	return SameCoset(c, S*S^-1, sigma_S, sigma_T);
end);

InstallGlobalFunction(MatrixInVeechGroup, function(A,O) return ElemOfVeechGroup(DecompositionOfMatritToFreeGroup(A),SAction(VeechGroup(O)) , TAction(VeechGroup(O))); end);
