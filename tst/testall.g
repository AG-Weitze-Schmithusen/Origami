LoadPackage("origami");

TestDirectory(DirectoriesPackageLibrary( "origami", "tst" ),
  rec(exitGAP     := true,
      testOptions := rec(compareFunction := "uptowhitespace") ) );

FORCE_QUIT_GAP(1);