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

		NeededOtherPackages := [["ModularGroup", "0.0.1"], ],

		SuggestedOtherPackages := [],

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
	LastName      := "Siccha",
	FirstNames    := "Sergio",
	IsAuthor      := true,
	IsMaintainer  := false,
	Email         := "siccha@mathb.rwth-aachen.de",
	WWWHome       := "https://www.mathb.rwth-aachen.de/Mitarbeiter/siccha.php",
    PostalAddress := Concatenation( [
                      "Lehrstuhl B für Mathematik RWTH - Aachen\n",
						"Pontdriesch 10-16\n",
						"52062 Aachen\n",
						"Germany" ] ),
    Place         := "Aachen",
    Institution   := "RTWH Aachen"
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


) );
