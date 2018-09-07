InstallMethod(String, [IsKinderzeichnung], function(Origami)
	return Concatenation("Kinderzeichnug(", String(PermX(Origami)), ", ", String(PermY(Origami)), ")");
end
);

InstallGlobalFunction(NormalKZForm, function(kinderzeichnung)
	local orbitElem, ergx, ergy;
	ergx := [];
	ergy := [];
	for orbitElem in OrbitsDomain (Group(PermX(kinderzeichnung), PermY(kinderzeichnung))) do
 		Add(ergx, RestrictedPermNC(PermX(kinderzeichnung), orbitElem));
 		Add(ergy, RestrictedPermNC(PermY(kinderzeichnung), orbitElem));
	od;
	return Kinderzeichnung(ergx, ergy);
end);
