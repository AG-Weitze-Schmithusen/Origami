LoadPackage("orb");
LoadPackage("ModularGroup");

ReadPackage("Origami/lib/origami.gd");
ReadPackage("Origami/lib/action.gd");
ReadPackage("Origami/lib/canonical.gd");
ReadPackage("Origami/lib/hash.gd");
ReadPackage("Origami/lib/origami-list.gd");
ReadPackage("Origami/lib/sage-methods.gd");
ReadPackage("Origami/lib/deckGroup.gd");
ReadPackage("Origami/lib/normalorigami.gd");
ReadPackage("Origami/lib/cyclic-torus-covers.gd");
ReadPackage("Origami/lib/homology.gd");
ReadPackage("Origami/lib/special_origamis.gd");
ReadPackage("Origami/lib/homologyaction.gd");

if TestPackageAvailability("ArangoDBInterface", "2018.12.09") = fail then
  Info(InfoWarning, 1, "The package 'ArangoDBInterface' is currently not installed. Without this package, the origami database is not available.");
else
  ReadPackage("Origami/lib/db.gd");
fi;
