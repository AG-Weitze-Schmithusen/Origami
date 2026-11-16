gap> START_TEST( "io.tst" );

# Tests for pickling origamis with the IO package (lib/io.g)
gap> LoadPackage("IO", false);
true
gap> file := Filename(DirectoryTemporary(), "origami.pickle");;
gap> RoundTrip := function(O)
>   local f, P;
>   f := IO_File(file, "w");
>   if IO_Pickle(f, O) <> IO_OK then return fail; fi;
>   IO_Close(f);
>   f := IO_File(file, "r");
>   P := IO_Unpickle(f);
>   IO_Close(f);
>   return P;
> end;;

# the deck group is restored as the same group of permutations of the squares;
# this used to come back as the first small group of the same order (C8 here)
gap> O := Origami((1,2,3,4)(5,6,7,8), (1,5,3,7)(2,8,4,6));;
gap> StructureDescription(DeckGroup(O));
"Q8"
gap> P := RoundTrip(O);
Origami((1,2,3,4)(5,6,7,8), (1,5,3,7)(2,8,4,6), 8)
gap> HasDeckGroup(P);
true
gap> IsPermGroup(DeckGroup(P)) and DeckGroup(P) = DeckGroup(O);
true
gap> StructureDescription(DeckGroup(P));
"Q8"

# pickling works for deck groups whose order has no IdGroup (used to fail)
gap> O := Origami(CycleFromList([1..512]), ());;
gap> Size(DeckGroup(O));
512
gap> P := RoundTrip(O);;
gap> P = O and DeckGroup(P) = DeckGroup(O);
true

# a NormalStoredOrigami stores its deck group as an abstract group, which is not
# saved; it is recomputed for the unpickled origami
gap> G := SmallGroup(8, 4);;
gap> N := NormalStoredOrigami(G.1, G.2, G);;
gap> P := RoundTrip(N);;
gap> HasDeckGroup(P);
false
gap> Size(DeckGroup(P)) = DegreeOrigami(P);
true

# files written by older versions contain IdGroup(DeckGroup(O)) instead; this
# is ignored, while the other stored attributes are still restored
gap> f := IO_File(file, "w");;
gap> IO_Write(f, "ORIG");;
gap> for v in [(1,2), (1,2,3), 3, [2], 2, fail, fail, fail, [8, 4], fail] do IO_Pickle(f, v); od;
gap> IO_Close(f);;
gap> f := IO_File(file, "r");;
gap> P := IO_Unpickle(f);
Origami((1,2), (1,2,3), 3)
gap> IO_Close(f);;
gap> HasStratum(P) and Stratum(P) = [2] and HasGenus(P) and Genus(P) = 2;
true
gap> HasDeckGroup(P);
false

#
gap> STOP_TEST( "io.tst" );
