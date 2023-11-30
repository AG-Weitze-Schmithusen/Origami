conjugate := function(c, O)
  return Origami( c * HorizontalPerm(O) * c ^-1, c * VerticalPerm(O) * c^-1, DegreeOrigami(O));
end;
