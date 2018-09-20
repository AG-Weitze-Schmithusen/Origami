InstallGlobalFunction("VeechgroupBySage", function(origami, c)
	local g;
	g := EvaluateBySCSCP("veech_group_of_origami", [HorizontalPerm(origami), VerticalPerm(origami)], c);
	return ModularSubgroup(g.object[1], g.object[2]);
end);


InstallGlobalFunction("NormalFormBySage", function(origami, c)
	local g;
	g := EvaluateBySCSCP("standard_form_of_origami", [HorizontalPerm(origami), VerticalPerm(origami)], c);
	return Origami(g.object[1], g.object[2], DegreeOrigami(origami));
end);
