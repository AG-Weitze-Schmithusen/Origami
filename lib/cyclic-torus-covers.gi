# this function is a helper function to create the correct permutations
# slits is hslits or vslits respectively and cycleFunc is a function
# that gives the right or the bottom neighbour
SlitsToPerm := function(n, d, cycleFunc, slits)
    local lst, q, i, k, numsq, newi, newk;
    
    lst := [];
    numsq := n^2;

    # we interate through all the fields (q ranges from 0 to dn^2-1)
    # and determine the right and lower neighbour
    for q in [0 .. (d*numsq - 1)] do
        i := QuoInt(q, numsq);
        k := (q mod numsq); # 0 based

        # the index of the copy is determined using slits, the actual field is cycled
        newi := (i+slits[k + 1]) mod d;
        newk := cycleFunc(n, k) + 1; # now 1 based
        
        lst[q + 1] := newi * numsq + newk; # also 1 based as needed
    od;
    return PermList(lst);
end;

# define the two functions that give the (cycled) right/top neighbour
# important: these are all 0 based, that is, the input must be in [0..n^2-1]
hcycle := {n, k} -> QuoInt(k, n) * n + (((k mod n) + 1) mod n);

vcycle := function(n, k)
    k := k + n;
    if k >= (n^2) then
        k := k - (n^2);
    fi;
    return k;
end;

InstallGlobalFunction(GeneralizedCyclicTorusCover, function(n, d, vslits, hslits)
    return Origami(SlitsToPerm(n, d, hcycle, vslits), SlitsToPerm(n, d, vcycle, hslits));
end);


InstallGlobalFunction(CombOrigami, function (n, x, y)
    local coord_to_index, vseams, hseams, vslits, hslits, s, half, connect, rcycle, ucycle, rotate90, 
        A, B, C, D, P, Q, R, S;
    half := n/2;
    x := x mod n;
    y := y mod n;
    if (x=0 and y=0) or (n mod 2 = 0 and ((x = half and y = half) or (x = half and y = 0) or (x = 0 and y = half))) then
        return fail;
    fi;

    rotate90 := k->[(n-k[2]) mod n, k[1] mod n];

    P := [x,y];
    Q := rotate90(P);
    R := rotate90(rotate90(P));
    S := rotate90(rotate90(rotate90(P)));
    A := [y,y];
    B := [n-y, y];
    C := [n-y, n-y];
    D := [y, n-y];

    rcycle := P-> [(P[1] + 1) mod n, P[2]];
    ucycle := P-> [P[1], (P[2] + 1) mod n];
    coord_to_index := A -> A[1] + n*A[2] + 1; # helper to convert 0 based coords to 1 based indices

    # helper that "connects" two points by returning a list of relevant seams
    # is_short_path determines which way to go to connect the two points
    connect := function(A, B, is_short_path)
        local lst;

        A := [A[1] mod n, A[2] mod n]; B := [B[1] mod n, B[2] mod n];
        if (A[1] <> B[1] and A[2] <> B[2]) or A=B then return []; fi;

        lst := [];
        if A[1] = B[1] then
            if (A[2] > B[2] and is_short_path) or (A[2] < B[2] and not is_short_path) then
                return connect(B, A, is_short_path);
            fi;
            # vertical seam
            Add(lst, coord_to_index([(A[1] - 1) mod n, A[2]]));
            while ucycle(A) <> B do
                A := ucycle(A);
                Add(lst, coord_to_index([(A[1] - 1) mod n, A[2]]));
            od;
        else
            if (A[1] > B[1] and is_short_path) or (A[1] < B[1] and not is_short_path) then
                return connect(B, A, is_short_path);
            fi;
            # horizontal seam
            Add(lst, coord_to_index([A[1], (A[2] - 1) mod n]));
            while rcycle(A) <> B do
                A := rcycle(A);
                Add(lst, coord_to_index([A[1], (A[2] - 1) mod n]));
            od;
        fi;

        
        return lst;
    end;

    # the different cass
    if y=0 then # on a line through 0
        hseams := connect(P, R, true);
        vseams := connect(Q, S, true);
    elif x=0 then
        vseams := connect(P, R, true);
        hseams := connect(Q, S, true);
    elif x=-y  or x=y then # diagonal
        hseams := Union([connect(P, Q, true), connect(P, Q, false)]);
        vseams := Union([connect(R, Q, false), connect(P, S, true)]);
    elif (x=half or y=half) and n mod 2 = 0 then # on a line through M
        # unclear where e3 goes, we assume B to A over the edge
        hseams := Union([connect(P, B, true), connect(B, A, false), connect(R, C, true)]);
        vseams := Union([connect(B, Q, true), connect(C, B, false), connect(A, S, true)]);
    else # inside a triangle
        hseams := Union([connect(P, B, true), connect(B, A, false), connect(R, C, true)]);
        vseams := Union([connect(Q, C, true), connect(S, A, false)]);
    fi;
    
    s := function (i, points) if i in points then return 1; else return 0; fi; end;
    vslits := List([1..n^2], i -> s(i, vseams));
    hslits := List([1..n^2], i -> s(i, hseams));

    return GeneralizedCyclicTorusCover(n, 2, vslits, hslits);
end);

InstallGlobalFunction(CyclicTorusCoverOrigami, function(n, d, v)
    local i, j, c, hslits, vslits;
    if not Length(v) = n*n+1 then
        Error("Length of v must be n^2+1");
    fi;
    hslits := List([1..n*n], i->0);
    vslits := List([1..n*n], i->0);
    # first fill the upper row
    for i in [1..n] do
        hslits[n*(n-1) + i] := v[i];
    od;
    # fill the right column
    for i in [1..n] do
        vslits[n*i] := v[n + i];
    od;
    # fill in the rest
    c := 2 * n;
    for i in [1..(n-1)] do
        for j in [1..(n-1)] do
            c := c + 1;
            # i is the row, j the column
            # the number of the tile is then n * (row - 1) + column
            hslits[n * (i - 1) + j] := v[c];
        od;
    od;
    return GeneralizedCyclicTorusCover(n, d, vslits, hslits);
end);

InstallGlobalFunction(TranslationGroupOnHomologyOfTn, function(n)
    return GroupByGenerators([TranslationMatrixOnHomologyOfTn(n, true), TranslationMatrixOnHomologyOfTn(n, false)]);
end);
