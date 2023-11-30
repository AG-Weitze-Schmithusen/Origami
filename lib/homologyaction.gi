#########################################   Help Functions ####################################################################################################


HomologyActionOfS := function(O)
  local n, A, h, v, i;
  n := DegreeOrigami(O);
  A := NullMat(2*n, 2*n, Integers);
  h := HorizontalPerm(O);
  v := VerticalPerm(O);
  for i in [1..n] do
    A[n+i^(v^-1)][i] := 1;
  od;
  for i in [1..n] do
    A[i][n+i] := -1;
  od;
  return A;
end;

HomologyActionOfSInv := function(O)
  local n, A, h, v, i;
  n := DegreeOrigami(O);
  A := NullMat(2*n, 2*n, Integers);
  h := HorizontalPerm(O);
  v := VerticalPerm(O);
  for i in [1..n] do
    A[n+i][i] := -1;
  od;
  for i in [1..n] do
    A[i^(h^-1)][n+i] := 1;
  od;
  return A;
end;

HomologyActionOfT := function(O)
  local n, A, h, v, i;
  n := DegreeOrigami(O);
  A := NullMat(2*n, 2*n, Integers);
  h := HorizontalPerm(O);
  v := VerticalPerm(O);
  for i in [1..n] do
    A[i][i] := 1;
  od;
  for i in [1..n] do
    A[i][n+i] := 1;
    A[n+i^h][n+i] := 1;
  od;
  return A;
end;

HomologyActionOfTInv := function(O)
  local n, A, h, v, i;
  n := DegreeOrigami(O);
  A := NullMat(2*n, 2*n, Integers);
  h := HorizontalPerm(O);
  v := VerticalPerm(O);
  for i in [1..n] do
    A[i][i] := 1;
  od;
  for i in [1..n] do
    A[n+i^(h^-1)][n+i] := 1;
    A[i^(h^-1)][n+i] := -1;
  od;
  return A;
end;

HomologyActionOfTInvC := function(O)
  local n, A, h, v, i,P;
  n := DegreeOrigami(O);
  P := ShallowCopy(O);
  A := NullMat(2*n, 2*n, Integers);
  h := HorizontalPerm(O);
  v := VerticalPerm(O);
  for i in [1..n] do
    A[i][i] := 1;
  od;
  for i in [1..n] do
    A[n+i^(h^-1)][n+i] := 1;
    A[i^(h^-1)][n+i] := -1;
  od;
    P := ActionOfTInv(P);
  return [A,P];
end;

HomologyActionOfChanged := function(A, O)
  local n, letter, word, F, wordString, N, P;
  n := DegreeOrigami(O);
  P := ShallowCopy(O);
  F := FreeGroup("S","T");
  wordString := String(STDecomposition(A));
	word := ParseRelators(GeneratorsOfGroup(F), wordString)[1];
  N := IdentityMat(2*n, Integers);
    #for letter in Reversed(LetterRepAssocWord(word)) do
	for letter in LetterRepAssocWord(word)do
		if letter = 1 then
      N := HomologyActionOfS(P) * N;
			P := ActionOfS(P);
		elif letter = 2 then
      N := HomologyActionOfT(P) * N;
			P := ActionOfT(P);
		elif letter = -1 then
      N := HomologyActionOfSInv(P) * N;
			P := ActionOfSInv(P);
		elif letter = -2 then
      N := HomologyActionOfTInv(P) * N;
			P := ActionOfTInv(P);
		else
			Error("<word> must be a word in two generators");
		fi;
	od;
  return ([N,P]);
end;


CorrectActionOnHomologyByPermutation := function (O,A,pi)
# Calculates the action on homology given the error permutation pi        
   #Input: origami O, matrix A which presents the action of an affine homeom on non-taut Part w.r.t. a possibly new labeling of the sqaures, permutation pi which describes the relabeling O --> A*O
   #Output: matrix A which describes the acion on homology w.r.t the original labeling
   local ANew, i ,j, n;
   n := DegreeOrigami(O);
   ANew := NullMat(2*n, 2*n, Integers);
    for i in [1..n] do for j in [1..2*n] do ANew[i,j] := A[i^pi,j]; od; od;
    for i in [1..n] do for j in [1..2*n] do ANew[n+i,j] := A[n+i^pi,j]; od; od;
   return(ANew);
   end;


# This function comptes a table which indicates which corner of each Square belongs to whih vertex in the following sense:
# Let v_1, ... v_k be the singularities of the Origami
# if VertexNumbering( O )[ 4* (i - 1) + j] = k means 
# j=1 => The upper left corner of squre i is v_k
# j=2 => The upper right corner of squre i is v_k
# j=3 => The bottom left corner of squre i is v_k
# j=4 => The bottom right corner of squre i is v_k
VertexNumbering := function( O )
	local ToVisit, StartQ, current, cc, Table, P;
	Table := [];
	ToVisit := [1.. DegreeOrigami( O )];
	cc := 1;
	while ( Length( ToVisit ) > 0  ) do
		StartQ := Remove(ToVisit, 1);
		current := StartQ;
		repeat
			Table[ 4 * ( current - 1) + 2] := cc;
			current := current ^ HorizontalPerm( O );
			
			Table[ 4 * ( current - 1) + 1] := cc;
			current := current ^ VerticalPerm( O );

			Table[ 4 * ( current - 1) + 3] := cc;
			current := current ^ ( HorizontalPerm( O )^-1 );

			Table[ 4 * ( current - 1) + 4] := cc;
			current := current ^ ( VerticalPerm( O )^-1 );	
			
			P := Position( ToVisit, current );
			if P <> fail then Remove( ToVisit, P); fi;							
		until ( current = StartQ);
		cc := cc + 1;
	od;
	return Table;
end;

# Comptutes the standard basis vector e_i in R^n
VecInDimZero := function( n, i )
	local res, k;
	res :=[];
	for k in [1..n] do
		if k = i then Add(res, 1); else Add(res, 0); fi;
	od;
	return res;
end;

# This computes the boundary map C_1 -> C_0 of the Origami O as matrix.
BoundaryMapInDimZero := function( O )
	local Edges, res, k, n;
	Edges := VertexNumbering( O );
	res := [];
	n := Maximum( Edges );
	for k in [1..DegreeOrigami( O )] do
	 Add( res, - VecInDimZero( n,  Edges[ 4 * ( k-1 ) + 3] ) + VecInDimZero(n, Edges[ 4 * ( k-1 ) + 4]  ) );	
	od;
	for k in [1..DegreeOrigami( O )] do
	 Add( res, VecInDimZero( n,  Edges[ 4 * ( k-1 ) + 1] ) - VecInDimZero( n, Edges[ 4 * ( k-1 ) + 3 ] ) );
	od;	
	return TransposedMat( res );
end;



# This function returns a list of relations of the homology of O. In fact it is a basis of the modul ker( d: C_2 -> C_1 ).
HomologyRelations := function( O )
	local res, k, l, rel;
	res := [];
	for l in [1.. DegreeOrigami( O )] do
		rel := [];
		for k in  [1..2*DegreeOrigami( O )] do
			Add(rel, 0);
		od;
		rel[l] := 1;
		rel[DegreeOrigami( O ) + l] := -1;
		rel[ l^VerticalPerm( O ) ] := rel[ l^VerticalPerm( O ) ] - 1;
		rel[DegreeOrigami( O ) + l^HorizontalPerm( O )] := rel[DegreeOrigami( O ) + l^HorizontalPerm( O )] + 1;
		Add(res, rel);
	od;
	return res;
end;



#Extents the Vector Space <V> \subsesteq Q^n to  Q^n. Returns a Basis of Q^n, which is a extension of V.
CompleteBasis := function( V, n)
	local B, res, k;
	B := Basis( Rationals^n );
	res := ShallowCopy( V );
	for k in [1..n] do
		if Dimension( VectorSpace( Rationals, res ) ) < Dimension( VectorSpace( Rationals, Union( res, [B[k]] ) ) ) then Add(res, B[k]); fi;
	od;
	return res;
end;

#Returns a Basis of a -complement- Vectorspace of <B_1> in <V>
CompleteBasisToVS := function( B_1, V )
	local B, CB, k, res;
	CB := ShallowCopy( B_1 );
	res := [];

	B := ShallowCopy( Basis( V ) );
	for k in [1..Dimension( V )] do
		if Dimension( VectorSpace( Rationals, CB ) ) < Dimension( VectorSpace( Rationals, Union( CB, [B[k]] ) ) ) then Add(CB, B[k]); Add(res, B[k]); fi;
	od;
	return res;	
end;




# Computes the holonomy map H_1( O, Z) -> Z^2 as matrix 
HolonomyMap := function( O, HomologyBasis )
	local res, k, l, sum;
	res := [];
	for k in [1..Length( HomologyBasis )] do
		Add(res, []);
		sum := 0;
		for l in [1..DegreeOrigami( O )] do
			sum := sum + HomologyBasis[k][l];
		od;
		res[k][1] := sum;
		sum := 0;
		for l in [1..DegreeOrigami( O )] do
			sum := sum + HomologyBasis[k][l + DegreeOrigami( O )];
		od;
		res[k][2] := sum;		
	od;
	return  res;
end;






# Cuts out the upper nxn Matrix of a larger Matrix
CutOutMatrix := function( M, n )
	local k,l, res;
	res := [];
	for k in [1..n] do
		Add( res, []);
		for l in [1..n] do
			res[k][l] := M[k][l];
		od;
	od;
	return res;
end; 

# Computes a Bais of C_1 = < h_1, ..., h_i, b_1, ..., b_k, a_1, ..., a_l, >, where the h's generate the Homology, the b's genereate Im(d: C_2 ->C_1)
NiceBasisForHomology := function( O, H)
	local res;
	res := ShallowCopy( H );
	Append( res, Basis( VectorSpace( Rationals, HomologyRelations(O)) ));
	res := CompleteBasis(res, 2*DegreeOrigami( O ));
	return res;	
end;

# Computes a Bais of C_1 = < n_1, ..., n_i, h_1,h_2, b_1, ..., b_k, a_1, ..., a_l, >, where the n's generate the Nontaut part of the Homology, the h's and the n's generate the entire Homology, the b's genereate Im(d: C_2 ->C_1)
NiceBasisForCurves := function( O, HomologyBasis )
	local res;
	res := NonTautPartOfHomologyOrigami( O, HomologyBasis );
	Append( res, CompleteBasisToVS(res, VectorSpace( Rationals, HomologyBasis)));
	Append( res, Basis( VectorSpace( Rationals, HomologyRelations(O)) ));
	res := CompleteBasis(res, 2*DegreeOrigami( O ));
	return res;
end;




CorPerm := function( O1, O2)
	return RepresentativeAction( SymmetricGroup( DegreeOrigami( O1) ), [HorizontalPerm( O1 ) , VerticalPerm( O1 ) ], [HorizontalPerm( O2 ) , VerticalPerm( O2 ) ], OnTuples);
end;

#Computes the action of A on the the edges of the Origami O
HomologyActionOnTop := function( O, A )
	local h;
	h := HomologyActionOfChanged( A, O );
	return CorrectActionOnHomologyByPermutation( O, h[1], CorPerm( O, h[2] ) );
end;











##########################################  Main Functions ##################################################################################################

#InstallMethod(ActionOfT, [IsOrigami], function(O)

InstallMethod(HomologyOrigami, [IsOrigami], function( O )
	return ComplementIntMat( NullspaceIntMat( TransposedMat( BoundaryMapInDimZero( O ) ) ), HomologyRelations( O ) ).complement;
end
);

InstallMethod(NonTautPartOfHomologyOrigami, [IsOrigami , IsList],  function( O, HomologyBasis )
	local k, res, L;
	L := NullspaceIntMat( HolonomyMap( O, HomologyBasis ) );
	res :=[];
	for k in [1..Length(L)] do
		Add(res, L[k] * HomologyBasis);
	od;
	return res;
end
);


# This function computes the Action of A on the  Homology of an Origami O with the  Homology Basis HomologyOrigami(O).
InstallMethod( ActionOfMatrixOnHom, [IsOrigami, IsMatrixObj], function( O, A)
	return ActionOfMatrixOnHom( O, A, HomologyOrigami(O) );
	end
);

# This function computes the Action of A on the  Homology of an Origami O with a given Homology Basis H 

InstallOtherMethod( ActionOfMatrixOnHom, [IsOrigami, IsMatrixObj, IsList], function( O, A, H)
	local dim, T, M;
	T := TransposedMat( NiceBasisForHomology( O, H ) );
	dim := Length( H);
	M := T^-1 * HomologyActionOnTop( O, A ) * T;
	return CutOutMatrix(M, dim);	
end );



# This function computes the Action of A on the nontautological part of the  Homology of an Origami O with the Homlogy Basis HomologyOrigami(O)
InstallMethod(ActionOfMatrixOnNonTaut , [IsOrigami, IsMatrixObj], function( O, A )
	return ActionOfMatrixOnNonTaut( O, A, HomologyOrigami( O ));
end
);

# This function computes the Action of A on the nontautological part of the Homology of an Origami O with a given HomologyBasis 
InstallOtherMethod( ActionOfMatrixOnNonTaut ,[IsOrigami, IsMatrixObj, IsList ], function( O, A, HomologyBasis )
	local dim, T, M;
	T := TransposedMat( NiceBasisForCurves( O, HomologyBasis ) );
	dim := Length( HomologyBasis ) - 2;
	M := T^-1 * HomologyActionOnTop( O, A ) * T;
	return CutOutMatrix(M, dim);
end );





# This function computes the Action of A on the nontautological part of the Homology of an Origami O with a given Homology Basis H and a basis of the Nontau. part H
InstallOtherMethod( ActionOfMatrixOnNonTaut, [IsOrigami, IsMatrixObj, IsList, IsList ] , function( O, A, HomBase, H )
	local NiceBasis, dim, T, M;
	NiceBasis := ShallowCopy( HomBase );
	Append( NiceBasis, CompleteBasisToVS(NiceBasis, VectorSpace( Rationals, H )));
	Append( NiceBasis, Basis( VectorSpace( Rationals, HomologyRelations(O)) ));
	NiceBasis := CompleteBasis(NiceBasis, 2*DegreeOrigami( O ));
	T := TransposedMat( NiceBasis );
	dim := Length( HomBase );
	M := T^-1 * HomologyActionOnTop( O, A ) * T;
	return CutOutMatrix(M, dim);
end );



# Computes the shadow Veech group of an Origami w.r.t. the Basis HomologyOrigami(O)
InstallMethod( ShadowVeechGroup, [IsOrigami], function( O )
	return ShadowVeechGroup( O, HomologyOrigami(O) );
end);


# Computes the shadow Veech group of an Origami w.r.t. the the Homolgy Basis H 
InstallOtherMethod( ShadowVeechGroup, [IsOrigami, IsList], function( O, H )
	local A, res, L, HomologyBasis, T, dim, M;
	res := [];
	L := MatrixGeneratorsOfGroup(VeechGroup(O));
	HomologyBasis := H;
	T := TransposedMat( NiceBasisForCurves( O, HomologyBasis ) );
	dim := Length( HomologyBasis ) - 2;
	for A in L do
		M := T^-1 * HomologyActionOnTop( O, A ) * T;
		Add( res,  CutOutMatrix(M, dim) );
	od;
	return Group( res );
end);

InstallGlobalFunction( HomologyToString, function( H )
	local i, res, m, n;
	n := Length(H)/2;
	m := -1;
	res := "";
	for i in [1..Length(H)] do
		if H[i] <> 0 then m := i; break; fi;
	od;
	if m = -1 then return "0"; fi;
	
	if m<= n  then 
		for i in [(m )..n] do
			if H[i] <> 0 then 
				if H[i] > 0 then Append( res, " + "); else Append(res, " - "); fi;
				Append( res, String(AbsoluteValue(H[i]) ) );
				Append( res, "s_");
				Append( res, String(i));
			fi;
		od;
	fi;	
	for i in [ Maximum( m, n + 1 ) ..Length(H)] do
		if H[i] <> 0 then 
			if H[i] > 0 then Append( res, " + "); else Append(res, " - "); fi;
			Append( res, String(AbsoluteValue(H[i]) ) );
			Append( res, "z_");
			Append( res, String(i - n));
		fi;
	od;	
	Remove( res, 1);
	Remove( res, 1);
	Remove( res, 1);	
	return res;
end);
