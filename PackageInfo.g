SetPackageInfo( rec(
	PackageName := "Origami",
	Subtitle := "Computing Veechgroups of origamis",
	Version := "1.0",
	Date := "26/02/2018",
	AvailabilityTest := ReturnTrue,
	
	PackageDoc := rec(
		BookName  := ~.PackageName,
		ArchiveURLSubset := ["doc"],
		HTMLStart := "doc/chap0.html",
		PDFFile   := "doc/manual.pdf",
		SixFile   := "doc/manual.six",
		LongTitle := ~.Subtitle,
),

Dependencies := rec(
		GAP := "4.5.3",

		NeededOtherPackages := [["ModularGroup", "0.0.1"], ["Orb", "4.7.6"],  ],

		SuggestedOtherPackages := [["HomalgToCAS" ,"2018.06.15"], ["IO_ForHomalg", "2017.09.02"], ["IO", "4.5.1"], ["RingsForHomalg", "2018.04.04"]],

		ExternalConditions := []

),

Persons := [
  rec(
    LastName      := "Kattler",
    FirstNames    := "Pascal",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "kattler@math.uni-sb.de",
    WWWHome       := "http://www.math.uni-sb.de/ag/weitze/",
    PostalAddress := Concatenation( [
                      "AG Weitze-Schmithüsen\n",
                      "FR 6.1 Mathematik\n",
                      "Universität des Saarlandes\n",
                      "D-66041 Saarbrücken" ] ),
    Place         := "Saarbrücken",
    Institution   := "Universität des Saarlandes"
  ),

	rec(
		LastName      := "Thevis",
		FirstNames    := "Andrea",
		IsAuthor      := true,
		IsMaintainer  := true,
		Email         := "thevis@math.uni-sb.de",
		WWWHome       := "http://www.math.uni-sb.de/ag/weitze/",
		PostalAddress := Concatenation( [
                       "AG Weitze-Schmithüsen\n",
                       "FR 6.1 Mathematik\n",
                       "Universität des Saarlandes\n",
                       "D-66041 Saarbrücken" ] ),
		Place         := "Saarbrücken",
		Institution   := "Universität des Saarlandes"
  ),
],

PackageWWWHome := "https://pascalkattler.github.io/Origami/",

ArchiveFormats := ".tar.gz .zip",

ArchiveURL     := Concatenation( "https://github.com/PascalKattler/Origami/releases/download/Origami-", ~.Version, "/Origami-", ~.Version ),
README_URL     := Concatenation( ~.PackageWWWHome, "README" ),
PackageInfoURL := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),


) );
