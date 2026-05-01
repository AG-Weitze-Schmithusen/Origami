InstallMethod(PrimeKernel, [IsOrigami, IsPosInt], function(O, p)
  local G, gens, M, A, kernelGens;
  if not IsPrime(p) then
    return "Error: p must be prime.";
  fi;
  G := VeechGroup(O);
  gens := GeneratorsOfGroup(G);
  kernelGens := [];
  for M in gens do
    A := ActionOfMatrixOnHom(O, M) * One(GF(p));
    if IsOne(A) then
      Add(kernelGens, M);
    fi;
  od;
  return kernelGens;
  #if kernelGens = [] then
  #  return ModularSubgroup((), ());
  #fi;
  #return ModularSubgroup(kernelGens);
end);