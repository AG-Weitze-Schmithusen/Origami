ReadPackage("Origami", "lib/origami.gi");
ReadPackage("Origami", "lib/action.gi");
ReadPackage("Origami", "lib/canonical.gi");
ReadPackage("Origami", "lib/hash.gi");
ReadPackage("Origami", "lib/origami-list.gi");
ReadPackage("Origami", "lib/deckGroup.gi");
ReadPackage("Origami", "lib/normalorigami.gi");
ReadPackage("Origami", "lib/actions_on_tn_covers.gi");
ReadPackage("Origami", "lib/cyclic-torus-covers.gi");
ReadPackage("Origami", "lib/search-for-cyclic-torus-origamis-with-veech-group.gi");
ReadPackage("Origami", "lib/special_origamis.gi");
ReadPackage("Origami", "lib/homologyaction.gi");
ReadPackage("Origami", "lib/systoles.gi");
ReadPackage("Origami", "lib/dessins.gi");

if TestPackageAvailability("IO", "4.5.1") <> fail then
  ReadPackage("Origami", "lib/io.g");
fi;
