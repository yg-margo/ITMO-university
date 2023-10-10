module Proving (solve) where

import CounterExample
import Expression
import Proof
import ProofList

import qualified Data.Map as Map
import Data.List (delete)
import Data.Maybe (fromJust)
import GHC.Exts (groupWith)

makeContext :: VariableEstimate -> Context
makeContext (VariableEstimate m) = Context $ Map.elems $ Map.mapWithKey makeVariable m
    where
        makeVariable :: String -> Bool -> Expression
        makeVariable var False = BinaryOperator Implication (Variable var) FalseItem
        makeVariable var True = Variable var

validityProof :: Statement -> VariableEstimate -> Proof
validityProof (Statement _ FalseItem) _ = error "Unable to prove false"
validityProof statement@(Statement _ (Variable _)) _ = makeAx statement -- Variable should already be in context
validityProof statement@(Statement _ (BinaryOperator Implication (Variable _) FalseItem)) _ = makeAx statement -- Variable should already be in context
validityProof statement@(Statement ctx (BinaryOperator Implication FalseItem FalseItem)) _ = falseImpliesFalse ctx -- _|_ -> _|_
validityProof statement@(Statement ctx (BinaryOperator Implication (BinaryOperator Implication a FalseItem) FalseItem)) vars = doubleNeg ctx a aProof -- (A->_|_)->_|_
    where
        aProof :: Proof
        aProof = validityProof (Statement ctx a) vars
validityProof statement@(Statement ctx@(Context exprs) (BinaryOperator Implication (BinaryOperator operator left right) FalseItem)) vars = case operator of
    And -> let subProof = if leftResult then rightProof else leftProof in andNeg ctx left right subProof leftResult
    Or -> falseOr ctx left right leftProof rightProof
    Implication -> falseImplication ctx left right leftProof rightProof
    where
        leftResult :: Bool
        leftResult = evaluate vars left

        rightResult :: Bool
        rightResult = evaluate vars right

        realLeft :: Expression
        realLeft = if leftResult then left else neg left

        realRight :: Expression
        realRight = if rightResult then right else neg right

        -- nextContext :: Context
        -- nextContext = case operator of
        --     Implication -> Context $ BinaryOperator And left right:exprs -- check if "and" and not impl
        --     And -> Context $ BinaryOperator And left right:exprs
        --     Or -> Context $ BinaryOperator Or left right:exprs

        nextContext :: Context
        nextContext = Context $ BinaryOperator operator left right:exprs

        leftContext :: Context
        leftContext = case operator of
            Or -> case nextContext of
                Context nextExprs -> Context $ left:nextExprs
            _ -> nextContext

        rightContext :: Context
        rightContext = case operator of
            Or -> case nextContext of
                Context nextExprs -> Context $ right:nextExprs
            _ -> nextContext

        leftProof :: Proof
        leftProof = validityProof (Statement leftContext realLeft) vars

        rightProof :: Proof
        rightProof = validityProof (Statement rightContext realRight) vars
validityProof statement@(Statement ctx@(Context exprs) (BinaryOperator operator left right)) vars = case operator of
    And -> makeIAnd statement leftProof rightProof
    Or -> (if leftResult then makeIlOr statement leftProof else makeIrOr statement  rightProof)
    Implication -> (if rightResult then makeIImpl statement rightProof else falseAImpliesAnything ctx left right leftProof)
    where
        leftResult :: Bool
        leftResult = evaluate vars left

        rightResult :: Bool
        rightResult = evaluate vars right

        realLeft :: Expression
        realLeft = if leftResult then left else neg left

        realRight :: Expression
        realRight = if rightResult then right else neg right

        nextContext :: Context
        nextContext = case operator of
            Implication -> Context $ left:exprs
            _ -> ctx

        leftProof :: Proof
        leftProof = validityProof (Statement nextContext realLeft) vars

        rightProof :: Proof
        rightProof = validityProof (Statement nextContext realRight) vars


makeValidityProofs :: [VariableEstimate] -> [Statement] -> [Proof]
makeValidityProofs mappings statements = zipWith validityProof statements mappings

combineProofs :: [Proof] -> [VariableEstimate] -> Proof
combineProofs [x] _ = x
combineProofs proofs estimates = combineProofs nextProofs nextEstimates
    where
        variableName :: String
        variableName = case head estimates of
            VariableEstimate m -> head $ Map.keys m

        variable :: Expression
        variable = Variable variableName

        proofPairs :: [[(VariableEstimate, Proof)]]
        proofPairs = groupWith (\(VariableEstimate m1, _) -> Map.delete variableName m1) $ zip estimates proofs

        orderPair :: [(VariableEstimate, Proof)] -> [(VariableEstimate, Proof)]
        orderPair [a@(VariableEstimate m, _), b] = if fromJust $ Map.lookup variableName m then [a, b] else [b, a]
        orderPair pairs = error $ "Impossible case in orderPair" ++ show (length pairs) ++ " " ++ show proofs ++ " " ++ show estimates ++ " " ++ show pairs ++ "\n" ++ show proofPairs

        pairProof :: [(VariableEstimate, Proof)] -> (VariableEstimate, Proof)
        pairProof [(ve1, proof1), (ve0, proof0)] = (nextEstimate, proof)
            where
                expr :: Expression
                expr = case proof1 of
                    Proof (Statement _ e) _ -> e

                clearContext :: Context -> Context
                clearContext (Context exprs) = Context $ (delete variable . delete (neg variable)) exprs

                nextEstimate :: VariableEstimate
                nextEstimate = case ve1 of
                    VariableEstimate m -> VariableEstimate $ Map.delete variableName m

                oldContext :: Context
                oldContext = case proof1 of
                    Proof (Statement ctx _) _ -> ctx

                nextContext :: Context
                nextContext = clearContext oldContext

                orProof :: Proof
                orProof = excludedMiddle nextContext variable

                proof :: Proof
                proof = makeEOr (Statement nextContext expr) proof1 proof0 orProof
        pairProof _ = error "Impossible case in pairProof"

        result :: [(VariableEstimate, Proof)]
        result = map (pairProof . orderPair) proofPairs

        nextEstimates :: [VariableEstimate]
        nextEstimates = map fst result

        nextProofs :: [Proof]
        nextProofs = map snd result

makeProof :: Expression -> Proof
makeProof expr = proof
    where
        mappings = variableMappings expr
        contexts = map makeContext mappings
        statements = map (`Statement` expr) contexts
        validityProofs = makeValidityProofs mappings statements
        proof = combineProofs validityProofs mappings


solve :: Expression -> Either Proof CounterExample
solve expr = case findCounterExample expr of
    Nothing -> Left $ makeProof expr
    Just ce -> Right ce

-- solve :: Expression -> Either Proof CounterExample
-- solve expr = case findCounterExample expr of
--     Nothing -> Left sampleProof
--     Just ce -> Right ce
