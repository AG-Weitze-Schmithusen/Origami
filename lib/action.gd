DeclareOperation("ActionOfS", [IsOrigami]);
DeclareOperation("ActionOfT", [IsOrigami]);
DeclareOperation("ActionOfInvT", [IsOrigami]);
DeclareOperation("ActionOfInvS", [IsOrigami]);




#! @Arguments word, Origami
#! @Returns the Origami Object word.Origami
#! @Description
#! 	This lets act a word in the free group  $Group(S, T)$ ,representing an element of $Sl_2(\mathbb{Z})$ on an Origami and returns $word.Origami$.
#! @ChapterInfo The Origami object, The action on the Origami
DeclareOperation("ActionOfSpecialLinearGroup", [IsObject , IsOrigami]);

#! @Arguments word, Origami
#! @Returns the Origami Object word.Origami
#! @Description
#!	This lets act a word in the free group $Group(S, T)$, representing an element of $Sl_2(\mathbb{Z})$, on an Origami and returns word.Origami. But in
#!contrast to
#! "ActionOfSl" the result is stored in the canonical representation.
#! @ChapterInfo The Origami object, The action on the Origami
DeclareGlobalFunction("ActionOfF2ViaCanonical");

#! @Arguments word, Origami
#! @Returns the Origami Object Origami.word
#! @Description
#! 	This lets act a word in the free group $Group(S, T)$ on an Origami from right and returns $Origami.word = word^-1.Origami$, where the left action
#! is the common action of $Sl_2(\mathbb{Z})$ on 2 mannifolds. This action has the same Veechgroup and orbits as the left action. In contrast to
#! "ActionOfSl" the result is stored in the canonical representation.
#! @ChapterInfo The Origami object, The action on the Origami
DeclareGlobalFunction("RightActionOfF2ViaCanonical");
