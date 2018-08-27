IsSimultanConjugatedForTestfile := function(a1, a2, b1, b2, n)

	if RepresentativeAction( SymmetricGroup(n), [a1, a2], [b1, b2], OnTuples) = fail then return false;
	else return true;
	fi;
end;
