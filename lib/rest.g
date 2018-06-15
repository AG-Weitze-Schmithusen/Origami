InstallGlobalFunction(CanonicalOrigamiViaDelaCroix, function(O, start)
	local xLoopStart, yLoopStart, NotVisitedY, xlevel, i, newxPerm, newyPerm, renumbering, currentxPosition, currentyPosition, help;
	renumbering := [ ];
	NotVisitedY := [ 1.. DegreeOrigami(O) ];
	newyPerm := [ 1.. DegreeOrigami(O) ];
	newxPerm := [ 1.. DegreeOrigami(O) ];
	xlevel := 0;
	yLoopStart := start;
	currentyPosition := start;
	i := 1;
	while NotVisitedY <> [ ] do
		repeat
							Print(currentyPosition);
			#if i = 2 then i := 1/0; fi; i := i + 1;
			if IsBound( renumbering[ currentyPosition ] ) = false then
				xlevel := xlevel + 1;
				xLoopStart := currentyPosition;
				currentxPosition := xLoopStart;
				renumbering[ xLoopStart ] := xlevel;
				repeat
					xlevel := xlevel + 1;
					newxPerm[xlevel - 1] := xlevel;
					renumbering[Position(renumbering, xlevel - 1)^HorizontalPerm(O)] := xlevel;
					currentxPosition := currentxPosition^HorizontalPerm(O);#Position(renumbering, xlevel + 1);
				until currentxPosition^HorizontalPerm(O) = xLoopStart;
				newxPerm[ xlevel - 1] := renumbering[ xLoopStart ];#newxPerm[Position(renumbering, xlevel - 1)] := renumbering[ xLoopStart ];
			fi;
			#if IsBound(renumbering[ currentyPosition^VerticalPerm(O) ]) = false then
				#newyPerm[ renumbering[ currentyPosition ]] := xlevel;
			#else
				#newyPerm[ renumbering[ currentyPosition ] ] := renumbering[currentyPosition^VerticalPerm(O)];
			#fi;
		#	Print(currentyPosition);Print("\n");
			RemoveSet( NotVisitedY, renumbering[ currentyPosition ]  );
			#Print(renumbering); Print("\n");
				#Print(NotVisitedY); Print("\n");
			currentyPosition := currentyPosition ^ VerticalPerm(O);
			#Print(currentyPosition); Print("\n");
		until currentyPosition ^ VerticalPerm(O) = yLoopStart;

		#Print(renumbering[ currentyPosition ] ); Print("\n");
		#Print(Position(NotVisitedY, renumbering[ currentyPosition ])); Print("\n");
		if IsBound(renumbering[ currentyPosition ]) = false then
					#Änderung renumbering[ currentyPosition ] := xlevel + 1;
					RemoveSet( NotVisitedY, xlevel + 1 );
		else
					RemoveSet( NotVisitedY, renumbering[ currentyPosition ] );
		fi;
		#newyPerm
		if NotVisitedY <> [] then
			yLoopStart := Position(renumbering, NotVisitedY[1]);
			currentyPosition := yLoopStart;
		fi;
	od;
	return [ newxPerm, newyPerm, renumbering ];
	#return Origami(PermList(newxPerm), PermList(newyPerm), DegreeOrigami(O));
end);
