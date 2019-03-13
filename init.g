LoadPackage("orb");
LoadPackage("ModularGroup");

if not IsBound(conjugacyClassesOfx) then
	conjugacyClassesOfx := [];
fi;

ReadPackage("Origami/lib/origami.gd");
ReadPackage("Origami/lib/action.gd");
ReadPackage("Origami/lib/canonical.gd");
ReadPackage("Origami/lib/hash.gd");
ReadPackage("Origami/lib/origami-list.gd");
ReadPackage("Origami/lib/sagefunction.gd");
