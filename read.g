ReadPackage("Origami/lib/origami.gi");
ReadPackage("Origami/lib/action.gi");
ReadPackage("Origami/lib/canonical.gi");
ReadPackage("Origami/lib/hash.gi");
ReadPackage("Origami/lib/origami-list.gi");
ReadPackage("Origami/lib/deckGroup.gi");

if TestPackageAvailability( "HomalgToCAS" ,"2018.06.15") and TestPackageAvailability( "IO_ForHomalg", "2017.09.02") and TestPackageAvailability( "IO", "4.5.1" ) and TestPackageAvailability 			("RingsForHomalg", "2018.04.04")
	
	then ReadPackage("Origami/lib/sagefunction.gi");
fi;
