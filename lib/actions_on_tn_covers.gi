TranslationMatrix := function(n, is_right) # n > 1
    local N, mat, i, j, in_axis, cross_axis, x, y, newx, newy;

    if not n > 1 then
        Error("n must be larger than 1");
    fi;
    N := n * n + 1;
    if is_right then 
        in_axis := 1; cross_axis := 2;
    else 
        in_axis := 2; cross_axis := 1;
    fi;
    mat := [];
    # one loops ("a" or "b") stays fixed, the image of the other one has to be
    # calculated
    mat[in_axis] := List([1..N], i->0);
    mat[in_axis][in_axis] := 1;
    mat[cross_axis] := List([1..N], i->0);
    mat[cross_axis][cross_axis] := 1;
    if n = 2 then
        # n = 2 is a special case, the only loop on the 2nd row/column is the 2nd/3rd one
        if is_right then
            mat[cross_axis][2 + 1] := -1;
            mat[cross_axis][2 + 2] := 0;
            mat[cross_axis][2 + 3] := -1;
        else
            mat[cross_axis] := [1,0,-1,-1,0];
        fi;
    else
        for i in [0..n-1] do
            if is_right then 
                j := 2 + (2 + i * n);
            else
                j := 2 + (1 + i + n);
            fi;
            mat[cross_axis][j] := 1; 
        od;
    fi;
    # loop through all loops and move them to the right/up
    for y in [0..n-1] do
        for x in [0..n-1] do
            if x=n-1 and y=n-1 then continue; fi;
            if is_right then
                newx := (x+1) mod n;
                newy := y;
            else
                newx := x;
                newy := (y+1) mod n;
            fi;
            # convert (x,y) to 1-based number
            mat[2 + n*y+x + 1] := vec_of_loop(n, n*newy+newx + 1);
        od;
    od;

    return TransposedMat(mat);
end;

BaseChangeSToB := function(n)
local N, mat, i, j, k, loopIndex;
N := n * n + 1;
mat := [];
mat[1] := List([1..N], i->0);
mat[1][n+1] := 1;
mat[2] := List([1..N], i->0);
mat[2][1] := 1;
for i in [0..n-2] do
    mat[2][2 * n + 1 + i * (n - 1)] := 1;
od;
# the origin loop crosses 4 slits
mat[3] := List([1..N], i->0);
mat[3][1] := 1;
mat[3][n+1] := -1;
mat[3][n] := -1;
mat[3][2*n] := 1;
# the loops at the left edge cross 3 slits
for i in [1..n-1] do
    loopIndex := 1 + i * n;
    mat[2 + loopIndex] := List([1..N], i->0);
    mat[2 + loopIndex][2 * n + 1 + (i-1) * (n-1)] := 1; # the horizontal slit is crossed bottom up
    mat[2 + loopIndex][i + n] := 1; # lower vertical slit crossed left to right
    mat[2 + loopIndex][i + n + 1] := -1; # upper vertical slit crossed right to left
od;
# the loops at the bottom edge
for i in [2..n] do
    mat[2 + i] := List([1..N], i->0);
    mat[2 + i][i] := 1;
    mat[2 + i][i-1] := -1;
od;
# the loops in the middle cross one or two slits
for i in [1..n-1] do
    for j in [1..n-1] do
        if i = n-1 and j = n-1 then continue; fi;
        loopIndex := i * n + j + 1;
        mat[2 + loopIndex] := List([1..N], i->0);
        k := 2 * n + (i-1) * (n-1) + j ;
        mat[2 + loopIndex][k] := -1;
        if j < n-1 then
            mat[2 + loopIndex][k+1] := 1;
        fi;
    od;
od;

return TransposedMat(mat);
end;

vec_of_loop := function(n, loop)
    local N, v;
    if loop < 1 or loop > n*n then
        Error("loop must be between 1 and n^2");
    fi;
    N := n*n+1;
    if loop = n*n then
        v := List([1..N], i->-1);
        v[1] := 0;
        v[2] := 0;
        return v;
    fi;
    v := List([1..N], i->0);
    v[loop+2] := 1;
    return v;
end;

ActionOfTOnHomologyOfTn := function(n)
    local mat, N, i, j, k, l, img_of_b_wrong_base;
    N := n * n + 1;
    mat := [];
    # the horizontal path is a fixpoint: T(a) = a
    mat[1] := List([1..N], i->0);
    mat[1][1] := 1;

    # the vertical path is done via the other base
    img_of_b_wrong_base := List([1..N], i->0);
    img_of_b_wrong_base[1] := 1;
    img_of_b_wrong_base[2*n] := 1;
    for i in [2..n-1] do
        img_of_b_wrong_base[n*i+2] := 1;
    od;
    mat[2] := Inverse(BaseChangeSToB(n)) * img_of_b_wrong_base;

    for k in [1..n*n-1] do
        # loop l_k
        # caluclate (0-based) (x,y)-coordinates of the loop
        i := QuoInt(k-1, n);
        j := ((k-1) mod n);
        l := n * i + ((i + j) mod n) + 1;
        mat[2+k] := vec_of_loop(n, l);
    od;

    return TransposedMat(mat);
end;

unit_vector := function(n, i)
    local v;
    v := List([1..n], x->0);
    v[i] := 1;
    return v;
end;

apply_S_to_loop := function(n, k)
    local x,y,x2, y2;
    y := QuoInt(k-1, n);
    x := ((k-1) mod n);
    # now rotate and wrap
    y2 := x mod n;
    x2 := -y mod n;
    return n * y2 + x2 + 1;
end;

ActionOfSOnHomologyOfTn := function(n)
    local mat, N, i, j, v, k, l;
    N := n * n + 1;
    mat := [];
    mat[1] := Inverse(BaseChangeSToB(n)) * unit_vector(N, n);
    mat[2] := -unit_vector(N,1);

    for k in [1..n*n-1] do
        mat[2+k] := vec_of_loop(n, apply_S_to_loop(n, k));
    od;

    return TransposedMat(mat);
end;

ActionOfMatrixOnHomologyOfTn := function(n, A)
    local itm, S, T, mat;
    S := ActionOfSOnHomologyOfTn(n);
    T := ActionOfTOnHomologyOfTn(n);
    mat := IdentityMat(n*n+1);
    for itm in STDecompositionAsList(A) do
        if itm[1] = "S" then
            mat := mat * (S^itm[2]);
        else
            mat := mat * (T^itm[2]);
        fi;
    od;
    return mat;
end;