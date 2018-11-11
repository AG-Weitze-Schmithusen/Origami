streamForSage := false;

LoadPackage("homalgto");
LoadPackage("io_forhomalg");
LoadPackage("io");
LoadPackage("rings");

BindGlobal("PrepareSage", function()
	streamForSage := LaunchCAS("HOMALG_IO_Sage");
	streamForSage.CUT_POS_END := 13;
	streamForSage.CUT_POS_BEGIN := 10;
	homalgSendBlocking(["from surface_dynamics.all import*"],"need_display", streamForSage);
end);

InstallGlobalFunction("VeechgroupBySage", function(origami)
	local O, V, S,T;
	if streamForSage = false then
		PrepareSage();
	fi;
	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"", String(VerticalPerm(origami))	, "\")"], streamForSage);
	V := homalgSendBlocking([O,".veech_group()"], streamForSage);
	S := homalgSendBlocking([V ,".S2()"], "need_output", streamForSage);
	T := homalgSendBlocking([V ,".L()"], "need_output", streamForSage);
	return ModularSubgroup(EvalString(S), EvalString(T));
end);


InstallGlobalFunction("NormalFormBySage", function(origami)
	local O, NF, r, u;
	if streamForSage = false then
		PrepareSage();
	fi;

	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"", String(VerticalPerm(origami))	, "\")"],streamForSage);
	NF := homalgSendBlocking([O, ".to_standard_form()"],streamForSage);
	r := EvalString(homalgSendBlocking([NF, ".r()"],"need_output",streamForSage));
	u := EvalString(homalgSendBlocking([NF, ".u()"],"need_output",streamForSage));
	return Origami(r, u, DegreeOrigami(origami));
end);

InstallGlobalFunction("IsHyperellipticBySage", function(origami)
	local O;
	if streamForSage = false then
		PrepareSage();
	fi;

	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"",
		String(VerticalPerm(origami))	, "\")"],streamForSage);
	return EvalString( LowercaseString( homalgSendBlocking( [O, ".is_hyperelliptic()"], "need_output", streamForSage ) ) );
end);

InstallGlobalFunction(IsPrimitiveBySage, function(origami)
	local O;
	if streamForSage = false then
		PrepareSage();
	fi;

	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"",
		String(VerticalPerm(origami))	, "\")"],streamForSage);
	return EvalString( LowercaseString( homalgSendBlocking( [O, ".is_primitive()"], "need_output", streamForSage ) ) );
end);

InstallGlobalFunction("ReduceBySage", function(origami)
	local O, R, r, u;
	if streamForSage = false then
		PrepareSage();
	fi;

	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"", String(VerticalPerm(origami))	, "\")"],streamForSage);
	R := homalgSendBlocking([O, ".reduce()"],streamForSage);
	r := EvalString(homalgSendBlocking([R, ".r()"],"need_output",streamForSage));
	u := EvalString(homalgSendBlocking([R, ".u()"],"need_output",streamForSage));
	return Origami(r, u, DegreeOrigami(origami));
end);

InstallGlobalFunction(AbsolutePeriodGeneratorsBySage, function(origami)
	local O, AP, l, i, result, t1, t2;
	if streamForSage = false then
		PrepareSage();
	fi;

	result := [];
	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"",
		String(VerticalPerm(origami))	, "\")"],streamForSage);
	AP := homalgSendBlocking([O, ".absolute_period_generators()"], streamForSage);
	l := EvalString( homalgSendBlocking(["len(", AP, ")"], "need_output", streamForSage) );
	for i in [0..(l - 1)] do
		t1 := EvalString( homalgSendBlocking([AP, "[", String(i), "][0]"], "need_output", streamForSage) );
		t2 := EvalString( homalgSendBlocking([AP, "[", i, "][1]"], "need_output", streamForSage) );
		result[i+1] := [t1, t2];
	od;
	return result;
end);


InstallGlobalFunction(LatticeOfAbsolutePeriodsBySage, function(origami)
	local O, tuple, t1, t2, t3;
	if streamForSage = false then
		PrepareSage();
	fi;

	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"",
		String(VerticalPerm(origami))	, "\")"],streamForSage);
	tuple := homalgSendBlocking([O, ".lattice_of_absolute_periods()"],  streamForSage);
	t1 := EvalString( homalgSendBlocking([tuple, "[0]"], "need_output", streamForSage) );
	t2 := EvalString( homalgSendBlocking([tuple, "[1]"], "need_output", streamForSage) );
	t3 := EvalString( homalgSendBlocking([tuple, "[2]"], "need_output", streamForSage) );
	return [[t1,0],[t2,t3]];
end);

InstallGlobalFunction(LatticeOfQuotientsBySage, function(origami)
	local O;
	if streamForSage = false then
		PrepareSage();
	fi;

	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"",
		String(VerticalPerm(origami))	, "\")"],streamForSage);
end);

InstallGlobalFunction(OptimalDegreeBySage, function(origami)
	local O;
	if streamForSage = false then
		PrepareSage();
	fi;

	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"",
		String(VerticalPerm(origami))	, "\")"],streamForSage);
	return EvalString( homalgSendBlocking([O, ".optimal_degree()"], "need_output", streamForSage) );
end);



InstallGlobalFunction(PeriodGeneratorsBySage, function(origami)
	local O, AP, l, i, result, t1, t2;
	if streamForSage = false then
		PrepareSage();
	fi;

	result := [];
	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"",
		String(VerticalPerm(origami))	, "\")"],streamForSage);
	AP := homalgSendBlocking([O, ".period_generators()"], streamForSage);
	l := EvalString( homalgSendBlocking(["len(", AP, ")"], "need_output", streamForSage) );
	for i in [0..(l - 1)] do
		t1 := EvalString( homalgSendBlocking([AP, "[", String(i), "][0]"], "need_output", streamForSage) );
		t2 := EvalString( homalgSendBlocking([AP, "[", i, "][1]"], "need_output", streamForSage) );
		result[i+1] := [t1, t2];
	od;
	return result;
end);

InstallGlobalFunction(WidthsAndHeightsBySage, function(origami)
	local O, AP, l, i, result, t1, t2;
	if streamForSage = false then
		PrepareSage();
	fi;

	result := [];
	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"",
		String(VerticalPerm(origami))	, "\")"],streamForSage);
	AP := homalgSendBlocking([O, ".widths_and_heights()"], streamForSage);
	l := EvalString( homalgSendBlocking(["len(", AP, ")"], "need_output", streamForSage) );
	for i in [0..(l - 1)] do
		t1 := EvalString( homalgSendBlocking([AP, "[", String(i), "][0]"], "need_output", streamForSage) );
		t2 := EvalString( homalgSendBlocking([AP, "[", i, "][1]"], "need_output", streamForSage) );
		result[i+1] := [t1, t2];
	od;
	return result;
end);


InstallGlobalFunction(SumOfLyapunovExponentsBySage, function(origami)
	local O;
	if streamForSage = false then
		PrepareSage();
	fi;

	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"",
		String(VerticalPerm(origami))	, "\")"],streamForSage);
	return EvalString( homalgSendBlocking([O, ".sum_of_lyapunov_exponents()"], "need_output", streamForSage) );
end);

InstallGlobalFunction(LyapunovExponentsApproxBySage, function(origami)
	local O;
	if streamForSage = false then
		PrepareSage();
	fi;

	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"",
		String(VerticalPerm(origami))	, "\")"],streamForSage);
	return EvalString( homalgSendBlocking([O, ".lyapunov_exponents_approx()"], "need_display", streamForSage) );
end);


InstallGlobalFunction(IntermediateCoversBySage, function(origami)
local O;
if streamForSage = false then
	PrepareSage();
fi;

O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"",
	String(VerticalPerm(origami))	, "\")"],streamForSage);
end);
