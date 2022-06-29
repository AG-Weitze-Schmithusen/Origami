LoadPackage( "AutoDoc" );
AutoDoc( rec( autodoc := true, gapdoc := false ) );

MakeGAPDocDoc(
  "doc",
  "manual.xml",
  ["../PackageInfo.g"],
  "Origami"
);;
CopyHTMLStyleFiles("doc");
QUIT;
