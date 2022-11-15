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

InstallGlobalFunction(SystoleLength, [IsOrigami], function(O)
    local min_cycle_length_horizontal, min_cycle_length_vertical, min_cycle_length,
            S, x, y, v, g, A, A_O, w, L, i, perm, k, j, graph, cycle_list, cycle_list_mapped, edges,
            min_cycle_length_squared, length, index_i, index_j, mapping_result;

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
            
            length := k * (x^2 + y^2)^0.5;
            # if i is contained in the nth cycle then LookUpIndex returns n, same for j
            index_i := LookupIndex(i, cycle_list_mapped);
            index_j := LookupIndex(j, cycle_list_mapped);
            
            AddEdge(graph, index_i, index_j, length);
            AddSingleEdge(edges, index_i, index_j, length);
        od;
    od;

    return MinimalCycle(graph, edges);
end);

InstallGlobalFunction(SystolicRatio, [IsOrigami], function(O)
    local systole_info;
    
    systole_info := SystoleLength(O);
    return rec(systolic_ratio := (systole_info.systole)^2 / DegreeOrigami(O), combinatorial_length := systole_info.combinatorial_length);
end);

InstallGlobalFunction(MaximalSystolicRatioInStratum, function(deg1, deg2, stratum)
    local max_sr, combinatorial_length, deg, origamis, result, max_origami, count, three_occured;

    max_sr := -1.;
    combinatorial_length := -1;
    max_origami := Origami((),());
    count := 0;
    three_occured := false;

    for deg in [deg1..deg2] do
        origamis := AllOrigamisInStratum(deg, stratum);
        result := MaximalSystolicRatioOfList(origamis);
        count := count + result.count;

        if result.three_occured then
            three_occured := true;
        fi;

        if result.systolic_ratio > max_sr then
            max_sr := result.systolic_ratio;
            combinatorial_length := result.combinatorial_length;
            max_origami := result.origami;
        fi;
    od;

    return rec(systolic_ratio := max_sr, combinatorial_length := combinatorial_length, origami := max_origami, count := count, three_occured := three_occured);
end);

InstallGlobalFunction(MaximalSystolicRatioByDegree, function(d)
    local origamis;

    origamis := Filtered(AllOrigamisByDegree(d), o -> Genus(o) >= 2);
    return MaximalSystolicRatioOfList(origamis);
end);

InstallGlobalFunction(MaximalSystolicRatioOfList, function(origamis)
    local max_sr, combinatorial_length, O, result, count, three_occured, max_origami;

    max_sr := -1.;
    combinatorial_length := -1;
    max_origami := Origami((),());
    count := 0;
    three_occured := false;

    for O in origamis do
        result := SystolicRatio(O);
        count := count + 1;
        if combinatorial_length = 3 then
            three_occured := true;
        fi;
        if(result.systolic_ratio > max_sr) then
            max_sr := result.systolic_ratio;
            combinatorial_length := result.combinatorial_length;
            max_origami := O;
        fi;   
    od;

    return rec(systolic_ratio := max_sr, combinatorial_length := combinatorial_length, origami := max_origami,
                count := count, three_occured := three_occured);
end);

Foo := function(deg)
    local list, O, a, b, i, j;

    list := AllOrigamisByDegree(deg);
    for O in list do
        a := OrigamiSingularities(O);
        b := CyclesToList(VerticalPerm(O)^-1 * HorizontalPerm(O)^-1 * VerticalPerm(O) * HorizontalPerm(O));
        for i in [1..Length(a)] do
            for j in [1..Length(a[i])] do
                if not(a[i][j] in b[i]) then
                    return O;
                fi;
            od;
        od;
    od;
end;

GetFpGroup := function(sys, a, b)
    local G, r, s;
    G := FreeGroup("r", "s");
    r := G.1;
    s := G.2;
    G := G / [s^-1*r^-1*s*r/r^sys, r^a, s^b];
    return G;
end;

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

FindFirstOcc := function(sys, limit)
    local G, i, j, O;
    for i in [sys + 1..limit] do
        for j in [2..2] do
            G := GetFpGroup(sys, i, j);
            O := GenerateOrigamiByFpGroup(G, G.1, G.2);
            if Length(Stratum(O)) > 0 then
                if Int(SystoleLength(O).systole) = Int(sys) then
                    return O;
                fi;
            fi;
        od;
    od;
    Error("did not work");
end;