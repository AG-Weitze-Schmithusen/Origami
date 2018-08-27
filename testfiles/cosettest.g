CosetsTest := function(TestCoset, O)
	local RepTest1, RepTest2, CTest;
	for RepTest1 in TestCoset do
		CTest:= false;
		for RepTest2 in Cosets(O) do
			if SameCoset(RepTest1, RepTest2, SAction(VeechGroup(O)), TAction(VeechGroup(O))) then CTest := true; fi;
		od;
		if CTest = false then return false; fi;
	od;
	return true;
end;
