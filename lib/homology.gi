## helper functions - intended for internal use only

ORIGAMI_DIRECTIONS := rec(
  X := "X",
  Y := "Y",
  XINV := "XINV",
  YINV := "YINV"
);

_ORIGAMI_FundamentalDomain := function(O)
  local S, d, sx, sy, F2, x, y, paths, k, i;

  S := [1];
  d := DegreeOrigami(O);
  F2 := FreeGroup("x", "y");
  x := F2.1;
  y := F2.2;
  sx := HorizontalPerm(O);
  sy := VerticalPerm(O);
  paths := ListWithIdenticalEntries(d, Identity(F2));

  while Length(S) < d do
    for i in S do
      if not i^sx in S then
        k := i^sx;
        Add(S, k);
        paths[k] :=  x^-1 * paths[i];
        break;
      elif not i^sy in S then
        k := i^sy;
        Add(S, k);
        paths[k] :=  y^-1 * paths[i];
        break;
      elif not i^(sx^-1) in S then
        k := i^(sx^-1);
        Add(S, k);
        paths[k] :=  x * paths[i];
        break;
      elif not i^(sy^-1) in S then
        k := i^(sy^-1);
        Add(S, k);
        paths[k] :=  y * paths[i];
        break;
      fi;
    od;
  od;

  return paths;
end;

_ORIGAMI_AugmentedFundamentalGroup := function(O)
  local paths, F2, x, y, d, sx, sy, generators, i, res, w;
  
  d := DegreeOrigami(O);
  sx := HorizontalPerm(O);
  sy := VerticalPerm(O);
  F2 := FreeGroup("x", "y");
  x := F2.1;
  y := F2.2;
  paths := List(_ORIGAMI_FundamentalDomain(O), p -> ObjByExtRep(FamilyObj(F2.1), ExtRepOfObj(p)));

  generators := [];

  for i in [1..d] do
    Add(generators, rec(path := paths[i]^-1 * x * paths[i^sx], edge := 2*i - 1));
    Add(generators, rec(path := paths[i]^-1 * y * paths[i^sy], edge := 2*i));
  od;

  generators := Filtered(generators, w -> not w.path = Identity(F2));
  res := [];
  for w in generators do
    res[w.edge] := w.path;
  od;
  return res;
end;

_ORIGAMI_OrigamiGraph := function(O)
  local graph, d, sx, sy, dir;
  d := DegreeOrigami(O);
  sx := HorizontalPerm(O);
  sy := VerticalPerm(O);
  dir := ORIGAMI_DIRECTIONS;
  graph := List([1..d], function(i)
    local r;
    r := rec();
    r.(dir.X) := i^sx;
    r.(dir.Y) := i^sy;
    r.(dir.XINV) := i^(sx^-1);
    r.(dir.YINV) := i^(sy^-1);
    return r;
  end);
  return graph;
end;

_ORIGAMI_OrigamiBFSMST := function(O)
  local origami_graph, visited, d, tree, queue, i, X, Y, XINV, YINV;
  origami_graph := _ORIGAMI_OrigamiGraph(O);
  d := DegreeOrigami(O);
  visited := ListWithIdenticalEntries(d, false);
  visited[1] := true;
  queue := [1];
  tree := rec(
    root := 1,
    graph := origami_graph,
    parentDirection := [1..d],
    parent := [1..d]
  );
  X := ORIGAMI_DIRECTIONS.X;
  Y := ORIGAMI_DIRECTIONS.Y;
  XINV := ORIGAMI_DIRECTIONS.XINV;
  YINV := ORIGAMI_DIRECTIONS.YINV;

  while Length(queue) > 0 do
    i := Remove(queue, 1);
    if not visited[origami_graph[i].(X)] then
      visited[origami_graph[i].(X)] := true;
      tree.parentDirection[origami_graph[i].(X)] := XINV;
      tree.parent[origami_graph[i].(X)] := i;
      Add(queue, origami_graph[i].(X));
    fi;

    if not visited[origami_graph[i].(Y)] then
      visited[origami_graph[i].(Y)] := true;
      tree.parentDirection[origami_graph[i].(Y)] := YINV;
      tree.parent[origami_graph[i].(Y)] := i;
      Add(queue, origami_graph[i].(Y));
    fi;

    if not visited[origami_graph[i].(XINV)] then
      visited[origami_graph[i].(XINV)] := true;
      tree.parentDirection[origami_graph[i].(XINV)] := X;
      tree.parent[origami_graph[i].(XINV)] := i;
      Add(queue, origami_graph[i].(XINV));
    fi;

    if not visited[origami_graph[i].(YINV)] then
      visited[origami_graph[i].(YINV)] := true;
      tree.parentDirection[origami_graph[i].(YINV)] := Y;
      tree.parent[origami_graph[i].(YINV)] := i;
      Add(queue, origami_graph[i].(YINV));
    fi;
  od;

  return tree;
end;

_ORIGAMI_FundamentalDomainBoundary := function(O)
  local origami_graph, mst, start, v, dir, F2d, boundary, isParent, contains, X, Y, XINV, YINV;
  origami_graph := _ORIGAMI_OrigamiGraph(O);
  mst := _ORIGAMI_OrigamiBFSMST(O);
  start := mst.root;
  X := ORIGAMI_DIRECTIONS.X;
  Y := ORIGAMI_DIRECTIONS.Y;
  XINV := ORIGAMI_DIRECTIONS.XINV;
  YINV := ORIGAMI_DIRECTIONS.YINV;
  dir := X;
  #F2d := FreeGroup(2*DegreeOrigami(O));
  #boundary := One(F2d);
  boundary := [];

  isParent := function(tree, v, dir)
    local invdir;
    if tree.graph[v].(dir) = tree.root then return false; fi;
    if dir = X then invdir := XINV; elif dir = XINV then invdir := X; elif dir = Y then invdir := YINV; else invdir := Y; fi;
    return tree.parentDirection[tree.graph[v].(dir)] = invdir;
  end;

  contains := function(tree, v, dir)
    local invdir;
    if dir = X then invdir := XINV; elif dir = XINV then invdir := X; elif dir = Y then invdir := YINV; else invdir := Y; fi;
    return isParent(tree, v, dir) or isParent(tree, tree.graph[v].(dir), invdir);
  end;

  while contains(mst, start, dir) do
    start := mst.graph[start].(dir);
  od;
  v := start;

  repeat
    if contains(mst, v, dir) then
      v := mst.graph[v].(dir);
      if dir = X then dir := YINV;
      elif dir = Y then dir := X;
      elif dir = XINV then dir := Y;
      else dir := XINV; fi;
    else
      if dir = X then
        #boundary := boundary * F2d.(2*v - 1);
        Add(boundary, 2*v-1);
        dir := Y;
      elif dir = Y then
        #boundary := boundary * F2d.(2*v);
        Add(boundary, 2*v);
        dir := XINV;
      elif dir = XINV then
        #boundary := boundary * F2d.(2*(origami_graph[v].(dir)) - 1)^-1;
        Add(boundary, -(2*(origami_graph[v].(dir)) - 1));
        dir := YINV;
      else
        #boundary := boundary * F2d.(2*(origami_graph[v].(dir)))^-1;
        Add(boundary, -2*origami_graph[v].(dir));
        dir := X;
      fi;
    fi;
  until v = start and dir = X;

  return boundary;
end;

_ORIGAMI_VertexEquivalenceRelation := function(boundary)
  local l, tuples, i;
  tuples := [];
  l := Length(boundary);
  for i in [1..(l-1)] do
    Add(tuples, Tuple([-boundary[i], boundary[i+1]]));
  od;
  Add(tuples, Tuple([-boundary[l], boundary[1]]));
  return EquivalenceRelationByPairsNC(Domain(boundary), tuples);
end;

_ORIGAMI_EliminateCancellingPairs := function(boundary)
  local i, indices;
  indices := [];
  for i in [1..(Length(boundary)-1)] do
    if boundary[i] = - boundary[i+1] then
      Add(indices, i);
      Add(indices, i+1);
    fi;
  od;
  if boundary[Length(boundary)] = - boundary[1] then
    Add(indices, Length(boundary));
    Add(indices, 1);
  fi;
  Sort(indices);
  indices := Reversed(indices);
  for i in indices do
    Remove(boundary, i);
  od;
  return boundary;
end;

_ORIGAMI_EliminateVertices := function(boundary)
  local rel, vertices, a, b, i, pos_a, pos_b, pos_binv;
  rel := _ORIGAMI_VertexEquivalenceRelation(boundary);
  vertices := EquivalenceRelationPartition(rel);

  while Length(vertices) > 1 do
    for i in [1..Length(boundary)-1] do
      if EquivalenceClassOfElement(rel, boundary[i]) <> EquivalenceClassOfElement(rel, boundary[i+1]) then
        a := boundary[i];
        b := boundary[i+1];
        pos_a := i;
        pos_b := i+1;
        break;
      fi;
    od;
    pos_binv := Position(boundary, -b);
    boundary := Concatenation(boundary{[1..pos_a-1]}, [b], boundary{[pos_b+1..pos_binv-1]}, [-b], [a], boundary{[pos_binv+1..Length(boundary)]});
    boundary := _ORIGAMI_EliminateCancellingPairs(boundary);
    rel := _ORIGAMI_VertexEquivalenceRelation(boundary);
    vertices := EquivalenceRelationPartition(rel);
  od;

  return boundary;
end;

_ORIGAMI_AugmentedEliminateVertices := function(boundary, generators)
  local rel, vertices, a, b, i, pos_a, pos_b, pos_binv;
  rel := _ORIGAMI_VertexEquivalenceRelation(boundary);
  vertices := EquivalenceRelationPartition(rel);

  while Length(vertices) > 1 do
    for i in [1..Length(boundary)-1] do
      if EquivalenceClassOfElement(rel, boundary[i]) <> EquivalenceClassOfElement(rel, boundary[i+1]) then
        a := boundary[i];
        b := boundary[i+1];
        pos_a := i;
        pos_b := i+1;
        break;
      fi;
    od;
    pos_binv := Position(boundary, -b);
    boundary := Concatenation(boundary{[1..pos_a-1]}, [b], boundary{[pos_b+1..pos_binv-1]}, [-b], [a], boundary{[pos_binv+1..Length(boundary)]});
    boundary := _ORIGAMI_EliminateCancellingPairs(boundary);
    rel := _ORIGAMI_VertexEquivalenceRelation(boundary);
    vertices := EquivalenceRelationPartition(rel);
    if a > 0 then
      generators[a] := (generators[AbsoluteValue(b)]^SignInt(b))^-1 * generators[a];
    else
      generators[-a] := generators[-a] * generators[AbsoluteValue(b)]^SignInt(b);
    fi;
  od;

  return rec(boundary := boundary, generators := generators);
end;

_ORIGAMI_HandleNormalization := function(boundary)
  local m, indices, i, a, pos_a, ainv, b, binv, pos_b, pos_ainv, pos_binv;

  m := Length(boundary); # always divisible by 4
  indices := Filtered([1..m], i -> i mod 4 = 1);

  for i in indices do
    # if this part is already in normal form, do nothing
    if boundary[i] = -boundary[i+2] and boundary[i+1] = -boundary[i+3] then
      continue;
    fi;

    pos_a := i;
    a := boundary[pos_a];
    pos_ainv := Position(boundary, -a);
    ainv := boundary[pos_ainv];
    pos_b := First([pos_a+1..pos_ainv-1], c -> not -boundary[c] in boundary{[pos_a+1..pos_ainv-1]});
    b := boundary[pos_b];
    pos_binv := Position(boundary, -b);
    binv := boundary[pos_binv];

    boundary := Concatenation(
      boundary{[1..pos_a-1]},                 # A
      [b],                                    # x
      boundary{[pos_ainv+1..pos_binv-1]},     # D
      boundary{[pos_b+1..pos_ainv]},          # C
      [binv],                                 # x^-1
      boundary{[pos_a..pos_b-1]},             # B
      boundary{[pos_binv+1..Length(boundary)]}# E
    );
    pos_a := Position(boundary, a);
    pos_ainv := Position(boundary, ainv);
    pos_b := Position(boundary, b);
    pos_binv := Position(boundary, binv);
    boundary := Concatenation(
      boundary{[1..pos_b]},                 # A
      [ainv],                               # x
      boundary{[pos_ainv+1..pos_a-1]},      # D
      boundary{[pos_a+1..pos_binv-1]},      # C
      [a],                                  # x^-1
      boundary{[pos_b+1..pos_ainv-1]},      # B
      boundary{[pos_a+1..Length(boundary)]} # E
    );
  od;

  return boundary;
end;

_ORIGAMI_AugmentedHandleNormalization := function(boundary, generators)
  local m, indices, i, a, pos_a, ainv, b, binv, pos_b, pos_ainv, pos_binv, e;

  m := Length(boundary); # always divisible by 4
  indices := Filtered([1..m], i -> i mod 4 = 1);

  for i in indices do
    # if this part is already in normal form, do nothing
    if boundary[i] = -boundary[i+2] and boundary[i+1] = -boundary[i+3] then
      continue;
    fi;

    pos_a := i;
    a := boundary[pos_a];
    pos_ainv := Position(boundary, -a);
    ainv := boundary[pos_ainv];
    pos_b := First([pos_a+1..pos_ainv-1], c -> not -boundary[c] in boundary{[pos_a+1..pos_ainv-1]});
    b := boundary[pos_b];
    pos_binv := Position(boundary, -b);
    binv := boundary[pos_binv];

    for e in Concatenation(boundary{[pos_a..pos_b-1]}, boundary{[pos_b+1..pos_ainv]}) do
      if e > 0 then
        generators[e] := (generators[AbsoluteValue(b)]^SignInt(b))^-1 * generators[e];
      else
        generators[-e] := generators[-e] * generators[AbsoluteValue(b)]^SignInt(b);
      fi;
    od;

    boundary := Concatenation(
      boundary{[1..pos_a-1]},                 # A
      [b],                                    # x
      boundary{[pos_ainv+1..pos_binv-1]},     # D
      boundary{[pos_b+1..pos_ainv]},          # C
      [binv],                                 # x^-1
      boundary{[pos_a..pos_b-1]},             # B
      boundary{[pos_binv+1..Length(boundary)]}# E
    );

    pos_a := Position(boundary, a);
    pos_ainv := Position(boundary, ainv);
    pos_b := Position(boundary, b);
    pos_binv := Position(boundary, binv);

    for e in Concatenation(boundary{[pos_b+1..pos_ainv-1]}, boundary{[pos_ainv+1..pos_binv-1]}) do
      if e > 0 then
        generators[e] := (generators[AbsoluteValue(b)]^SignInt(b))^-1 * generators[e];
      else
        generators[-e] := generators[-e] * generators[AbsoluteValue(b)]^SignInt(b);
      fi;
    od;

    boundary := Concatenation(
      boundary{[1..pos_b]},                 # A
      [ainv],                               # x
      boundary{[pos_ainv+1..pos_a-1]},      # D
      boundary{[pos_a+1..pos_binv-1]},      # C
      [a],                                  # x^-1
      boundary{[pos_b+1..pos_ainv-1]},      # B
      boundary{[pos_a+1..Length(boundary)]} # E
    );
  od;

  return rec(boundary := boundary, generators := generators);
end;

_ORIGAMI_SurfaceNormalForm := function(O)
  return _ORIGAMI_HandleNormalization(_ORIGAMI_EliminateVertices(_ORIGAMI_FundamentalDomainBoundary(O)));
end;

_ORIGAMI_PathIndex := function(p)
  local w, last, l, res;

  w := LetterRepAssocWord(p); # 1 = x, 2 = y

  res := 0;
  last := w[Length(w)];

  for l in w do
    if last = 1 then
      if l = 1 then
      elif l = 2 then
        res := res + 1;
      elif l = -1 then
        res := res + 2;
      elif l = -2 then
        res := res - 1;
      fi;
    elif last = 2 then
      if l = 1 then
        res := res - 1;
      elif l = 2 then
      elif l = -1 then
        res := res + 1;
      elif l = -2 then
        res := res + 2;
      fi;
    elif last = -1 then
      if l = 1 then
        res := res + 2;
      elif l = 2 then
        res := res - 1;
      elif l = -1 then
      elif l = -2 then
        res := res + 1;
      fi;
    elif last = -2 then
      if l = 1 then
        res := res + 1;
      elif l = 2 then
        res := res + 2;
      elif l = -1 then
        res := res - 1;
      elif l = -2 then
      fi;
    fi;
    last := l;
  od;

  return res;
end;

###

InstallMethod(SymplecticBasisOfHomology, [IsOrigami], function(O)
  local boundary, generators, res, basis, m, indices, i;
  boundary := _ORIGAMI_FundamentalDomainBoundary(O);
  generators := _ORIGAMI_AugmentedFundamentalGroup(O);
  res := _ORIGAMI_AugmentedEliminateVertices(boundary, generators);
  res := _ORIGAMI_AugmentedHandleNormalization(res.boundary, res.generators);
  basis := [];
  m := Length(res.boundary);
  indices := Filtered([1..m], i -> i mod 4 = 1 or i mod 4 = 2);
  for i in indices do
    Add(basis, res.generators[AbsoluteValue(res.boundary[i])]^SignInt(res.boundary[i]));
  od;
  return basis;
end);

InstallMethod(SpinStructure, [IsOrigami], function(O)
  local basis, g, i, s;

  basis := SymplecticBasisOfHomology(O);
  g := Length(basis)/2; # = Genus(O)
  s := 0;

  for i in [1..g] do
    s := s + (_ORIGAMI_PathIndex(basis[2*i-1]) + 1) * (_ORIGAMI_PathIndex(basis[2*i]) + 1);
  od;

  return s mod 2;
end);