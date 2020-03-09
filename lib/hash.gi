#####
# implements a hash table for origamis
#####

InstallGlobalFunction(AddHash, function(HashTable, Elem, HashFunction)
    local hashValue;
    hashValue := HashFunction(Elem);
    if IsBound(HashTable[hashValue]) then
      Add(HashTable[hashValue], Elem);
    else
      HashTable[hashValue] := [Elem];
    fi;
end);

InstallGlobalFunction(ContainsHash, function(HashTable, Elem, HashFunction)
	local HashValue, pos;
	HashValue := HashFunction(Elem);
	if IsBound(HashTable[HashValue]) = false then
		return 0;
	else
    pos := Position(HashTable[HashValue], Elem);
		if pos = fail then
			return 0;
		else
			return _IndexOrigami(HashTable[HashValue][pos]);
		fi;
	fi;
end);

InstallGlobalFunction(HashForPermutations, function(p)
    local l;
    l:=LARGEST_MOVED_POINT_PERM(p);
    if IsPerm4Rep(p) then
        # is it a proper 4byte perm?
        if l>65536 then
            return HashKeyBag(p,255,0,4*l);
        else
            # the permutation does not require 4 bytes. Trim in two
            # byte representation (we need to do this to get consistent
            # hash keys, regardless of representation.)
            TRIM_PERM(p,l);
        fi;
    fi;
    # now we have a Perm2Rep:
    return HashKeyBag(p,255,0,2*l);
end);

InstallGlobalFunction(HashForOrigamis, function(O)
    return (HashForPermutations(HorizontalPerm(O)) + HashForPermutations(VerticalPerm(O))) mod 1000000 + 1;
end);
