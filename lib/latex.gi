InstallGlobalFunction(ProduceTable, function(path, size, caption, labels, centering, data)
    local i, j, columnCount;

    columnCount := Length(labels);

    # HEADER
    PrintTo(path, "\\documentclass{article}\n");
    AppendTo(path, "\\usepackage{booktabs}\n");
    AppendTo(path, "\\usepackage{graphicx}\n");
    AppendTo(path, "\\usepackage{floatrow}\n");
    AppendTo(path, "\\usepackage{mathtools}\n");
    AppendTo(path, "\\usepackage{amsthm}\n");
    AppendTo(path, "\\usepackage{amssymb}\n\n");
    
    # TABLE
    AppendTo(path, "\\begin{document}\n");
    AppendTo(path, "\t\\begin{table}[H]\n");
    AppendTo(path, "\t\t\\resizebox{", size, "\\textwidth}{!}{\n");
    AppendTo(path, "\t\t\t\\begin{tabular}{");
    for i in [1..Length(centering)] do
        AppendTo(path, centering[i]);
    od;
    AppendTo(path, "}\n");
    AppendTo(path, "\t\t\t\t\\toprule\n");
    AppendTo(path, "\t\t\t\t");
    for i in [1..columnCount-1] do
        AppendTo(path, labels[i], " & ");
    od;
    AppendTo(path, labels[Length(labels)], " \\\\\n");
    AppendTo(path, "\t\t\t\t\\midrule\n");
    
    # DATA
    for i in [1..Length(data)] do
        AppendTo(path, "\t\t\t\t");
        for j in [1..columnCount-1] do
            AppendTo(path, data[i][j], " & ");
        od;
        AppendTo(path, data[i][columnCount], " \\\\\n");
    od;

    AppendTo(path, "\t\t\t\t\\bottomrule\n");
    AppendTo(path, "\t\t\t\\end{tabular}\n");
    AppendTo(path, "\t\t}\n");
    if not caption = "" then
        AppendTo(path, "\t\t\\caption{", caption,"}\n");
    fi;
    AppendTo(path, "\t\\end{table}\n");
    AppendTo(path, "\\end{document}\n");
end);

ExportSystolicRatioOfNormalOrigamis := function(path, data, append)
    local fileStream, i, str;
    
    # file scheme: [horizontal perm] \n [verticalperm] \n [stratum] \n [SR-square] \n [SR-equilateral] \n [CombLengthNotThree] \n
    fileStream := OutputTextFile(path, append);
    for i in [1..Length(data)] do
        WriteLine(fileStream, String(HorizontalPerm(data[i][1])));
        WriteLine(fileStream, String(VerticalPerm(data[i][1])));
        WriteLine(fileStream, String(data[i][2]));
        WriteLine(fileStream, String(data[i][3]));
        WriteLine(fileStream, String(data[i][4]));
        WriteLine(fileStream, String(data[i][5]));
    od;
    CloseStream(fileStream);
end;

ImportSystolicRatioOfNormalOrigamis := function(path)
    local data, fileStream, entry, i;
    
    data := [];
    fileStream := InputTextFile(path);

    while true do
        entry := [];
        for i in [1..6] do
            Add(entry, ReadLine(fileStream));
        od;
        if(fail in entry) then
            break;
        else
            Apply(entry, x -> EvalString(x));
            entry := [Origami(entry[1], entry[2]), entry[3], entry[4], entry[5], entry[6]];
            Add(data, entry);
        fi;
    od;
    return data;
end;