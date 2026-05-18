InstallMethod(PrimeKernel, [IsOrigami, IsPosInt], function(O, p)
  local G, VeechGens, gens, M, A, kernelGens, rep, g, C, D, queue, foundKernelElm, i, j, VeechRep, VeechQueue, VeechM, VeechC;
  if not IsPrime(p) then
    return "Error: p must be prime.";
  fi;
  G := VeechGroup(O);
  VeechGens := GeneratorsOfGroup(G);
  gens := ShallowCopy(VeechGens);
  Apply(gens, A -> ActionOfMatrixOnHom(O, A) * One(GL(2 * Genus(O), p)));
  M := One(GL(2 * Genus(O), p));
  rep := [M];
  VeechRep := [One(G)];
  queue := [M];
  VeechQueue := [One(G)];
  kernelGens := [];

  while not IsEmpty(queue) do
    M := queue[1];
    VeechM := VeechQueue[1];
    Remove(queue, 1);
    Remove(VeechQueue, 1);
    for i in [1..Length(gens)] do
      C := M * gens[i];
      VeechC := VeechM * VeechGens[i];
      foundKernelElm := false;
      for j in [1..Length(rep)] do
        D := rep[j];
        if C = D then
          foundKernelElm := true;
          if not VeechC * VeechRep[j]^-1 in kernelGens then
            Add(kernelGens, VeechC * VeechRep[j]^-1);
          fi;
        fi;
      od;
      if not foundKernelElm and not C in rep then
        Add(rep, C);
        Add(VeechRep, VeechC);
        Add(queue, C);
        Add(VeechQueue, VeechC);
      fi;
    od;
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


