InstallMethod(IO_Pickle, "for an origami", [IsFile, IsOrigami], function(f, O)
	IO_AddToPickled(O);
	if IO_Write(f, "ORIG") = fail then IO_FinalizePickled(); return IO_Error; fi;
	if IO_Pickle(f, HorizontalPerm(O)) = IO_Error then IO_FinalizePickled(); return IO_Error; fi;
	if IO_Pickle(f, VerticalPerm(O)) = IO_Error then IO_FinalizePickled(); return IO_Error; fi;
	if IO_Pickle(f, DegreeOrigami(O)) = IO_Error then IO_FinalizePickled(); return IO_Error; fi;

	if HasStratum(O) then
    if IO_Pickle(f, Stratum(O)) = IO_Error then IO_FinalizePickled(); return IO_Error; fi;
  else
    if IO_Pickle(f, fail) = IO_Error then IO_FinalizePickled(); return IO_Error; fi;
  fi;

	if HasGenus(O) then
    if IO_Pickle(f, Genus(O)) = IO_Error then IO_FinalizePickled(); return IO_Error; fi;
  else
    if IO_Pickle(f, fail) = IO_Error then IO_FinalizePickled(); return IO_Error; fi;
  fi;

	if HasIndexOfMonodromyGroup(O) then
    if IO_Pickle(f, IndexOfMonodromyGroup(O)) = IO_Error then IO_FinalizePickled(); return IO_Error; fi;
  else
    if IO_Pickle(f, fail) = IO_Error then IO_FinalizePickled(); return IO_Error; fi;
  fi;

	if HasSumOfLyapunovExponents(O) then
    if IO_Pickle(f, SumOfLyapunovExponents(O)) = IO_Error then IO_FinalizePickled(); return IO_Error; fi;
  else
    if IO_Pickle(f, fail) = IO_Error then IO_FinalizePickled(); return IO_Error; fi;
  fi;

	if HasIsHyperelliptic(O) then
    if IO_Pickle(f, IsHyperelliptic(O)) = IO_Error then IO_FinalizePickled(); return IO_Error; fi;
  else
    if IO_Pickle(f, fail) = IO_Error then IO_FinalizePickled(); return IO_Error; fi;
  fi;

	if HasSpinParity(O) then
    if IO_Pickle(f, SpinParity(O)) = IO_Error then IO_FinalizePickled(); return IO_Error; fi;
  else
    if IO_Pickle(f, fail) = IO_Error then IO_FinalizePickled(); return IO_Error; fi;
  fi;

	if HasDeckGroup(O) then
    if IO_Pickle(f, IdGroup(DeckGroup(O))) = IO_Error then IO_FinalizePickled(); return IO_Error; fi;
  else
    if IO_Pickle(f, fail) = IO_Error then IO_FinalizePickled(); return IO_Error; fi;
  fi;

	if HasVeechGroup(O) then
    if IO_Pickle(f, VeechGroup(O)) = IO_Error then IO_FinalizePickled(); return IO_Error; fi;
  else
    if IO_Pickle(f, fail) = IO_Error then IO_FinalizePickled(); return IO_Error; fi;
  fi;

	IO_FinalizePickled();
  return IO_OK;
end);

IO_Unpicklers.ORIG := function(f)
	local x, y, d, O, stratum, genus, index_of_monodromy_group, lyapunov, hyperelliptic, spin, deckgroup, vg;
	x := IO_Unpickle(f);
  if x = IO_Error then return IO_Error; fi;
	y := IO_Unpickle(f);
  if y = IO_Error then return IO_Error; fi;
	d := IO_Unpickle(f);
  if d = IO_Error then return IO_Error; fi;
	O := Origami(x, y, d);
	IO_AddToUnpickled(O);

	stratum := IO_Unpickle(f);
  if stratum = IO_Error then IO_FinalizeUnpickled(); return IO_Error; fi;
	genus := IO_Unpickle(f);
	if genus = IO_Error then IO_FinalizeUnpickled(); return IO_Error; fi;
	index_of_monodromy_group := IO_Unpickle(f);
	if index_of_monodromy_group = IO_Error then IO_FinalizeUnpickled(); return IO_Error; fi;
	lyapunov := IO_Unpickle(f);
	if lyapunov = IO_Error then IO_FinalizeUnpickled(); return IO_Error; fi;
	hyperelliptic := IO_Unpickle(f);
	if hyperelliptic = IO_Error then IO_FinalizeUnpickled(); return IO_Error; fi;
	spin := IO_Unpickle(f);
	if spin = IO_Error then IO_FinalizeUnpickled(); return IO_Error; fi;
	deckgroup := IO_Unpickle(f);
	if deckgroup = IO_Error then IO_FinalizeUnpickled(); return IO_Error; fi;
	vg := IO_Unpickle(f);
	if vg = IO_Error then IO_FinalizeUnpickled(); return IO_Error; fi;

	if stratum <> fail then SetStratum(O, stratum); fi;
	if genus <> fail then SetGenus(O, genus); fi;
	if index_of_monodromy_group <> fail then SetIndexOfMonodromyGroup(O, index_of_monodromy_group); fi;
	if lyapunov <> fail then SetSumOfLyapunovExponents(O, lyapunov); fi;
	if hyperelliptic <> fail then SetIsHyperelliptic(O, hyperelliptic); fi;
	if spin <> fail then SetSpinParity(O, spin); fi;
	if deckgroup <> fail then SetDeckGroup(O, OneSmallGroup(deckgroup)); fi;
	if vg <> fail then SetVeechGroup(O, vg); fi;

	IO_FinalizeUnpickled();
	return O;
end;