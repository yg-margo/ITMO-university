module ModusPonens where

import Expression
import Data.Bool
import Data.List
import Data.Maybe
import Data.Map (Map)
import qualified Data.Map as Map

data ModusPonensCheck = NoModusPonens
                      | ModusPonens Int Int

type ModusPonensCtx = Map Assertion (Int, Int)

instance Show ModusPonensCheck where
    show (ModusPonens i j) =
        --let [x, y] = sort [i, j] in
        let [x, y] = [i, j] in
        "[M.P. " ++ show x ++ ", " ++ show y ++ "]"
    show NoModusPonens = ""

-- check :: Assertion -> Assertion -> Assertion -> Bool
-- check (Assert (Ctx ctx1) a)
--       (Assert (Ctx ctx2) (BinaryOperator Implication b c))
--       (Assert (Ctx ctx3) d)
--     | (sort ctx1 == sort ctx2) && (sort ctx2 == sort ctx3)
--     &&b == d && a == c = True
--     | otherwise = False
-- check _ _ _ = False

sortContext :: Assertion -> Assertion
sortContext (Assert (Ctx ctx) exp) = Assert (Ctx (sort ctx)) exp

derive :: (Assertion, Int) -> ModusPonensCtx -> (Assertion, Int) -> ModusPonensCtx
derive (Assert (Ctx ctx1) c@(BinaryOperator Implication a b), i)
       ctx
       (Assert (Ctx ctx2) f@(BinaryOperator Implication d e), j)
    | c == d && sort ctx1 == sort ctx2 = Map.insert (Assert (Ctx (sort ctx1)) e) (i, j) ctx
    | a == f && sort ctx1 == sort ctx2 = Map.insert (Assert (Ctx (sort ctx1)) b) (j, i) ctx
    | otherwise = ctx
derive (Assert (Ctx ctx1) a, i)
       ctx
       (Assert (Ctx ctx2) (BinaryOperator Implication b c), j)
    | a == b && sort ctx1 == sort ctx2 = Map.insert (Assert (Ctx (sort ctx1)) c) (i, j) ctx
    | otherwise = ctx
derive (Assert (Ctx ctx2) (BinaryOperator Implication b c), j)
       ctx
       (Assert (Ctx ctx1) a, i)
    | a == b && sort ctx1 == sort ctx2 = Map.insert (Assert (Ctx (sort ctx1)) c) (i, j) ctx
    | otherwise = ctx
derive _ ctx _ = ctx


modusPonens :: ModusPonensCtx -> Assertion -> ModusPonensCheck
modusPonens ctx a =
    case Map.lookup (sortContext a) ctx of
    Nothing -> NoModusPonens
    Just (x,y) -> ModusPonens x y

addCtx :: ModusPonensCtx -> [Assertion] -> ModusPonensCtx
addCtx ctx assertions =
    let a = last assertions in
    let preva = take (length assertions - 1) assertions in
    foldl (derive (a, length assertions)) ctx (zip preva [1..length assertions - 1])

buildModusPonensContexts :: [[Assertion]] -> [ModusPonensCtx]
buildModusPonensContexts alists =
    scanl addCtx Map.empty alists
