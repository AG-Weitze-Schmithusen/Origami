LoadPackage("orb");
LoadPackage("images");
LoadPackage("profiling");
#SetPackagePath("ModularGroup","/home/pk/src/ModularGroup");
#LoadPackage("ModularGroup");

#Definition of the free group F_2 in S and T = <S,T>

if not IsBound(F) then
	F:=FreeGroup("S", "T");
	gens:= GeneratorsOfGroup(F);
	S:=gens[1];
	T:=gens[2];
fi;

if not IsBound(conjugacyClassesOfx) then
	conjugacyClassesOfx := [];
fi;

ReadPackage("Origami/lib/origami.gd");
ReadPackage("Origami/lib/action.gd");
ReadPackage("Origami/lib/canonical.gd");
ReadPackage("Origami/lib/sl2_test.gd");
ReadPackage("Origami/lib/hash.gd");
