IsSimultanConjugatedForTestfile := function(a1, a2, b1, b2, n)
	local p;
	if RepresentativeAction( SymmetricGroup(n), [a1, a2], [b1, b2], OnTuples) = fail then return false;
	else p := RepresentativeAction( SymmetricGroup(n), [a1, a2], [b1, b2], OnTuples);
		if 1^p = 1 then return true; else return false; fi;
	fi;
	return true;
end;


IsSameVeechGroupForTestfile := function(a1, a2, b1, b2)
	local n;
	n := 1;
	if Length(RightCosetRepresentatives( ModularSubgroup(a1, a2) )) = Length(RightCosetRepresentatives( ModularSubgroup(b1, b2) )) then 
	n := Length(RightCosetRepresentatives( ModularSubgroup(a1, a2) ));
  	else return false;
	fi;
	if RepresentativeAction( SymmetricGroup(n), [a1, a2], [b1, b2], OnTuples) = fail then return false;
	else return true;
   	fi;
 end;
