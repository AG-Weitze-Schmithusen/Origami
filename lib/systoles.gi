# priority queue
PQueue_push := function(q, elem)
    local low, high, mid;

    low := 1;
    high := Length(q);
    
    while low < high do
        mid := Int((low + high) * 0.5);
        if q[mid] < elem then
            low := mid + 1;
        else
            high := mid;
        fi;
    od;

    Add(q, elem, low);
end;

PQueue_top := function(q)
    return q[1];
end;

PQueue_pop := function(q)
    local temp;

    temp := q[1];
    Remove(q, 1);
    return temp; 
end;

# graphs

CreateGraph := function(i)
    local G;
    G := [];
    for i in [1..i] do
        Add(G, []);
    od;
    return G;
end;

AddSingleEdge := function(E, a, b, w)
    Add(E, rec(u := a, v := b, weight := w));
end;

AddEdge := function(G, a, b, w)
    Add(G[a], rec(node := b, weight := w));
    Add(G[b], rec(node := a, weight := w));
end;

RemoveEdge := function(G, a, b, w)
    local j, k;

    Remove(G[a], Position(G[a], rec(node := b, weight := w)));
    Remove(G[b], Position(G[b], rec(node := a, weight := w)));
end;

ShortestPath := function(G, src, dest)
    local pq, dist, p, u, i, weight, v, prev, S, node;
    pq := [];
    dist := [];
    prev := [];

    for p in [1..Length(G)] do
        Add(dist, infinity);
        Add(prev, -1);
    od;
    
    PQueue_push(pq, rec(first := 0., second := src));
    dist[src] := 0;

    while(not IsEmpty(pq)) do
        u := PQueue_pop(pq).second;
        
        for i in G[u] do
            v := i.node;
            weight := i.weight;

            if (Float(dist[v]) > Float(dist[u] + weight)) then
                dist[v] := dist[u] + weight;
                PQueue_push(pq, rec(first := dist[v], second := v));
                prev[v] := u;
            fi;
        od;
    od;

    S := [];
    node := dest;
    if not (prev[node] = -1) or node = src then
        while not (prev[node] = -1) do
            Add(S, node, 1);
            node := prev[node];
        od;
    fi;

    return rec(length := dist[dest], combinatorial_length := Length(S));
end;

MinimalCycle := function(G, E)
    local min_cycle, i, e, distance, combinatorial_length, temp_length, result;

    min_cycle := infinity;
    combinatorial_length := -1;

    for i in [1..Length(E)] do
        distance := 0;
        e := E[i];
        RemoveEdge(G, e.u, e.v, e.weight);

        # edge from a node to itself already is a path with minimum distance
        if e.u = e.v then
            # set distance to 0 because the weight is already added in the if statement below
            distance := 0;
            temp_length := 1;
        else
            result := ShortestPath(G, e.u, e.v);
            distance := result.length;
            # add one because we removed one edge
            temp_length := result.combinatorial_length + 1;
        fi;
        
        # update the minimal cycle if necessary
        if Float(min_cycle) > Float(distance + e.weight) then
            min_cycle := distance + e.weight;
            combinatorial_length := temp_length;
        fi;

        AddEdge(G, e.u, e.v, e.weight);
    od;

    # we save the combinatorial length to verify its a systole
    return rec(systole := min_cycle, combinatorial_length := combinatorial_length);
end;

# other helpers

CyclesToList := function(sigma)
    local L, k, i, cycle_list, curr, temp;

    L := List(MovedPoints(sigma));
    cycle_list := [];
    curr := 1;

    while(Length(L) > 0) do
        k := 1;
        i := L[1];
        
        Add(cycle_list, []);
        Add(cycle_list[curr], i);
        while(not (i ^ (sigma ^ k) = i)) do
            temp := i ^ (sigma ^ k);
            Remove(L, Position(L, temp));
            Add(cycle_list[curr], temp);
            k := k + 1;
        od;

        Remove(L, Position(L, i)); 
        curr := curr + 1;
    od;

    return cycle_list;
end;

MapCycleListAndOrigami := function(wordString, cycle_list, O)
    local i, j, letter, F, word;

    F := FreeGroup("S","T");
	word := ParseRelators(GeneratorsOfGroup(F), wordString)[1];

    # loop over the decompositon of A
	for letter in Reversed(LetterRepAssocWord(word)) do
		if letter = 1 then
            # we apply S to the origami and the singularities
            for i in [1..Length(cycle_list)] do
                Apply(cycle_list[i], j -> j ^ (VerticalPerm(O)^-1));
            od;
			O := ActionOfS(O);
		elif letter = 2 then
            # only need to apply T to the origami
			O := ActionOfT(O);
		elif letter = -1 then
            # we apply S^-1 to the origami and the singularities
            for i in [1..Length(cycle_list)] do
                Apply(cycle_list[i], j -> j ^ (HorizontalPerm(O)^-1));
            od;
			O := ActionOfSInv(O);
		elif letter = -2 then
            # only need to apply T to the origami
			O := ActionOfTInv(O);
		else
			Error("<word> must be a word in two generators");
		fi;
	od;

	return rec(cycle_list_mapped := cycle_list, mapped_origami := O);
end;

LookupIndex := function(a, c)
    local i, j;
    for i in [1..Length(c)] do
        for j in [1..Length(c[i])] do
            if c[i][j] = a then
                return i;
            fi;
        od;
    od;
    Error("No index found!");
end;

InstallGlobalFunction(SystoleLength, function(O, equilateral...)
    local min_cycle_length_horizontal, min_cycle_length_vertical, min_cycle_length,
            S, x, y, v, g, A, A_O, w, L, i, perm, k, j, graph, cycle_list, cycle_list_mapped, edges,
            min_cycle_length_squared, length, index_i, index_j, mapping_result, equilateral_length,
            equilateral_basis_vector1, equilateral_basis_vector2, equilateral_vector;

    equilateral_length := (2^0.5)/(3^0.25);
    equilateral_basis_vector1 := [equilateral_length, 0];
    equilateral_basis_vector2 := equilateral_length * [0.5, (3^0.5)/2];

    min_cycle_length_horizontal := Minimum(List(MovedPoints(HorizontalPerm(O)), x -> CycleLength(HorizontalPerm(O), x)));
    min_cycle_length_vertical := Minimum(List(MovedPoints(VerticalPerm(O)), x -> CycleLength(VerticalPerm(O), x)));

    min_cycle_length := Minimum(min_cycle_length_horizontal, min_cycle_length_vertical);
    min_cycle_length_squared := min_cycle_length^2;

    # calculate S = list of all the primitive vectors with length of at most min_cycle_length
    S := [[1, 0]];

    # y > 0
    x := -(min_cycle_length - 1);
    y := 1;
    while x^2 + y^2 <= min_cycle_length_squared do
        while x^2 + y^2 <= min_cycle_length_squared do
            if Gcd(x, y) = 1 then
                Add(S, [x, y]);
            fi;
            y := y + 1;
        od;
        y := 1;
        x := x + 1;
    od;
 
    # create an empty graph with as much nodes as there are singularities
    graph := CreateGraph(Length(Stratum(O)));

    # we keep an extra list of the edges for algorithm 3
    edges := [];

    # make a list from the cycles of the commutator of the horizontal/vertical permutations
    # to find corresponding singularites after applying an element of SL_2(Z)
    cycle_list := CyclesToList(VerticalPerm(O)^-1 * HorizontalPerm(O)^-1 * VerticalPerm(O) * HorizontalPerm(O));

    # for every direction in S we apply Algorithm 1
    for v in S do     

        x := v[1];
        y := v[2];

        A_O := O;
        cycle_list_mapped := StructuralCopy(cycle_list);

        # if v is the unit vector we do not need to apply a matrix
        if not v = [1, 0] then
            # find a matrix A in SL_2(Z) s.t. Av = (1, 0) via the extended Eucledian algorithm
            g := Gcdex(x, y);
            A := [[g.coeff1, g.coeff2], [-y, x]];

            # map the singularities from O to the singularities of A.O and compute the origami A.O
            mapping_result := MapCycleListAndOrigami(String(STDecomposition(A)), cycle_list_mapped, A_O);
            cycle_list_mapped := mapping_result.cycle_list_mapped;
            A_O := mapping_result.mapped_origami;
        fi;

        # compute a list of all squares whose lower left corner has a singularity
        L := MovedPoints(VerticalPerm(A_O)^-1 * HorizontalPerm(A_O)^-1 * VerticalPerm(A_O) * HorizontalPerm(A_O));

        # in this step the edges are computed and added to the graph
        for i in L do
            perm := HorizontalPerm(A_O);
            k := 1;
            j := i^perm;

            # find the smallest k such that sigma(i)^k is contained in L
            while not j in L do
                perm := HorizontalPerm(A_O) * perm;
                k := k + 1;
                j := i^perm;
            od;
            
            # check if we want to consider origamis consisting of equilateral triangles
            if Length(equilateral) > 0 and IsBool(equilateral[1]) and (equilateral[1] = true) then
                equilateral_vector := x * equilateral_basis_vector1 + y * equilateral_basis_vector2;
                length := k * (equilateral_vector[1]^2 + equilateral_vector[2]^2)^0.5;
            else
                length := k * (x^2 + y^2)^0.5;
            fi;
            # if i is contained in the nth cycle then LookUpIndex returns n, same for j
            index_i := LookupIndex(i, cycle_list_mapped);
            index_j := LookupIndex(j, cycle_list_mapped);
            
            AddEdge(graph, index_i, index_j, length);
            AddSingleEdge(edges, index_i, index_j, length);
        od;
    od;

    return MinimalCycle(graph, edges);
end);

InstallGlobalFunction(SystolicRatio, function(O, equilateral...)
    local systole_info;
    if Length(equilateral) > 0 then
        systole_info := SystoleLength(O, equilateral[1]);
    else
        systole_info := SystoleLength(O);
    fi;
    return rec(systolic_ratio := (systole_info.systole)^2 / DegreeOrigami(O), combinatorial_length := systole_info.combinatorial_length);
end);

InstallGlobalFunction(MaximalSystolicRatioInStratum, function(from, to, stratum, equilateral...)
    local max_sr, deg, origamis, result, max_origami, three_occured;

    max_sr := -1.;
    max_origami := Origami((),());
    three_occured := false;

    for deg in [from..to] do
        origamis := AllOrigamisInStratum(deg, stratum);
        if Length(equilateral) > 0 then
            result := MaximalSystolicRatioOfList(origamis, equilateral[1]);
        else
            result := MaximalSystolicRatioOfList(origamis);
        fi;

        if result.three_occured then
            three_occured := true;
        fi;

        if result.systolic_ratio > max_sr then
            max_sr := result.systolic_ratio;
            max_origami := result.origami;
        fi;
    od;

    return rec(systolic_ratio := max_sr, origami := max_origami, three_occured := three_occured);
end);

InstallGlobalFunction(MaximalSystolicRatioByDegree, function(d, equilateral...)
    local origamis;

    origamis := Filtered(AllOrigamisByDegree(d), o -> Genus(o) >= 2);
    if Length(equilateral) > 0 then
        return MaximalSystolicRatioOfList(origamis, equilateral[1]);
    else
        return MaximalSystolicRatioOfList(origamis);
    fi;
end);

InstallGlobalFunction(MaximalSystolicRatioOfList, function(origamis, equilateral...)
    local max_sr, O, result, three_occured, max_origami;

    max_sr := -1.;
    max_origami := Origami((),());
    three_occured := false;

    for O in origamis do
        if Length(equilateral) > 0 then
            result := SystolicRatio(O, equilateral[1]);
        else
            result := SystolicRatio(O);
        fi;
        if result.combinatorial_length = 3 then
            three_occured := true;
        fi;
        if(result.systolic_ratio > max_sr) then
            max_sr := result.systolic_ratio;
            max_origami := O;
        fi;   
    od;

    return rec(systolic_ratio := max_sr, origami := max_origami, three_occured := three_occured);
end);

GenerateOrigamiByFpGroup := function(G, r, s)
    local horizontalPerm, verticalPerm, i, j, elemTimes_r, elemTimes_s, elements, elem;
    
    elements := Elements(G);

    horizontalPerm := [1..Order(G)];
    verticalPerm := [1..Order(G)];

    for i in [1..Order(G)] do
        elemTimes_r := elements[i] * r;
        elemTimes_s := elements[i] * s;
        j := 1;
        for elem in elements do
            if elemTimes_r = elem then
                horizontalPerm[i] := Position(elements, elem);
            fi;
            if elemTimes_s = elem then
                verticalPerm[i] := Position(elements, elem);
            fi;
        od;
    od;

    return Origami(PermList(horizontalPerm), PermList(verticalPerm));
end;

CompareOrigamisInStratum := function(degree, stratum)
    local L, equilateral_wins, square_wins, square_posmax, equilateral_posmax, square_max, equilateral_max;

    L := AllOrigamisInStratum(degree, stratum);
    Apply(L, o -> [o, SystolicRatio(o), SystolicRatio(o, true)]);
    Apply(L, x -> [x[1], x[2], x[3], x[2] < x[3], x[3] < x[2]]);
    equilateral_wins := Length(Filtered(L, x -> x[4] = true));
    square_wins := Length(Filtered(L, x -> x[5] = true));
    square_posmax := PositionMaximum(List(L, x -> x[2]));
    square_max := [L[square_posmax][1], L[square_posmax][2]];
    equilateral_posmax := PositionMaximum(List(L, x -> x[3]));
    equilateral_max := [L[equilateral_posmax][1], L[equilateral_posmax][3]];
    Print("There was a total of ", Length(L)," origamis.\n");
    Print("Square max: ", square_max, "\n");
    Print("Equilateral max: ", equilateral_max, "\n");
    Print("Square wins ", square_wins, "\n");
    Print("Equilateral wins ", equilateral_wins, "\n");
end;

SystolicRatioOfNormalOrigamis := function(from, to)
    local L, StratumCompare, MapOrigami, i;

    L := [];
    for i in [from..to] do
        Append(L, AllNormalOrigamisByDegree(i));
    od;

    Apply(L, o -> AsPermutationRepresentation(o));
    L := Filtered(L, o -> Genus(o) >= 2);
    
    StratumCompare := function(o1, o2)
        if Length(Stratum(o1)) = Length(Stratum(o2)) then
            return Stratum(o1)[1] < Stratum(o2)[1];
        else
            return Length(Stratum(o1)) < Length(Stratum(o2));
        fi;
    end;

    Sort(L, StratumCompare);

    MapOrigami := function(o)
        local result1, result2;

        result1 := SystolicRatio(o);
        result2 := SystolicRatio(o, true);
        if result1.combinatorial_length = true or result2.combinatorial_length = true then
            return [o, Stratum(o), result1.systolic_ratio, result2.systolic_ratio, true];
        fi;
        return [o, Stratum(o), result1.systolic_ratio, result2.systolic_ratio, false];
    end;

    Apply(L, o -> MapOrigami(o));
    return L;
end;

RoundToDigit := function(number, digits)
    local factor;

    factor := 10^(digits - 1);
    return Round(number * factor) / factor;
end;