ReadPackage("Origami/lib/origami.gi");
ReadPackage("Origami/lib/action.gi");
ReadPackage("Origami/lib/canonical.gi");
ReadPackage("Origami/lib/hash.gi");
ReadPackage("Origami/lib/origami-list.gi");
ReadPackage("Origami/lib/deckGroup.gi");
ReadPackage("Origami/lib/normalorigami.gi");
ReadPackage("Origami/lib/sage-methods.gi");
ReadPackage("Origami/lib/homology.gi");

if TestPackageAvailability("ArangoDBInterface", "2018.12.09") = fail then
  Info(InfoWarning, 1, "The package 'ArangoDBInterface' is currently not installed. Without this package, the origami database is not available.");
else
  ReadPackage("Origami/lib/db.gi");
fi;

if TestPackageAvailability("IO", "4.5.1") <> fail then
  ReadPackage("Origami/lib/io.g");
fi;
