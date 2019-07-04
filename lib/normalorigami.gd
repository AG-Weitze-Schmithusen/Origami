# The constructors
DeclareCategory("IsNormalStoredOrigami", IsOrigami);

DeclareOperation("NormalStoredOrigamiNC", [IsMultiplicativeElementWithInverse, IsMultiplicativeElementWithInverse, IsGroup]);

DeclareOperation( "NormalStoredOrigami" , [IsMultiplicativeElementWithInverse, IsMultiplicativeElementWithInverse, IsGroup]);

## The attributed

DeclareAttribute( "HorizontalElement" , IsNormalStoredOrigami );

DeclareAttribute( "VerticalElement" , IsNormalStoredOrigami );

DeclareAttribute( "AbstractDeckGroup" ,IsNormalStoredOrigami);

## 

DeclareOperation("AsPermutationRepresentation" , [IsNormalStoredOrigami]);
