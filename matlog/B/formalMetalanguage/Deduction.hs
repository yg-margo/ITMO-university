module Deduction where

import Expression
import Data.List
import Data.Maybe
import Data.Map (Map)
import qualified Data.Map as Map

data DeductionCheck = NoDeduction
                    | Deduction Int

type DeductionCtx = Map Assertion Int

instance Show DeductionCheck where
    show NoDeduction = ""
    show (Deduction n) = "[Ded. " ++ show n ++ "]"

sortContext :: Assertion -> Assertion
sortContext (Assert (Ctx ctx) exp) = Assert (Ctx (sort ctx)) exp

normalize :: Assertion -> Assertion
normalize (Assert (Ctx ctx) (BinaryOperator Implication exp1 exp2))
    = normalize (Assert (Ctx (exp1:ctx)) exp2)
normalize a = sortContext a

check :: Assertion -> Assertion -> Bool
check a b = normalize a == normalize b

deduction :: DeductionCtx -> Assertion -> DeductionCheck
deduction ctx a =
    case Map.lookup (normalize a) ctx of
    Nothing -> NoDeduction
    Just x -> Deduction x

insertWithoutUpdate k v m =
    case Map.member k m of
    True -> m
    False -> Map.insert k v m

addCtx ctx (a, i) =
    insertWithoutUpdate (normalize a) i ctx

buildDeductionContexts :: [Assertion] -> [DeductionCtx]
buildDeductionContexts assertions =
    scanl addCtx Map.empty (zip assertions [1..length assertions])

check_old :: Assertion -> Assertion -> Bool
check_old a@(Assert _ (BinaryOperator Implication _ _)) b = normalize a == normalize b
check_old a@(Assert (Ctx []) _) b = False
check_old a b = normalize a == normalize b

deduction_old :: Assertion -> [Assertion] -> DeductionCheck
deduction_old a preva =
    let l = [(check_old a x, x) | x <- preva] in
    case filter (\(c, x) -> c) l of
    [] -> NoDeduction
    (True,x):_ -> Deduction (fromJust(elemIndex x preva) + 1)
