ReadPackage("Origami/lib/origami.gi");
ReadPackage("Origami/lib/action.gi");
ReadPackage("Origami/lib/canonical.gi");
ReadPackage("Origami/lib/hash.gi");
ReadPackage("Origami/lib/origami-list.gi");
ReadPackage("Origami/lib/kinderzeichnungen.gi");
ReadPackage("Origami/lib/sagefunction.gi");

if TestPackageAvailability("ArangoDBInterface", "2018.12.09") = fail then
  Info(InfoWarning, 1, "The package 'ArangoDBInterface' is currently not installed. Without this package, the origami database is not available.");
else
  ReadPackage("Origami/lib/db.gi");
fi;
