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
ReadPackage("Origami/lib/deckGroup.gd");
ReadPackage("Origami/lib/normalorigami.gd");

if TestPackageAvailability("ArangoDBInterface", "2018.12.09") = fail then
  Info(InfoWarning, 1, "The package 'ArangoDBInterface' is currently not installed. Without this package, the origami database is not available.");
else
  ReadPackage("Origami/lib/db.gd");
fi;
