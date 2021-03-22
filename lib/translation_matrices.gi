hcycle := function(n, i)
    if i mod n = 0 then return i - n + 1; fi;
    return i + 1;
end;
vcycle := function(n, i)
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
    mat[cross_axis][in_axis] := 1;
    for i in [0..n-1] do
        if is_right then 
            j := 2 + (2 + i * n);
        else
            j := 2 + (1 + i + n);
        fi;
        mat[cross_axis][j] := 1; 
    od;
    for i in [1..n*n-1] do
        if i = extra_point then continue; fi;
        mat[2+i] := List([1..N], i->0);
        if is_right then j := hcycle(n, i); else j := vcycle(n, i); fi;
        mat[2+i][2+j] := 1;
    od;
    mat[2 + extra_point] := List([1..N], i->-1);
    mat[2 + extra_point][1] := 0;
    mat[2 + extra_point][2] := 0;
    return TransposedMat(mat);
end;