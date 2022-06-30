EigenspacesModuloTranslations := function(field, mat, translation_mats)
    local spaces, t;
    spaces := [];
    for t in translation_mats do
        Append(spaces, Eigenspaces(field, mat*t));
    od;
    return spaces;
end;

FindSimultaneousEigenvectorsRecursivelyHelper := function(field, mats, i, translation_mats)
    local space1, space2, tmp, res;
    if i = 1 then
        return Eigenspaces(field, mats[1]);
    else
        res := [];
        for space1 in FindSimultaneousEigenvectorsRecursivelyHelper(field, mats, i-1, translation_mats) do
            for space2 in EigenspacesModuloTranslations(field, mats[i], translation_mats) do
                tmp := Intersection(space1, space2);
                if Dimension(tmp) > 0 then
                    Add(res, tmp);
                fi;
            od;
        od;
        return res;
    fi;
end;

FindSimultaneousEigenvectorsRecursively := function(p, mats, translation_mats)
    return FindSimultaneousEigenvectorsRecursivelyHelper(GF(p), List(mats, m->m*One(GF(p))), Length(mats), translation_mats);
end;

IsEigenvector := function(M, d, v)
    local w, a;
    w := (v*M) mod d;
    for a in [0..(d-1)] do
        if a*v mod d = w then
            return true;
        fi;
    od;
    return false;
end;

IsStabilizedBy := function(d, mat, translation_mats, v)
    local t;
    for t in translation_mats do
        if IsEigenvector(mat * t, d, v) then
            return true;
        fi;
    od;
    return false;
end;

InstallGlobalFunction(SearchForOrigamiWithVeechGroup, function(n, p, H)
    local d,mats_sl2z, matrices, sim_vec, o, sim_vecs, veech_ind, DBSTransposeInverse, 
    eigSpaces, esp, sim_vec_int, translations, S, T;

    if not IsPrimeInt(p) or n <= 1 then
        Error("p must be prime and n a natural number > 1");
    fi;

    DBSTransposeInverse := TransposedMat(Inverse(BaseChangeLToS(n)));
    d := p;
    mats_sl2z := MatrixGeneratorsOfGroup(H);
    matrices := List(mats_sl2z, m->Inverse(ActionOfMatrixOnHomologyOfTn(n, m)));
    translations := TranslationGroup(n);
    eigSpaces := FindSimultaneousEigenvectorsRecursively(p, matrices, translations);
    S := Inverse(ActionOfSOnHomologyOfTn(n));
    T := Inverse(ActionOfTOnHomologyOfTn(n));

    for esp in eigSpaces do
        if Dimension(esp) = 0 then
            continue;
        fi;
        for sim_vec in esp do
            sim_vec_int := List(sim_vec, i->IntFFE(i)) mod p;
            if Gcd(Concatenation(sim_vec_int, [d])) <> 1 then
                # this is not a generating tuple and thus won't be an Origami
                continue;
            fi;
            if not (IsStabilizedBy(d, S, translations, sim_vec_int) and IsStabilizedBy(d, T, translations, sim_vec_int)) then
                return sim_vec_int;    # success!
            fi;
        od;
    od;

    return false;
end);