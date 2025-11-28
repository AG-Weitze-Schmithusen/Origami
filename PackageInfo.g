SetPackageInfo( rec(
	PackageName := "Origami",
	Subtitle := "Computing Veech groups of origamis",
	Version := "2.0.2",
	Date := "28/11/2025",
	AvailabilityTest := ReturnTrue,
	Status := "other",
	License := "GPL-3.0-or-later",

	PackageDoc := rec(
		BookName  := ~.PackageName,
		ArchiveURLSubset := ["doc"],
		HTMLStart := "doc/chap0.html",
		PDFFile   := "doc/manual.pdf",
		SixFile   := "doc/manual.six",
		LongTitle := ~.Subtitle,
),

##  <#GAPDoc Label="PKGVERSIONDATA">
##  <!ENTITY VERSION "2.0.2">
##  <!ENTITY RELEASEDATE "28 November 2025">
##  <!ENTITY RELEASEYEAR "2025">
##  <#/GAPDoc>

Dependencies := rec(
		GAP := "4.10",

		NeededOtherPackages := [["ModularGroup", "2.0.0"], ["Orb", "4.7.6"]],

		SuggestedOtherPackages := [
			["HomalgToCAS" ,"2018.06.15"],
			["IO_ForHomalg", "2017.09.02"],
			["IO", "4.5.1"],
			["RingsForHomalg", "2018.04.04"],
			["ArangoDBInterface", "2019.07.30"]
		],

		ExternalConditions := []

),

Persons := [
	rec(
		LastName      := "Emmerich",
		FirstNames    := "Leo",
		IsAuthor      := true,
		IsMaintainer  := true,
		Email         := "leem00001@stud.uni-saarland.de",
		WWWHome       := "https://www.uni-saarland.de/lehrstuhl/weitze-schmithuesen.html",
		PostalAddress := Concatenation( [
										 	"AG Weitze-Schmithüsen\n",
										 	"FR 6.1 Mathematik\n",
										 	"Universität des Saarlandes\n",
										 	"D-66041 Saarbrücken" ] ),
		Place         := "Saarbrücken",
		Institution   := "Universität des Saarlandes"
	),
	rec(
		LastName      := "Engelhardt",
		FirstNames    := "Sebastian",
		IsAuthor      := true,
		IsMaintainer  := true,
		Email         := "seen00001@stud.uni-saarland.de",
		WWWHome       := "https://www.uni-saarland.de/lehrstuhl/weitze-schmithuesen.html",
		PostalAddress := Concatenation( [
										 	"AG Weitze-Schmithüsen\n",
										 	"FR 6.1 Mathematik\n",
										 	"Universität des Saarlandes\n",
										 	"D-66041 Saarbrücken" ] ),
		Place         := "Saarbrücken",
		Institution   := "Universität des Saarlandes"
	),
	rec(
		LastName      := "Ertl",
		FirstNames    := "Simon",
		IsAuthor      := true,
		IsMaintainer  := false,
		Email         := "s8siertl@stud.uni-saarland.de",
		WWWHome       := "https://www.uni-saarland.de/lehrstuhl/weitze-schmithuesen.html",
		PostalAddress := Concatenation( [
										 	"AG Weitze-Schmithüsen\n",
										 	"FR 6.1 Mathematik\n",
										 	"Universität des Saarlandes\n",
										 	"D-66041 Saarbrücken" ] ),
		Place         := "Saarbrücken",
		Institution   := "Universität des Saarlandes"
	),
	rec(
		LastName      := "Junk",
		FirstNames    := "Luca Leon",
		IsAuthor      := true,
		IsMaintainer  := false,
		Email         := "junk@math.uni-sb.de",
		WWWHome       := "https://www.uni-saarland.de/lehrstuhl/weber-moritz/team/luca-junk.html",
		PostalAddress := Concatenation( [
						"Saarland University\n",
						"Department of Mathematics\n",
						"Postfach 15 11 50\n",
						"66041 Saarbrücken\n",
						"Germany" ] ),
		Place         := "Saarbrücken",
		Institution   := "Universität des Saarlandes"
	),
  rec(
    LastName      := "Kattler",
    FirstNames    := "Pascal",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "kattler@math.uni-sb.de",
    WWWHome       := "https://www.uni-saarland.de/lehrstuhl/weitze-schmithuesen/team/pascal-kattler.html",
    PostalAddress := Concatenation( [
                      "AG Weitze-Schmithüsen\n",
                      "FR 6.1 Mathematik\n",
                      "Universität des Saarlandes\n",
                      "D-66041 Saarbrücken" ] ),
    Place         := "Saarbrücken",
    Institution   := "Universität des Saarlandes"
  ),
	rec(
		LastName      := "Rogovskyy",
		FirstNames    := "Alexander",
		IsAuthor      := true,
		IsMaintainer  := false,
		Email         := "s8alrogo@stud.uni-saarland.de",
		WWWHome       := "https://www.uni-saarland.de/lehrstuhl/weitze-schmithuesen.html",
		PostalAddress := Concatenation( [
										 	"AG Weitze-Schmithüsen\n",
										 	"FR 6.1 Mathematik\n",
										 	"Universität des Saarlandes\n",
										 	"D-66041 Saarbrücken" ] ),
		Place         := "Saarbrücken",
		Institution   := "Universität des Saarlandes"
	),
	rec(
		LastName      := "Schumann",
		FirstNames    := "Pascal",
		IsAuthor      := true,
		IsMaintainer  := true,
		Email         := "s8pcschu@stud.uni-saarland.de",
		WWWHome       := "https://www.uni-saarland.de/lehrstuhl/weitze-schmithuesen.html",
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
		IsMaintainer  := false,
		Email         := "thevis@math.uni-frankfurt.de",
		WWWHome       := "https://www.uni-frankfurt.de/115635174/Dr__Andrea_Thevis/",
		PostalAddress := Concatenation( [
                       "FB 12 – Institut für Mathematik\n",
                       "Johann Wolfgang Goethe-Universität\n",
                       "Robert-Mayer-Str. 6-8\n",
                       " D-60325 Frankfurt am Main"] ),
		Place         := "Saarbrücken",
		Institution   := "Universität des Saarlandes"
    ),
    rec(
		LastName      := "Wagmann",
		FirstNames    := "Hannah",
		IsAuthor      := true,
		IsMaintainer  := true,
		Email         := "wagmann@math.uni-sb.de",
		WWWHome       := "https://www.uni-saarland.de/lehrstuhl/weitze-schmithuesen/team/hannah-wagmann.html",
		PostalAddress := Concatenation( [
										 	"AG Weitze-Schmithüsen\n",
										 	"FR 6.1 Mathematik\n",
										 	"Universität des Saarlandes\n",
										 	"D-66041 Saarbrücken" ] ),
		Place         := "Saarbrücken",
		Institution   := "Universität des Saarlandes"
	),
	rec(
		LastName      := "Weitze-Schmithüsen",
		FirstNames    := "Gabriela",
		IsAuthor      := true,
		IsMaintainer  := true,
		Email         := "weitze@math.uni-sb.de",
		WWWHome       := "https://www.uni-saarland.de/lehrstuhl/weitze-schmithuesen/team/gabriela-weitze-schmithuesen.html",
		PostalAddress := Concatenation( [
                       "AG Weitze-Schmithüsen\n",
                       "FR 6.1 Mathematik\n",
                       "Universität des Saarlandes\n",
                       "D-66041 Saarbrücken" ] ),
		Place         := "Saarbrücken",
		Institution   := "Universität des Saarlandes"
    ),
],



GithubUser := "AG-Weitze-Schmithusen",
GithubRepository := ~.PackageName,
GithubWWW := Concatenation("https://github.com/", ~.GithubUser, "/", ~.GithubRepository),

PackageWWWHome := Concatenation("https://", ~.GithubUser, ".github.io/", ~.GithubRepository, "/"),

ArchiveURL     := Concatenation( "https://github.com/", ~.GithubUser, "/", ~.GithubRepository, "/releases/download/Origami-", ~.Version, "/", ~.GithubRepository, "-", ~.Version ),
README_URL     := Concatenation( ~.PackageWWWHome, "README.md" ),
PackageInfoURL := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),

AbstractHTML   := "<span class=\"pkgname\">Origami</span> is a package for computing the Veech group of square-tiled surfaces which are also known as origamis.",

ArchiveFormats := ".tar.gz .zip",
ArchiveURL     := Concatenation(~.GithubWWW,
                    "/releases/download/v", ~.Version, "/",
~.GithubRepository, "-", ~.Version),

BannerString := Concatenation("""
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
         ┌──┐
         │  │           Loading  Origami """, ~.Version, """ (Computing Veech groups of origamis)
      ┌──┼──┼──┐        by Leo Emmerich (https://www.uni-saarland.de/lehrstuhl/weitze-schmithuesen.html),
      │  │  │  │           Sebastian Engelhardt (https://www.uni-saarland.de/lehrstuhl/weitze-schmithuesen.html),
   ┌──┼──┼──┼──┼──┐        Simon Ertl (https://www.uni-saarland.de/lehrstuhl/weitze-schmithuesen.html),
   │  │  │  │  │  │        Luca Junk (https://www.uni-saarland.de/lehrstuhl/weber-moritz/team/luca-junk.html),
┌──┼──┼──┼──┼──┼──┼──┐     Pascal Kattler (https://www.uni-saarland.de/lehrstuhl/weitze-schmithuesen/team/pascal-kattler.html),
│  │  │  │  │  │  │  │     Alexander Rogovskyy (https://www.uni-saarland.de/lehrstuhl/weitze-schmithuesen.html),
└──┼──┼──┼──┼──┼──┼──┘ 	   Pascal Schumann (https://www.uni-saarland.de/lehrstuhl/weitze-schmithuesen.html),
   │  │  │  │  │  │        Andrea Thevis (https://www.uni-frankfurt.de/115635174/Dr__Andrea_Thevis),
   └──┼──┼──┼──┼──┘        Hannah Wagmann (https://www.uni-saarland.de/lehrstuhl/weitze-schmithuesen/team/hannah-wagmann.html), and
      │  │  │  │           Gabriela Weitze-Schmithüsen (https://www.uni-saarland.de/lehrstuhl/weitze-schmithuesen/team/gabriela-weitze-schmithuesen.html).
      └──┼──┼──┘        Homepage: https://AG-Weitze-Schmithusen.github.io/Origami/
         │  │
         └──┘
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
"""),

TestFile := "tst/testall.g",

) );
