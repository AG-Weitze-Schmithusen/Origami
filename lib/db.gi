InstallGlobalFunction(ConnectToOrigamiDB, function()
  InstallValue(ORIGAMI_DB, AttachAnArangoDatabase([
    "--server.database", "origami",
    "--server.endpoint", "http+tcp://127.0.0.1:8529",
    "--server.username", "origami",
    "--server.password", "secret"
  ]));
end);


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
  stmt := ORIGAMI_DB._createStatement(rec(
    query := Concatenation(
      "FOR vg IN veechgroups FILTER vg.sigma_s == ", String(sigma_s),
      " AND vg.sigma_t == ", String(sigma_t), " RETURN vg"
    ),
    count := true
  ));
  result := stmt.execute();

  if result.count() = 0 then
    return fail;
  fi;

  return NextIterator(Iterator(result));
end);


InstallMethod(GetVeechGroups, [IsRecord], function(constraints)
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
  local index, sigma_s, sigma_t, new_vg_entry;

  index := Index(VG);
  sigma_s := ListPerm(SAction(VG), index);
  sigma_t := ListPerm(TAction(VG), index);
  new_vg_entry := rec();
  if HasDeficiency(VG) then
    new_vg_entry.deficiency := Deficiency(VG);
  fi;
  if HasGenus(VG) then
    new_vg_entry.genus := Genus(VG);
  fi;
  UpdateDatabase(rec(sigma_s := String(sigma_s), sigma_t := String(sigma_t)), new_vg_entry, ORIGAMI_DB.veechgroups);
end);

# removes a veech group from the database
InstallMethod(RemoveVeechGroupFromDB, [IsModularSubgroup], function(VG)
  local index, sigma_s, sigma_t, stmt, result;

  index := Index(VG);
  sigma_s := ListPerm(SAction(VG), index);
  sigma_t := ListPerm(TAction(VG), index);
  stmt := ORIGAMI_DB._createStatement(rec(
    query := Concatenation(
      "FOR vg IN veechgroups FILTER vg.sigma_s == ", String(sigma_s),
      " AND vg.sigma_t == ", String(sigma_t), " REMOVE vg IN veechgroups"
    )
  ));
  result := stmt.execute();
end);


# inserts the normal form of an origami into the origami representative database
# and returns the resulting arangodb document (only inserts precomputed data)
InstallMethod(InsertOrigamiRepresentativeIntoDB, [IsOrigami], function(O)
  local VG, vg_entry, degree, sigma_x, sigma_y, origami_entry;

  O := OrigamiNormalForm(O);
  degree := DegreeOrigami(O);
  sigma_x := HorizontalPerm(O);
  sigma_y := VerticalPerm(O);
  origami_entry := rec(
    sigma_x := ListPerm(sigma_x, degree),
    sigma_y := ListPerm(sigma_y, degree),
    degree := degree
    # TODO: index_monodromy_group := IndexNC(SymmetricGroup(degree), Group(sigma_x, sigma_y))
    # TODO: deck group ?
  );
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

  return InsertIntoDatabase(origami_entry, ORIGAMI_DB.origami_representatives);
end);


InstallMethod(GetOrigamiOrbitRepresentativeDBEntry, [IsOrigami], function(O)
  local sigma_x, sigma_y, stmt, result;

  sigma_x := ListPerm(HorizontalPerm(O), DegreeOrigami(O));
  sigma_y := ListPerm(VerticalPerm(O), DegreeOrigami(O));
  stmt := ORIGAMI_DB._createStatement(rec(
    query := Concatenation(
      "FOR o IN origami_representatives FILTER o.sigma_x == ", String(sigma_x),
      " AND o.sigma_y == ", String(sigma_y), " RETURN o"
    ),
    count := true
  ));
  result := stmt.execute();

  if result.count() = 0 then
    return fail;
  fi;

  return NextIterator(Iterator(result));
end);


InstallMethod(GetOrigamiOrbitRepresentatives, [IsRecord], function(constraints)
  local result, veechgroups, vg_doc, constr, origamis, vg_entry;

  if IsBound(constraints.veechgroup) then
    if IsRecord(constraints.veechgroup) then
      # OPTIMIZE: reduce the number of queries
      veechgroups := ShallowCopy(GetVeechGroups(constraints.veechgroup));
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
          if IsBound(doc.veechgroup) then
            VG := GetVeechGroups(rec(_id := doc.veechgroup))[1];
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
      return GetOrigamiOrbitRepresentatives(constr);
    else
      return fail;
    fi;
  fi;

  if IsBound(constraints.stratum) then
    constraints := ShallowCopy(constraints);
    constraints.stratum := ["==", constraints.stratum];
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
    if IsBound(doc.veechgroup) then
      VG := GetVeechGroups(rec(_id := doc.veechgroup))[1];
      SetVeechGroup(O, VG);
    fi;
    return O;
  end);
  return result;
end);


InstallMethod(GetAllOrigamiOrbitRepresentatives, [], function()
  return GetOrigamiOrbitRepresentatives(rec());
end);


InstallMethod(UpdateOrigamiOrbitRepresentativeDBEntry, [IsOrigami], function(O)
  local new_origami_entry, VG, vg_entry, origami_entry;

  new_origami_entry := rec();
  if HasStratum(O) then
    new_origami_entry.stratum := Stratum(O);
  fi;
  if HasGenus(O) then
    new_origami_entry.genus := Genus(O);
  fi;
  if HasVeechGroup(O) then
    VG := VeechGroup(O);
    vg_entry := GetVeechGroupDBEntry(VG);
    if vg_entry = fail then
      vg_entry := InsertVeechGroupIntoDB(VG);
    fi;
    new_origami_entry.veechgroup := vg_entry._id;
  fi;
  origami_entry := GetOrigamiOrbitRepresentativeDBEntry(O);
  UpdateDatabase(rec(_id := origami_entry._id), new_origami_entry, ORIGAMI_DB.origami_representatives);
end);


InstallMethod(RemoveOrigamiOrbitRepresentativeFromDB, [IsOrigami], function(O)
  # TODO: implement
  # should this remove the whole orbit?
  return fail;
end);

# Inserts an origami O together with a specified orbit representative R into the
# database. Only checks whether R exists already in the database, no check is
# performed if there is an isomorphic copy of R or another element of the same
# orbit in the table 'origami_representatives'!
InstallMethod(InsertOrigamiWithOrbitRepresentativeIntoDB, [IsOrigami, IsOrigami], function(O, R)
  local rep_db_entry, degree, sigma_x, sigma_y, origami_entry;

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
    orbit_representative := rep_db_entry._id
  );

  InsertIntoDatabase(origami_entry, ORIGAMI_DB.origamis);
end);


# Inserts an origami O into the database.
# If the veech group of O is known, this function checks if there is already a
# representative of the orbit of O in the database. If not, O is inserted as the
# representative of its orbit, if yes, O is only inserted into the 'origamis'
# table with a pointer to the representative.
# If the veech group of O is not known, it is inserted as its own representative.
# This might result in entries in 'orbit_representatives' which are in the same
# orbit.
InstallMethod(InsertOrigamiIntoDB, [IsOrigami], function(O)
  local orbit, db_reps, P, Q, R;
  if HasVeechGroup(O) then
    orbit := SL2Orbit(O);
    db_reps := GetAllOrigamiOrbitRepresentatives();
    for P in db_reps do
      for Q in orbit do
        if EquivalentOrigami(P, Q) then
          R := P; # it's important to take P and not Q here!
          break;
        fi;
      od;
      if IsBound(R) then break; fi;
    od;
    InsertOrigamiWithOrbitRepresentativeIntoDB(O, R);
  else
    InsertOrigamiWithOrbitRepresentativeIntoDB(O, O);
  fi;
end);


InstallMethod(GetOrigamiDBEntry, [IsOrigami], function(O)
  local sigma_x, sigma_y, stmt, result;

  sigma_x := ListPerm(HorizontalPerm(O), DegreeOrigami(O));
  sigma_y := ListPerm(VerticalPerm(O), DegreeOrigami(O));
  stmt := ORIGAMI_DB._createStatement(rec(
    query := Concatenation(
      "FOR o IN origamis FILTER o.sigma_x == ", String(sigma_x),
      " AND o.sigma_y == ", String(sigma_y), " RETURN o"
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

  origami_entry := GetOrigamiDBEntry(O);
  if origami_entry = fail then
    return fail;
  fi;

  orbit := ShallowCopy(ListOp(QueryDatabase(rec(orbit_representative := origami_entry.orbit_representative), ORIGAMI_DB.origamis)));
  Apply(orbit, doc -> DatabaseDocumentToRecord(doc));
  Apply(orbit, o -> Origami(PermList(o.sigma_x), PermList(o.sigma_y)));

  return orbit;
end);
