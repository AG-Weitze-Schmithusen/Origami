DeclareCategory("IsNormalStoredOrigami", IsOrigami);
DeclareOperation("NormalStoredOrigamiNC", [IsMultiplicativeElementWithInverse, IsMultiplicativeElementWithInverse, IsGroup]);
DeclareOperation("NormalStoredOrigami" , [IsMultiplicativeElementWithInverse, IsMultiplicativeElementWithInverse, IsGroup]);


DeclareAttribute("HorizontalElement", IsNormalStoredOrigami );
DeclareAttribute("VerticalElement", IsNormalStoredOrigami );

DeclareOperation("AsPermutationRepresentation", [IsNormalStoredOrigami]);
DeclareOperation("AllNormalOrigamisByDegree", [IsPosInt]);
DeclareOperation("AllNormalOrigamisFromGroup", [IsGroup and IsFinite]);
