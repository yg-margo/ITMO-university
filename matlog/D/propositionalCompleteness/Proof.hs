{-# LANGUAGE InstanceSigs #-}

module Proof (Proof (..), makeAx, makeEImpl, makeIImpl, makeIAnd, makeElAnd, makeErAnd, makeIlOr, makeIrOr, makeEOr, makeENot) where

import Expression
import Data.List

data Rule = Ax
          | EImpl Proof Proof
          | IImpl Proof
          | IAnd Proof Proof
          | ElAnd Proof
          | ErAnd Proof
          | IlOr Proof
          | IrOr Proof
          | EOr Proof Proof Proof
          | ENot Proof

data Proof = Proof Statement Rule

compContext :: Context -> Context -> Bool
compContext (Context aExprs) (Context bExprs) = sort aExprs == sort bExprs

makeAx :: Statement -> Proof
makeAx statement@(Statement (Context exprs) expr) | expr `elem` exprs = Proof statement Ax
makeAx statement = error $ "Unable to make Ax " ++ show statement

makeEImpl :: Statement -> Proof -> Proof -> Proof
makeEImpl statement@(Statement bCtx b) aProof@(Proof (Statement aCtx a) _) abProof@(Proof (Statement abCtx ab) _) |
    ab == BinaryOperator Implication a b && compContext bCtx aCtx && compContext bCtx abCtx = Proof statement (EImpl abProof aProof)
makeEImpl statement aProof@(Proof aStatement _) abProof@(Proof abStatement _) = error $ "Unable to make EImpl " ++ show statement ++ "; LEFT: " ++ show aStatement ++ "; RIGHT:" ++ show abStatement ++ "\n" ++ show aProof ++ "\n" ++ show abProof

makeIImpl :: Statement -> Proof -> Proof
makeIImpl statement@(Statement (Context abExprs) (BinaryOperator Implication a b1)) bProof@(Proof (Statement bCtx b2) _) |
    b1 == b2 && compContext bCtx (Context $ a:abExprs) = Proof statement (IImpl bProof)
makeIImpl statement (Proof bStatement _) = error $ "Unable to make IImpl " ++ show statement ++ "    " ++ show bStatement

makeIAnd :: Statement -> Proof -> Proof -> Proof
makeIAnd statement@(Statement abCtx (BinaryOperator And a1 b1)) aProof@(Proof (Statement aCtx a2) _) bProof@(Proof (Statement bCtx b2) _) |
    a1 == a2 && b1 == b2 && compContext abCtx aCtx && compContext abCtx bCtx = Proof statement (IAnd aProof bProof)
makeIAnd statement _ _ = error $ "Unable to make IAnd " ++ show statement

makeElAnd :: Statement -> Proof -> Proof
makeElAnd statement@(Statement aCtx a1) abProof@(Proof (Statement abCtx (BinaryOperator And a2 b)) _) |
    a1 == a2 && compContext aCtx abCtx = Proof statement (ElAnd abProof)
makeElAnd statement _ = error $ "Unable to make ElAnd " ++ show statement

makeErAnd :: Statement -> Proof -> Proof
makeErAnd statement@(Statement bCtx b1) abProof@(Proof (Statement abCtx (BinaryOperator And a b2)) _) |
    b1 == b2 && compContext bCtx abCtx = Proof statement (ErAnd abProof)
makeErAnd statement _ = error $ "Unable to make ErAnd " ++ show statement

makeIlOr :: Statement -> Proof -> Proof
makeIlOr statement@(Statement abCtx (BinaryOperator Or a1 b)) aProof@(Proof (Statement aCtx a2) _) |
    a1 == a2 && compContext abCtx aCtx = Proof statement (IlOr aProof)
makeIlOr statement _ = error $ "Unable to make IlOr " ++ show statement

makeIrOr :: Statement -> Proof -> Proof
makeIrOr statement@(Statement abCtx (BinaryOperator Or a b1)) bProof@(Proof (Statement bCtx b2) _) |
    b1 == b2 && compContext abCtx bCtx = Proof statement (IrOr bProof)
makeIrOr statement _ = error $ "Unable to make IlOr " ++ show statement

makeEOr :: Statement -> Proof -> Proof -> Proof -> Proof
makeEOr statement@(Statement (Context exprs1) p1)
        aProof@(Proof (Statement (Context aExprs) p2) _)
        bProof@(Proof (Statement (Context bExprs) p3) _)
        orProof@(Proof (Statement (Context exprs2) (BinaryOperator Or a b)) _) |
    p1 == p2 && p2 == p3 && compContext (Context exprs1) (Context exprs2) && compContext (Context $ a:exprs1) (Context aExprs) && compContext (Context $ b:exprs1) (Context bExprs) =
        Proof statement (EOr aProof bProof orProof)
makeEOr statement _ _ _ = error $ "Unable to make EOr " ++ show statement

makeENot :: Statement -> Proof -> Proof
makeENot statement@(Statement (Context aExprs) a) aProof@(Proof (Statement aFalseCtx FalseItem) _) |
    compContext aFalseCtx (Context $ neg a : aExprs) = Proof statement (ENot aProof)
makeENot statement@(Statement (Context aExprs) a) aProof@(Proof (Statement (Context aFalseExprs) x) _)= error $ "Unable to make ENot " ++ show statement

showSubProofs :: Rule -> Int -> [String]
showSubProofs Ax _ = []
showSubProofs (EImpl a b) layer = showProof a (layer + 1) ++ showProof b (layer + 1)
showSubProofs (IImpl a) layer = showProof a (layer + 1)
showSubProofs (IAnd a b) layer = showProof a (layer + 1) ++ showProof b (layer + 1)
showSubProofs (ElAnd a) layer = showProof a (layer + 1)
showSubProofs (ErAnd a) layer = showProof a (layer + 1)
showSubProofs (IlOr a) layer = showProof a (layer + 1)
showSubProofs (IrOr a) layer = showProof a (layer + 1)
showSubProofs (EOr a b c) layer = showProof a (layer + 1) ++ showProof b (layer + 1) ++ showProof c (layer + 1)
showSubProofs (ENot a) layer = showProof a (layer + 1)

ruleLabel :: Rule -> String
ruleLabel Ax = "[Ax]"
ruleLabel (EImpl _ _) = "[E->]"
ruleLabel (IImpl _) = "[I->]"
ruleLabel (IAnd _ _) = "[I&]"
ruleLabel (ElAnd _ ) = "[El&]"
ruleLabel (ErAnd _ ) = "[Er&]"
ruleLabel (IlOr _) = "[Il|]"
ruleLabel (IrOr _) = "[Ir|]"
ruleLabel (EOr {}) = "[E|]"
ruleLabel (ENot _) = "[E!!]"

showProof :: Proof -> Int -> [String]
showProof (Proof statement rule) layer =
    let subProofs = showSubProofs rule layer
        currentLine = "[" ++ show layer ++ "] " ++ show statement ++ " " ++ ruleLabel rule
    in  subProofs ++ [currentLine]

instance Show Proof where
    show :: Proof -> String
    show proof = intercalate "\n" $ showProof proof 0
