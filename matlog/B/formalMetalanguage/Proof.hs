module Proof where

import Expression
import Axiom
import ModusPonens
import Deduction
import Hypothesis

getProof :: (ModusPonensCtx, DeductionCtx, [Assertion]) -> String
getProof (mpCtx, dedCtx, assertions)
    = let a = last assertions in
    let preva = take (length assertions - 1) assertions in
    let (Assert ctx e) = a in
    let prefix = "[" ++ show (length assertions) ++ "] " in
    case (axiom e, modusPonens mpCtx a, deduction dedCtx a, hypothesis a) of
        (ax@(AxiomSch _), _, _, _) -> prefix ++ show a ++ " " ++ show ax
        (_, mp@(ModusPonens _ _), _, _) -> prefix ++ show a ++ " " ++ show mp
        (_, _, d@(Deduction _), _) -> prefix ++ show a ++ " " ++ show d
        (_, _, _, hyp@(Hypothesis _)) -> prefix ++ show a ++ " " ++ show hyp
        _ -> prefix ++ show a ++ " [Incorrect]"

alists :: [Assertion] -> [[Assertion]]
alists assertions =
    map (\i -> take i assertions) [1..length assertions]

getProofs :: [Assertion] -> [String]
getProofs assertions =
    let al = alists assertions in
    let mpCtxs = buildModusPonensContexts al in
    let dedСtxs = buildDeductionContexts assertions in
    let l = zip3 mpCtxs dedСtxs al in
    map getProof l
