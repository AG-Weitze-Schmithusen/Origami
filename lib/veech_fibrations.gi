InstallMethod(PrimeKernel, [IsOrigami, IsPosInt], function(O, p)
  local G, gens, M, A, kernelGens, rep, g, C, D, queue, successor,
    foundKernelElm;
  if not IsPrime(p) then
    return "Error: p must be prime.";
  fi;
  G := VeechGroup(O);
  gens := GeneratorsOfGroup(G);
  kernelGens := [];
  M := One(G);
  rep := [M];
  queue := [M];

  #successor := function(L, M)
  #  local elm, decomp;
  #  for elm in L do
  #    if M^-1 * elm in [[[0, -1], [1, 0]], [[1, 1], [0, 1]]] then
  #      return elm;
  #    fi;
  #  od;
  #  return fail;
  # end;

  while not IsEmpty(queue) do
    M := queue[1];
    Remove(queue, 1);
    for g in gens do
      C := M * g;
      foundKernelElm := false;
      for D in rep do
        A := ActionOfMatrixOnHom(O, C * D^-1) * One(GF(p));
        if IsOne(A) then
          foundKernelElm := true;
          if not C * D^-1 in kernelGens then
            Add(kernelGens, C * D^-1);
            Print("kernel: ", kernelGens, "\n");
          fi;
        fi;
      od;
      if not foundKernelElm and not C in rep then
        Add(rep, C);
        Add(queue, C);
        Print("Added: ", STDecomposition(C), "\n");
      fi;
    od;
    Print("Removed: ", STDecomposition(M), "\n");
  od;
  return kernelGens;
  # if kernelGens = [] then
  #  return ModularSubgroup((), ());
  # fi;
  # return ModularSubgroup(kernelGens);
end);

InstallMethod(PrimeKernelAlt, [IsOrigami, IsPosInt], function(O, p)
  local G, gens, A, H;
  G := VeechGroup(O);
  gens := ShallowCopy(GeneratorsOfGroup(G));
  Apply(gens, A -> ActionOfMatrixOnHom(O, A) * One(Sp(2 * Genus(O), p)));
  Print(gens);
  H := Group(gens);
  return H;
end);


