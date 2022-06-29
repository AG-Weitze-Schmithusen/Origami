LoadPackage( "AutoDoc" );
AutoDoc( rec( autodoc := true, gapdoc := false ) );

MakeGAPDocDoc(
  "doc",
  "manual.xml",
  ["../PackageInfo.g"],
  "Origami",
  "MathJax"
);;
CopyHTMLStyleFiles("doc");
QUIT;
