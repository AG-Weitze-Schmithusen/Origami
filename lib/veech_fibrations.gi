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

InstallMethod(PrimeKernelOrder, [IsOrigami, IsPosInt], function(O, p)
  local G, gens, A, H, J;
  G := VeechGroup(O);
  gens := ShallowCopy(GeneratorsOfGroup(G));
  Apply(gens, A -> ActionOfMatrixOnHom(O, A) * One(Sp(2 * Genus(O), p)));
  H := Group(gens);
  return Order(H);
end);

InstallMethod(TotalTwisting, [IsOrigami, IsModularSubgroup], function(O, PM)
  local cuspGens, cusps, originalCusps, VG, totalT, i, c, cGen, v, d, A, Bezout, x, y, horiO, cylStruc, kmin, k0, T, tup, kc;
  cuspGens := CuspGenerators(PM);
  cusps := Cusps(PM);
  VG := VeechGroup(O);
  originalCusps := Cusps(VG);
  totalT := [];
  for i in [1..Length(cusps)] do
    c := cusps[i];
    if c in originalCusps then
      cGen := cuspGens[i];
      v := Eigenvectors(Rationals, TransposedMat(cGen))[1];
      # make v integer
      d := Lcm(List(v, DenominatorRat));
      v := d * v;
      A := [[1, 0], [0, 1]];
      if v[2] <> 0 then
        if v[1] = 0 then
          A := [[0, 1], [-1, 0]];
        else
          d := Gcd(List(v, AbsInt));
          v := 1/d * v;
          Bezout := Gcdex(v[1], v[2]);
          x := Bezout.coeff1;
          y := Bezout.coeff2;
          A := [[x, y], [-v[2], v[1]]];
        fi;
      fi;
      horiO := ActionOfSL2(A, O);
      cylStruc := CylinderStructure(horiO);

      #compute the minimal Dehn multi-twist exponent
      k0 := AbsInt((cGen^(A^-1))[1][2]);
      # For a horizontal shear [[1, k], [0, 1]], the twist number on the i-th cylinder
      # is k * h_i / w_i. Thus, the smallest positive k giving an honest multitwist is
      # the smallest integer s.t. w_i | k*h_i for all i, i.e.
      # kmin = lcm_i w_i / gcd(w_i, h_i).
      kmin := Lcm(List(cylStruc, tup -> tup[2] / Gcd(tup[1], tup[2])));
      T := Sum(cylStruc, tup -> kmin * tup[1] / tup[2]);
      kc := kmin / Gcd(kmin, k0);
      if not IsPosInt(kc) then
        Error("Something went wrong in computing the minimal exponent k_c!");
      fi;
      Add(totalT, [T, kc]);
    fi;
  od;
  return totalT;
end);

