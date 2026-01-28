InstallGlobalFunction(AllOrigamisByDegree, function(d)
    local C, part, Sd, canonicals, canonicals_x, canonicals_y, x;
    part := Partitions(d);
    canonicals := [];
    canonicals_x := List(part, x -> CanonicalPermFromCycleStructure(CycleStructureFromPartition(x)));
    Sd := SymmetricGroup(d);
    for x in canonicals_x do
        C := Centralizer(Sd, x);
        canonicals_y := List(OrbitsDomain(C, Sd, OnPoints), Minimum);
        Append(canonicals, List(canonicals_y, y -> rec(x := x, y := y)));
    od;
    canonicals := Filtered(canonicals, o -> IsTransitive(Group(o.x, o.y), [1..d]));
    Apply(canonicals, o -> OrigamiNC(o.x, o.y, d));
    return canonicals;
end);

InstallGlobalFunction(AllOrigamisInStratum, function(d, stratum)
	stratum := AsSortedList(stratum);
	return Filtered(AllOrigamisByDegree(d), O -> Stratum(O) = stratum);
end);

# Introductory statement: This section computes the number of equivalence classes of origamis of a given
# degree. Rather than plucking the apple directly we shake the branch on which it's attached by the following
# fact:

# The number of equivalence classes of origamis of a degree d is equal to the number of conjugacy classes of
# subgroups of index d in the free group of rank 2. 

# Hence we want to compute the number of conjugacy classes of subgroups of a given index in the free group of
# a given rank. We follow closely the ways described in:

# A) Alexander Mednykh, Counting non-equivalent coverings and non-isomorphic maps for Riemann surfaces (2005),
# Theorem 1

# B) Alexander Lubotzky, Dan Segal, Subgroup Growth (2003), Prop. 2.1.1


# Let r be a non-negative integer and F the free group of rank r.

# Function 1: Let b be a non-negative integer. HowManySubgroups(b, r) is the list a1...ab where ai is the
# number of index i subroups in F. This list is empty when b is zero.
HowManySubgroups := function(leash, rank)
    local list, i, k, accu;

    list := [];
    for i in [1..leash] do
        accu := 0;
        for k in [1..i-1] do
	        accu := accu + list[k] * Factorial(i - k) ^ (rank - 1); 
        od;
	Add(list, i * Factorial(i) ^ (rank - 1) - accu);
    od;
    return list;
end;

# Explanation: If G is a group and n a positive integer then the map from transitive actions on {1...n} to
# subgroups of G which send a' -> Stab(a',1) hits all and only the index n subgroups, and their fibers all
# have (n - 1)! elements. This relates the number an of index n subgroups to the number tn of transitive
# actions on [n]: an = tn/(n - 1)!. Furthermore an arbitrary action of G on a finite set can be considered as
# a transitive action on one of the orbits together with an arbitrary action on the remainder. This allows
# for recursive computation of the number hn of all actions if the number of transitive actions is known:
# hn = Sigma k=1..n: (n-1 choose k-1) * tk * h(n-k), h0 = 1. Plugging one formula into the other and
# rearranging yields another recursive equation: an = hn/(n-1)! - Sigma k=1..n-1: ak * h(n-k) / (n-k)!.
# But in our special case G = F simply hk = k!^r so an = n * n!^(r-1) - Sigma k=1..n: ak * (n-k)!^(r-1).

# Tests:
# HowManySubgroups(5,0) = [1,0,0,0,0]
# HowManySubgroups(5,1) = [1,1,1,1,1]


# Function 2: Let d be a positive integer and Z the cyclic group of order d. HowManyEpi(r, d) is the number
# of epimorphisms from F onto Z.
HowManyEpi := function(rank, order)
    local accu, l;

    accu := 0;
    for l in [1..order] do
	    if order mod l = 0 then
	        accu := accu + MoebiusMu(order / l) * l ^ rank;
	    fi;
    od;
    return accu;
end;

# Explanation: All subgroups of Zd are of the form Zl with l | d and every such subgroup occurs exactly once
# in Zd. The set of homomorphisms Hom(F,Zd) can be partitioned by grouping together those whose images are
# the same. Together this implies #Hom(F,Zd) = Sigma l|d: #Epi(F,Zl). Now by Möbius inversion formula,
# #Epi(F,Zd) = Sigma l|d: #Möb(d/l) * #Hom(F,Zl).

# Tests: We should have:
# HowManyEpi(0, 1) = 1
# HowManyEpi(0, d) = 0 for d > 1
# HowManyEpi(1, d) = number of non-negative integers coprime to and < d:
# HowManyEpi(n, p) = p^n - 1 if p is prime


# Function 3: Let n be a positive integer. HowManyConjugatedSubgroups(n, r) is the number of conjugacy
# classes of subgroups of index n in F.
HowManyConjugatedSubgroups := function(index, rank)
    local i, accu, list;

    list := HowManySubgroups(index, rank); 
    accu := 0;
    for i in [1..index] do
        if index mod i = 0 then
	        accu := accu + list[i] * HowManyEpi(1 + i * (rank - 1), index / i);
	    fi;
    od;
    return accu / index;
end;

# Source: This is Theorem 1 in (A) + index rank formula.

# Tests:
# HowManyConjugatedSubgroups(1,2) = 1
# HowManyConjugatedSubgroups(2,2) = 3
# HowManyConjugatedSubgroups(3,2) = 7
# HowManyConjugatedSubgroups(4,2) = 26
# HowManyConjugatedSubgroups(5,2) = 97
# HowManyConjugatedSubgroups(6,2) = 624
# HowManyConjugatedSubgroups(7,2) = 4163
# HowManyConjugatedSubgroups(8,2) = 34470
# HowManyConjugatedSubgroups(9,2) = 314493
# HowManyConjugatedSubgroups(10,2) = 3202839


# Function 3.1:

InstallGlobalFunction(NumberOfOrigamisByDegree, function(d) 
	return HowManyConjugatedSubgroups(d,2);
end);