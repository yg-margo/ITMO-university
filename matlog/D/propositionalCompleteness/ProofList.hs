module ProofList (falseImpliesFalse, doubleNeg, expressionAxProof, falseAImpliesAnything, falseImplication, falseOr, andNeg, excludedMiddle, sampleProof) where

import Expression
import Proof

falseImpliesFalse :: Context -> Proof
falseImpliesFalse ctx@(Context exprs) = makeIImpl (Statement ctx (neg FalseItem)) falseAx
    where
        falseAx :: Proof
        falseAx = makeAx (Statement (Context (FalseItem:exprs)) FalseItem)

expressionAxProof :: Context -> Expression -> Proof
expressionAxProof (Context exprs) expr = makeAx (Statement (Context $ expr:exprs) expr)

doubleNeg :: Context -> Expression -> Proof -> Proof
doubleNeg ctx@(Context exprs) a realAProof = makeEImpl (Statement ctx (neg (neg a))) realAProof aNegAFalse
    where
        fullContext :: Context
        fullContext = Context $ a:neg a:exprs

        aProof :: Proof
        aProof = makeAx (Statement fullContext a)

        negAProof :: Proof
        negAProof = makeAx (Statement fullContext (neg a))

        excludedMiddle :: Proof
        excludedMiddle = makeEImpl (Statement fullContext FalseItem) aProof negAProof

        implShortcut :: Proof
        implShortcut = makeIImpl (Statement (Context $ a:exprs) (neg (neg a))) excludedMiddle

        aNegAFalse :: Proof
        aNegAFalse = makeIImpl (Statement ctx (BinaryOperator Implication a (neg (neg a)))) implShortcut


falseItemImpliesAnything :: Context -> Expression -> Proof
falseItemImpliesAnything ctx@(Context exprs) a = makeIImpl (Statement ctx (BinaryOperator Implication FalseItem a)) proof2
    where
        proof1 :: Proof
        proof1 = makeAx (Statement (Context $ FalseItem:neg a:exprs) FalseItem)

        proof2 :: Proof
        proof2 = makeENot (Statement (Context $ FalseItem:exprs) a) proof1

falseAImpliesAnything :: Context -> Expression -> Expression -> Proof -> Proof
falseAImpliesAnything ctx@(Context exprs) a b aRealProof = makeIImpl (Statement ctx (BinaryOperator Implication a b)) bProof
    where
        aProof :: Proof
        aProof = expressionAxProof ctx a

        contextWithA :: Context
        contextWithA = Context $ a:exprs

        falseToB :: Proof
        falseToB = falseItemImpliesAnything contextWithA b

        falseProof :: Proof
        falseProof = makeEImpl (Statement contextWithA FalseItem) aProof aRealProof

        bProof :: Proof
        bProof = makeEImpl (Statement contextWithA b) falseProof falseToB

falseImplication :: Context -> Expression -> Expression -> Proof -> Proof -> Proof
falseImplication ctx@(Context exprs) a b aRealProof bRealProof = makeIImpl (Statement ctx (neg impl)) falseProof
    where
        impl :: Expression
        impl = BinaryOperator Implication a b

        contextWithImpl :: Context
        contextWithImpl = Context $ impl:exprs

        implProof :: Proof
        implProof = makeAx (Statement contextWithImpl impl)

        bProof :: Proof
        bProof = makeEImpl (Statement contextWithImpl b) aRealProof implProof

        falseProof :: Proof
        falseProof = makeEImpl (Statement contextWithImpl FalseItem) bProof bRealProof

andNeg :: Context -> Expression -> Expression -> Proof -> Bool -> Proof
andNeg ctx@(Context exprs) left right realProof isRight = makeIImpl (Statement ctx (neg andExpression)) falseProof
    where
        andExpression :: Expression
        andExpression = BinaryOperator And left right

        contextWithAnd :: Context
        contextWithAnd = Context $ andExpression:exprs

        andProof :: Proof
        andProof = makeAx (Statement contextWithAnd andExpression)

        proof :: Proof
        proof = if isRight then makeErAnd (Statement contextWithAnd right) andProof else makeElAnd (Statement contextWithAnd left) andProof

        falseProof :: Proof
        falseProof = makeEImpl (Statement contextWithAnd FalseItem) proof realProof

falseOr :: Context -> Expression -> Expression -> Proof -> Proof -> Proof
falseOr ctx@(Context exprs) left right realLeftProof realRightProof = makeIImpl (Statement ctx (neg orExpr)) falseOrProof
    where
        orExpr :: Expression
        orExpr = BinaryOperator Or left right

        orContext :: Context
        orContext = Context $ orExpr:exprs

        orProof :: Proof
        orProof = makeAx (Statement orContext orExpr)

        leftContext :: Context
        leftContext = Context $ left:orExpr:exprs

        rightContext :: Context
        rightContext = Context $ right:orExpr:exprs

        leftProof :: Proof
        leftProof = makeAx (Statement leftContext left)

        rightProof :: Proof
        rightProof = makeAx (Statement rightContext right)

        falseLeftProof :: Proof
        falseLeftProof = makeEImpl (Statement leftContext FalseItem) leftProof realLeftProof

        falseRightProof :: Proof
        falseRightProof = makeEImpl (Statement rightContext FalseItem) rightProof realRightProof

        falseOrProof :: Proof
        falseOrProof = makeEOr (Statement orContext FalseItem) falseLeftProof falseRightProof orProof

axiom1 :: Context -> Expression -> Expression -> Proof
axiom1 ctx@(Context exprs) a b = abaProof
    where
        aProof :: Proof
        aProof = makeAx (Statement (Context $ a:b:exprs) a)

        ba :: Expression
        ba = BinaryOperator Implication b a

        baProof :: Proof
        baProof = makeIImpl (Statement (Context $ a:exprs) ba) aProof

        aba :: Expression
        aba = BinaryOperator Implication a ba

        abaProof :: Proof
        abaProof = makeIImpl (Statement ctx aba) baProof

axiom6 :: Context -> Expression -> Expression -> Proof
axiom6 ctx@(Context exprs) a b = proof
    where
        contextWithA :: Context
        contextWithA = Context $ a:exprs

        aProof :: Proof
        aProof = makeAx (Statement contextWithA a)

        aOrb :: Expression
        aOrb = BinaryOperator Or a b

        abProof :: Proof
        abProof = makeIlOr (Statement contextWithA aOrb) aProof

        axiomExpr :: Expression
        axiomExpr = BinaryOperator Implication a aOrb

        proof :: Proof
        proof = makeIImpl (Statement ctx axiomExpr) abProof

axiom7 :: Context -> Expression -> Expression -> Proof
axiom7 ctx@(Context exprs) a b = proof
    where
        contextWithB :: Context
        contextWithB = Context $ b:exprs

        bProof :: Proof
        bProof = makeAx (Statement contextWithB b)

        aOrb :: Expression
        aOrb = BinaryOperator Or a b

        abProof :: Proof
        abProof = makeIrOr (Statement contextWithB aOrb) bProof

        axiomExpr :: Expression
        axiomExpr = BinaryOperator Implication b aOrb

        proof :: Proof
        proof = makeIImpl (Statement ctx axiomExpr) abProof

axiom9 :: Context -> Expression -> Expression -> Proof
axiom9 ctx@(Context exprs) a b = impl3Proof
    where
        ab :: Expression
        ab = BinaryOperator Implication a b

        aNotb :: Expression
        aNotb = BinaryOperator Implication a (neg b)

        fullContext :: Context
        fullContext = Context $ ab:aNotb:a:exprs

        aProof :: Proof
        aProof = makeAx (Statement fullContext a)

        abProof :: Proof
        abProof = makeAx (Statement fullContext ab)

        aNotbProof :: Proof
        aNotbProof = makeAx (Statement fullContext aNotb)

        bProof :: Proof
        bProof = makeEImpl (Statement fullContext b) aProof abProof

        notbProof :: Proof
        notbProof = makeEImpl (Statement fullContext (neg b)) aProof aNotbProof

        falseProof :: Proof
        falseProof = makeEImpl (Statement fullContext FalseItem) bProof  notbProof

        notAProof :: Proof
        notAProof = makeIImpl (Statement (Context $ ab:aNotb:exprs) (neg a)) falseProof

        impl2Proof :: Proof
        impl2Proof = makeIImpl (Statement (Context $ ab:exprs) (BinaryOperator Implication aNotb (neg a))) notAProof

        impl3Proof :: Proof
        impl3Proof = makeIImpl (Statement ctx (BinaryOperator Implication ab (BinaryOperator Implication aNotb (neg a)))) impl2Proof

axiom10 :: Context -> Expression -> Proof
axiom10 ctx@(Context exprs) a = proof
    where
        fullContext :: Context
        fullContext = Context $ neg a : neg (neg a) : exprs

        notA :: Proof
        notA = makeAx (Statement fullContext (neg a))

        notNotA :: Proof
        notNotA = makeAx (Statement fullContext (neg (neg a)))

        falseProof :: Proof
        falseProof = makeEImpl (Statement fullContext FalseItem) notA notNotA

        dedProof :: Proof
        dedProof = makeENot (Statement (Context $ neg (neg a) : exprs) a) falseProof

        proof :: Proof
        proof = makeIImpl (Statement ctx (BinaryOperator Implication (neg (neg a)) a)) dedProof

contraposition :: Context -> Expression -> Expression -> Proof
contraposition ctx@(Context exprs) a b = proof9
    where
        ab :: Expression
        ab = BinaryOperator Implication a b

        aNotb :: Expression
        aNotb = BinaryOperator Implication a (neg b)

        fullContext :: Context
        fullContext = Context $ ab : neg b : exprs

        proof1 :: Proof
        proof1 = axiom9 fullContext a b

        proof2 :: Proof
        proof2 = makeAx (Statement fullContext ab)

        proof3 :: Proof
        proof3 = makeEImpl (Statement fullContext (BinaryOperator Implication aNotb (neg a))) proof2 proof1

        proof4 :: Proof
        proof4 = axiom1 fullContext (neg b) a

        proof5 :: Proof
        proof5 = makeAx (Statement fullContext (neg b))

        proof6 :: Proof
        proof6 = makeEImpl (Statement fullContext aNotb) proof5 proof4

        proof7 :: Proof
        proof7 = makeEImpl (Statement fullContext (neg a)) proof6 proof3

        notBnotA :: Expression
        notBnotA = BinaryOperator Implication (neg b) (neg a)

        proof8 :: Proof
        proof8 = makeIImpl (Statement (Context $ ab:exprs) notBnotA) proof7

        contrExpr :: Expression
        contrExpr = BinaryOperator Implication ab notBnotA

        proof9 :: Proof
        proof9 = makeIImpl (Statement ctx contrExpr) proof8

excludedMiddle :: Context -> Expression -> Proof
excludedMiddle ctx a = proof7
    where
        proof11 :: Proof
        proof11 = axiom6 ctx a (neg a)

        aOrNotA :: Expression
        aOrNotA = BinaryOperator Or a (neg a)

        proof12 :: Proof
        proof12 = contraposition ctx a aOrNotA

        part1 :: Expression
        part1 = BinaryOperator Implication (neg aOrNotA) (neg a)

        proof13 :: Proof
        proof13 = makeEImpl (Statement ctx part1) proof11 proof12

        proof21 :: Proof
        proof21 = axiom7 ctx a (neg a)

        proof22 :: Proof
        proof22 = contraposition ctx (neg a) aOrNotA

        part2 :: Expression
        part2 = BinaryOperator Implication (neg aOrNotA) (neg (neg a))

        proof23 :: Proof
        proof23 = makeEImpl (Statement ctx part2) proof21 proof22

        proof3 :: Proof
        proof3 = axiom9 ctx (neg aOrNotA) (neg a)

        part5 :: Expression
        part5 = neg $ neg aOrNotA

        part4 :: Expression
        part4 = BinaryOperator Implication (BinaryOperator Implication (neg aOrNotA) (neg $ neg a)) part5

        proof4 :: Proof
        proof4 = makeEImpl (Statement ctx part4) proof13 proof3

        proof5 :: Proof
        proof5 = makeEImpl (Statement ctx part5) proof23 proof4

        proof6 :: Proof
        proof6 = axiom10 ctx aOrNotA

        proof7 :: Proof
        proof7 = makeEImpl (Statement ctx aOrNotA) proof5 proof6

sampleProof :: Proof
sampleProof = proof5
    where
        a :: Expression
        a = Variable "A"

        proof1 :: Proof
        proof1 = makeAx (Statement (Context [a]) a)

        proof2 :: Proof
        proof2 = makeAx (Statement (Context [a, a]) a)

        aa :: Expression
        aa = BinaryOperator Implication a a

        proof3 :: Proof
        proof3 = makeIImpl (Statement (Context [a]) aa) proof2

        aAndaa :: Expression
        aAndaa = BinaryOperator And a aa

        proof4 :: Proof
        proof4 = makeIAnd (Statement (Context [a]) aAndaa) proof1 proof3

        proof5 :: Proof
        proof5 = makeIImpl (Statement (Context []) (BinaryOperator Implication a aAndaa)) proof4