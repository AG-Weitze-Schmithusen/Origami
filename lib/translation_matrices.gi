transl_matr_hcycle := function(n, i)
    if i mod n = 0 then return i - n + 1; fi;
    return i + 1;
end;
transl_matr_vcycle := function(n, i)
    if QuoInt(i-1, n) = n-1 then return i - n * (n-1); fi;
    return i + n;
end;
TranslationMatrix := function(n, is_right)
    local N, mat, i, j, in_axis, cross_axis, extra_point;
    N := n * n + 1;
    if is_right then 
        in_axis := 1; cross_axis := 2; extra_point := n * n - 1;
    else 
        in_axis := 2; cross_axis := 1; extra_point := n * n - n;
    fi;
    mat := [];
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
    for i in [1..n*n-1] do
        if i = extra_point then continue; fi;
        mat[2+i] := List([1..N], i->0);
        if is_right then j := transl_matr_hcycle(n, i); else j := transl_matr_vcycle(n, i); fi;
        mat[2+i][2+j] := 1;
    od;
    mat[2 + extra_point] := List([1..N], i->-1);
    mat[2 + extra_point][1] := 0;
    mat[2 + extra_point][2] := 0;
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