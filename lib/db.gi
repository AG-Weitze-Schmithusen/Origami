InstallGlobalFunction(ConnectToOrigamiDB, function()
  InstallValue(ORIGAMI_DB, AttachAnArangoDatabase([
    "--server.database", "origami",
    "--server.endpoint", "http+tcp://127.0.0.1:8529",
    "--server.username", "origami"
  ]));
end);
InstallValue(ARANGODB_MAX_INT, (2-2^(-52))*2^1023);


InstallMethod(InsertVeechGroupIntoDB, [IsModularSubgroup], function(VG)
  local index, sigma_s, sigma_t, vg_entry;

  index := Index(VG);
  sigma_s := ListPerm(SAction(VG), index);
  sigma_t := ListPerm(TAction(VG), index);
  vg_entry := rec(
    index := index,
    sigma_s := sigma_s,
    sigma_t := sigma_t,
    congruence := IsCongruence(VG),
    level := GeneralizedLevel(VG)
    );
  if HasDeficiency(VG) then
    vg_entry.deficiency := Deficiency(VG);
  fi;
  if HasGenus(VG) then
    vg_entry.genus := Genus(VG);
  fi;

  return InsertIntoDatabase(vg_entry, ORIGAMI_DB.veechgroups);
end);

# for a veech group, returns the arangodb document corresponding to the group or fail if
# it doesn't exist in the database
InstallMethod(GetVeechGroupDBEntry, [IsModularSubgroup], function(VG)
  local index, sigma_s, sigma_t, stmt, result;

  index := Index(VG);
  sigma_s := ListPerm(SAction(VG), index);
  sigma_t := ListPerm(TAction(VG), index);
  result := ORIGAMI_DB._createStatement(rec(
    query := Concatenation("FOR v IN veechgroups FILTER v.sigma_s == ", GapToJsonStringForArangoDB(sigma_s), " AND v.sigma_t == ", GapToJsonStringForArangoDB(sigma_t), " RETURN v"),
    count := true
  )).execute();

  if result.count() = 0 then
    return fail;
  fi;

  return NextIterator(Iterator(result));
end);


InstallMethod(GetVeechGroupsFromDB, [IsRecord], function(constraints)
  local result;
  result :=  ShallowCopy(ListOp(QueryDatabase(constraints, ORIGAMI_DB.veechgroups)));
  Apply(result, doc -> DatabaseDocumentToRecord(doc));
  Apply(result, function(doc)
    local VG;
    VG := ModularSubgroup(PermList(doc.sigma_s), PermList(doc.sigma_t));
    SetGeneralizedLevel(VG, doc.level);
    SetIsCongruence(VG, doc.congruence);
    if IsBound(doc.genus) then
      SetGenus(VG, doc.genus);
    fi;
    if IsBound(doc.deficiency) then
      SetDeficiency(VG, doc.deficiency);
    fi;
    return VG;
  end);
  return result;
end);

# updates the veech group entry in the database with newly computed data and returns
# the corresponding updated arangodb document
InstallMethod(UpdateVeechGroupDBEntry, [IsModularSubgroup], function(VG)
  local doc;
  
  doc := GetVeechGroupDBEntry(VG);
  if doc = fail then return fail; fi;
  
  doc := DatabaseDocumentToRecord(doc);
  if HasDeficiency(VG) then
    doc.deficiency := Deficiency(VG);
  fi;
  if HasGenus(VG) then
    doc.genus := Genus(VG);
  fi;
  UpdateDatabase(doc._key, doc, ORIGAMI_DB.veechgroups);
end);

# removes a veech group from the database
InstallMethod(RemoveVeechGroupFromDB, [IsModularSubgroup], function(VG)
  local index, sigma_s, sigma_t, stmt, result;

  index := Index(VG);
  sigma_s := ListPerm(SAction(VG), index);
  sigma_t := ListPerm(TAction(VG), index);
  stmt := ORIGAMI_DB._createStatement(rec(
    query := Concatenation(
      "FOR vg IN veechgroups FILTER vg.sigma_s == ", GapToJsonString(sigma_s),
      " AND vg.sigma_t == ", GapToJsonString(sigma_t), " REMOVE vg IN veechgroups"
    )
  ));
  result := stmt.execute();
end);


# inserts the normal form of an origami into the origami representative database
# and returns the resulting arangodb document (only inserts precomputed data)
InstallMethod(InsertOrigamiRepresentativeIntoDB, [IsOrigami], function(O)
  local VG, vg_entry, degree, sigma_x, sigma_y, origami_entry, DG, rels, index_monodromy, sum_of_lyapunov_exponents;

  O := CopyOrigamiInNormalForm(O);
  degree := DegreeOrigami(O);
  sigma_x := HorizontalPerm(O);
  sigma_y := VerticalPerm(O);
  origami_entry := rec(
    sigma_x := ListPerm(sigma_x, degree),
    sigma_y := ListPerm(sigma_y, degree),
    degree := degree
  );
  index_monodromy := IndexNC(SymmetricGroup(degree), Group(sigma_x, sigma_y));
  if index_monodromy <= ARANGODB_MAX_INT then
    origami_entry.index_monodromy_group := index_monodromy;
  else
    origami_entry.index_monodromy_group := 0;
  fi;

  if HasDeckGroup(O) then
    DG := DeckGroup(O);
    if Size(DG) <= 2000 and Size(DG) <> 1024 and Size(DG) <> 512 then
      origami_entry.deck_group_description := "GAP_ID";
      origami_entry.deck_group := IdSmallGroup(DG);
      origami_entry.is_normal := IsNormalOrigami(O);
    elif IsPermGroup(DG) then
      # TODO: implement this
    elif IsFpGroup(DG) then
      origami_entry.deck_group_description := "PRES";
      rels := ShallowCopy(RelatorsOfFpGroup(DG));
      Apply(rels, ExtRepOfObj);
      origami_entry.deck_group := rels;
      origami_entry.is_normal := IsNormalOrigami(O);
    elif IsPcGroup(DG) then
      origami_entry.deck_group_description := "PRES";
      DG := Image(IsomorphismFpGroupByPcgs(FamilyPcgs(DG), "f"));
      rels := ShallowCopy(RelatorsOfFpGroup(DG));
      Apply(rels, ExtRepOfObj);
      origami_entry.deck_group := rels;
      origami_entry.is_normal := IsNormalOrigami(O);
    else
      Error("Can't store the deck group in the database.");
    fi;
  fi;

  if HasStratum(O) then
    origami_entry.stratum := Stratum(O);
  fi;
  if HasGenus(O) then
    origami_entry.genus := Genus(O);
  fi;
  if HasVeechGroup(O) then
    VG := VeechGroup(O);
    vg_entry := GetVeechGroupDBEntry(VG);

    if vg_entry = fail then
      # veech group does not exist in database, we need to insert it first
      vg_entry := InsertVeechGroupIntoDB(VG);
    fi;
    origami_entry.veechgroup := vg_entry._id;
  fi;
  if HasSumOfLyapunovExponents(O) then
    sum_of_lyapunov_exponents := SumOfLyapunovExponents(O);
    origami_entry.sum_of_lyapunov_exponents := [NumeratorRat(sum_of_lyapunov_exponents), DenominatorRat(sum_of_lyapunov_exponents)];
  fi;
  if HasSpinParity(O) then
    origami_entry.spin_parity := SpinParity(O);
  fi;
  if HasIsHyperelliptic(O) then
    origami_entry.is_hyperelliptic := IsHyperelliptic(O);
  fi;

  return InsertIntoDatabase(origami_entry, ORIGAMI_DB.origami_representatives);
end);


InstallMethod(GetOrigamiOrbitRepresentativeDBEntry, [IsOrigami], function(O)
  local sigma_x, sigma_y, stmt, result;

  O := CopyOrigamiInNormalForm(O);
  sigma_x := ListPerm(HorizontalPerm(O), DegreeOrigami(O));
  sigma_y := ListPerm(VerticalPerm(O), DegreeOrigami(O));
  result := ORIGAMI_DB._createStatement(rec(
    query := Concatenation("FOR o IN origami_representatives FILTER o.sigma_x == ", GapToJsonStringForArangoDB(sigma_x), " AND o.sigma_y == ", GapToJsonStringForArangoDB(sigma_y), " RETURN o"),
    count := true
  )).execute();
  
  if result.count() = 0 then
    return fail;
  fi;

  return NextIterator(Iterator(result));
end);


InstallMethod(GetOrigamiOrbitRepresentativesFromDB, [IsRecord], function(constraints)
  local result, veechgroups, vg_doc, constr, origamis, vg_entry, num_gens, i, j, rels, F;

  if IsBound(constraints.veechgroup) then
    if IsRecord(constraints.veechgroup) then
      # OPTIMIZE: reduce the number of queries
      veechgroups := ShallowCopy(GetVeechGroupsFromDB(constraints.veechgroup));
      Apply(veechgroups, vg -> DatabaseDocumentToRecord(GetVeechGroupDBEntry(vg)));
      result := [];
      constr := ShallowCopy(constraints);
      for vg_doc in veechgroups do
        constr.veechgroup := vg_doc._id;
        origamis := ShallowCopy(ListOp(QueryDatabase(constr, ORIGAMI_DB.origami_representatives)));

        # TODO: clean up code duplication
        Apply(origamis, doc -> DatabaseDocumentToRecord(doc));
        Apply(origamis, function(doc)
          local O, VG;
          O := Origami(PermList(doc.sigma_x), PermList(doc.sigma_y));
          if IsBound(doc.stratum) then
            SetStratum(O, doc.stratum);
          fi;
          if IsBound(doc.genus) then
            SetGenus(O, doc.genus);
          fi;
          if IsBound(doc.deck_group) then
            SetIsNormalOrigami(O, doc.is_normal);
            if doc.deck_group_description = "GAP_ID" then
              SetDeckGroup(O, SmallGroup(doc.deck_group));
            elif doc.deck_group_description = "PRES" then
              num_gens := 1;
              for i in [1..Length(doc.deck_group)] do
                j := 1;
                repeat
                  num_gens := Maximum(num_gens, doc.deck_group[i][j]);
                  j := j+2;
                until j > Length(doc.deck_group[i]);
              od;
              F := FreeGroup(num_gens);
              rels := ShallowCopy(doc.deck_group);
              Apply(rels, w -> ObjByExtRep(FamilyObj(F.1), w));
              SetDeckGroup(O, Image(IsomorphismPcGroup(FactorGroupFpGroupByRels(F, rels))));
            elif doc.deck_group_description = "PERM" then
              # TODO: implement this
            else
              Error("Can't interpret stored deck group.");
            fi;
          fi;
          if IsBound(doc.veechgroup) then
            VG := GetVeechGroupsFromDB(rec(_id := doc.veechgroup))[1];
            SetVeechGroup(O, VG);
          fi;
          return O;
        end);
        result := Concatenation(result, origamis);
      od;
      return result;
    elif IsModularSubgroup(constraints.veechgroup) then
      vg_entry := GetVeechGroupDBEntry(constraints.veechgroup);
      constr := ShallowCopy(constraints);
      constr.veechgroup := rec(_id := vg_entry._id);
      return GetOrigamiOrbitRepresentativesFromDB(constr);
    else
      return fail;
    fi;
  fi;

  if IsBound(constraints.stratum) then
    constraints := ShallowCopy(constraints);
    constraints.stratum := ["==", constraints.stratum];
  fi;
  
  if IsBound(constraints.sum_of_lyapunov_exponents) then
    constraints := ShallowCopy(constraints);
    constraints.sum_of_lyapunov_exponents := ["==", [NumeratorRat(constraints.sum_of_lyapunov_exponents), DenominatorRat(constraints.sum_of_lyapunov_exponents)]];
  fi;

  if IsBound(constraints.example_series) then
    constraints := ShallowCopy(constraints);
    constraints.example_series := ["==", constraints.example_series];
  fi;

  if IsBound(constraints.spin_parity) then
    constraints.spin_parity := ["==", constraints.spin_parity];
  fi;

  if IsBound(constraints.is_hyperelliptic) then
    constraints.is_hyperelliptic := ["==", constraints.is_hyperelliptic];
  fi;

  result :=  ShallowCopy(ListOp(QueryDatabase(constraints, ORIGAMI_DB.origami_representatives)));
  Apply(result, doc -> DatabaseDocumentToRecord(doc));
  Apply(result, function(doc)
    local O, VG;
    O := Origami(PermList(doc.sigma_x), PermList(doc.sigma_y));
    if IsBound(doc.stratum) then
      SetStratum(O, doc.stratum);
    fi;
    if IsBound(doc.genus) then
      SetGenus(O, doc.genus);
    fi;
    if IsBound(doc.deck_group) then
      SetIsNormalOrigami(O, doc.is_normal);
      if doc.deck_group_description = "GAP_ID" then
        SetDeckGroup(O, SmallGroup(doc.deck_group));
      elif doc.deck_group_description = "PRES" then
        num_gens := 1;
        for i in [1..Length(doc.deck_group)] do
          j := 1;
          repeat
            num_gens := Maximum(num_gens, doc.deck_group[i][j]);
            j := j+2;
          until j > Length(doc.deck_group[i]);
        od;
        F := FreeGroup(num_gens);
        rels := ShallowCopy(doc.deck_group);
        Apply(rels, w -> ObjByExtRep(FamilyObj(F.1), w));
        SetDeckGroup(O, Image(IsomorphismPcGroup(FactorGroupFpGroupByRels(F, rels))));
      elif doc.deck_group_description = "PERM" then
        # TODO: implement this
      else
        Error("Can't interpret stored deck group.");
      fi;
    fi;
    if IsBound(doc.veechgroup) then
      VG := GetVeechGroupsFromDB(rec(_id := doc.veechgroup))[1];
      SetVeechGroup(O, VG);
    fi;
    return O;
  end);
  return result;
end);


InstallMethod(GetAllOrigamiOrbitRepresentativesFromDB, [], function()
  return GetOrigamiOrbitRepresentativesFromDB(rec());
end);

InstallMethod(UpdateOrigamiOrbitRepresentativeDBEntry, [IsOrigami], function(O)
  local new_origami_entry, origami_entry, DG, rels, sum_of_lyapunov_exponents;

  new_origami_entry := rec();
  if HasStratum(O) then
    new_origami_entry.stratum := Stratum(O);
  fi;
  if HasGenus(O) then
    new_origami_entry.genus := Genus(O);
  fi;
  if HasSumOfLyapunovExponents(O) then
    sum_of_lyapunov_exponents := SumOfLyapunovExponents(O);
    new_origami_entry.sum_of_lyapunov_exponents := [NumeratorRat(sum_of_lyapunov_exponents), DenominatorRat(sum_of_lyapunov_exponents)];
  fi;
  if HasSpinParity(O) then
    new_origami_entry.spin_parity := SpinParity(O);
  fi;
  if HasIsHyperelliptic(O) then
    new_origami_entry.is_hyperelliptic := IsHyperelliptic(O);
  fi;
  if HasDeckGroup(O) then
    new_origami_entry.is_normal := IsNormalOrigami(O);
    DG := DeckGroup(O);
    if Size(DG) <= 2000 and Size(DG) <> 1024 then
      new_origami_entry.deck_group_description := "GAP_ID";
      new_origami_entry.deck_group := IdSmallGroup(DG);
    elif IsPermGroup(DG) then
      # TODO: implement this
    elif IsFpGroup(DG) then
      new_origami_entry.deck_group_description := "PRES";
      rels := ShallowCopy(RelatorsOfFpGroup(DG));
      Apply(rels, ExtRepOfObj);
      new_origami_entry.deck_group := rels;
    else
      Error("Can't store the deck group in the database.");
    fi;
  fi;
  origami_entry := GetOrigamiOrbitRepresentativeDBEntry(O);
  UpdateDatabase(rec(_id := origami_entry._id), new_origami_entry, ORIGAMI_DB.origami_representatives);
end);

#InstallOtherMethod(UpdateOrigamiOrbitRepresentativeDBEntry, [IsOrigami, IsList], function(O, orbit)
#  local new_origami_entry, VG, vg_entry, origami_entry, i, new_rep, orb;

#  new_origami_entry := rec();
#  if HasStratum(O) then
#    new_origami_entry.stratum := Stratum(O);
#  fi;
#  if HasGenus(O) then
#    new_origami_entry.genus := Genus(O);
#  fi;

  # We can assume that the Veechgroup of O is known, since we know the SL2-orbit
  # of O.
#  VG := VeechGroup(O);
#  vg_entry := GetVeechGroupDBEntry(VG);
#  if vg_entry = fail then
#    vg_entry := InsertVeechGroupIntoDB(VG);
#  fi;
#  new_origami_entry.veechgroup := vg_entry._id;

#  orb := ShallowCopy(orbit); # orbit might not be mutable
#  Sort(orb);
#  new_rep := orb[1];
#  if HasStratum(O) then
#    SetStratum(new_rep, Stratum(O));
#  fi;
#  if HasGenus(O) then
#    SetGenus(new_rep, Genus(O));
#  fi;

  # TODO: this is the wrong group. we need to conjugate this with something
#  SetVeechGroup(new_rep, VeechGroup(O));

#  for i in [2..Length(orb)] do
#    RemoveOrigamiOrbitRepresentativeFromDB(orb[i]);
#    RemoveOrigamiFromDB(orb[i]);
#    InsertOrigamiWithOrbitRepresentativeIntoDB(orb[i], new_rep);
#  od;
#end);


InstallMethod(RemoveOrigamiOrbitRepresentativeFromDB, [IsOrigami], function(O)
  local entry, id;
  entry := GetOrigamiOrbitRepresentativeDBEntry(O);
  if entry <> fail then
    id := DatabaseDocumentToRecord(entry)._key;
    RemoveFromDatabase(id, ORIGAMI_DB.origami_representatives);
  fi;
end);


InstallMethod(InsertOrigamiWithOrbitRepresentativeIntoDB, [IsOrigami, IsOrigami, IsMatrix], function(O, R, A)
  local rep_db_entry, degree, sigma_x, sigma_y, origami_entry;

  O := CopyOrigamiInNormalForm(O);
  R := CopyOrigamiInNormalForm(R);

  # check if orbit representative is already in database
  rep_db_entry := GetOrigamiOrbitRepresentativeDBEntry(R);
  if rep_db_entry = fail then
    # if not, insert it
    rep_db_entry := InsertOrigamiRepresentativeIntoDB(R);
  fi;

  # insert origami into database
  degree := DegreeOrigami(O);
  sigma_x := HorizontalPerm(O);
  sigma_y := VerticalPerm(O);
  origami_entry := rec(
    sigma_x := ListPerm(sigma_x, degree),
    sigma_y := ListPerm(sigma_y, degree),
    degree := degree,
    orbit_representative := rep_db_entry._id,
    matrix := A
  );

  return InsertIntoDatabase(origami_entry, ORIGAMI_DB.origamis);
end);


InstallMethod(AddLabelToOrigamiDBEntry, [IsOrigami, IsString], function(O, label)
  local db_doc;
  
  db_doc := GetOrigamiDBEntry(O);
  db_doc := DatabaseDocumentToRecord(db_doc);
  if not IsBound(db_doc.labels) then
    db_doc.labels := [];
  fi;
  Add(db_doc.labels, label);
  
  return UpdateDatabase(db_doc._key, db_doc, ORIGAMI_DB.origamis);
end);
InstallOtherMethod(AddLabelToOrigamiDBEntry, [IsDatabaseDocument, IsString], function(doc, label)
  doc := DatabaseDocumentToRecord(doc);
  if not IsBound(doc.labels) then
    doc.labels := [];
  fi;
  Add(doc.labels, label);

  return UpdateDatabase(doc._key, doc, ORIGAMI_DB.origamis);
end);


# Inserts an origami O into the database.
# If the veech group and the orbit of O is known, this function checks if there is already a
# representative of the orbit of O in the database. If not, O is inserted as the
# representative of its orbit, if yes, O is only inserted into the 'origamis'
# table with a pointer to the representative.
# If the veech group of O is not known, it is inserted as its own representative.
# This might result in entries in 'orbit_representatives' which are in the same
# orbit.
InstallMethod(InsertOrigamiIntoDB, [IsOrigami], function(O)
  InsertOrigamiWithOrbitRepresentativeIntoDB(O, O);
end);
InstallOtherMethod(InsertOrigamiIntoDB, [IsOrigami, IsList], function(O, orbit)
  local db_reps, P, Q, R;
  O := CopyOrigamiInNormalForm(O);
  db_reps := GetAllOrigamiOrbitRepresentativesFromDB(); # TODO: we don't need all representatives
  for P in db_reps do
    for Q in orbit do
      if OrigamisEquivalent(P, Q) then
        R := P; # it's important to take P and not Q here!
        break;
      fi;
    od;
    if IsBound(R) then break; fi;
  od;
  if IsBound(R) then
    InsertOrigamiWithOrbitRepresentativeIntoDB(O, R);
  else
    Apply(orbit, ori -> OrigamiNormalForm(ori));
    Sort(orbit);
    InsertOrigamiWithOrbitRepresentativeIntoDB(O, orbit[1]);
  fi;
end);


InstallMethod(GetOrigamiDBEntry, [IsOrigami], function(O)
  local sigma_x, sigma_y, stmt, result;

  O := OrigamiNormalForm(O);
  sigma_x := ListPerm(HorizontalPerm(O), DegreeOrigami(O));
  sigma_y := ListPerm(VerticalPerm(O), DegreeOrigami(O));
  stmt := ORIGAMI_DB._createStatement(rec(
    query := Concatenation(
      "FOR o IN origamis FILTER o.sigma_x == ", GapToJsonString(sigma_x),
      " AND o.sigma_y == ", GapToJsonString(sigma_y), " RETURN o"
    ),
    count := true
  ));
  result := stmt.execute();

  if result.count() = 0 then
    return fail;
  fi;

  return NextIterator(Iterator(result));
end);


InstallMethod(GetOrigamiOrbit, [IsOrigami], function(O)
  local origami_entry, orbit;

  O := CopyOrigamiInNormalForm(O);

  origami_entry := GetOrigamiDBEntry(O);
  if origami_entry = fail then
    return fail;
  fi;

  orbit := ShallowCopy(ListOp(QueryDatabase(rec(orbit_representative := origami_entry.orbit_representative), ORIGAMI_DB.origamis)));
  Apply(orbit, doc -> DatabaseDocumentToRecord(doc));
  Apply(orbit, o -> Origami(PermList(o.sigma_x), PermList(o.sigma_y)));

  return orbit;
end);

InstallMethod(UpdateRepresentativeOfOrigami, [IsOrigami, IsOrigami], function(O, R)
  local O_entry, R_entry;
  O := OrigamiNormalForm(O);
  R := OrigamiNormalForm(R);
  O_entry := GetOrigamiDBEntry(O);
  R_entry := GetOrigamiOrbitRepresentativeDBEntry(R);

  if O_entry = fail or R_entry = fail then return; fi;

  UpdateDatabase(rec(_id := DatabaseDocumentToRecord(O_entry)._id, orbit_representative := DatabaseDocumentToRecord(R_entry)._id));
end);

InstallMethod(RemoveOrigamiFromDB, [IsOrigami], function(O)
  local entry;
  O := OrigamiNormalForm(O);
  entry := GetOrigamiDBEntry(O);
  if entry = fail then return; fi;
  RemoveFromDatabase(DatabaseDocumentToRecord(entry)._key, ORIGAMI_DB.origamis);
end);
