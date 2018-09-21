stream := false;

LoadPackage("homalgto");
LoadPackage("io_forhomalg");
LoadPackage("io");
LoadPackage("rings");

BindGlobal("PrepareSage", function()
	stream := LaunchCAS("HOMALG_IO_Sage");
	stream.CUT_POS_END := 13;
	stream.CUT_POS_BEGIN := 10;
	homalgSendBlocking(["from surface_dynamics.all import*"],"need_display", stream);
end);

InstallGlobalFunction("VeechgroupBySage", function(origami)
	local O, V, S,T;
	if stream = false then
		PrepareSage();
	fi;
	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"", String(VerticalPerm(origami))	, "\")"],stream);
	V := homalgSendBlocking([O,".veech_group()"], stream);
	S := homalgSendBlocking([V ,".S2()"], "need_output", stream);
	T := homalgSendBlocking([V ,".L()"], "need_output", stream);
	return ModularSubgroup(EvalString(S), EvalString(T));
end);


InstallGlobalFunction("NormalFormBySage", function(origami)
	local O, NF, r, u;
	if stream = false then
		PrepareSage();
	fi;

	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"", String(VerticalPerm(origami))	, "\")"],stream);
	NF := homalgSendBlocking([O, ".to_standard_form()"],stream);
	r := EvalString(homalgSendBlocking([NF, ".r()"],"need_output",stream));
	u := EvalString(homalgSendBlocking([NF, ".u()"],"need_output",stream));
	return Origami(r, u, DegreeOrigami(origami));
end);

InstallGlobalFunction("IsHyperellipticBySage", function(origami)
	local O;
	if stream = false then
		PrepareSage();
	fi;

	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"",
		String(VerticalPerm(origami))	, "\")"],stream);
	return EvalString( LowercaseString( homalgSendBlocking( [O, ".is_hyperelliptic()"], "need_output", stream ) ) );
end);

InstallGlobalFunction(IsPrimitiveBySage, function(origami)
	local O;
	if stream = false then
		PrepareSage();
	fi;

	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"",
		String(VerticalPerm(origami))	, "\")"],stream);
	return EvalString( LowercaseString( homalgSendBlocking( [O, ".is_primitive()"], "need_output", stream ) ) );
end);

InstallGlobalFunction("ReduceBySage", function(origami)
	local O, R, r, u;
	if stream = false then
		PrepareSage();
	fi;

	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"", String(VerticalPerm(origami))	, "\")"],stream);
	R := homalgSendBlocking([O, ".reduce()"],stream);
	r := EvalString(homalgSendBlocking([R, ".r()"],"need_output",stream));
	u := EvalString(homalgSendBlocking([R, ".u()"],"need_output",stream));
	return Origami(r, u, DegreeOrigami(origami));
end);

InstallGlobalFunction(AbsolutePeriodGeneratorsBySage, function(origami)
	local O, AP, l, i, result, t1, t2;
	if stream = false then
		PrepareSage();
	fi;

	result := [];
	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"",
		String(VerticalPerm(origami))	, "\")"],stream);
	AP := homalgSendBlocking([O, ".absolute_period_generators()"], stream);
	l := EvalString( homalgSendBlocking(["len(", AP, ")"], "need_output", stream) );
	for i in [0..(l - 1)] do
		t1 := EvalString( homalgSendBlocking([AP, "[", String(i), "][0]"], "need_output", stream) );
		t2 := EvalString( homalgSendBlocking([AP, "[", i, "][1]"], "need_output", stream) );
		result[i+1] := [t1, t2];
	od;
	return result;
end);


InstallGlobalFunction(LatticeOfAbsolutePeriodsBySage, function(origami)
	local O, tuple, t1, t2, t3;
	if stream = false then
		PrepareSage();
	fi;

	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"",
		String(VerticalPerm(origami))	, "\")"],stream);
	tuple := homalgSendBlocking([O, ".lattice_of_absolute_periods()"],  stream);
	t1 := EvalString( homalgSendBlocking([tuple, "[0]"], "need_output", stream) );
	t2 := EvalString( homalgSendBlocking([tuple, "[1]"], "need_output", stream) );
	t3 := EvalString( homalgSendBlocking([tuple, "[2]"], "need_output", stream) );
	return [[t1,0],[t2,t3]];
end);

InstallGlobalFunction(LatticeOfQuotientsBySage, function(origami)
	local O;
	if stream = false then
		PrepareSage();
	fi;

	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"",
		String(VerticalPerm(origami))	, "\")"],stream);
end);

InstallGlobalFunction(OptimalDegreeBySage, function(origami)
	local O;
	if stream = false then
		PrepareSage();
	fi;

	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"",
		String(VerticalPerm(origami))	, "\")"],stream);
	return EvalString( homalgSendBlocking([O, ".optimal_degree()"], "need_output", stream) );
end);



InstallGlobalFunction(PeriodGeneratorsBySage, function(origami)
	local O, AP, l, i, result, t1, t2;
	if stream = false then
		PrepareSage();
	fi;

	result := [];
	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"",
		String(VerticalPerm(origami))	, "\")"],stream);
	AP := homalgSendBlocking([O, ".period_generators()"], stream);
	l := EvalString( homalgSendBlocking(["len(", AP, ")"], "need_output", stream) );
	for i in [0..(l - 1)] do
		t1 := EvalString( homalgSendBlocking([AP, "[", String(i), "][0]"], "need_output", stream) );
		t2 := EvalString( homalgSendBlocking([AP, "[", i, "][1]"], "need_output", stream) );
		result[i+1] := [t1, t2];
	od;
	return result;
end);

InstallGlobalFunction(WidthsAndHeightsBySage, function(origami)
	local O, AP, l, i, result, t1, t2;
	if stream = false then
		PrepareSage();
	fi;

	result := [];
	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"",
		String(VerticalPerm(origami))	, "\")"],stream);
	AP := homalgSendBlocking([O, ".widths_and_heights()"], stream);
	l := EvalString( homalgSendBlocking(["len(", AP, ")"], "need_output", stream) );
	for i in [0..(l - 1)] do
		t1 := EvalString( homalgSendBlocking([AP, "[", String(i), "][0]"], "need_output", stream) );
		t2 := EvalString( homalgSendBlocking([AP, "[", i, "][1]"], "need_output", stream) );
		result[i+1] := [t1, t2];
	od;
	return result;
end);


InstallGlobalFunction(SumOfLyapunovExponentsBySage, function(origami)
	local O;
	if stream = false then
		PrepareSage();
	fi;

	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"",
		String(VerticalPerm(origami))	, "\")"],stream);
	return EvalString( homalgSendBlocking([O, ".sum_of_lyapunov_exponents()"], "need_output", stream) );
end);

InstallGlobalFunction(LyapunovExponentsApproxBySage, function(origami)
	local O;
	if stream = false then
		PrepareSage();
	fi;

	O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"",
		String(VerticalPerm(origami))	, "\")"],stream);
	return EvalString( homalgSendBlocking([O, ".lyapunov_exponents_approx()"], "need_display", stream) );
end);


InstallGlobalFunction(IntermediateCoversBySage, function(origami)
local O;
if stream = false then
	PrepareSage();
fi;

O := homalgSendBlocking( ["Origami(\"", String(HorizontalPerm(origami)), "\",\"",
	String(VerticalPerm(origami))	, "\")"],stream);
end);
