InstallGlobalFunction(RandomOrigami, function(d)
	local sigma_x, sigma_y, S_d;
	S_d := SymmetricGroup(d);
	sigma_x := Random(GlobalMersenneTwister, S_d);
	sigma_y := Random(GlobalMersenneTwister, S_d);
	while not IsTransitive(Group(sigma_x, sigma_y), [1..d]) do
		sigma_y := Random(GlobalMersenneTwister, S_d);
	od;
	return OrigamiNC(sigma_x, sigma_y, d);
end);

InstallGlobalFunction(StaircaseOrigami, function(length, height, steps)
	local sigma_h, sigma_h_step, sigma_v, sigma_v_step, step;
	sigma_h := ();
	sigma_h_step := [];
	for step in [1 .. steps] do
		sigma_h_step[step] := CycleFromList([(step-1)*(length+height)+1 .. (step-1)*(length+height)+length]);
		sigma_h := sigma_h * sigma_h_step[step];
	od;

	sigma_v := ();
	sigma_v_step := [];
	for step in [1 .. steps-1] do
		sigma_v_step[step] := CycleFromList([step*length+(step-1)*height .. step*(length+height)+1]);
		sigma_v := sigma_v * sigma_v_step[step];
	od;

	sigma_v := sigma_v * CycleFromList([steps*length+(steps-1)*height .. steps*(length+height)]);	#Loop one shorter because the last cycle is one shorter.

	return OrigamiNormalForm(Origami(sigma_h, sigma_v));
end);

InstallGlobalFunction(XOrigami, function(d)
	#degree of this origami is 2*tiles
    local sigma_h, sigma_v, tile;

    sigma_h:=CycleFromList([1..2*tiles]);
    sigma_v:=();

    for tile in [1 .. tiles] do
        sigma_v:=sigma_v*(2*tile-1, 2*tile);
    od;

    return OrigamiNormalForm(Origami(sigma_h,sigma_v));
end);

InstallGlobalFunction(ElevatorOrigami, function(length, height, steps)
	local sigma_h, sigma_h_step, sigma_v, sigma_v_step, step;

	sigma_h := ();
	sigma_h_step := [];
	for step in [1 .. steps] do
		sigma_h_step[step] := CycleFromList([(step-1)*(length+height)+1 .. (step-1)*(length+height)+length]);
		sigma_h := sigma_h * sigma_h_step[step];
	od;

	sigma_v := ();
	sigma_v_step := [];
	for step in [1 .. steps-1] do
		sigma_v_step[step] := CycleFromList([step*length+(step-1)*height .. step*(length+height)+1]);
		sigma_v := sigma_v * sigma_v_step[step];
	od;
	sigma_v_step := [steps*length+(steps-1)*height .. steps*(length+height)];
	Add(sigma_v_step, 1); #connecting the last tile of the last step to the first tile of the first step

	sigma_v := sigma_v * CycleFromList(sigma_v_step);

	return OrigamiNormalForm(Origami(sigma_h, sigma_v));
end);