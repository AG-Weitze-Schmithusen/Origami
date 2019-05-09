# The constructors
DeclareCategory("IsNormalStoredOrigami", IsOrigami);

DeclareOperation("NormalStoredOrigamiNC", [IsMultiplicativeElementWithInverse, IsMultiplicativeElementWithInverse, IsGroup]);

DeclareOperation( "NormalStoredOrigami" , [IsMultiplicativeElementWithInverse, IsMultiplicativeElementWithInverse, IsGroup]);

## The attributed

DeclareAttribute( "HorizontalElement" , IsNormalStoredOrigami );

DeclareAttribute( "VerticalElement" , IsNormalStoredOrigami );

## 

DeclareOperation("AsPermutationRepresentation" , [IsNormalStoredOrigami]);
